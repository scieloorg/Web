<?php

/**
 * Shared security helpers for public SciELO endpoints.
 *
 * Audit events intentionally exclude request payloads, cookies and configuration
 * values. PHP's session identifier is treated as a credential and is only logged
 * as a one-way hash.
 */

function scielo_audit_sanitize($value, $key = '')
{
    $sensitiveKeys = array(
        'password', 'senha', 'pwd', 'token', 'secret', 'api_key',
        'authorization', 'cookie', 'email', 'from', 'to'
    );

    if (in_array(strtolower((string) $key), $sensitiveKeys, true)) {
        return '***';
    }

    if (is_array($value)) {
        $clean = array();
        foreach ($value as $itemKey => $itemValue) {
            $clean[$itemKey] = scielo_audit_sanitize($itemValue, $itemKey);
        }
        return $clean;
    }

    if (is_string($value)) {
        return substr($value, 0, 200);
    }

    if (is_scalar($value) || $value === null) {
        return $value;
    }

    return gettype($value);
}

function scielo_audit_event($action, $result, $resource, $resourceId = null, $extra = array())
{
    $ipAddress = isset($_SERVER['REMOTE_ADDR'])
        && filter_var($_SERVER['REMOTE_ADDR'], FILTER_VALIDATE_IP)
        ? $_SERVER['REMOTE_ADDR']
        : null;

    $sessionId = null;
    if (function_exists('session_status') && session_status() === PHP_SESSION_ACTIVE) {
        $rawSessionId = session_id();
        if ($rawSessionId !== '') {
            $sessionId = hash('sha256', $rawSessionId);
        }
    }

    $entry = array(
        'timestamp' => gmdate('c'),
        'user_id' => null,
        'ip_address' => $ipAddress,
        'session_id' => $sessionId,
        'action' => (string) $action,
        'resource' => (string) $resource,
        'resource_id' => $resourceId === null ? null : substr((string) $resourceId, 0, 128),
        'result' => (string) $result,
        'extra' => scielo_audit_sanitize($extra),
    );

    error_log(json_encode($entry, JSON_UNESCAPED_SLASHES));
}

