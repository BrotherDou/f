<?php
declare(strict_types=1);

// 在下面两条 WHITELIST_NAMES 标记之间添加 Roblox 用户名，每行一个。
// 不需要引号、逗号或 => true；大小写均可；空行和 # 开头的备注行会被忽略。
// 请填写账号用户名（Player.Name），不要填写显示名称（DisplayName）或 UserId。
const WHITELIST_PLAYERS = <<<'WHITELIST_NAMES'

WHITELIST_NAMES;

header('Content-Type: application/json; charset=utf-8');
header('X-Content-Type-Options: nosniff');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header('Expires: 0');
header('X-Robots-Tag: noindex, nofollow');

const MONITOR_STORAGE_PREFIX = "<?php http_response_code(404); exit; ?>\n";
const MONITOR_MAX_EVENTS = 2000;
const MONITOR_MAX_UNIQUE_IPS = 20000;
const MONITOR_MAX_GEO_CACHE = 2000;
const MONITOR_UNIQUE_IP_TTL = 7776000;
const MONITOR_GEO_CACHE_TTL = 604800;
const MONITOR_FAILED_GEO_TTL = 3600;

function respond(
    bool $allowed,
    string $status,
    string $reason = '',
    int $httpCode = 200
): never {
    http_response_code($httpCode);

    $flags = JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES;
    if (defined('JSON_INVALID_UTF8_SUBSTITUTE')) {
        $flags |= JSON_INVALID_UTF8_SUBSTITUTE;
    }

    $json = json_encode([
        'allowed' => $allowed,
        'status' => $status,
        'reason' => $reason,
        'time' => time(),
    ], $flags);

    echo is_string($json)
        ? $json
        : '{"allowed":false,"status":"error","reason":"json_encode_failed","time":0}';
    exit;
}

function isValidIp(string $ip): bool
{
    return filter_var($ip, FILTER_VALIDATE_IP) !== false;
}

function ipInCidr(string $ip, string $cidr): bool
{
    $cidr = trim($cidr);
    if ($cidr === '') {
        return false;
    }

    if (strpos($cidr, '/') === false) {
        $ipBinary = inet_pton($ip);
        $cidrBinary = inet_pton($cidr);

        return $ipBinary !== false && $cidrBinary !== false && hash_equals($cidrBinary, $ipBinary);
    }

    [$network, $prefixText] = explode('/', $cidr, 2);
    $network = trim($network);
    $prefixText = trim($prefixText);

    if (!isValidIp($network) || !ctype_digit($prefixText)) {
        return false;
    }

    $ipBinary = inet_pton($ip);
    $networkBinary = inet_pton($network);
    if ($ipBinary === false || $networkBinary === false || strlen($ipBinary) !== strlen($networkBinary)) {
        return false;
    }

    $prefix = (int) $prefixText;
    $maxBits = strlen($ipBinary) * 8;
    if ($prefix < 0 || $prefix > $maxBits) {
        return false;
    }

    $wholeBytes = intdiv($prefix, 8);
    $remainingBits = $prefix % 8;

    if ($wholeBytes > 0 && substr($ipBinary, 0, $wholeBytes) !== substr($networkBinary, 0, $wholeBytes)) {
        return false;
    }

    if ($remainingBits === 0) {
        return true;
    }

    $mask = (0xFF << (8 - $remainingBits)) & 0xFF;

    return (ord($ipBinary[$wholeBytes]) & $mask) === (ord($networkBinary[$wholeBytes]) & $mask);
}

function trustedProxyCidrs(): array
{
    static $cidrs = null;

    if (is_array($cidrs)) {
        return $cidrs;
    }

    $configured = getenv('WL_V2_TRUSTED_PROXIES');
    if (!is_string($configured) || trim($configured) === '') {
        $cidrs = [];
        return $cidrs;
    }

    $cidrs = array_values(array_filter(array_map('trim', explode(',', $configured))));
    return $cidrs;
}

function isTrustedProxy(string $ip): bool
{
    foreach (trustedProxyCidrs() as $cidr) {
        if (ipInCidr($ip, $cidr)) {
            return true;
        }
    }

    return false;
}

