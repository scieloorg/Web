<?php

function assert_true($condition, $message)
{
    if (!$condition) {
        fwrite(STDERR, "FAIL: " . $message . PHP_EOL);
        exit(1);
    }
}

require_once(__DIR__ . '/../htdocs/security.php');

assert_true(scielo_validate_internal_host('127.0.0.1') === '127.0.0.1', 'IPv4 host should be accepted');
assert_true(scielo_validate_internal_host('backend.example.org:8080') === 'backend.example.org:8080', 'hostname and port should be accepted');
assert_true(scielo_validate_internal_host('attacker.example/path') === false, 'path must not be accepted as a host');
assert_true(scielo_validate_internal_host('user@attacker.example') === false, 'userinfo must not be accepted as a host');
assert_true(scielo_validate_internal_host('backend.example.org:65536') === false, 'invalid port must be rejected');

putenv('SCIELO_ENABLE_DIAGNOSTICS');
$_SERVER['REMOTE_ADDR'] = '127.0.0.1';
assert_true(scielo_diagnostics_allowed() === false, 'diagnostics must be disabled by default');

putenv('SCIELO_ENABLE_DIAGNOSTICS=1');
$_SERVER['REMOTE_ADDR'] = '203.0.113.20';
assert_true(scielo_diagnostics_allowed() === false, 'remote diagnostics must remain disabled');
assert_true(scielo_diagnostic_mode_allowed('XML') === false, 'remote XML diagnostics must remain disabled');

$_SERVER['REMOTE_ADDR'] = '::1';
assert_true(scielo_diagnostics_allowed() === true, 'explicitly enabled loopback diagnostics should be allowed');

putenv('SCIELO_ENABLE_DIAGNOSTICS');
assert_true(scielo_diagnostics_allowed() === false, 'general loopback diagnostics require explicit enablement');
assert_true(scielo_diagnostic_mode_allowed('XML') === true, 'loopback XML compatibility mode should remain available');

$_GET = array('REQUEST_URI' => '/attacker', 'SCIELO_TEST_GLOBAL' => 'attacker');
$_POST = array();
$_COOKIE = array();
$_SERVER['REQUEST_URI'] = '/trusted';
require(__DIR__ . '/../htdocs/old2new.inc');

assert_true(!isset($GLOBALS['SCIELO_TEST_GLOBAL']), 'request keys must not be copied to GLOBALS');
assert_true($_SERVER['REQUEST_URI'] === '/trusted', 'request data must not overwrite SERVER values');
assert_true(isset($GLOBALS['HTTP_GET_VARS']), 'legacy request array alias should remain available');

$config = array('SCIELO' => array('SERVER_SCIELO' => '127.0.0.1:8080'));
assert_true(scielo_internal_host_from_config($config) === '127.0.0.1:8080', 'configured internal host should be returned');
assert_true(scielo_audit_sanitize('secret-value', 'password') === '***', 'sensitive audit fields must be redacted');

$old2newSource = file_get_contents(__DIR__ . '/../htdocs/old2new.inc');
$exportSource = file_get_contents(__DIR__ . '/../htdocs/export.php');
$articlePageSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/pages/services/articleRequestGraphicPage.php');
$sendMailSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/pages/services/sendMail.php');
$rssSource = file_get_contents(__DIR__ . '/../htdocs/rss.php');
$clinicalTrialsSource = file_get_contents(__DIR__ . '/../htdocs/scieloOrg/php/clinicaltrials.php');
$projectFapespSource = file_get_contents(__DIR__ . '/../htdocs/scieloOrg/php/projfapesp.php');

assert_true(strpos($old2newSource, '$GLOBALS[$key]') === false, 'old2new must not export arbitrary request keys');
assert_true(strpos($exportSource, "\$_SERVER['HTTP_HOST']") === false, 'export must not use the request Host as backend destination');
assert_true(strpos($articlePageSource, 'new ArticleService($requestedCaller)') === false, 'article statistics must not use the requested caller as a host');
assert_true(strpos($sendMailSource, 'new ArticleService($requestedCaller)') === false, 'send mail must not use the requested caller as a host');
assert_true(strpos($rssSource, "\$_SERVER['HTTP_HOST']") === false, 'RSS backends must not use the request Host');
assert_true(strpos($clinicalTrialsSource, "\$_SERVER['HTTP_HOST']") === false, 'clinical trials backend must not use the request Host');
assert_true(strpos($projectFapespSource, "\$_SERVER['HTTP_HOST']") === false, 'FAPESP project backend must not use the request Host');

fwrite(STDOUT, "Security regression tests passed" . PHP_EOL);
