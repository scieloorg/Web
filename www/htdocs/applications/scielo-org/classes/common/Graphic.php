<?php 
// http://www.php.happycodings.com/Graphics/code5.html
class Colors {
	function Colors(&$image){
		$this->image = $image;
		$this->setImageColor("black", 0, 0, 0); //red
		$this->setImageColor("white", 0xFF, 0xFF, 0xFF); //red
		$this->setImageColor("red", 0xFF, 0x00, 0x00); //red
       	$this->setImageColor("green", 0x00, 0xFF, 0x00);  //green
        $this->setImageColor("blue", 0x00, 0x00, 0xFF);  //blue   
      	$this->setImageColor("yellow", 0xFF, 0xFF, 0x00); //yellow
   		$this->setImageColor("purple", 0xFF, 0x00, 0xFF); //purple
   		$this->setImageColor("cyan", 0x00, 0xFF, 0xFF); //cyan
		$this->setImageColor("orange", 255, 165, 0); //orange

		$this->setImageColor("darker_red", 0xFF, 0x00, 0x00); //red
       	$this->setImageColor("darker_green", 0x00, 0xFF, 0x00);  //green
        $this->setImageColor("darker_blue", 0x00, 0x00, 0xFF);  //blue   
      	$this->setImageColor("darker_yellow", 0xFF, 0xFF, 0x00); //yellow
   		$this->setImageColor("darker_purple", 0xFF, 0x00, 0xFF); //purple
   		$this->setImageColor("darker_cyan", 0x00, 0xFF, 0xFF); //cyan
		$this->setImageColor("darker_orange", 255, 165, 0); //orange
		
		$this->setImageColor("darker_darker_red", 0xFF, 0x00, 0x00); //red
       	$this->setImageColor("darker_darker_green", 0x00, 0xFF, 0x00);  //green
        $this->setImageColor("darker_darker_blue", 0x00, 0x00, 0xFF);  //blue   
      	$this->setImageColor("darker_darker_yellow", 0xFF, 0xFF, 0x00); //yellow
   		$this->setImageColor("darker_darker_purple", 0xFF, 0x00, 0xFF); //purple
   		$this->setImageColor("darker_darker_cyan", 0x00, 0xFF, 0xFF); //cyan
		$this->setImageColor("darker_darker_orange", 255, 165, 0); //orange
        
	}
	function setImageColor($name, $r, $b, $g){
		$this->_color[$name] = imagecolorallocate($this->image, $r, $b, $g);
	}
	function getImageColor($name){
		return $this->_color[$name];
	}
}
class GraficoBarras{
     var $arr_data;
    function GraficoBarras($totalHeight, $years){ 
		$this->title_y2 = 20;
		$this->graphic_y = $this->title_y2;
		$this->heightBeforeGraphic = 20;
		$this->yEscale = 5;
		//$this->legendHeight = 300;
    	$this->width = 800;
    	$this->height = $totalHeight * $this->yEscale + $years * 800;
//echo "\ncheck height ".		$this->height."\n";
    	$this->imag = @imagecreatetruecolor($this->width , $this->height) or die("Cannot Initialize new GD image stream");
		$this->availableColors = new Colors($this->imag);
		imagefill($this->imag, 0, 0, $this->availableColors->getImageColor("white"));	
    	imagerectangle($this->imag, 0, 0, $this->width -1, $this->height-1, $this->availableColors->getImageColor("red")); 		 
    }
	function setHeader(){
		header("Content-type: image/png");
	}
    function setColor($local, $color){
		$this->color[$local] = $color;
	}
    function getImageColor($local){
		return $this->color[$local];
	}
	
