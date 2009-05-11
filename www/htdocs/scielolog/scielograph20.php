<?php 

// Constantes

include_once ("jpgraph/jpgraph.php");
include_once ("jpgraph/jpgraph_pie.php");

include_once ("include_grafico.php");

//$ui=getmypid();
$ui=date('y').date('z');

$db_data=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/datemfn";
$db_acesso=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/acesso";
$db_tmp_issn=$defFile["PATH"]["PATH_DATABASE"]."/tmp/".$ui.".tab_issn";
$db_title=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/title/title";

$utl="/cisis";

//Busca o mfn inicial da data fim
//Se a data inicial nao foi passada pega a primeira data da base

$first_date=primeira_data($db_data);
if ($dti=='') {
    $dti=$first_date;
}
$mfn_ini=busca_mfnini($dti,$db_data);

//Busca o mfn final da data fim
//Se a data final nao foi passada pega a ultima data da base

$last_date=ultima_data($db_data);
if ($dtf=='') {
    $dtf=$last_date;
} 
$mfn_fim=busca_mfnfim($dtf,$db_data);

// ***********************************************************
// ********* Calcula e gera arquivos com totais  *************
// ***********************************************************

if (!file_exists($db_tmp_issn.".mst")) {
	$proc="\"proc='<100 0>',ref(['$db_title']l(['$db_title'],v1),v150),'</100>'\"";
	exec("$utl/mxtb $db_acesso create=$db_tmp_issn from=$mfn_ini to=$mfn_fim \"bool=artigos\" \"256:v1\" \"tab=v5\" \"class=120000\"");
	exec("$utl/msrt $db_tmp_issn \"128\" \"f(val('9999999')-val(v999),7,0)\" now");
	exec("$utl/mx $db_tmp_issn $proc copy=$db_tmp_issn -all now");	
	}
	
 //  ****** Acha soma total de frequencias  ***************************

	$result=exec("$utl/mx $db_tmp_issn \"pft=v999,':',\" now");
	//die($result);
	$array_total=split(":",$result);
	for ($i=0;$i < count($array_total);++$i) {
	  	if ($array_total[$i]!='') {
			$total=$total+$array_total[$i];
		} 
	}

// **************************************************************
// ********** Monta tabela com os dados   ***********************
// **************************************************************

	$pft_show="\"pft=v100,',',v999,':',\"";
	$OP="$utl/mx $db_tmp_issn \"count=10\" $pft_show now ";
	$result=exec($OP);

	$array_linha=split(":",$result);

	for ($i=0;$i < count($array_linha);++$i) {
	  	if ($array_linha[$i]!='') {
			$array=explode(",",$array_linha[$i]);
			$legenda[]=$array[0];
			$tot_top10=$tot_top10+$array[1];
			$data[]=$array[1];
		}
	}
	
	$legenda[]="Other Titles";
	$data[]=$total-$tot_top10;
	
	// operação retirada em 02/2006
	// Objetivo: aproveitar o arquivo já processada anteriormente, desde que no mesmo dia
	// $OP="rm -f $db_tmp_issn.* ";
	// $result=exec($OP);
	
// **************************************************************
// ********  Apresentação grafico                        ********
// **************************************************************	
	    $graph = new PieGraph (690,350);
     //   $graph->SetShadow ();

        // Create
        $p1 = new PiePlot ($data);
        // Set A title for the plot
        $p1->SetLegends ($legenda);
        $p1->SetSize (.4);
        $p1->SetCenter (.28,.5);
        $txt = new Text ("Most Visited Titles", 0.15, 0.00);
        
        $txt->SetFont(FONT1_BOLD);
        
        $graph->Add ($p1);
        $graph->AddText ($txt);
        $graph->Stroke ();      
		
?> 

