<?php 
include_once ("include_grafico.php");
include_once ("include_montaXML.php");

$script=$_REQUEST["script"];
$dti=$_REQUEST["dti"];
$dtf=$_REQUEST["dtf"];
$nlines=$_REQUEST["nlines"];
$cpage=$_REQUEST["cpage"];
$order=$_REQUEST["order"];
$lng=$_REQUEST["lng"];
$pid=$_REQUEST["pid"];
// Constantes

$ui=getmypid();

// INICIO - Configuração das variaveis
// dependem da instalação

$Temp=$defFile["PATH"]["PATH_DATABASE"]."/tmp/";
$Trab=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/";
$TrabArt=$defFile["PATH"]["PATH_DATABASE"]."/artigo/";

$utl=$defFile["PATH"]["PATH_PROC"]."/cisis";

// FIM - Configuração das variaveis

if ($lang=='') { $lang='en'; }

// Seta arquivos de leitura
$db_data=$Trab."datemfn";
$db_data_art=$Trab."articles/datemfn_$pid";
$db_acesso=$Trab."acesso";

//$db_acesso_art=$Trab."acesso_articles";
$db_acesso_art=$Trab."articles/articles".$pid;

$db_issn=$Trab."issn";
$db_artigonp=$TrabArt."artigo";
$db_issue=$defFile["PATH"]["PATH_DATABASE"]."/issue/issue";
$gizmo=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/gizmoLR";

// Seta arquivos temporarios
$db_tmp_artigo=$Temp.$ui.".tab_artigo";
$db_tmp_pid=$Temp.$ui.".tab_pid";
$db_tmp_home=$Temp.$ui.".tab_home";
$db_tmp_sumario=$Temp.$ui.".tab_sumario";
$db_tmp_outros=$Temp.$ui.".tab_outros";
$db_tmp_fasc=$Temp.$ui.".tab_fasc";
$db_tmp_fasc02=$Temp.$ui.".tab_fasc02";
$db_tmp_article=$Temp.$ui.".tab_article";
$db_tmp_article02=$Temp.$ui.".tab_article02";


// Seta variaveis que não foram enviadas pelo request
if ($nlines=="") {
   $nlines="80";
  }
if ($cpage=="") { 
   $cpage=1;
  }
if ($order=="") { 
   $order=1;
  }
if ($lng=='') { 
  	$lng="en";
  };
 
//Busca o mfn inicial da data fim
//Se a data inicial nao foi passada pega a primeira data da base

$first_date=primeira_data($db_data);

if ($dti=='') {
    $dti=$first_date;
}

$mfn_ini=busca_mfnini($dti,$db_data);
$mfn_ini_art=busca_mfnini($dti,$db_data_art);

//Busca o mfn final da data fim
//Se a data final nao foi passada pega a ultima data da base

$last_date=ultima_data($db_data);
if ($dtf=='') {
    $dtf=$last_date;
}
$mfn_fim=busca_mfnfim($dtf,$db_data);
$mfn_fim_art=busca_mfnfim($dtf,$db_data_art);

// ***********************************************************
// ********* Camada de Processamento dos Dados   *************
// ********* Calcula e gera arquivos com totais  *************
// ***********************************************************

