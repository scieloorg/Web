<?php 
include_once ("include_grafico.php");
include_once ("include_montaXML.php");
// Constantes

$ui=getmypid();
$pid=$_REQUEST["pid"];
$app=$_REQUEST["app"];

// INICIO - Configuracao das variaveis
// dependem da instalacao

if ($app=='') {
	$app='scielo';
}


$Temp=$defFile["PATH"]["PATH_DATABASE"]."/tmp/";
$Trab=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/";
$TrabArt=$defFile["PATH"]["PATH_DATABASE"]."/artigo/";
$utl=$defFile["PATH"]["PATH_PROC"]."/cisis";


// FIM - Configuração das variaveis

if ($lang=='') { $lang='en'; }

$issn=substr($pid,1,9);

// Seta arquivos de leitura

$db_data_art=$Trab."articles/datemfn_".$issn;

//$db_acesso_art=$Trab."acesso_articles";
$db_acesso_art=$Trab."articles/articles".$issn;

$db_issn=$Trab."issn";
$db_artigonp=$Trab."artigonp";
$db_issue=$Trab."/issue/issue";
$gizmo="/home/scielolog/scielolog/gizmoLR";

// Seta arquivos temporarios

$db_tmp_article=$Temp.$ui.".tab_article";
$db_tmp_article02=$Temp.$ui.".tab_article02";


// Seta variaveis que não foram enviadas pelo request
  
if ($lng=='') { 
  	$lng="en";
  };
 
//Busca o mfn inicial da data fim
//Se a data inicial nao foi passada pega a primeira data da base

$first_date=primeira_data($db_data_art);
if ($dti=='') {
    $dti=$first_date;
}

$mfn_ini_art=busca_mfnini($dti,$db_data_art);

//Busca o mfn final da data fim
//Se a data final nao foi passada pega a ultima data da base

$last_date=ultima_data($db_data_art);
if ($dtf=='') {
    $dtf=$last_date;
}

$mfn_fim_art=busca_mfnfim($dtf,$db_data_art);

// ***********************************************************
// ********* Camada de Processamento dos Dados   *************
// ********* Calcula e gera arquivos com totais  *************
// ***********************************************************


    // ***** Calcula total por artigos *****

	exec("$utl/mxtb $db_acesso_art create=$db_tmp_article02 from=$mfn_ini_art to=$mfn_fim_art \"bool=$pid\" \"256:mhu,v3*0.6'|'v1,v2,\" \"tab=v5\" \"class=120000\"");

	$proc_access=monta_proc($access);
	exec("$utl/mx $db_tmp_article02 \"join=$db_issue,43=s('Y',v1*7.17)\" \"proc='d32001'\" $proc_access \"append=$db_tmp_article\"");
	exec("$utl/mx $db_tmp_article \"join=$db_artigonp=s('HR=S',v1*7)\" copy=$db_tmp_article -all now");

        exec("$utl/msrt $db_tmp_article \"30\" \"v1*0.6\"");
	
// ***************************************************************
// ********  Camada de Apresentação dos dados             ********
// ********  Exibe os dados em formato XML para posterior ********
// ********  transformação pela XSL adequada              ********
// ***************************************************************

	$pft_show=monta_pft_statart02($pid,$lng,$db_issn);
	
	$result=exec("$utl/mx $db_tmp_article btell=0 lw=99999 gizmo=$gizmo $pft_show +hits now");
	$result=str_replace('<aspas>','"',$result);
	$result=str_replace('\n','',$result);
	$arr=split('<line>',$result);

	$xml="<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>";
	$xml.="<ROOT>";
	$xml.="\n<STATPARAM>\n";
 	$xml.="<START_DATE>$first_date</START_DATE>\n";
 	$xml.="<CURRENT_DATE>$last_date</CURRENT_DATE>\n";
 	$xml.="<FILTER>\n";
 	$xml.="<ORDER>1</ORDER>\n";
 	$xml.="<INITIAL_DATE>$dti</INITIAL_DATE>\n";
 	$xml.="<FINAL_DATE>$dtf</FINAL_DATE>\n";
 	$xml.="</FILTER>\n";
 	$xml.="</STATPARAM>\n";
	$xml.="<ISSN TYPE=\"PRINT\">$issn</ISSN>\n";
	$xml.="<ARTICLE_LIST>\n";
	
	for ($i=0; $i<count($arr); $i++) {
		$xml.= $arr[$i];
		$xml.="\n";
	} 
	
	$xml.="</ARTICLE_LIST>\n";
	$xml.="</ROOT>";

echo $xml;

exec("rm -f $db_tmp_article.* $db_tmp_article02.*");
?> 

