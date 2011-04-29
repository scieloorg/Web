<?php 
// http://www.php.happycodings.com/Graphics/code5.html
header("Content-type: image/png");
class GraficoBarras{
    var $num_barras, $max_val, $inc_horiz, $inc_vert, $inc3D, $incV; 
    var $imag, $EscHorizontal, $width, $height, $estilo;
    var	$arr_data, $arr_nomes, $arr_y, $y_max;
    var $cor_de_fundo, $cor_do_titulo, $cor_de_linhas, $cores, $dark_cores, $preto, $cor_letras;
    
    function GraficoBarras($num=3, $larg=400, $alt=300, $estilo){ 
		$this->num_barras = $num;
    	$this->inc_horiz = (380-30)/$this->num_barras;
    	$this->EscHorizontal = 0;
    	$this->width = $larg;
    	$this->height = $alt;
    	$this->y_max = 300;
    	$this->estilo = $estilo;
    	$this->arr_data = array();
    	$this->arr_nomes = array();
    	$this->arr_y = array();	 
    	$this->imag = @imagecreatetruecolor($larg, $alt) or die("Cannot Initialize new GD image stream");
    	$estilo = ($estilo == "") ? 'Classico' : $estilo;
		switch($estilo){ 
    		case 'Classico':  
				$this->cor_do_fundo = imagecolorallocate($this->imag, 0xC1, 0xC7, 0xCC);
		    break;
    		case 'Feminista': 
				$this->cor_do_fundo = imagecolorallocate($this->imag, 0xFF, 0xB3, 0xB3);
		    break; 
    		case 'Moderno':
			 	$this->cor_do_fundo = imagecolorallocate($this->imag, 0x8C, 0xBA, 0xDE);
		    break; 
    	}  	 
    	$this->cores = array(
			"0" => imagecolorallocate($this->imag, 0xFF, 0x00, 0x00), //red
        	"1" => imagecolorallocate($this->imag, 0x00, 0xFF, 0x00),  //green
	        "2" => imagecolorallocate($this->imag, 0x00, 0x00, 0xFF),  //blue   
       		"3" => imagecolorallocate($this->imag, 0xFF, 0xFF, 0x00), //yellow
    		"4" => imagecolorallocate($this->imag, 0xFF, 0x00, 0xFF), //purple
    		"5" => imagecolorallocate($this->imag, 0x00, 0xFF, 0xFF), //cyan
			"6" => imagecolorallocate($this->imag, 255, 165, 0)); //orange
        $this->dark_cores = array(
			"0" => imagecolorallocate($this->imag, 0x90, 0x00, 0x00), 
            "1" => imagecolorallocate($this->imag, 0x00, 0x90, 0x00),  
            "2" => imagecolorallocate($this->imag, 0x00, 0x00, 0x90),  
            "3" => imagecolorallocate($this->imag, 0x90, 0x90, 0x00),
    		"4" => imagecolorallocate($this->imag, 0x90, 0x00, 0x90),
    		"5" => imagecolorallocate($this->imag, 0x00, 0x90, 0x90),
    		"6" => imagecolorallocate($this->imag, 190, 100, 0)); 		
    	$this->preto = imagecolorallocate($this->imag, 0, 0, 0);
    	imagefill($this->imag, 0, 0, $this->cor_do_fundo);	
    	imagerectangle ($this->imag, 0, 0, $larg-1, $alt-1, $this->preto); 		 
    }
    
    function adicionarTituloGrafico($titulo){
    	$this->cor_titulo = imagecolorallocate($this->imag, 255, 255, 255);
    	$corRect = imagecolorallocate($this->imag, 0, 0x3F, 0x7D); 
    	$x2 = $this->width-2;
    	$y2 = 20;
    	imagefilledrectangle ($this->imag, 1, 1, $x2, $y2, $corRect);   		
    	imagestring($this->imag, 5, 4, 3, ':: '.$titulo, $this->cor_titulo);		
    	imageline ($this->imag, 0, $y2+1, $x2, $y2+1, $this->preto);
    	imagestring($this->imag, 5, 4, 3, ':: '.$titulo, $this->cor_titulo);	 	
    }
    
