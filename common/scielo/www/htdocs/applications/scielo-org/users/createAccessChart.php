<?

	$dir = dirname(__FILE__)."/";
	
	require_once($dir."../classes/Article.php");
	include_once($dir."../php/include.php");
	include_once($dir."../users/langs.php");
	require_once($dir."../includes/jpgraph-1.20.4/src/jpgraph.php");
	require_once($dir."../includes/jpgraph-1.20.4/src/jpgraph_line.php");

	
	$pid = $_GET['pid'];
	
	$article = new Article();

	$article->setPID($pid);

	$article_accessed_list = $article->getAccessStatistics();

	/*
	"gabarito" da linha dos graficos com 12 posicoes, uma para cada mes
	os valores "-" sao considerados NULLs pelo jpgraph
	*/
	$data = array("-","-","-","-","-","-","-","-","-","-","-","-","-");
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
	$graph = new Graph(760,400,"auto");    
	$graph->SetScale("textlin");


/*
cira um array bi-dimencional contendo array(ano{array com a quantidade de acessos por mes})
*/
	for($c = 0; $c < count($article_accessed_list); $c++){
		$obj = $article_accessed_list[$c];
		$mes = intval(substr($obj->getDate(),5,2));
		$ano = intval(substr($obj->getDate(),0,4));
		$values[$ano][$mes] = $obj->getCount();
	}


	foreach($values as $ano => $meses){
/*
valores será a variavel que servirá de "datasource" para a linha do grafico
inicialmente ele eh inicializada com o gabarito, e serao preenchidos os valores
dos meses no laço for logo abaixo
*/
		$valores = $data;
		
		for($k = 1; $k <= count($valores); $k++){
			if($meses[$k])
				$valores[$k] = $meses[$k];
		}

		unset($valores[0]);
		$valores = array_values($valores);

/*
aqui eu uso "Variáveis Variáveis" do PHP para poder
inserir vária linhas no gráfico
*/
		$nome = "lineplot".$ano;
		$$nome = new LinePlot($valores);
		$cor = $cores[rand(0,11)];
		$$nome->SetColor($cor);

		/*configs para os valores do ponto*/
		$$nome->value->SetColor("darkred"); 
		$$nome->value->SetFont( FF_FONT1, FS_BOLD); 
		$$nome->value->SetFormat("%0.1d"); 
		$$nome->value->Show();
		$$nome->SetWeight(2);
		$$nome->setLegend($ano);
		
		/*adicionando a linha ao grafico*/
		$graph->Add($$nome);		
	}

	// Create the linear plot
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
	$graph->legend->SetLayout(LEGEND_VER);

	// Display the graph
	$graph->Stroke();
?>