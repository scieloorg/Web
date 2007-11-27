<?php
/**
 * Constantes usadas pelo Serviço de Log de Acessos
 */
/**
 * @param string LOG_DIR Diretório onde serão gravados os logs 
 */
define("LOG_DIR",$ini["LOGS"]["SERVICESLOGPATH"]);
/**
 * @param string LOG_SEPARATOR Caracter delimitador de campos
 *
 */
define("LOG_SEPARATOR", ";");
/**
 * @param string LOG_ADMIN para quem vai ser mandando o e-mail de erro.
 *
 */
define("LOG_ADMIN", $ini["LOGS"]["SERVICES_LOG_ERROR_MAIL_ALERT"]);

?>