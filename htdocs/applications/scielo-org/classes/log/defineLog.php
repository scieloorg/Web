<?php
/**
 * Constantes usadas pelo Servi�o de Log de Acessos
 */
/**
 * @param string LOG_DIR Diret�rio onde ser�o gravados os logs 
 */
define("LOG_DIR",$ini["LOG"]["SERVICES_LOG_DIRECTORY"]);
/**
 * @param string LOG_SEPARATOR Caracter delimitador de campos
 *
 */
define("LOG_SEPARATOR", ";");
/**
 * @param string LOG_ADMIN para quem vai ser mandando o e-mail de erro.
 *
 */
define("LOG_ADMIN", $ini["LOG"]["SERVICES_LOG_ERROR_MAIL_ALERT"]);

?>