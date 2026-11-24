<?php

header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: no-store');

$root = '/var/www/html';
$checks = array(
    'wxis' => is_executable($root . '/cgi-bin/wxis.exe'),
    'bases' => is_readable($root . '/bases'),
);
$healthy = !in_array(false, $checks, true);

if (!$healthy) {
    http_response_code(503);

    $unavailable = array();
    foreach ($checks as $component => $available) {
        if (!$available) {
            $unavailable[] = $component;
        }
    }

    error_log(json_encode(array(
        'timestamp' => gmdate('c'),
        'user_id' => null,
        'ip_address' => isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : null,
        'session_id' => null,
        'action' => 'system.healthcheck',
        'resource' => 'service.scielo_web',
        'resource_id' => null,
        'result' => 'failure',
        'before' => null,
        'after' => null,
        'extra' => array('unavailable_components' => $unavailable),
    )));
}

echo json_encode(array('status' => $healthy ? 'ok' : 'unavailable'));
