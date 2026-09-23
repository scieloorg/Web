<?php

function assert_true($condition, $message)
{
    if (!$condition) {
        fwrite(STDERR, "FAIL: " . $message . PHP_EOL);
        exit(1);
    }
}

require_once(__DIR__ . '/../htdocs/security.php');
require_once(__DIR__ . '/../htdocs/applications/scielo-org/classes/domit-1/xml_domit_lite_include.inc.php');

$domitDocument = new DOMIT_Lite_Document();
assert_true($domitDocument->parseXML('<ARTICLE><TITLE>Safe title</TITLE></ARTICLE>') === true, 'DOMIT should parse XML on PHP 8.5');
$domitTitles = $domitDocument->getElementsByPath('//TITLE');
assert_true($domitTitles->item(0)->getText() === 'Safe title', 'DOMIT should expose parsed XML content');

assert_true(scielo_validate_internal_host('127.0.0.1') === '127.0.0.1', 'IPv4 host should be accepted');
assert_true(scielo_validate_internal_host('backend.example.org:8080') === 'backend.example.org:8080', 'hostname and port should be accepted');
assert_true(scielo_validate_internal_host('attacker.example/path') === false, 'path must not be accepted as a host');
assert_true(scielo_validate_internal_host('user@attacker.example') === false, 'userinfo must not be accepted as a host');
assert_true(scielo_validate_internal_host('backend.example.org:65536') === false, 'invalid port must be rejected');
assert_true(scielo_validate_article_pid('S0100-879X2013000100058') === 'S0100-879X2013000100058', 'valid article PID should be accepted');
assert_true(scielo_validate_article_pid('S0100-879X<script>') === false, 'markup must not be accepted in an article PID');
assert_true(scielo_validate_email_address("test@example.org\r\nBcc: attacker@example.org") === false, 'email header injection must be rejected');
assert_true(scielo_validate_person_name('Maria da Silva') === 'Maria da Silva', 'valid person name should be accepted');
assert_true(scielo_validate_person_name('<img src=x>') === false, 'markup must not be accepted in a person name');
assert_true(scielo_validate_comment(str_repeat('a', 1001)) === false, 'oversized comments must be rejected');
assert_true(scielo_escape_html('"<script>') === '&quot;&lt;script&gt;', 'HTML output must be contextually escaped');

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

$csrfToken = scielo_csrf_token();
assert_true(strlen($csrfToken) === 64, 'CSRF token should contain 256 bits encoded as hexadecimal');
assert_true(scielo_csrf_token_is_valid($csrfToken) === true, 'generated CSRF token should be valid');
assert_true(scielo_csrf_token_is_valid(str_repeat('0', 64)) === false, 'invalid CSRF token must be rejected');

$_SERVER['REMOTE_ADDR'] = '198.51.100.25';
$rateBucket = 'security-regression-' . getmypid();
assert_true(scielo_rate_limit($rateBucket, 2, 60)['allowed'] === true, 'first request should pass the rate limit');
assert_true(scielo_rate_limit($rateBucket, 2, 60)['allowed'] === true, 'second request should pass the rate limit');
assert_true(scielo_rate_limit($rateBucket, 2, 60)['allowed'] === false, 'request over the limit must be rejected');
@unlink(rtrim(sys_get_temp_dir(), DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . 'scielo-rate-limit'
    . DIRECTORY_SEPARATOR . hash('sha256', $rateBucket . '|' . $_SERVER['REMOTE_ADDR']) . '.json');

$old2newSource = file_get_contents(__DIR__ . '/../htdocs/old2new.inc');
$exportSource = file_get_contents(__DIR__ . '/../htdocs/export.php');
$articlePageSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/pages/services/articleRequestGraphicPage.php');
$sendMailSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/pages/services/sendMail.php');
$rssSource = file_get_contents(__DIR__ . '/../htdocs/rss.php');
$clinicalTrialsSource = file_get_contents(__DIR__ . '/../htdocs/scieloOrg/php/clinicaltrials.php');
$projectFapespSource = file_get_contents(__DIR__ . '/../htdocs/scieloOrg/php/projfapesp.php');
$statJournalSource = file_get_contents(__DIR__ . '/../htdocs/statjournal.php');
$articleGraphicSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/pages/services/articleRequestGraphic.php');
$serviceSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/classes/services/Service.php');
$accessServiceSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/classes/services/AccessServiceBar.php');
$graphSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/classes/Open_Flash_Chart/ofc-library/Graph.php');
$apacheSource = file_get_contents(__DIR__ . '/../docker/rocky9/httpd-scielo.conf');
$domitUtilitiesSource = file_get_contents(__DIR__ . '/../htdocs/applications/scielo-org/classes/domit-1/xml_domit_utilities.php');

assert_true(strpos($old2newSource, '$GLOBALS[$key]') === false, 'old2new must not export arbitrary request keys');
assert_true(strpos($exportSource, "\$_SERVER['HTTP_HOST']") === false, 'export must not use the request Host as backend destination');
assert_true(strpos($articlePageSource, 'new ArticleService($requestedCaller)') === false, 'article statistics must not use the requested caller as a host');
assert_true(strpos($sendMailSource, 'new ArticleService($requestedCaller)') === false, 'send mail must not use the requested caller as a host');
assert_true(strpos($rssSource, "\$_SERVER['HTTP_HOST']") === false, 'RSS backends must not use the request Host');
assert_true(strpos($clinicalTrialsSource, "\$_SERVER['HTTP_HOST']") === false, 'clinical trials backend must not use the request Host');
assert_true(strpos($projectFapespSource, "\$_SERVER['HTTP_HOST']") === false, 'FAPESP project backend must not use the request Host');
assert_true(strpos($statJournalSource, "\$_REQUEST['collection']") === false, 'journal statistics must not reflect an unescaped collection');
assert_true(strpos($articlePageSource, "\$_REQUEST['startYear']") === false, 'article statistics years must not use unvalidated request values');
assert_true(strpos($articleGraphicSource, "\$_REQUEST['pid']") === false, 'article graph must validate its PID');
assert_true(strpos($sendMailSource, "\$_mail->ErrorInfo") === false, 'mail transport details must not be returned to users');
assert_true(strpos($sendMailSource, 'scielo_csrf_token_is_valid') !== false, 'send mail must validate a CSRF token');
assert_true(strpos($sendMailSource, 'scielo_rate_limit') !== false, 'send mail must apply server-side rate limiting');
assert_true(strpos($serviceSource, "print '<!--'.\$url") === false, 'service URLs must not be disclosed in HTML comments');
assert_true(strpos($accessServiceSource, 'isset($values[$year])') !== false, 'article graph must tolerate years without access data');
assert_true(strpos($graphSource, 'function __construct()') !== false, 'legacy graph class must initialize on PHP 8.5');
assert_true(strpos($apacheSource, '.*\\.(?:inc|def|template)') !== false, 'Apache must block auxiliary file extensions');
assert_true(substr_count($apacheSource, 'Require all denied') >= 3, 'Apache must deny unsafe files and CGI by default');
assert_true(strpos($domitUtilitiesSource, 'public static function validateXML') !== false, 'DOMIT utility methods must support static calls on PHP 8.5');

fwrite(STDOUT, "Security regression tests passed" . PHP_EOL);
