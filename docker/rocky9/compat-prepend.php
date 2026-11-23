<?php

/**
 * Conditionally prepend htdocs/compat.php without mutating per-worker PHP-FPM
 * INI state via SetEnv PHP_ADMIN_VALUE on /health.php.
 */
if (
    (isset($_SERVER['SCRIPT_FILENAME']) ? $_SERVER['SCRIPT_FILENAME'] : '') !== '/opt/scielo-health/health.php'
    && is_file('/var/www/html/htdocs/compat.php')
) {
    require_once '/var/www/html/htdocs/compat.php';
}