function getClientIp(): string
{
    $remoteAddress = trim((string) ($_SERVER['REMOTE_ADDR'] ?? ''));
    if (!isValidIp($remoteAddress)) {
        return 'unknown';
    }

    if (!isTrustedProxy($remoteAddress)) {
        return $remoteAddress;
    }

    $cloudflareIp = trim((string) ($_SERVER['HTTP_CF_CONNECTING_IP'] ?? ''));
    if (isValidIp($cloudflareIp)) {
        return $cloudflareIp;
    }

    $forwardedFor = (string) ($_SERVER['HTTP_X_FORWARDED_FOR'] ?? '');
    $chain = [];

    foreach (explode(',', $forwardedFor) as $candidate) {
        $candidate = trim($candidate);
        if (isValidIp($candidate)) {
            $chain[] = $candidate;
        }
    }

    $chain[] = $remoteAddress;

    for ($index = count($chain) - 1; $index >= 0; $index--) {
        if (!isTrustedProxy($chain[$index])) {
            return $chain[$index];
        }
    }

    return $remoteAddress;
}

function trimPlayerName(string $value): string
{
    $value = trim($value);
    // 只清理首尾复制时带入的空白、BOM 和零宽空格，不改动用户名内部字符。
    $cleaned = preg_replace(
        '/\A[\s\p{Z}\x{FEFF}\x{200B}]+|[\s\p{Z}\x{FEFF}\x{200B}]+\z/u',
        '',
        $value
    );

    return is_string($cleaned) ? $cleaned : $value;
}

function whitelistSet(): array
{
    static $whitelist = null;
    if (is_array($whitelist)) {
        return $whitelist;
    }

    $whitelist = [];
    $lines = preg_split('/\r\n|\r|\n/', WHITELIST_PLAYERS);
    foreach ($lines === false ? [] : $lines as $index => $line) {
        $name = trimPlayerName($line);
        if ($name === '' || $name[0] === '#') {
            continue;
        }

        if (preg_match('/\A[A-Za-z0-9_]{1,20}\z/', $name) !== 1) {
            error_log('[WL-V2] invalid whitelist entry at list line ' . ($index + 1));
            continue;
        }

        // 名单与请求统一使用小写键；重复添加同一个账号不会影响匹配。
        $whitelist[strtolower($name)] = true;
    }

    return $whitelist;
}

function monitorDataPath(): string
{
    $configured = getenv('WL_V2_MONITOR_DATA');
    if (is_string($configured) && trim($configured) !== '') {
        return trim($configured);
    }

    return __DIR__ . DIRECTORY_SEPARATOR . '.whitelist-v2-monitor-data.php';
}

function monitorInitialData(): array
{
    return [
        'version' => 1,
        'created_at' => time(),
        'updated_at' => time(),
        'counters' => ['total' => 0, 'allowed' => 0, 'blocked' => 0],
        'days' => [],
        'unique_ips' => [],
        'geo_cache' => [],
        'events' => [],
    ];
}

function decodeMonitorData(string $payload): array
{
    if (strncmp($payload, MONITOR_STORAGE_PREFIX, strlen(MONITOR_STORAGE_PREFIX)) === 0) {
        $payload = substr($payload, strlen(MONITOR_STORAGE_PREFIX));
    }

    $decoded = json_decode($payload, true);
    if (!is_array($decoded)) {
        return monitorInitialData();
    }

    $defaults = monitorInitialData();
    foreach ($defaults as $key => $value) {
        if (!array_key_exists($key, $decoded) || !is_array($decoded[$key]) && is_array($value)) {
            $decoded[$key] = $value;
        }
    }

    return $decoded;
}

function monitorJsonEncode(array $value): ?string
{
    $flags = JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES;
    if (defined('JSON_INVALID_UTF8_SUBSTITUTE')) {
        $flags |= JSON_INVALID_UTF8_SUBSTITUTE;
    }

    $encoded = json_encode($value, $flags);
    return is_string($encoded) ? $encoded : null;
}