    function desenhaExterior(){
    	$this->inc3D = (60/$this->num_barras);
    	$this->inc3D = ($this->inc3D < 20) ? $this->inc3D : 20;
    	$this->inc3D = ($this->inc3D > 5) ? $this->inc3D : 5;	
    	$inc3D = $this->inc3D; 
    	$this->cor_de_linhas = imagecolorallocate($this->imag, 0, 0, 0); 
    	$grey = imagecolorallocate($this->imag, 180, 180, 180);
    	$dark_grey = imagecolorallocate($this->imag, 120, 120, 120); 	
		
    	imagefilledrectangle ( $this->imag, 30+$inc3D, 30, 380+$inc3D, $this->y_max-$inc3D, $grey);		
        $values = array(0=>30, 1=>$this->y_max, 2=>380, 3=>$this->y_max,
    4=>380+$inc3D, 5=>$this->y_max-$inc3D, 6=>30+$inc3D, 7=>$this->y_max-$inc3D, 8=>30, 9=>$this->y_max);                     
        imagefilledpolygon($this->imag, $values, 5, $dark_grey ); 
    	$values = array(0=>30, 1=>$this->y_max, 2=>30+$inc3D, 3=>$this->y_max-$inc3D,
    4=>30+$inc3D, 5=>30, 6=>30, 7=>30+$inc3D, 8=>30, 9=>$this->y_max);
    	imagefilledpolygon($this->imag, $values, 5, $grey); 	
    	imageline($this->imag, 30, 30+$inc3D, 30, $this->y_max + 3, $this->cor_de_linhas); //barra vertical	
    	imageline($this->imag, 30, $this->y_max, 380, $this->y_max, $this->cor_de_linhas); //barra horizontal
    	imageline($this->imag, 30+$inc3D, 30, 30+$inc3D, $this->y_max-$inc3D, $this->preto); // barra cinzenta   	           
    }		
    	
    function desenhaEscVertical($val){		
  		if ($val < 10){ $posx = 8; }		 
   		else if ($val >= 10 && $val < 20){ $posx = 6; }
   		else{ $posx = 4; } 
   		$inc3D = $this->inc3D; 	 		 		 
   		$val = ($val > 10) ? 10 : $val; 		 	
		if ($val == 0)
	 		return;	 
    	$this->inc_vert = ($this->y_max-60)/$val;
    	$k=0;
    	$inc = ($this->max_val / $val);  	 
    	for ($n=$this->y_max, $a=0; $n>30; $n = $n-$this->inc_vert, $a++){
    		if ($n > 50){
    	 		imageline($this->imag, 28, $n, 30, $n, $this->cor_de_linhas); //_ horizontal		 		  
    	 		imageline($this->imag, 30, $n, 30+$inc3D, $n-$inc3D, $this->cor_de_linhas);	//obliqua
    	 	}
    	 	if ($n-6 > 30)
    	 		imagestring($this->imag, 2, $posx, $n-6, round($k, 1), $this->cor_de_linhas);
    	 	if ($n-$inc3D > 30)	 
    	 		imageline($this->imag, 30+$inc3D, $n-$inc3D, 380+$inc3D, $n-$inc3D, $this->cor_de_linhas); //horizontal
    	 	if ($a < 2) $this->arr_y[$a] = $n-$inc3D;
    		$k = $k + $inc; 
    	}
		$this->incV = ($this->arr_y[1]-$this->arr_y[0])/$inc;	 
    }	
    		
    function desenhaEscHorizontal(){ $this->EscHorizontal = 1; }	
    
    function setMaxValor($valor) { $this->max_val = $valor; }		
    
    function destroy(){ imagedestroy($this->imag); }	
    
    function addDados($dado){ array_push($this->arr_data, $dado); }
    
    function addNomes($dado){ array_push($this->arr_nomes, $dado); }
    
