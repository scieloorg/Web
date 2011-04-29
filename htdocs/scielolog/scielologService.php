<?php 
include_once ("include_grafico.php");
include_once ("include_montaXML.php");
// Constantes
$ui=getmypid();

// INICIO - Configuração das variaveis
// dependem da instalação

$Temp=$defFile["PATH"]["PATH_DATABASE"]."/bases/tmp/";
$Trab=$defFile["PATH"]["PATH_DATABASE"]."/bases/accesslog/log_scielo/trab/";
$utl=$defFile["PATH"]["PATH_PROC"]."/cisis";

// FIM - Configuração das variaveis

if ($lang=='') { $lang='en'; }

// Seta arquivos de leitura

$db_acesso_serv=$Trab."services/services".$issn;

$db_issn=$Trab."issn";
$db_artigonp=$Trab."artigonp";
$db_issue=$defFile["PATH"]["PATH_DATABASE"]."/bases/issue/issue";
$gizmo=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/gizmoLR";

// Seta arquivos temporarios

$db_tmp_service=$Temp.$ui.".tab_service";
$db_tmp_service02=$Temp.$ui.".tab_service02";


// Seta variaveis que não foram enviadas pelo request
  
if ($lng=='') { 
  	$lng="en";
  };

$bool=$issn;
if ($pid != '') {
	$bool.=' and '.$pid;
}
 
// ***********************************************************
// ********* Camada de Processamento dos Dados   *************
// ********* Calcula e gera arquivos com totais  *************
// ***********************************************************


    // ***** Calcula total por artigos *****

	exec("$utl/mxtb $db_acesso_serv create=$db_tmp_service02  \"bool=$bool\" \"256:mhu,v4,\" \"tab=v5\" \"class=120000\"");

	$proc_access=monta_proc($access);
	exec("$utl/mx $db_tmp_service02 \"join=$db_issue,43=s('Y',v1*7.17)\" \"proc='d32001'\" $proc_access \"append=$db_tmp_service\"");
	
// ***************************************************************
// ********  Camada de Apresentação dos dados             ********
// ********  Exibe os dados em formato XML para posterior ********
// ********  transformação pela XSL adequada              ********
// ***************************************************************

        $pft_show="\"pft='<SERVICE>'/,'<TIPO>',v1,'</TIPO>'/,'<TOTAL>',v999,'</TOTAL>'/,'</SERVICE'#,\"";	
	$result=exec("/usr/local/bireme/cisis/4.3a/lind/mx $db_tmp_service btell=0 lw=99999 \"pft='<SERVICE>','<TIPO>',v1,'</TIPO>','<TOTAL>',v999,'</TOTAL>','</SERVICE>',\"  +hits now");

	$xml="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>";
	$xml.="\n<ROOT>";
	$xml.="\n<STATPARAM>\n";
 	$xml.="<FILTER>\n";
 	$xml.="<ORDER>1</ORDER>\n";
 	$xml.="</FILTER>\n";
 	$xml.="</STATPARAM>\n";
	$xml.="<ISSN TYPE=\"PRINT\">$issn</ISSN>\n";
	if ($pid != '') {
		$xml.="<PID>".$pid."</PID>\n";
	}
	$xml.="<SERVICE_LIST>\n";
        $xml.=$result;
	$xml.="</SERVICE_LIST>\n";
	$xml.="</ROOT>";

echo $xml;

exec("rm -f $db_tmp_service.* $db_tmp_service02.*");
?> 