if ($script=='sci_journalstat') {
	// ***** Calcula total por revistas *****
	$bool2=monta_bool02($pid);
	$bool=monta_bool($pid,"artigos");
	exec("$utl/mxtb $db_acesso create=$db_tmp_artigo from=$mfn_ini to=$mfn_fim $bool \"256:mhu,v1,'@',v4\" \"tab=v5\" \"class=120000\"");
	exec("$utl/mx $db_tmp_artigo \"fst=1 0 v1/\" fullinv=$db_tmp_artigo now");
	// ***** Calcula total home *****
	$bool=monta_bool($pid,"home");
	exec("$utl/mxtb $db_acesso create=$db_tmp_home from=$mfn_ini to=$mfn_fim $bool \"256:mhu,v1,'@',v4\" \"tab=v5\" \"class=120000\"");
	exec("$utl/mx $db_tmp_home \"fst=1 0 v1/\" fullinv=$db_tmp_home now");
	// ***** Calcula total sumario *****
	$bool=monta_bool($pid,"sumario");
	exec("$utl/mxtb $db_acesso create=$db_tmp_sumario from=$mfn_ini to=$mfn_fim $bool \"256:mhu,v1,'@',v4\" \"tab=v5\" \"class=120000\"");
	exec("$utl/mx $db_tmp_sumario \"fst=1 0 v1/\" fullinv=$db_tmp_sumario now");
	// ***** Calcula total outros *****
	$bool=monta_bool($pid,"outros");
	exec("$utl/mxtb $db_acesso create=$db_tmp_outros from=$mfn_ini to=$mfn_fim $bool \"256:mhu,v1,'@',v4\" \"tab=v5\" \"class=120000\"");
	exec("$utl/mx $db_tmp_outros \"fst=1 0 v1/\" fullinv=$db_tmp_outros now");
} elseif ($script=='sci_statiss') {
    // ***** Calcula total por fasciculos *****
	$bool=monta_bool($pid,"fasciculo");
	exec("$utl/mxtb $db_acesso create=$db_tmp_fasc02 from=$mfn_ini to=$mfn_fim $bool \"256:if p(v2) then mhu,v1','v2 fi\" \"tab=v5\" \"class=120000\"");
	$proc_access=monta_proc($access);
	exec("$utl/mx $db_tmp_fasc02 \"join=$db_issue,43=s('Y',replace(v1,',',''))\" \"proc='d32001'\" $proc_access \"proc=if a(v43) then 'd*' fi\" \"append=$db_tmp_fasc\"");
	exec("$utl/msrt $db_tmp_fasc \"128\" \"f(val('9999999')-val(v999),7,0)\"");
	// ***** Pega o total de registros *****
	$OP1="$utl/mx $db_tmp_fasc now +control";
	$result=exec($OP1);
	$tot_regs=total_registros($result);
	// ***** Calcula o total de paginas *****
	$tot_pags=ceil($tot_regs / $nlines);
	// ***** Calcula proxima pagina ********
	$nextpg=($cpage+1);
	// ***** Pega a maior frequencia *****
	$OP="$utl/mx $db_tmp_fasc \"from=1\" \"to=1\" \"pft=v999/\" now";
	$max_val=exec($OP);
	$list_box=calcula_list_box($max_val);
	$list_boxXML=calcula_list_box_XML($max_val);
} elseif ($script=='sci_statart') {
    // ***** Calcula total por artigos *****
	$bool=monta_bool($pid,"articles");
	//exec("$utl/mxtb $db_acesso_art create=$db_tmp_article02 from=$mfn_ini_art to=$mfn_fim_art $bool \"256:mhu,v1,',',v2,\" \"tab=v5\" \"class=120000\"");
	die("$utl/mxtb $db_acesso_art create=$db_tmp_article02 from=$mfn_ini_art to=$mfn_fim_art \"256:mhu,v1,',',v2,\" \"tab=v5\" \"class=120000\"");
	$proc_access=monta_proc($access);
	exec("$utl/mx $db_tmp_article02 \"join=$db_issue,43=s('Y',replace(v1*0.18,',',''))\" \"proc='d32001'\" $proc_access \"append=$db_tmp_article\"");
	exec("$utl/mx $db_tmp_article \"join=$db_artigonp=s('HR=S',replace(v1,',',''))\" copy=$db_tmp_article -all now");
	exec("$utl/msrt $db_tmp_article \"128\" \"f(val('9999999')-val(v999),7,0)\"");
	// ***** Pega o total de registros *****
	$OP1="$utl/mx $db_tmp_article now +control";
	$result=exec($OP1);
	$tot_regs=total_registros($result);
	// ***** Calcula o total de paginas *****
	$tot_pags=ceil($tot_regs / $nlines);
	// ***** Calcula proxima pagina ********
	$nextpg=($cpage+1);
	// ***** Pega a maior frequencia *****
	$OP="$utl/mx $db_tmp_article \"from=1\" \"to=1\" \"pft=v999/\" now";
	$max_val=exec($OP);
	$list_box=calcula_list_box($max_val);
	$list_boxXML=calcula_list_box_XML($max_val);
}