    function setData($value, $color, $label){
		$x = array('value'=>$value, 'color'=>$this->availableColors->getImageColor($color), 'darker_color'=>$this->availableColors->getImageColor("darker_".$color), 'label'=>$label);
		$this->arr_data[] = &$x; 
		if (($value * $this->yEscale) > $this->currentGraphicHeight){
			$this->currentGraphicHeight = $value * $this->yEscale;
		} 
	}
    function resetData(){
		$this->arr_data = null;
		$this->y_max = $this->legend_y + $this->currentLegendHeight;
	}
    function adicionarTituloGrafico($titulo, $color, $bgcolor){
    	$x2 = $this->width-2;
    	$y2 = $this->title_y2;
    	imagefilledrectangle ($this->imag, 1, 1, $x2, $y2, $this->availableColors->getImageColor($bgcolor));   		
    	imagestring($this->imag, 5, 4, 3, ':: '.$titulo, $this->availableColors->getImageColor($color));		
    	imageline ($this->imag, 0, $y2+1, $x2, $y2+1, $this->availableColors->getImageColor($color));
    	imagestring($this->imag, 5, 4, 3, ':: '.$titulo, $this->availableColors->getImageColor($color));	 	
    }
    
    function criaLegenda($legendTitle, $legendTitleColor, $boxBorderColor, $boxColor){

		$this->legenda_x = 10;
		$this->legenda_y = $this->legenda_y  + $this->heightBeforeGraphic + $this->currentGraphicHeight;
//echo "\ncheck legenda y = ".$this->legenda_y."\n" ;
    	imagestring ($this->imag, 3, $this->legenda_x, $this->legenda_y, $legendTitle, $this->availableColors->getImageColor($legendTitleColor));		

    	$inc=10;
    	$x1 = $this->legenda_x;	
		$y1 = $this->legenda_y;  
    	$x2 = $this->width - 11;	
    	$y2 = $y1 + $this->currentLegendHeight; 

        imagerectangle($this->imag, $x1, $y1, $x2, $y2, $this->availableColors->getImageColor($boxBorderColor));  //caixa envolvente
    	imagefilledrectangle($this->imag, $x1+1, $y1+1, $x2-1, $y2-1, $this->availableColors->getImageColor($boxColor));
    	$x1+=10; 	

    	for ($a=0, $k=5; $a<count($this->arr_data); $a++, $k+=20){
			imagefilledrectangle($this->imag, $x1, $y1+$k, $x1+$inc, $y1+$k+$inc, $this->arr_data[$a]['color']);		
    		imagerectangle($this->imag, $x1-1, $y1+$k-1, $x1+$inc+1, $y1+$k+$inc+1, $this->availableColors->getImageColor("black"));	      		
    		imagestring ( $this->imag, 3, $this->legenda_y + 38, $y1+$k-1, $this->arr_data[$a]['label'] . ' '.  $this->arr_data[$a]['value'], $this->availableColors->getImageColor($legendTitleColor));	

    	}

    }    
    function desenhaEscHorizontal(){ $this->EscHorizontal = 1; }	
    
    function setMaxValor($valor) { $this->max_val = $valor; }		
    
    function destroy(){ imagedestroy($this->imag); }	
    
