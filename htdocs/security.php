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
