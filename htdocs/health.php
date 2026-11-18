<?php

require_once(__DIR__ . '/security.php');

header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: no-store');

$healthy = is_executable(__DIR__ . '/../cgi-bin/wxis.exe')
    && is_readable(__DIR__ . '/../bases');

if (!$healthy) {
    http_response_code(503);
    scielo_audit_event(
        'system.healthcheck',
        'failure',
        'service.scielo_web',
        null,
        array('reason' => 'runtime_dependency_unavailable')
    );
}

echo json_encode(array('status' => $healthy ? 'ok' : 'unavailable'));