function monitorCleanText(string $value, int $maxLength): string
{
    $value = trim((string) preg_replace('/[\x00-\x1F\x7F]+/', ' ', $value));

    if (function_exists('mb_substr')) {
        return mb_substr($value, 0, $maxLength, 'UTF-8');
    }

    return substr($value, 0, $maxLength);
}

function monitorDay(int $timestamp): string
{
    try {
        $date = new DateTimeImmutable('@' . $timestamp);
        return $date->setTimezone(new DateTimeZone('Asia/Shanghai'))->format('Y-m-d');
    } catch (Throwable $error) {
        return gmdate('Y-m-d', $timestamp + 28800);
    }
}

function readCachedLocation(string $ip): ?array
{
    if ($ip === 'unknown') {
        return null;
    }

    $handle = @fopen(monitorDataPath(), 'rb');
    if ($handle === false) {
        return null;
    }

    if (!flock($handle, LOCK_SH)) {
        fclose($handle);
        return null;
    }

    $data = decodeMonitorData((string) stream_get_contents($handle));
    flock($handle, LOCK_UN);
    fclose($handle);

    $key = hash('sha256', $ip);
    $cached = $data['geo_cache'][$key] ?? null;
    if (!is_array($cached) || (int) ($cached['expires_at'] ?? 0) <= time()) {
        return null;
    }

    return $cached;
}

function isPublicIp(string $ip): bool
{
    return filter_var(
        $ip,
        FILTER_VALIDATE_IP,
        FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE
    ) !== false;
}

function requestLocationJson(string $url): ?array
{
    $body = false;

    if (function_exists('curl_init')) {
        $curl = curl_init($url);
        if ($curl !== false) {
            $options = [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_FOLLOWLOCATION => false,
                CURLOPT_CONNECTTIMEOUT => 1,
                CURLOPT_TIMEOUT => 2,
                CURLOPT_HTTPHEADER => ['Accept: application/json'],
                CURLOPT_USERAGENT => 'Roblox-Whitelist-V2-Monitor/1.0',
            ];

            if (defined('CURLOPT_PROTOCOLS') && defined('CURLPROTO_HTTPS')) {
                $options[CURLOPT_PROTOCOLS] = CURLPROTO_HTTPS;
            }

            curl_setopt_array($curl, $options);
            $body = curl_exec($curl);
            $status = (int) curl_getinfo($curl, CURLINFO_HTTP_CODE);
            curl_close($curl);

            if ($status !== 200) {
                $body = false;
            }
        }
    } elseif (filter_var((string) ini_get('allow_url_fopen'), FILTER_VALIDATE_BOOL)) {
        $context = stream_context_create([
            'http' => [
                'method' => 'GET',
                'timeout' => 2,
                'ignore_errors' => true,
                'header' => "Accept: application/json\r\nUser-Agent: Roblox-Whitelist-V2-Monitor/1.0\r\n",
            ],
            'ssl' => [
                'verify_peer' => true,
                'verify_peer_name' => true,
            ],
        ]);
        $body = @file_get_contents($url, false, $context, 0, 65536);
    }

    if (!is_string($body) || $body === '' || strlen($body) > 65536) {
        return null;
    }

    $decoded = json_decode($body, true);
    return is_array($decoded) ? $decoded : null;
}

