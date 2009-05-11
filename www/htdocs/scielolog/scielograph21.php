<?php 

// Constantes

include_once ("jpgraph/jpgraph.php");
include_once ("jpgraph/jpgraph_log.php");
include_once ("jpgraph/jpgraph_bar.php");

include_once ("include_grafico.php");

$ui=date('y').date('z');

$db_data=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/datemfn";
$db_acesso=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/trab/acesso";
$db_tmp_datatb=$defFile["PATH"]["PATH_DATABASE"]."/tmp/".$ui.".tab_datatb";
$db_title=$defFile["PATH"]["PATH_DATABASE"]."/accesslog/log_scielo/title/title";

$utl="/cisis";

for ($j=0;$j < count($pid);++$j) {
	$pid2.=$pid[$j];
}

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
// Tabula os anos existentes na base de acesso e tranforma em um array

    if (!file_exists($db_tmp_datatb.".mst")) {
		exec("$utl/mxtb $db_data create=$db_tmp_datatb from=2 \"256:v1.4/,\" \"class=120000\"");
		exec("$utl/msrt $db_tmp_datatb \"256\" \"v1/\"");
	}
	
	$result=exec("$utl/mx $db_tmp_datatb \"pft=v1,':'\" now"); 
	$array_ano=split(":",$result);
	
	// Para cada ano faz uma tabulação separada na base de acesso
	
	for ($i=0;$i < count($array_ano);++$i) {
	  	if ($array_ano[$i]!='') {
			$db_tmp_ano=$defFile["PATH"]["PATH_DATABASE"]."/tmp/".$ui.$pid2.".tab_ano".$array_ano[$i];
			//$bool="\"bool=artigos and $array_ano[$i]$\"";
			$str="artigos and $array_ano[$i]$";
			$bool=monta_bool_array($pid,$str);
			if (!file_exists($db_tmp_ano.".mst")) {
				exec("$utl/mxtb $db_acesso create=$db_tmp_ano $bool \"256:v3*4.2/,\" \"tab=v5\" \"class=120000\"");
				exec("$utl/msrt $db_tmp_ano \"256\" \"v1/\"");
			}
			$result=exec("$utl/mx $db_tmp_ano \"pft=v1,',',v999,':'\" now"); 
			$array_linha=split(":",$result);
			$serie=Array (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			for ($j=0;$j < count($array_linha);++$j) {
	 	 		if ($array_linha[$j]!='') {
					$array=explode(",",$array_linha[$j]);
					$idx=$array[0]-1;
					$serie[$idx]=$array[1];
				}
			}
			$data[$i]=$serie;
			$legend[]=$array_ano[$i];
			if (!$pid=='') {
				exec("rm -f $db_tmp_ano.* ");
			}
		}		
	}
	
		//$OP="rm -f $db_tmp_datatb.*";
		//$result=exec($OP);
	
// **************************************************************
// ********  Apresentação grafico                        ********
// **************************************************************	

		$months = Array ("Ene", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
    
	    $graph = new Graph(620,450);
        $graph->img->SetMargin(60,135,40,40);
        $graph->SetShadow();
        $graph->SetScale("textlog");
        $colors = Array ("hotpink", "green", "blue", "gold", "blueviolet", "deepskyblue", "brown", "cadetblue", "darksalmon", "cornflowerblue", "darkslateblue", "limegreen", "yellow", "navy", "slategray");

        srand (1);

        for ($i = 0; $i < sizeof($data); $i++)    {
            $bplot[$i] = new BarPlot($data[$i]);
			$a=$data[$i];
		//	echo "<br>$i - 0=$a[0] 1=$a[1] 2=$a[2] 3=$a[3] 4=$a[4] 5=$a[5] 6=$a[6] 7=$a[7] 8=$a[8] 9=$a[9] 10=$a[10] 11=$a[11] 12=$a[12] 13=$a[13]";
			if ($i < sizeof($colors))  {
                $color = $colors[$i];
            }
            else  {
                $r = rand(0, 255);
                $g = rand(0, 255);
                $b = rand(0, 255);
                $color = Array ( $r, $g, $b);            
            }
            $bplot[$i]->SetFillColor ($color);
            $bplot[$i]->SetLegend ($legend[$i]);
        }

        $gbplot = new GroupBarPlot($bplot);
 		
		$graph->Add($gbplot);        
        
        $graph->title->Set ("Numero de articulos visitados por mes (log)");
        $graph->title->SetFont (FONT2_BOLD);
		$graph->xaxis->SetTickLabels ($months);
        $graph->ygrid->Show(true,true);
		$graph->xaxis->SetTextTicks(1);
        $graph->xaxis->SetFont (FONT1_BOLD);
        $graph->yaxis->SetFont (FONT1_BOLD);
        $graph->Stroke();

// ********************************************************************
// *********** Deleta arquivos temporarios  ***************************
// ********************************************************************
	  	

?> 

