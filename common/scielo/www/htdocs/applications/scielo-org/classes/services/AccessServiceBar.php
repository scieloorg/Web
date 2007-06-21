<?php

	require_once(dirname(__FILE__)."/Service.php");
	require_once(dirname(__FILE__)."/AccessServiceResult.php");

/*
para ter o gráfico "multi-lingüe"
*/
	require_once(dirname(__FILE__)."/../../../../php/include.php");
	require_once(dirname(__FILE__)."/../../users/langs.php");
	require_once(dirname(__FILE__)."/../../includes/jpgraph-1.20.4/src/jpgraph.php");
	require_once(dirname(__FILE__)."/../../includes/jpgraph-1.20.4/src/jpgraph_bar.php");
	require_once(dirname(__FILE__)."/../../includes/jpgraph-1.20.4/src/jpgraph_canvas.php");
	require_once(dirname(__FILE__)."/../XML_XSL/XML_XSL.inc.php");
	require_once(dirname(__FILE__)."/../XML_XSL/xslt.inc.php");
	
	
	class AccessService extends Service {
		function AccessService(){
		
			$f = dirname(__FILE__);
			$this->ini = parse_ini_file($f."/../../scielo.def", true);
			$this->Service('access');
		}
		function setParams($pid){
			$this->setParam('pid', $pid);
		}
		function getStats(){
		//FIXME 
			$array = $this->ini['collections'];
			foreach ($array as $name=>$collection){
			$this->setCall($this->ini['requests_server'][$name].'/scielolog/scielologArticle.php');

				Service::callService(Service::buildCall());
				$xml[] = Service::getResultInXML();
			}

			$XML_XSL = new XSL_XML();
			$result = new AccessServiceResult($XML_XSL->concatXML($xml));
			$requests = $result->getStats();
			return $requests;
		}

		function buildGraphic($stats){
			$stat = $stats->getRequests();
			foreach ($stat as $s){
				$mes = intval($s->getMonth());
				$ano = intval($s->getYear());
				$values[$ano][$mes] = $s->getNumberOfRequests();
			}
			if($values == NULL){
				header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
				header("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past
				header("Content-type: image/png");
				$im = @imagecreate(strlen(NO_DATA_FOR_GRAPHIC)*15, 75);
				    $background_color = imagecolorallocate($im, 255, 255, 255);
				    $text_color = imagecolorallocate($im, 153, 0, 0);
				    imagestring($im, 15, 40, 35, NO_DATA_FOR_GRAPHIC, $text_color);
				    imagepng($im);
				    imagedestroy($im);
			}

			/*
			"gabarito" da linha dos graficos com 12 posicoes, uma para cada mes
			os valores "-" sao considerados NULLs pelo jpgraph
			*/
			$data = array("0","0","0","0","0","0","0","0","0","0","0","0");
			/*
			"gabarito" para as cores das linhas do gráfico
			*/
			$cores = array("blue",
								    "yellow",
								    "purple",
								    "cyan",
								    "pink",
								    "red",
								    "orange",
								    "green",
								    "black",
								    "sienna",
									"darkred",
									"darkgreen");
		
			// Create the graph. These two calls are always required
//			$graph = new Graph(700,400,"auto");    
			$graph = new Graph(900,300,"auto");    
			$graph->SetScale("textlin");
		
		/*
		cira um array bi-dimencional contendo array(ano{array com a quantidade de acessos por mes})
		*/

			$colorIndex = 0;
			$bars = array();

			foreach($values as $ano => $meses){
		/*
		valores será a variavel que servirá de "datasource" para a barra do grafico
		inicialmente ele eh inicializada com o gabarito, e serao preenchidos os valores
		dos meses no laço for logo abaixo
		*/
				$valores = $data;
				
				for($k = 0; $k <= 12; $k++){
					if($meses[$k])
					{
						$valores[$k-1] = $meses[$k];
					}
				}
				$valores = array_values($valores);

				/*
				aqui eu uso "Variáveis Variáveis" do PHP para poder
				inserir vária linhas no gráfico
				*/
				$nome = "barplot".$ano;
		
				$$nome = new BarPlot($valores);

				$cor = $cores[$colorIndex];

				$$nome->SetFillColor($cor);
				$$nome->SetColor($cor);		
				/*configs para os valores do ponto*/
				$$nome->value->SetColor("darkred"); 

				$$nome->value->SetFont( FF_FONT1, FS_BOLD); 
				$$nome->value->SetFormat( "%0.1d"); 
//				$$nome->SetWeight(20); 
//				$$nome->SetWidth(20); 
				$$nome->value->Show();
				$$nome->value->iHideZero = true;
				$$nome->setLegend($ano);
				/*adicionando a linha ao grafico*/
 				$colorIndex++;
				array_push($bars,$$nome);

			}

			$gbplot = new GroupBarPlot($bars);
			$gbplot->SetWidth(0.9);
			$graph->Add($gbplot);
			$graph->yaxis->scale->SetGrace(20);
			$graph->img->SetMargin(40,20,20,40);
			$graph->title->Set(ARTICLE_ACCESS);
			$graph->xaxis->title->Set(MONTHS);
			$graph->yaxis->title->Set(ACCESSES);
		
			$graph->title->SetFont(FF_FONT1,FS_BOLD);
			$graph->yaxis->title->SetFont(FF_FONT1,FS_BOLD);
			$graph->xaxis->title->SetFont(FF_FONT1,FS_BOLD);
			$graph->SetShadow();

			$graph->xaxis->SetTickLabels(explode(",",MONTH_LIST));

			// Adjust the legend position
//			$graph->legend->SetLayout(LEGEND_VER);
			$graph->legend->Pos(.04,0.092,"","center");
			$graph->legend->SetLayout(LEGEND_HOR); 
			// Display the graph
			$graph->Stroke();
		}

		/** Constroi o gráfico entre periodos de anos 
			retorna true se o grafico foi montado e false se não foi
		**/
		function buildGraphicByYear($stats, $startYear, $lastYear)
		{
			$graficoStatus = false; // Para descobrir se entrou no for e vai construir um gráfico
			$stat = $stats->getRequests();

			// Pega todos os anos entre o Ano Inicial e o Ano Final 
			$anos = array();
			for($j = 0, $year = $startYear; $year<=$lastYear; $year++, $j++)
			{
				$anos[$j] = $year;
			}

			foreach ($stat as $s){
				$mes = intval($s->getMonth());
				$ano = intval($s->getYear());
				$values[$ano][$mes] = $s->getNumberOfRequests();
			}
			
			

			/*
			"gabarito" da linha dos graficos com 12 posicoes, uma para cada mes
			os valores "-" sao considerados NULLs pelo jpgraph
			*/
			$data = array("0","0","0","0","0","0","0","0","0","0","0","0");
			/*
			"gabarito" para as cores das linhas do gráfico
			*/
			$cores = array("blue",
								    "yellow",
								    "purple",
								    "cyan",
								    "pink",
								    "red",
								    "orange",
								    "green",
								    "black",
								    "sienna",
									"darkred",
									"darkgreen");
		
			// Create the graph. These two calls are always required
//			$graph = new Graph(700,400,"auto");    
			$graph = new Graph(900,300,"auto");    
			$graph->SetScale("textlin");
		
		/*
		cira um array bi-dimencional contendo array(ano{array com a quantidade de acessos por mes})
		*/

			$colorIndex = 0;
			$bars = array();

			foreach($values as $ano => $meses){
		/*
		valores será a variavel que servirá de "datasource" para a barra do grafico
		inicialmente ele eh inicializada com o gabarito, e serao preenchidos os valores
		dos meses no laço for logo abaixo
		*/
				$valores = $data;
				
				for($k = 0; $k <= count($valores); $k++){
					if($meses[$k])
						$valores[$k] = $meses[$k];
				}

				if(count($valores) > 12)
				{
					unset($valores[0]);
				}

				$valores = array_values($valores);

				/*
				aqui eu uso "Variáveis Variáveis" do PHP para poder
				inserir vária linhas no gráfico
				*/
				$nome = "barplot".$ano;
		
				$$nome = new BarPlot($valores);

				$cor = $cores[$colorIndex];

				$$nome->SetFillColor($cor);
				$$nome->SetColor($cor);		
				/*configs para os valores do ponto*/
				$$nome->value->SetColor("darkred"); 

				$$nome->value->SetFont( FF_FONT1, FS_BOLD); 
				$$nome->value->SetFormat( "%0.1d"); 
//				$$nome->SetWeight(20);
				
				// Arrumando para um tamanho mais amigavel
				if(count($anos)<3)
				{
					$$nome->SetWidth(20); 
				}
				else if(count($anos)< 4)
				{
					$$nome->SetWidth(15);
				}
				else if(count($anos)< 6)
				{
					$$nome->SetWidth(10); 
				}
				else if(count($anos)< 8)
				{
					$$nome->SetWidth(5); 
				}
				else if(count($anos)< 11)
				{
					$$nome->SetWidth(3); 
				}

				$$nome->value->Show();
				$$nome->value->iHideZero = true;
				$$nome->setLegend($ano);
				/*adicionando a linha ao grafico*/
 				$colorIndex++;
				
				// Somente monta o gráfico dos anos exigidos pelo usuário
				for($i = 0; $i<count($anos); $i++)
				{
					if($ano == $startYear+$i)
					{
						$graficoStatus = true; // entrou no for significa que o gráfico vai ser construido
						array_push($bars,$$nome);
					}
				}


			}
			/****************************************************************
			* Se não existir dados estatísticos para o período selecionado	*
			* Então ele constroi uma imagem com a mensagem de que não		*
			* existem dados estatísticos.									*
			*****************************************************************/
			if($graficoStatus == false)
			{
				$graph = new CanvasGraph(600, 30);
				$t1 = new Text(GRAFIC_STATS_FALSE);
				$t1->Pos(0.05, 0.5);
				$t1->SetOrientation('h');
				$t1->SetFont(FF_FONT1, FS_BOLD);
				$t1->SetColor('black');
				$graph->AddText($t1);
				$graph->Stroke();
				return $graficoStatus;
			}

			$gbplot = new GroupBarPlot($bars);
			$gbplot->SetWidth(0.9);
			$graph->Add($gbplot);
			$graph->yaxis->scale->SetGrace(20);
			$graph->img->SetMargin(40,20,20,40);
			$graph->title->Set(ARTICLE_ACCESS);
			$graph->xaxis->title->Set(MONTHS);
			$graph->yaxis->title->Set(ACCESSES);
		
			$graph->title->SetFont(FF_FONT1,FS_BOLD);
			$graph->yaxis->title->SetFont(FF_FONT1,FS_BOLD);
			$graph->xaxis->title->SetFont(FF_FONT1,FS_BOLD);
			$graph->SetShadow();

			$graph->xaxis->SetTickLabels(explode(",",MONTH_LIST));

			// Adjust the legend position
//			$graph->legend->SetLayout(LEGEND_VER);
			$graph->legend->Pos(.04,0.092,"","center");
			$graph->legend->SetLayout(LEGEND_HOR); 
			// Mostra o gráfico somente se, o ano que o usuario entrou existir estatisticas
			if($graficoStatus == true)
			{
				$graph->Stroke();
			}
			
			return $graficoStatus;
		}


		function xxxbuildGraphic($stats){
			$maior = 200;   // maior valor	
	        $titulo = "Dados de acessos"; 		
			$stat = $stats->getRequests();

			$q = count($stat);
			
			foreach ($stat as $s){
				if ($year!= $s->getYear()){
					$height[$s->getYear()] = $s->getNumberOfRequests();
					$year = $s->getYear();
				} else {
					if ($height[$year] < $s->getNumberOfRequests()){
						$height[$year] = $s->getNumberOfRequests();
					}
				}
			}
			$totalHeight = array_sum($height);
			$years = count($height);
			
	   		$gbarras = new GraficoBarras($totalHeight, $years);
	      	$gbarras->setHeader();
	   		$gbarras->adicionarTituloGrafico($titulo, "darker_red", "white");		  
	  		$gbarras->setmaxvalor($maior);
			$arrayColors = array('red', 'green', 'yellow', 'blue', 'orange', 'purple', 'red', 'darker_green', 'darker_yellow', 'darker_blue', 'darker_orange', 'darker_purple');
			$i = 0;
			$year = 0;
			foreach ($stat as $s){
				if ($year == 0){
					$year = $s->getYear();
				}
				if (($year > 0) && $year!= $s->getYear()){
		   			$gbarras->criaLegenda('Legenda', "black", "black", "white");
			   		$gbarras->criaGrafico();
					$gbarras->desenhaGrafico();
					$gbarras->resetData();
					//die();
				}
		      	$gbarras->setData($s->getNumberOfRequests(), $arrayColors[$i], $s->getMonth().'/'.$s->getYear());		

				if ($i == count($arrayColors)) $i = 0;
				$i++;
			}
			if ($year > 0 && $year!= $s->getYear()){
				//$gbarras->criaLegenda('Legenda', "black", "black", "white");
		   		$gbarras->criaGrafico();
				$gbarras->desenhaGrafico();
			}
		}
		function oldbuildGraphic($stats){
			// Add values to the graph
			header("Content-type: image/png");
			$imgWidth=250;
			$imgHeight=250;

			$image=imagecreate($imgWidth, $imgHeight);
			$colorWhite=imagecolorallocate($image, 255, 255, 255);
			$colorGrey=imagecolorallocate($image, 192, 192, 192);
			$colorBlue=imagecolorallocate($image, 0, 0, 255);

			imageline($image, 0, 0, 0, 250, $colorGrey);
			imageline($image, 0, 0, 250, 0, $colorGrey);
			imageline($image, 249, 0, 249, 249, $colorGrey);
			imageline($image, 0, 249, 249, 249, $colorGrey);

			$reqs = $stats->getRequests();
			$this->aux($image, $reqs);
			ImagePNG($image);
			ImageDestroy($image);
		}
		
		function aux(&$image, $arrayValues){
			$colorBlue=imagecolorallocate($image, 0, 0, 255);
			$i = 0;
			$grid_width = 10;
			$col_width = 5;
			$col_unity = 5;
			$height = 250;
			foreach ($arrayValues as $r){
				imagefilledrectangle($image, $i*$grid_width, ($height - $col_unity * $r->getNumberOfRequests()), $i*$grid_width+$col_width, $height, $colorBlue);
				$i ++;
			}
		}
	}
?>
