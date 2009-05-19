<?php
include_once ("classLogDatabaseQueryArticleLanguageYear.php");

define ("LOGDEF", "../scielo.def.php");

$log = new LogDatabaseQueryArticleLanguageYear(LOGDEF);

if ( isset($dti) ) $log->SetInitialDate ($dti);
if ( isset($dtf) ) $log->SetFinalDate ($dtf);
if ( isset($pid) ) $log->SetPid ($pid);

if ( isset($script) )  $log->SetScriptName ($script);
if ( isset($lng) )  $log->SetInterfaceLanguage ($lng);
if ( isset($nrm) )  $log->SetStandard ($nrm);

$response = $log->getResultXML();
$log->destroy();

echo $response;

?>