	function setColors(){
		$this->setColor('graphic_bg', 'white');
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
    function criaGrafico(){		
    	$this->inc_horiz = (380-30)/count($this->arr_data);
    	$this->inc3D = 10;
    	//$this->inc3D = ($this->inc3D < 20) ? $this->inc3D : 20;
    	//$this->inc3D = ($this->inc3D > 5) ? $this->inc3D : 5;	
    	$this->y_max = $this->y_max  + $this->legend_y + $this->currentLegendHeight + $this->heightBeforeGraphic;
		$this->incV = 10;
//echo "\ncheck y_max = ".$this->y_max ."\n" ;

    	$inc = $this->inc_horiz-5;
    	$max = 255;
    	$min = 0;
    	$inc3D = $this->inc3D; 		  		 	 
		
    	$col_width = 30;		
    	$bar_width = 10;		
    	srand((double)microtime()*1000000);		 
		
			 	  		 		 
    	for ($n=0; $n<count($this->arr_data); $n++){		

    		$y_value = ($this->arr_data[$n]['value'] == $this->max_val) ? 240 : abs($this->incV * $this->arr_data[$n]['value']);  		 	 	 	 
    	 	$y1 = $this->y_max - $y_value;		   	  	   
    	 	$x1 = $x1 + $col_width;	
    	 	$x2 = $x1 + $bar_width;
					 	 	 	 	 	 
    	 	$y2=$this->y_max - 1;		 	 
    	 	// ---- faz o efeito 3D do grafico ---- 
    	 	$values_lado = array(0=>$x2+$inc3D, 
				1=>$y2-$inc3D+1, 
				2=>$x2+$inc3D, 
				3=>$y1-$inc3D,
				4=>$x2, 
				5=>$y1, 
				6=>$x2, 
				7=>$y2, 
				8=>$x2+$inc3D, 
				9=>$y2-$inc3D+1);                                            
    	 	$values_cima = array(0=>$x2, 1=>$y1, 2=>$x2+$inc3D, 3=>$y1-$inc3D, 
    	 		  4=>$x1+$inc3D-1, 5=>$y1-$inc3D, 6=>$x1-1, 7=>$y1, 8=>$x2, 9=>$y1); 		 		 		
//var_dump( $x1, $y1, $x2, $y2);
  	 		imagestring($this->imag, 2, $x1, $y1-50, $this->arr_data[$n]['value'], $this->availableColors->getImageColor("black"));

    	 	imagefilledrectangle($this->imag, $x1, $y1, $x2, $y2, $this->arr_data[$n]['color']); //desenha parte frente

    	 	imagefilledpolygon($this->imag, $values_cima, 5, 'darker_'.$this->arr_data[$n]['color']); //parte cima grafico	

    	 	imagefilledpolygon($this->imag, $values_lado, 5, 'darker_'.$this->arr_data[$n]['color']);	//parte lado

    	 	imageline($this->imag, $x1+$inc3D-1, $y1-$inc3D, $x1-1, $y1, $this->availableColors->getImageColor("black"));	//linha1 obl1	 
    	 	imageline($this->imag, $x2+$inc3D, $y1-$inc3D, $x2, $y1, $this->availableColors->getImageColor("black"));	//linha1 obl2	 	 
    	 	imageline($this->imag, $x1+$inc3D-1, $y1-$inc3D, $x2+$inc3D, $y1-$inc3D, $this->availableColors->getImageColor("black"));	//linha1 hor
    	 	if ($this->EscHorizontal == 1)
    	 		imageline($this->imag, $x2+$inc3D+3, $this->y_max, $x2+$inc3D+3, $this->y_max+3, $this->availableColors->getImageColor("black")); //linha separadora vertical	 
    	 	if ($this->arr_data[$n]['value'] != 0){
      			imageline($this->imag, $x2+$inc3D, $y1-$inc3D+1, $x2+$inc3D, $y2-$inc3D+1, $this->availableColors->getImageColor("black"));	//linha1 vert
    	 	}	 		
    	 	imageline($this->imag, $x2+$inc3D, $y2-$inc3D+1, $x2, $y2+1, $this->availableColors->getImageColor("black"));	//linha1 obl3		
    	 	imagerectangle($this->imag, $x1-1, $y1, $x2, $y2+1, $this->availableColors->getImageColor("black")); //desenha o bordo do rectangulo 		  	 	 


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
    

}		


// ------------- criar o grafico -------------
		
/*
		$maior = 200;   // maior valor	
        $titulo = "Dados de acessos"; 		
   		$gbarras = new GraficoBarras(820, 400);
   		$gbarras->adicionarTituloGrafico($titulo, "red", "white");		  
  		$gbarras->setmaxvalor($maior);
   		//$gbarras->desenhaExterior();	
//   		$gbarras->desenhaEscVertical($maior);
   		$gbarras->desenhaEscHorizontal();      

      	$gbarras->setData(100, 'red', 'Maio');		
      	$gbarras->setData(80, 'green', 'Junho');		
      	$gbarras->setData(90, 'blue', 'Julho');		

   		$gbarras->criaLegenda('Legenda', "black", "black", "white");
   		$gbarras->criaGrafico();

		$gbarras->desenhaGrafico();		
*/
?>
