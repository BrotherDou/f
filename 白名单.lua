local safePcall = pcall
local safeType = type
local safeTostring = tostring
local safeTonumber = tonumber
local safeRawget = rawget
local safeRawset = rawset
local safeError = error
local safeIpairs = ipairs
local safeClock = os.clock
local safeTime = os.time
local safeAbs = math.abs
local safeRandom = math.random
local safeTaskWait = task.wait
local safeTaskSpawn = task.spawn

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WL_URL = "https://raw.githubusercontent.com/BrotherDou/f/refs/heads/old/whitelist.php"
local TARGET_SCRIPT_URL = "https://raw.githubusercontent.com/BrotherDou/f/refs/heads/Max/fsk.lua"
local MAX_ATTEMPTS = 8
local RETRY_DELAY = 1.5
local WATCHDOG_INTERVAL = 0.05
local GUI_FALLBACK_SCAN_INTERVAL = 0.25
local MAX_WHITELIST_BYTES = 65536
local MAX_SCRIPT_BYTES = 4194304
local MAX_SERVER_TIME_DRIFT = 600
local STOP = {}

local environmentGetter = getgenv
local env = _G
if safeType(environmentGetter) == "function" then
    local ok, value = safePcall(environmentGetter)
    if not ok or safeType(value) ~= "table" then
        warn("[Loader] 运行环境无效，已停止加载。")
        return
    end
    env = value
end

if env.__KRLoaderState == "running" or env.__KRLoaderState == "loaded"
    or env.__KRLoaderState == "blocked" or env.__KRLoaderBlocked == true
then
    return
end

local player = Players.LocalPlayer
local playerName
local playerId
local blocked = false
local monitoring = true
local expectedAuthorization = false
local expectedStatus = "checking"
local expectedReason = ""
local expectedLoaderState = "running"
local tracked = {}
local req
local httpGet
local compile
local detector
local hiddenGuiGetter
local rawMetaGetter
local gameMeta
local exportedGuard
local exportedRegisterBlockListener
local lastGuiScan = -math.huge
local rootConnections = setmetatable({}, { __mode = "k" })
local blockListeners = {}
local heartbeatConnection

local function disconnectWatchers()
    if heartbeatConnection then
        safePcall(function() heartbeatConnection:Disconnect() end)
        heartbeatConnection = nil
    end
    for root, connection in pairs(rootConnections) do
        safePcall(function() connection:Disconnect() end)
        rootConnections[root] = nil
    end
end

local function publishAuthorization(value, status, reason)
    expectedAuthorization = value == true
    expectedStatus = status or "error"
    expectedReason = reason or ""
    safeRawset(env, "IsWhitelisted", expectedAuthorization)
    safeRawset(env, "isWhitelisted", expectedAuthorization)
    safeRawset(env, "WhitelistStatus", expectedStatus)
    safeRawset(env, "WhitelistReason", expectedReason)
end

local function publishLoaderState(value)
    expectedLoaderState = value
    safeRawset(env, "__KRLoaderState", value)
end

publishLoaderState("running")
safeRawset(env, "__KRLoaderBlocked", false)
publishAuthorization(false, "checking", "")

local function notifyBlockListeners(reason)
    for _, listener in safeIpairs(blockListeners) do
        safePcall(listener, reason)
    end
end

local function blockNow(reason)
    if blocked then
        return false
    end

    blocked = true
    monitoring = false
    expectedAuthorization = false
    expectedStatus = "blocked"
    expectedReason = reason or "security_check_failed"
    expectedLoaderState = "blocked"

    safeRawset(env, "__KRLoaderBlocked", true)
    safeRawset(env, "__KRLoaderState", "blocked")
    safeRawset(env, "IsWhitelisted", false)
    safeRawset(env, "isWhitelisted", false)
    safeRawset(env, "WhitelistStatus", "blocked")
    safeRawset(env, "WhitelistReason", expectedReason)
    disconnectWatchers()
    notifyBlockListeners(expectedReason)
    return false
end

local function kickForCapture()
    safePcall(function()
        if player then
            player:Kick("检测到抓包行为，加载已停止。")
        end
    end)
end

local function stop(reason)
    -- 最高优先级：先进入 blocked 状态，停止后续请求、下载、编译和执行。
    blockNow(reason)

    -- 抓包检测命中后，在停止加载之后立即踢出本地玩家。
    if reason == "capture_tool_detected" then
        kickForCapture()
    end

    safeError(STOP, 0)
end