function lookupIpLocation(string $ip): array
{
    $now = time();
    $fallback = [
        'country_code' => '',
        'country' => '未知位置',
        'region' => '',
        'city' => '',
        'isp' => '',
        'timezone' => '',
        'expires_at' => $now + MONITOR_FAILED_GEO_TTL,
        'last_used' => $now,
    ];

    if (!isPublicIp($ip)) {
        $fallback['country'] = $ip === 'unknown' ? '未知位置' : '本地/保留地址';
        $fallback['expires_at'] = $now + MONITOR_GEO_CACHE_TTL;
        return $fallback;
    }

    $url = 'https://ipwho.is/' . rawurlencode($ip)
        . '?fields=success,message,country_code,country,region,city,connection,timezone&lang=zh-CN';
    $payload = requestLocationJson($url);

    if (!is_array($payload) || ($payload['success'] ?? false) !== true) {
        $cloudflareCountry = monitorCleanText((string) ($_SERVER['HTTP_CF_IPCOUNTRY'] ?? ''), 8);
        if ($cloudflareCountry !== '' && $cloudflareCountry !== 'XX' && $cloudflareCountry !== 'T1') {
            $fallback['country_code'] = strtoupper($cloudflareCountry);
            $fallback['country'] = strtoupper($cloudflareCountry);
        }
        return $fallback;
    }

    $connection = is_array($payload['connection'] ?? null) ? $payload['connection'] : [];
    $timezone = is_array($payload['timezone'] ?? null) ? $payload['timezone'] : [];

    return [
        'country_code' => strtoupper(monitorCleanText((string) ($payload['country_code'] ?? ''), 8)),
        'country' => monitorCleanText((string) ($payload['country'] ?? '未知位置'), 80),
        'region' => monitorCleanText((string) ($payload['region'] ?? ''), 100),
        'city' => monitorCleanText((string) ($payload['city'] ?? ''), 100),
        'isp' => monitorCleanText((string) ($connection['isp'] ?? ''), 120),
        'timezone' => monitorCleanText((string) ($timezone['id'] ?? ''), 80),
        'expires_at' => $now + MONITOR_GEO_CACHE_TTL,
        'last_used' => $now,
    ];
}

function writeAll($handle, string $payload): bool
{
    $length = strlen($payload);
    $written = 0;

    while ($written < $length) {
        $result = fwrite($handle, substr($payload, $written));
        if ($result === false || $result === 0) {
            return false;
        }
        $written += $result;
    }

    return true;
}

function recordVerification(string $player, bool $allowed, string $ip, string $userAgent): void
{
    $now = time();
    $location = readCachedLocation($ip);
    if ($location === null) {
        $location = lookupIpLocation($ip);
    }

    $path = monitorDataPath();
    $directory = dirname($path);
    if (!is_dir($directory) && !@mkdir($directory, 0700, true) && !is_dir($directory)) {
        error_log('[WL-V2] monitor storage directory unavailable');
        return;
    }

    $handle = @fopen($path, 'c+b');
    if ($handle === false) {
        error_log('[WL-V2] monitor storage unavailable');
        return;
    }

    @chmod($path, 0600);

    if (!flock($handle, LOCK_EX)) {
        fclose($handle);
        error_log('[WL-V2] monitor storage lock unavailable');
        return;
    }

    rewind($handle);
    $data = decodeMonitorData((string) stream_get_contents($handle));

    $data['updated_at'] = $now;
    $data['counters']['total'] = (int) ($data['counters']['total'] ?? 0) + 1;
    $counterKey = $allowed ? 'allowed' : 'blocked';
    $data['counters'][$counterKey] = (int) ($data['counters'][$counterKey] ?? 0) + 1;

    $day = monitorDay($now);
    if (!isset($data['days'][$day]) || !is_array($data['days'][$day])) {
        $data['days'][$day] = ['total' => 0, 'allowed' => 0, 'blocked' => 0];
    }
    $data['days'][$day]['total'] = (int) ($data['days'][$day]['total'] ?? 0) + 1;
    $data['days'][$day][$counterKey] = (int) ($data['days'][$day][$counterKey] ?? 0) + 1;

    if ($ip !== 'unknown') {
        $ipKey = hash('sha256', $ip);
        $data['unique_ips'][$ipKey] = $now;
        $location['last_used'] = $now;
        $data['geo_cache'][$ipKey] = $location;
    }

    try {
        $eventId = bin2hex(random_bytes(8));
    } catch (Throwable $error) {
        $eventId = str_replace('.', '', uniqid('', true));
    }

    $event = [
        'id' => $eventId,
        'time' => $now,
        'player' => $player,
        'allowed' => $allowed,
        'result' => $allowed ? 'ALLOWED' : 'BLOCKED',
        'ip' => $ip,
        'location' => $location,
        'user_agent' => monitorCleanText($userAgent, 240),
    ];

    array_unshift($data['events'], $event);
    if (count($data['events']) > MONITOR_MAX_EVENTS) {
        $data['events'] = array_slice($data['events'], 0, MONITOR_MAX_EVENTS);
    }

    $dayCutoff = monitorDay($now - 5184000);
    foreach ($data['days'] as $storedDay => $unused) {
        if ((string) $storedDay < $dayCutoff) {
            unset($data['days'][$storedDay]);
        }
    }

    $uniqueCutoff = $now - MONITOR_UNIQUE_IP_TTL;
    foreach ($data['unique_ips'] as $key => $lastSeen) {
        if ((int) $lastSeen < $uniqueCutoff) {
            unset($data['unique_ips'][$key]);
        }
    }
    if (count($data['unique_ips']) > MONITOR_MAX_UNIQUE_IPS) {
        asort($data['unique_ips'], SORT_NUMERIC);
        $data['unique_ips'] = array_slice($data['unique_ips'], -MONITOR_MAX_UNIQUE_IPS, null, true);
    }

    foreach ($data['geo_cache'] as $key => $cached) {
        if (!is_array($cached) || (int) ($cached['expires_at'] ?? 0) < $now - MONITOR_GEO_CACHE_TTL) {
            unset($data['geo_cache'][$key]);
        }
    }
    if (count($data['geo_cache']) > MONITOR_MAX_GEO_CACHE) {
        uasort($data['geo_cache'], static function ($left, $right): int {
            return (int) ($left['last_used'] ?? 0) <=> (int) ($right['last_used'] ?? 0);
        });
        $data['geo_cache'] = array_slice($data['geo_cache'], -MONITOR_MAX_GEO_CACHE, null, true);
    }

    $encoded = monitorJsonEncode($data);
    if ($encoded === null) {
        flock($handle, LOCK_UN);
        fclose($handle);
        error_log('[WL-V2] monitor JSON encode failed');
        return;
    }

    rewind($handle);
    ftruncate($handle, 0);
    $ok = writeAll($handle, MONITOR_STORAGE_PREFIX . $encoded);
    fflush($handle);
    flock($handle, LOCK_UN);
    fclose($handle);

    if (!$ok) {
        error_log('[WL-V2] monitor storage write failed');
    }
}

