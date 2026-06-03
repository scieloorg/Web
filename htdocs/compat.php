<?php

define('SCIELO_COMPAT_LOADED', true);

function scielo_utf8_encode($value)
{
    if (function_exists('mb_convert_encoding')) {
        return mb_convert_encoding((string)$value, 'UTF-8', 'ISO-8859-1');
    }
    return utf8_encode((string)$value);
}

function scielo_utf8_decode($value)
{
    if (function_exists('mb_convert_encoding')) {
        return mb_convert_encoding((string)$value, 'ISO-8859-1', 'UTF-8');
    }
    return utf8_decode((string)$value);
}

// Legacy regex functions removed in PHP 7+.
if (!function_exists('ereg')) {
    function ereg($pattern, $string, &$regs = null)
    {
        $result = preg_match('/' . str_replace('/', '\\/', $pattern) . '/', (string)$string, $matches);
        if ($regs !== null) {
            $regs = $matches;
        }
        return $result;
    }
}

if (!function_exists('eregi')) {
    function eregi($pattern, $string, &$regs = null)
    {
        $result = preg_match('/' . str_replace('/', '\\/', $pattern) . '/i', (string)$string, $matches);
        if ($regs !== null) {
            $regs = $matches;
        }
        return $result;
    }
}

if (!function_exists('ereg_replace')) {
    function ereg_replace($pattern, $replacement, $string)
    {
        return preg_replace('/' . str_replace('/', '\\/', $pattern) . '/', $replacement, (string)$string);
    }
}

if (!function_exists('eregi_replace')) {
    function eregi_replace($pattern, $replacement, $string)
    {
        return preg_replace('/' . str_replace('/', '\\/', $pattern) . '/i', $replacement, (string)$string);
    }
}

if (!function_exists('split')) {
    function split($pattern, $string, $limit = -1)
    {
        return preg_split('/' . str_replace('/', '\\/', $pattern) . '/', (string)$string, (int)$limit);
    }
}

if (!function_exists('spliti')) {
    function spliti($pattern, $string, $limit = -1)
    {
        return preg_split('/' . str_replace('/', '\\/', $pattern) . '/i', (string)$string, (int)$limit);
    }
}

if (!function_exists('each')) {
    function each(&$array)
    {
        $key = key($array);
        if ($key === null) {
            return false;
        }

        $value = current($array);
        next($array);

        return array(
            0 => $key,
            1 => $value,
            'key' => $key,
            'value' => $value,
        );
    }
}

if (!function_exists('set_magic_quotes_runtime')) {
    function set_magic_quotes_runtime($newSetting)
    {
        return false;
    }
}

if (!function_exists('get_magic_quotes_gpc')) {
    function get_magic_quotes_gpc()
    {
        return false;
    }
}

if (!function_exists('session_register')) {
    function session_register(...$vars)
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            @session_start();
        }

        foreach ($vars as $name) {
            if (isset($GLOBALS[$name])) {
                $_SESSION[$name] = $GLOBALS[$name];
            } elseif (!isset($_SESSION[$name])) {
                $_SESSION[$name] = null;
            }
        }

        return true;
    }
}

if (!function_exists('apache_request_headers')) {
    function apache_request_headers()
    {
        $headers = array();
        foreach ($_SERVER as $name => $value) {
            if (strpos($name, 'HTTP_') === 0) {
                $key = str_replace('_', '-', ucwords(strtolower(substr($name, 5)), '_'));
                $headers[$key] = $value;
            }
        }
        return $headers;
    }
}