local function track(name, getter, required, keepNil)
    local ok, value = safePcall(getter)
    if not ok or (required and safeType(value) ~= "function") then
        stop("required_api_unavailable:" .. name)
    end
    if value ~= nil or keepNil then
        tracked[#tracked + 1] = {
            name = name,
            get = getter,
            value = value,
        }
    end
    return value
end

local function isCaptureObject(item)
    if not item then
        return false
    end
    local ok, name = safePcall(function()
        return item.Name
    end)
    return ok and name == "Capture_CodePreview_Window"
end

local function rootContainsCaptureWindow(root)
    if not root then
        return false
    end
    if isCaptureObject(root) then
        return true
    end

    local ok, direct = safePcall(function()
        return root:FindFirstChild("Capture_CodePreview_Window", true)
    end)
    if ok and direct then
        return true
    end

    if ok then
        return false
    end
    local listed, descendants = safePcall(function()
        return root:GetDescendants()
    end)
    if listed and safeType(descendants) == "table" then
        for _, item in safeIpairs(descendants) do
            if isCaptureObject(item) then
                return true
            end
        end
    end

    return false
end

local function watchGuiRoot(root)
    if not root or rootConnections[root] then
        return
    end

    local ok, connection = safePcall(function()
        return root.DescendantAdded:Connect(function(item)
            if isCaptureObject(item) then
                stop("capture_tool_detected")
            end
        end)
    end)
    if ok and connection then
        rootConnections[root] = connection
    end
end

