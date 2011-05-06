<?php

// Codigo para compatibilizar versoes anteriores do PHP
// que consideravam qualquer coisa que vinha do usuario
// como variavel globa (versoes anteriores ao PHP 4.1)
/*
Em PHP anterior a 4.1 temos:
$PHP_SELF...........The filename of the currently executing script, relative to the document root.
                    If PHP is running as a command-line processor, this variable is not available. 
$HTTP_COOKIE_VARS...An associative array of variables passed to the current script via HTTP cookies. 
$HTTP_GET_VARS......An associative array of variables passed to the current script via the HTTP GET method. 
$HTTP_POST_VARS.....An associative array of variables passed to the current script via the HTTP POST method. 
$HTTP_POST_FILES....An associative array of variables containing information about files uploaded via the
                    HTTP POST method. See POST method uploads for information on the contents of $HTTP_POST_FILES. 
$HTTP_POST_FILES....is available only in PHP 4.0.0 and later. 
$HTTP_ENV_VARS......An associative array of variables passed to the current script via the parent environment. 
$HTTP_SERVER_VARS...An associative array of variables passed to the current script from the HTTP server.
                    These variables are analogous to the Apache variables described above. 
Em PHP 4.2 temos:
$_GET.......contains form variables sent through GET 
$_POST......contains form variables sent through POST 
$_COOKIE....contains HTTP cookie variables 
$_SERVER....contains server variables (e.g., REMOTE_ADDR) 
$_ENV.......contains the environment variables 
$_REQUEST...a merge of the GET variables, POST variables and Cookie
            variables. In other words - all the information that is
			coming from the user, and that from a security point of
			view, cannot be trusted. 
$_SESSION...contains HTTP variables registered by the session module
$_POST......Variables provided to the script via HTTP POST. Analogous
            to the old $HTTP_POST_VARS array (which is still available,
			but deprecated). 

*/
$old2newArray = array("HTTP_POST_VARS"    => "_POST",
                      "HTTP_GET_VARS"     => "_GET",
					  "HTTP_COOKIE_VARS"  => "_COOKIE",
					  "HTTP_SERVER_VARS"  => "_SERVER",
					  "HTTP_ENV_VARS"     => "_ENV",
					  "HTTP_SESSION_VARS" => "_SESSION",
					  "HTTP_POST_FILES " => "_REQUEST");
reset($old2newArray);
while (list($old, $new) = each($old2newArray))
{
	if  (!isset($$old) && isset($$new)) $$old = $$new;
	if  (isset($$old))
	{
		reset($$old);
		while (list($key, $value) = each($$old)) $GLOBALS[$key] = $value;
	}
}

?>