function scielo_escape_html($value)
{
    return htmlspecialchars((string) $value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function scielo_validate_language($value, $default = 'en')
{
    $allowed = array('pt', 'en', 'es');
    return in_array($value, $allowed, true) ? $value : $default;
}

function scielo_validate_article_pid($value)
{
    if (!is_string($value) || strlen($value) > 64) {
        return false;
    }

    return preg_match('/^S[0-9]{4}-[0-9]{3}[0-9Xx][A-Za-z0-9.()_-]{1,40}$/D', $value)
        ? $value
        : false;
}

function scielo_validate_email_address($value)
{
    if (!is_string($value) || strlen($value) > 254 || preg_match('/[\r\n]/', $value)) {
        return false;
    }

    $value = trim($value);
    return filter_var($value, FILTER_VALIDATE_EMAIL) ? $value : false;
}

function scielo_validate_person_name($value)
{
    if (!is_string($value)) {
        return false;
    }

    $value = trim($value);
    if (!preg_match('/^[\p{L}\p{M}\p{N} .,\x27-]{1,100}$/u', $value)) {
        return false;
    }

    return $value;
}

function scielo_validate_comment($value)
{
    if (!is_string($value) || strlen($value) > 1000
        || preg_match('/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/', $value)) {
        return false;
    }

    return trim($value);
}

function scielo_start_secure_session()
{
    if (session_status() === PHP_SESSION_ACTIVE) {
        return;
    }

    session_set_cookie_params(array(
        'lifetime' => 0,
        'path' => '/',
        'secure' => !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off',
        'httponly' => true,
        'samesite' => 'Lax',
    ));
    session_start();
}

function scielo_csrf_token()
{
    scielo_start_secure_session();

    if (empty($_SESSION['scielo_csrf_token'])) {
        $_SESSION['scielo_csrf_token'] = bin2hex(random_bytes(32));
    }

    return $_SESSION['scielo_csrf_token'];
}

function scielo_csrf_token_is_valid($token)
{
    scielo_start_secure_session();

    return is_string($token)
        && isset($_SESSION['scielo_csrf_token'])
        && hash_equals($_SESSION['scielo_csrf_token'], $token);
}

function scielo_rate_limit($bucket, $limit, $windowSeconds)
{
    $ipAddress = isset($_SERVER['REMOTE_ADDR'])
        && filter_var($_SERVER['REMOTE_ADDR'], FILTER_VALIDATE_IP)
        ? $_SERVER['REMOTE_ADDR']
        : null;

    if ($ipAddress === null || !is_string($bucket) || $bucket === ''
        || $limit < 1 || $windowSeconds < 1) {
        return array('allowed' => false, 'retry_after' => $windowSeconds);
    }

    $directory = rtrim(sys_get_temp_dir(), DIRECTORY_SEPARATOR)
        . DIRECTORY_SEPARATOR . 'scielo-rate-limit';
    if (!is_dir($directory) && !mkdir($directory, 0700, true) && !is_dir($directory)) {
        return array('allowed' => false, 'retry_after' => $windowSeconds);
    }

    $filename = $directory . DIRECTORY_SEPARATOR
        . hash('sha256', $bucket . '|' . $ipAddress) . '.json';
    $handle = fopen($filename, 'c+');
    if ($handle === false || !flock($handle, LOCK_EX)) {
        if (is_resource($handle)) {
            fclose($handle);
        }
        return array('allowed' => false, 'retry_after' => $windowSeconds);
    }

    $now = time();
    $contents = stream_get_contents($handle);
    $timestamps = json_decode($contents, true);
    if (!is_array($timestamps)) {
        $timestamps = array();
    }
    $timestamps = array_values(array_filter($timestamps, function ($timestamp) use ($now, $windowSeconds) {
        return is_int($timestamp) && $timestamp > ($now - $windowSeconds);
    }));

    $allowed = count($timestamps) < $limit;
    $retryAfter = 0;
    if ($allowed) {
        $timestamps[] = $now;
    } else {
        $retryAfter = max(1, $windowSeconds - ($now - min($timestamps)));
    }

    rewind($handle);
    ftruncate($handle, 0);
    fwrite($handle, json_encode($timestamps));
    fflush($handle);
    flock($handle, LOCK_UN);
    fclose($handle);

    return array('allowed' => $allowed, 'retry_after' => $retryAfter);
}

function scielo_is_loopback_request()
{
    $remoteAddress = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';
    return in_array($remoteAddress, array('127.0.0.1', '::1'), true);
}

function scielo_diagnostics_allowed()
{
    if (getenv('SCIELO_ENABLE_DIAGNOSTICS') !== '1') {
        return false;
    }

    return scielo_is_loopback_request();
}

function scielo_diagnostic_mode_allowed($mode)
{
    if (strtoupper((string) $mode) === 'XML') {
        return scielo_is_loopback_request();
    }

    return scielo_diagnostics_allowed();
}

function scielo_validate_internal_host($host)
{
    if (!is_string($host) || strlen($host) > 253) {
        return false;
    }

    if (!preg_match('/^([A-Za-z0-9][A-Za-z0-9.-]*)(?::([0-9]{1,5}))?$/', $host, $matches)) {
        return false;
    }

    if (strpos($matches[1], '..') !== false) {
        return false;
    }

    if (isset($matches[2])) {
        $port = (int) $matches[2];
        if ($port < 1 || $port > 65535) {
            return false;
        }
    }

    return $host;
}

function scielo_internal_host_from_config($config)
{
    if (!is_array($config)
        || !isset($config['SCIELO'])
        || !isset($config['SCIELO']['SERVER_SCIELO'])) {
        throw new RuntimeException('SERVER_SCIELO is not configured');
    }

    $host = scielo_validate_internal_host(trim($config['SCIELO']['SERVER_SCIELO']));
    if ($host === false) {
        throw new RuntimeException('SERVER_SCIELO has an invalid format');
    }

    return $host;
}
