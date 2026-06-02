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

		exec(scielolog_shell_arg("$utl/mxtb")." ".scielolog_shell_arg($db_acesso_serv)." ".scielolog_shell_arg("create=$db_tmp_service02")." ".scielolog_bool_arg($bool)." ".scielolog_shell_arg("256:mhu,v4,")." ".scielolog_shell_arg("tab=v5")." ".scielolog_shell_arg("class=120000"));

	$proc_access=monta_proc($access);
		exec(scielolog_shell_arg("$utl/mx")." ".scielolog_shell_arg($db_tmp_service02)." ".scielolog_shell_arg("join=$db_issue,43=s('Y',v1*7.17)")." ".scielolog_shell_arg("proc='d32001'")." $proc_access ".scielolog_shell_arg("append=$db_tmp_service"));
	
// ***************************************************************
// ********  Camada de Apresentação dos dados             ********
// ********  Exibe os dados em formato XML para posterior ********
// ********  transformação pela XSL adequada              ********
// ***************************************************************

        $pft_show="\"pft='<SERVICE>'/,'<TIPO>',v1,'</TIPO>'/,'<TOTAL>',v999,'</TOTAL>'/,'</SERVICE'#,\"";	
		$result=exec(scielolog_shell_arg("/usr/local/bireme/cisis/4.3a/lind/mx")." ".scielolog_shell_arg($db_tmp_service)." btell=0 lw=99999 ".scielolog_shell_arg("pft='<SERVICE>','<TIPO>',v1,'</TIPO>','<TOTAL>',v999,'</TOTAL>','</SERVICE>',")." +hits now");

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

scielolog_remove_temp_files($db_tmp_service);
scielolog_remove_temp_files($db_tmp_service02);
?> 