    function criaGrafico(){		
    	$inc = $this->inc_horiz-5;
    	$max = 255;
    	$min = 0;
    	$inc3D = $this->inc3D; 		  		 	 
    	if ($this->num_barras <= 4) $incX = 55;
    	else if ($this->num_barras > 4 && $this->num_barras <= 8) $incX = 45;
    	else $incX = 40;		
    	srand((double)microtime()*1000000);		 	 	  		 		 
    	for ($n=0; $n<count($this->arr_data); $n++){		 		 	
    		$y_value = ($this->arr_data[$n] == $this->max_val) ? 240 : abs($this->incV * $this->arr_data[$n]);  		 	 	 	 
    	 	$y1 = $this->y_max - $y_value;		   	  	   
    	 	$x1 = ($incX+($inc)*$n+(4*$n));	
    	 	switch($incX){
    	 		case 55: $x2 = (15+($inc*($n+1))+(4*$n));
    		 		break;
    		  	case 45: $x2 = (25+($inc*($n+1))+(4*$n));
    		 		break;
				default: 		  		 		
					$x2 = (25+($inc*($n+1))+(4*$n))+ 3; 	
    	 	} 		 	 	 	 	 	 
    	 	$y2=$this->y_max-1;		 	 
    	 	// ---- faz o efeito 3D do grafico ---- 
    	 	$values_lado = array(0=>$x2+$inc3D, 1=>$y2-$inc3D+1, 2=>$x2+$inc3D, 3=>$y1-$inc3D,
    4=>$x2, 5=>$y1, 6=>$x2, 7=>$y2, 8=>$x2+$inc3D, 9=>$y2-$inc3D+1);                                            
    	 	$values_cima = array(0=>$x2, 1=>$y1, 2=>$x2+$inc3D, 3=>$y1-$inc3D, 
    	 		  4=>$x1+$inc3D-1, 5=>$y1-$inc3D, 6=>$x1-1, 7=>$y1, 8=>$x2, 9=>$y1); 		 		 		
    	 	if ($n + 1 > count($this->cores)){
		    	$r = rand(100, 255);
    			$g = rand(100, 255);
				$b = rand(100, 255);
    			$cor = imagecolorallocate($this->imag, $r, $g, $b);
    			$dark_cor = imagecolorallocate($this->imag, $r-100, $g-100, $b-100);		
    			array_push($this->cores, $cor);
    			array_push($this->dark_cores, $dark_cor);	
    	 	}		 	 	 	  
    	 	imagefilledrectangle($this->imag, $x1, $y1, $x2, $y2, $this->cores[$n]); //desenha parte frente
    	 	imagefilledpolygon($this->imag, $values_lado, 5, $this->dark_cores[$n]);	//parte lado
    	 	imagefilledpolygon($this->imag, $values_cima, 5, $this->dark_cores[$n]); //parte cima grafico	
    	 	imageline($this->imag, $x1+$inc3D-1, $y1-$inc3D, $x1-1, $y1, $this->cor_de_linhas);	//linha1 obl1	 
    	 	imageline($this->imag, $x2+$inc3D, $y1-$inc3D, $x2, $y1, $this->cor_de_linhas);	//linha1 obl2	 	 
    	 	imageline($this->imag, $x1+$inc3D-1, $y1-$inc3D, $x2+$inc3D, $y1-$inc3D, $this->cor_de_linhas);	//linha1 hor
    	 	if ($this->EscHorizontal == 1)
    	 		imageline($this->imag, $x2+$inc3D+3, $this->y_max, $x2+$inc3D+3, $this->y_max+3, $this->cor_de_linhas); //linha separadora vertical	 
    	 	if ($this->arr_data[$n] != 0){
      			imageline($this->imag, $x2+$inc3D, $y1-$inc3D+1, $x2+$inc3D, $y2-$inc3D+1, $this->cor_de_linhas);	//linha1 vert
    	 	}	 		
    	 	imageline($this->imag, $x2+$inc3D, $y2-$inc3D+1, $x2, $y2+1, $this->cor_de_linhas);	//linha1 obl3		
    	 	imagerectangle($this->imag, $x1-1, $y1, $x2, $y2+1, $this->preto); //desenha o bordo do rectangulo 		  	 	 
    	}
    		 
    }	
    	
    function desenhaGrafico(){	 
		imagepng($this->imag);
    	imagedestroy($this->imag);
    }
    
    function guardaGrafico($img){	 
		imagepng($this->imag, $img);
    	imagedestroy($this->imag);
    }	
    
    function criaLegenda(){
    	$this->cor_letras = imagecolorallocate($this->imag, 0, 0, 0);		 
    	$cor_legenda = imagecolorallocate($this->imag, 255, 255, 204);     		
    	imagestring ($this->imag, 3, 10, 315, "Legenda:", $this->dark_cores[2]);		
    	$inc=10;
    	$x1=10;	$y1=330;  
    	$x2 = $this->width-11;	
    	$y2=$y1+(20.1*$this->num_barras); 
        imagerectangle($this->imag, $x1, $y1, $x2, $y2, $this->dark_cores[2]);  //caixa envolvente
    	imagefilledrectangle($this->imag, $x1+1, $y1+1, $x2-1, $y2-1, $cor_legenda);
    	$x1+=10; 		
    	for ($a=0, $k=5; $a<$this->num_barras; $a++, $k+=20){
			imagefilledrectangle($this->imag, $x1, $y1+$k, $x1+$inc, $y1+$k+$inc, $this->cores[$a]);		
    		imagerectangle($this->imag, $x1-1, $y1+$k-1, $x1+$inc+1, $y1+$k+$inc+1, $this->preto);	      		
    		imagestring ( $this->imag, 3, 38, $y1+$k-1, $this->arr_nomes[$a], $this->cor_letras);	
    	}		            		      
    }
}		


// ------------- criar o grafico -------------
		
		$maior = 100;   // maior valor	
          $titulo = "Perguntas por tipo"; 		
      		$gbarras = new GraficoBarras(3, 420, 400, $estilo_s);
      		$gbarras->adicionarTituloGrafico($titulo);		  
      		$gbarras->setmaxvalor($maior);
      		$gbarras->desenhaExterior();	
      		$gbarras->desenhaEscVertical($maior);
      		$gbarras->desenhaEscHorizontal();      

      	$gbarras->addDados(100);		
      	$gbarras->addNomes("Benfica");
	$gbarras->addDados(75);		
      	$gbarras->addNomes("Porto MFC");
	$gbarras->addDados(50);		
      	$gbarras->addNomes("Juveo Gay");

		
      		$gbarras->criaGrafico();
      		$gbarras->criaLegenda();
		$gbarras->desenhaGrafico();		
?>