// ***************************************************************
// ********  Camada de Apresentação dos dados             ********
// ********  Exibe os dados em formato XML para posterior ********
// ********  transformação pela XSL adequada              ********
// ***************************************************************

if ($script=='sci_journalstat') {
	$pft_show=monta_pft_journalstat($pid,$script,$db_tmp_home,$db_tmp_sumario,$db_tmp_artigo,$db_tmp_outros);
	$journal=exec("$utl/mx $db_issn btell=0 lw=99999 $bool2 $pft_show +hits now");
	$journal=str_replace('<aspas>','"',$journal);
	$arr=split('<line>',$journal);
	//echo "$first_date \n $last_date \n $order \n $dti \n $dtf \n $pid";
	$xml.= monta_xml_statparam($first_date,$last_date,$order,$dti,$dtf,$pid);
	if ($pid=='') { $xml.='<LIST>\n'; };
	for ($i=0; $i<count($arr); $i++) {
		$xml.= $arr[$i];
		$xml.="\n";
	}
	if ($pid=='') { $xml.='</LIST>\n'; };
 } elseif ($script=='sci_statiss') {
	$from=calcula_from($cpage,$nlines);
	$pft_show=monta_pft_statiss($pid,$lng,$db_issn);
	$result=exec("$utl/mx $db_tmp_fasc btell=0 lw=99999 from=$from count=$nlines $pft_show +hits now");
	$result=str_replace('<aspas>','"',$result);
	$arr=split('<line>',$result);
	$xml.=monta_xml_statparam($first_date,$last_date,$order,$dti,$dtf,$pid); 	$next=calcula_next($cpage,$tot_pags);
	$previous=calcula_previous($cpage,$tot_pags);
//	$previous=1;
	$xml.="\n<QUERY_RESULT_PAGES CURRENT=\"$cpage\" NEXT=\"$next\" PREVIOUS=\"$previous\" TOTAL=\"$tot_pags\" NLINES=\"$nlines\"/>\n\n";
	$xml.="<POSSIBLE_NO_ACCESS MAX=\"$max_val\">\n";
    $xml.=$list_boxXML;
	$xml.="</POSSIBLE_NO_ACCESS>\n\n";
	$xml.="<ISSUE_LIST>\n";
	for ($i=0; $i<count($arr); $i++) {
		$xml.= $arr[$i];
		$xml.="\n";
	} 
	$xml.="</ISSUE_LIST>\n";
} elseif ($script=='sci_statart') { 
    $from=calcula_from($cpage,$nlines);
	$pft_show=monta_pft_statart($pid,$lng,$db_issn);
	$result=exec("$utl/mx $db_tmp_article btell=0 lw=99999 from=$from count=$nlines gizmo=$gizmo $pft_show  now");
	$result=str_replace('<aspas>','"',$result);
	$result=str_replace('\n','',$result);
	$arr=split('<line>',$result);
	$xml.=monta_xml_statparam($first_date,$last_date,$order,$dti,$dtf,$pid);
	$xml.="\n<QUERY_RESULT_PAGES CURRENT=\"$cpage\" NEXT=\"$nextpg\" TOTAL=\"$tot_pags\" NLINES=\"$nlines\"/>\n\n";
	$xml.="<POSSIBLE_NO_ACCESS MAX=\"$max_val\">\n";
    $xml.=$list_boxXML;
	$xml.="</POSSIBLE_NO_ACCESS>\n\n";
	$xml.="<ARTICLE_LIST>\n";
	for ($i=0; $i<count($arr); $i++) {
		$xml.= $arr[$i];
		$xml.="\n";
	} 
	$xml.="</ARTICLE_LIST>\n";
}

echo $xml;

exec("rm -f $db_tmp_article02.* $db_tmp_pid.* $db_tmp_fasc02.* $db_tmp_article.* $db_tmp_article02. $db_tmp_fasc.* $db_tmp_outros.* $db_tmp_sumario.* $db_tmp_home.* $db_tmp_artigo.*");

?> 