function respondWithVerificationRecord(
    bool $allowed,
    string $player,
    string $ip,
    string $userAgent
): never {
    $status = $allowed ? 'authorized' : 'denied';
    $reason = $allowed ? '' : 'not_whitelisted';
    $flags = JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES;
    if (defined('JSON_INVALID_UTF8_SUBSTITUTE')) {
        $flags |= JSON_INVALID_UTF8_SUBSTITUTE;
    }

    $json = json_encode([
        'allowed' => $allowed,
        'status' => $status,
        'reason' => $reason,
        'time' => time(),
    ], $flags);

    if (!is_string($json)) {
        respond(false, 'error', 'json_encode_failed', 500);
    }

    http_response_code(200);
    echo $json;

    ignore_user_abort(true);
    if (function_exists('fastcgi_finish_request')) {
        fastcgi_finish_request();
    }

    recordVerification($player, $allowed, $ip, $userAgent);

    error_log(sprintf(
        '[WL-V2] %s | player=%s | result=%s | ip=%s',
        gmdate('c'),
        $player,
        $allowed ? 'AUTHORIZED' : 'DENIED',
        $ip
    ));

    exit;
}

$method = (string) ($_SERVER['REQUEST_METHOD'] ?? '');
if ($method !== 'GET') {
    header('Allow: GET');
    respond(false, 'error', 'method_not_allowed', 405);
}

$rawPlayer = $_GET['player'] ?? null;
if (!is_string($rawPlayer)) {
    respond(false, 'error', 'missing_player', 400);
}

$player = trimPlayerName($rawPlayer);
if ($player === '') {
    respond(false, 'error', 'missing_player', 400);
}

if (preg_match('/\A[A-Za-z0-9_]{1,20}\z/', $player) !== 1) {
    respond(false, 'error', 'invalid_player', 400);
}

$allowed = isset(whitelistSet()[strtolower($player)]);
$ip = getClientIp();
$userAgent = (string) ($_SERVER['HTTP_USER_AGENT'] ?? '');

respondWithVerificationRecord($allowed, $player, $ip, $userAgent);