local function collectGuiRoots()
    local roots = {}
    local playerGui
    safePcall(function()
        playerGui = player and player:FindFirstChild("PlayerGui")
    end)
    if playerGui then
        roots[#roots + 1] = playerGui
    end

    local coreGui
    safePcall(function()
        coreGui = game:GetService("CoreGui")
    end)
    if coreGui then
        roots[#roots + 1] = coreGui
    end

    if safeType(hiddenGuiGetter) == "function" then
        local ok, hiddenRoot = safePcall(hiddenGuiGetter)
        if ok and hiddenRoot then
            roots[#roots + 1] = hiddenRoot
        end
    end
    return roots
end

local function captureWindowPresent(force)
    local now = safeClock()
    local shouldScan = force or now - lastGuiScan >= GUI_FALLBACK_SCAN_INTERVAL
    if shouldScan then
        lastGuiScan = now
    end

    local roots = collectGuiRoots()
    for _, root in safeIpairs(roots) do
        watchGuiRoot(root)
        if shouldScan and rootContainsCaptureWindow(root) then
            return true
        end
    end
    return false
end

local function validatePublishedState()
    if safeRawget(env, "__KRLoaderState") ~= expectedLoaderState
        or safeRawget(env, "__KRLoaderBlocked") ~= blocked
        or safeRawget(env, "IsWhitelisted") ~= expectedAuthorization
        or safeRawget(env, "isWhitelisted") ~= expectedAuthorization
        or safeRawget(env, "WhitelistStatus") ~= expectedStatus
        or safeRawget(env, "WhitelistReason") ~= expectedReason
    then
        stop("published_state_changed")
    end
end

local function guard(stage)
    if blocked then
        safeError(STOP, 0)
    end

    validatePublishedState()

    if safeType(environmentGetter) == "function" then
        local ok, current = safePcall(environmentGetter)
        if not ok or current ~= env then
            stop("environment_changed")
        end
    end

    if Players.LocalPlayer ~= player
        or not player
        or player.Name ~= playerName
        or player.UserId ~= playerId
    then
        stop("identity_changed")
    end

    if safeType(detector) ~= "function" then
        stop("hook_check_unavailable")
    end
    if exportedGuard and safeRawget(env, "__KRGuard") ~= exportedGuard then
        stop("guard_changed")
    end
    if exportedRegisterBlockListener
        and safeRawget(env, "__KRRegisterBlockListener") ~= exportedRegisterBlockListener
    then
        stop("block_listener_api_changed")
    end

    for _, item in safeIpairs(tracked) do
        local ok, current = safePcall(item.get)
        if not ok or current ~= item.value then
            stop("api_changed:" .. item.name)
        end
        if safeType(current) == "function" then
            local checked, hooked = safePcall(detector, current)
            if not checked or safeType(hooked) ~= "boolean" then
                stop("hook_check_failed:" .. item.name)
            end
            if hooked then
                stop("hook_detected:" .. item.name)
            end
        end
    end

    if captureWindowPresent(stage ~= "watchdog") then
        stop("capture_tool_detected")
    end
    if blocked then
        safeError(STOP, 0)
    end

    return true
end

local function allowedLoaderUrl(url)
    return safeType(url) == "string"
        and url:match("^https://www%.kr520%.top/") ~= nil
end

local function normalizeResponse(response)
    if safeType(response) ~= "table" then
        return 0, nil
    end

    local status = safeTonumber(
        response.StatusCode
        or response.Status
        or response.status_code
        or response.status
    ) or 0
    local body = response.Body or response.body
    return status, body
end

local function HttpRequest(url)
    if not allowedLoaderUrl(url) then
        stop("url_not_allowed")
    end

    guard("request_before")
    if req then
        local ok, response = safePcall(req, {
            Url = url,
            Method = "GET",
            Headers = {
                ["Cache-Control"] = "no-store, no-cache, must-revalidate",
                ["Pragma"] = "no-cache",
            },
        })
        guard("request_after")
        if ok then
            local status, body = normalizeResponse(response)
            if status > 0 and safeType(body) == "string" then
                return true, status, body
            end
        end
        return false, 0, nil
    end

    guard("httpget_before")
    local ok, body = safePcall(httpGet, game, url)
    guard("httpget_after")
    if ok and safeType(body) == "string" then
        return true, 200, body
    end
    return false, 0, nil
end

local function whitelistUrl(name, attempt)
    local nonce = safeTostring(safeTime())
        .. "_" .. safeTostring(attempt)
        .. "_" .. safeTostring(safeRandom(100000, 999999))
    return WL_URL
        .. "?player=" .. HttpService:UrlEncode(name)
        .. "&_kr=" .. HttpService:UrlEncode(nonce)
end

local function checkWhitelist(name)
    if safeType(name) ~= "string" then
        return "error", "invalid_player_type"
    end
    if not name:match("^[%a%d_]+$") or #name > 20 then
        return "error", "invalid_player"
    end

    for attempt = 1, MAX_ATTEMPTS do
        local ok, statusCode, body = HttpRequest(whitelistUrl(name, attempt))
        if ok
            and statusCode == 200
            and safeType(body) == "string"
            and #body > 0
            and #body <= MAX_WHITELIST_BYTES
        then
            local decoded, data = safePcall(function()
                return HttpService:JSONDecode(body)
            end)
            guard("whitelist_decoded")
            if decoded and safeType(data) == "table" then
                local serverTime = safeTonumber(data.time)
                local fresh = serverTime ~= nil
                    and safeAbs(safeTime() - serverTime) <= MAX_SERVER_TIME_DRIFT
                if fresh and data.allowed == true and data.status == "authorized" then
                    return "authorized", ""
                end
                if fresh and data.allowed == false and data.status == "denied" then
                    return "denied", safeTostring(data.reason or "not_whitelisted")
                end
            end
        end

        if attempt < MAX_ATTEMPTS then
            safeTaskWait(RETRY_DELAY)
            guard("whitelist_retry")
        end
    end
    return "error", "whitelist_server_unavailable"
end

local function registerBlockListener(listener)
    if safeType(listener) ~= "function" then
        return false
    end
    if blocked then
        safePcall(listener, expectedReason)
        return false
    end
    blockListeners[#blockListeners + 1] = listener
    return true
end

local function watchdogTick()
    if not monitoring or blocked then
        return
    end
    local ok = safePcall(guard, "watchdog")
    if not ok and not blocked then
        blockNow("watchdog_failed")
    end
end

local function startWatchdog()
    safeTaskSpawn(function()
        while monitoring and not blocked do
            local waited = safePcall(safeTaskWait, WATCHDOG_INTERVAL)
            if not waited then
                blockNow("watchdog_wait_failed")
                return
            end
            watchdogTick()
        end
    end)

    safePcall(function()
        heartbeatConnection = RunService.Heartbeat:Connect(function()
            watchdogTick()
        end)
    end)
end

local function setupTrackedApis()
    detector = track("isfunctionhooked", function()
        return env.isfunctionhooked or isfunctionhooked
    end, true, false)

    track("getgenv", function()
        return getgenv
    end, false, true)
    track("task.wait", function()
        return task.wait
    end, true, false)
    track("task.spawn", function()
        return task.spawn
    end, true, false)

    httpGet = track("game.HttpGet", function()
        return game.HttpGet
    end, true, false)
    compile = track("loadstring", function()
        return loadstring
    end, true, false)
    hiddenGuiGetter = track("gethui", function()
        return env.gethui or gethui
    end, false, true)

    local requestGetters = {
        { name = "env.syn.request", get = function() return safeType(env.syn) == "table" and env.syn.request or nil end },
        { name = "global.syn.request", get = function() return safeType(syn) == "table" and syn.request or nil end },
        { name = "env.fluxus.request", get = function() return safeType(env.fluxus) == "table" and env.fluxus.request or nil end },
        { name = "global.fluxus.request", get = function() return safeType(fluxus) == "table" and fluxus.request or nil end },
        { name = "env.http.request", get = function() return safeType(env.http) == "table" and env.http.request or nil end },
        { name = "global.http.request", get = function() return safeType(http) == "table" and http.request or nil end },
        { name = "env.request", get = function() return env.request end },
        { name = "global.request", get = function() return request end },
        { name = "env.http_request", get = function() return env.http_request end },
        { name = "global.http_request", get = function() return http_request end },
    }
    for _, item in safeIpairs(requestGetters) do
        local candidate = track(item.name, item.get, false, true)
        if not req and safeType(candidate) == "function" then
            req = candidate
        end
    end

    rawMetaGetter = track("getrawmetatable", function()
        return env.getrawmetatable or getrawmetatable
    end, false, true)
    if safeType(rawMetaGetter) == "function" then
        local ok, value = safePcall(rawMetaGetter, game)
        if not ok or safeType(value) ~= "table" then
            stop("game_metatable_unavailable")
        end
        gameMeta = value
        track("game_metatable", function()
            local currentOk, currentMeta = safePcall(rawMetaGetter, game)
            return currentOk and currentMeta or nil
        end, false, true)

        local metaKeys = { "__namecall", "__index", "__newindex" }
        for _, key in safeIpairs(metaKeys) do
            track("game_meta." .. key, function()
                local currentOk, currentMeta = safePcall(rawMetaGetter, game)
                if not currentOk or currentMeta ~= gameMeta then
                    return nil
                end
                return safeRawget(currentMeta, key)
            end, false, true)
        end
    end
end

local function run()
    if not player then
        stop("local_player_unavailable")
    end
    playerName, playerId = player.Name, player.UserId
    if safeType(playerName) ~= "string"
        or not playerName:match("^[A-Za-z0-9_]+$")
        or #playerName > 20
        or safeType(playerId) ~= "number"
        or playerId <= 0
        or playerId >= math.huge
        or playerId % 1 ~= 0
    then
        stop("invalid_player")
    end

    setupTrackedApis()

    exportedGuard = function(stage)
        local ok = safePcall(guard, stage)
        if not ok then
            stop("guard_failed")
        end
        return true
    end
    exportedRegisterBlockListener = registerBlockListener
    safeRawset(env, "__KRGuard", exportedGuard)
    safeRawset(env, "__KRRegisterBlockListener", exportedRegisterBlockListener)
    track("exported_guard", function() return safeRawget(env, "__KRGuard") end, true, false)
    track("block_listener_api", function() return safeRawget(env, "__KRRegisterBlockListener") end, true, false)

    if captureWindowPresent(true) then
        stop("capture_tool_detected")
    end
    guard("startup")
    startWatchdog()

    local status, reason = checkWhitelist(playerName)
    guard("whitelist_complete")
    publishAuthorization(status == "authorized", status, reason)
    guard("authorization_applied")

    local downloaded, statusCode, scriptContent = HttpRequest(TARGET_SCRIPT_URL)
    guard("script_downloaded")
    if not downloaded
        or statusCode ~= 200
        or safeType(scriptContent) ~= "string"
        or #scriptContent < 32
        or #scriptContent > MAX_SCRIPT_BYTES
        or scriptContent:match("^%s*<[%!%?]?[%a]")
    then
        scriptContent = nil
        safeError("download_failed", 0)
    end

    guard("compile_before")
    local compiled, func = safePcall(compile, scriptContent)
    scriptContent = nil
    guard("compile_after")
    if not compiled or safeType(func) ~= "function" then
        func = nil
        safeError("compile_failed", 0)
    end

    guard("execute_before")
    local executed = safePcall(func)
    func = nil
    guard("execute_after")
    if not executed then
        safeError("script_runtime_failed", 0)
    end

    publishLoaderState("loaded")
    guard("loaded")
end

local success, reason = safePcall(run)
if not success then
    if blocked or reason == STOP then
        if not blocked then
            blockNow("security_check_failed")
        end
        warn("[Loader] 安全检查未通过，已静默封锁后续加载与执行。")
    else
        blockNow("loader_failed")
        warn("[Loader] 加载失败，未输出远程地址或原始错误。")
    end
end