if (!function_exists('mysql_connect')) {
    $GLOBALS['__scielo_mysql_last_link'] = null;
    $GLOBALS['__scielo_mysql_error'] = '';
    $GLOBALS['__scielo_mysql_errno'] = 0;

    function __scielo_mysql_set_error($link = null)
    {
        if ($link instanceof mysqli) {
            $GLOBALS['__scielo_mysql_errno'] = mysqli_connect_errno() ?: mysqli_errno($link);
            $GLOBALS['__scielo_mysql_error'] = mysqli_connect_error() ?: mysqli_error($link);
            return;
        }
        $GLOBALS['__scielo_mysql_errno'] = mysqli_connect_errno();
        $GLOBALS['__scielo_mysql_error'] = mysqli_connect_error();
    }

    function __scielo_mysql_get_link($link = null)
    {
        if ($link instanceof mysqli) {
            return $link;
        }
        if ($GLOBALS['__scielo_mysql_last_link'] instanceof mysqli) {
            return $GLOBALS['__scielo_mysql_last_link'];
        }
        return null;
    }

    function mysql_connect($server = null, $username = null, $password = null, $new_link = false, $client_flags = 0)
    {
        if (!function_exists('mysqli_connect')) {
            return false;
        }
        $link = @mysqli_connect($server, $username, $password);
        if (!$link) {
            __scielo_mysql_set_error();
            return false;
        }
        $GLOBALS['__scielo_mysql_last_link'] = $link;
        return $link;
    }

    function mysql_pconnect($server = null, $username = null, $password = null, $client_flags = 0)
    {
        return mysql_connect($server, $username, $password, true, $client_flags);
    }

    function mysql_close($link_identifier = null)
    {
        $link = __scielo_mysql_get_link($link_identifier);
        if (!$link) {
            return false;
        }
        return mysqli_close($link);
    }

    function mysql_select_db($database_name, $link_identifier = null)
    {
        $link = __scielo_mysql_get_link($link_identifier);
        if (!$link) {
            return false;
        }
        $result = mysqli_select_db($link, $database_name);
        if (!$result) {
            __scielo_mysql_set_error($link);
        }
        return $result;
    }

    function mysql_query($query, $link_identifier = null)
    {
        $link = __scielo_mysql_get_link($link_identifier);
        if (!$link) {
            return false;
        }
        $result = mysqli_query($link, $query);
        if ($result === false) {
            __scielo_mysql_set_error($link);
        }
        return $result;
    }

    function mysql_fetch_row($result)
    {
        return mysqli_fetch_row($result);
    }

    function mysql_fetch_array($result, $result_type = MYSQLI_BOTH)
    {
        return mysqli_fetch_array($result, $result_type);
    }

    function mysql_fetch_assoc($result)
    {
        return mysqli_fetch_assoc($result);
    }

    function mysql_num_rows($result)
    {
        return mysqli_num_rows($result);
    }

    function mysql_free_result($result)
    {
        return mysqli_free_result($result);
    }

    function mysql_insert_id($link_identifier = null)
    {
        $link = __scielo_mysql_get_link($link_identifier);
        if (!$link) {
            return 0;
        }
        return mysqli_insert_id($link);
    }

    function mysql_affected_rows($link_identifier = null)
    {
        $link = __scielo_mysql_get_link($link_identifier);
        if (!$link) {
            return -1;
        }
        return mysqli_affected_rows($link);
    }

    function mysql_errno($link_identifier = null)
    {
        $link = __scielo_mysql_get_link($link_identifier);
        if ($link) {
            return mysqli_errno($link);
        }
        return (int)$GLOBALS['__scielo_mysql_errno'];
    }

    function mysql_error($link_identifier = null)
    {
        $link = __scielo_mysql_get_link($link_identifier);
        if ($link) {
            return mysqli_error($link);
        }
        return (string)$GLOBALS['__scielo_mysql_error'];
    }

    function mysql_escape_string($unescaped_string)
    {
        $link = __scielo_mysql_get_link();
        if ($link) {
            return mysqli_real_escape_string($link, $unescaped_string);
        }
        return addslashes($unescaped_string);
    }

    function mysql_real_escape_string($unescaped_string, $link_identifier = null)
    {
        $link = __scielo_mysql_get_link($link_identifier);
        if ($link) {
            return mysqli_real_escape_string($link, $unescaped_string);
        }
        return addslashes($unescaped_string);
    }
}
