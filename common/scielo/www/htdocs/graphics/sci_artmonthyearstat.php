<?php
include_once ("classLogDatabaseQueryArticleMonthYear.php");

define ("LOGDEF", "../scielo.def.php");
define ("MYSQL_SUCCESS", 0);


/***************************************************************************************************/
/****************************************    MAIN CODE    ******************************************/
/***************************************************************************************************/
$log = new LogDatabaseQueryArticleMonthYear(LOGDEF);
if ( isset($pid) ) $log->SetPid ($pid);
if ( isset($debug) ) $log->SetDebug ($debug);
if ( isset($script) )  $log->SetScriptName ("sci_artmonthyearstat");
if ( isset($lng) )  $log->SetInterfaceLanguage ($lng);
if ( isset($nrm) )  $log->SetStandard ($nrm);

$response = $log->getResultXML();
$log->destroy();

echo $response;
?>
