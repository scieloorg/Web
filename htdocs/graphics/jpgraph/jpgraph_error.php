<?php
/*=======================================================================
// File: 				JPGRAPH_ERROR.PHP
// Description: 		Error plot extension for JpGraph
// Created: 			2001-01-08
//	Last edit:			12/03/01 21:47
// Author:				Johan Persson (johanp@aditus.nu)
// Ver:					1.2
//
// License:				This code is released under GPL 2.0
//
//========================================================================
*/

//===================================================
// CLASS ErrorPlot
// Description: 
//===================================================
class ErrorPlot extends Plot {
	var $errwidth=2;
	var $center=false;
//---------------
// CONSTRUCTOR
	function ErrorPlot(&$datay,$datax=false) {
		$this->Plot($datay,$datax);
		$this->numpoints /= 2;
	}

//---------------
// PUBLIC METHODS
	function SetCenter($c=true) {
		$this->center=$c;
	}	
	
	// Gets called before any axis are stroked
	function PreStrokeAdjust(&$graph) {
		if( $this->center ) {
			$a=0.5; $b=0.5;
			++$this->numpoints;			
		} else {
			$a=0; $b=0;
		}
		$graph->xaxis->scale->ticks->SetXLabelOffset($a);
		$graph->SetTextScaleOff($b);						
		$graph->xaxis->scale->ticks->SupressMinorTickMarks();
	}
	
	// Method description
	function Stroke(&$img,&$xscale,&$yscale) {
		$numpoints=count($this->coords[0])/2;
		$img->SetColor($this->color);
		$img->SetLineWeight($this->weight);	
		
		for( $i=0; $i<$numpoints; ++$i) {
			$xt = $xscale->Translate($i+1);
			$yt1 = $yscale->Translate($this->coords[0][$i*2]);
			$yt2 = $yscale->Translate($this->coords[0][$i*2+1]);
			$img->Line($xt,$yt1,$xt,$yt2);
			$img->Line($xt-$this->errwidth,$yt1,$xt+$this->errwidth,$yt1);
			$img->Line($xt-$this->errwidth,$yt2,$xt+$this->errwidth,$yt2);
		}			
		return true;
	}

//---------------
// PRIVATE METHODS	
} // Class


//===================================================
// CLASS ErrorLinePlot
// Description: 
//===================================================
class ErrorLinePlot extends ErrorPlot {
	var $line=null;
//---------------
// CONSTRUCTOR
	function ErrorLinePlot(&$datay,$datax=false) {
		$this->ErrorPlot($datay);
		// Calculate line coordinates as the average of the error limits
		for($i=0; $i<count($datay); $i+=2 ) {
			$ly[]=($datay[$i]+$datay[$i+1])/2;
		}		
		$this->line=new LinePlot($ly);
	}

//---------------
// PUBLIC METHODS
	function Legend(&$graph) {
		if( $this->legend != "" )
			$graph->legend->Add($this->legend,$this->color);
		$this->line->Legend($graph);
	}
			
	// Method description
	function Stroke(&$img,&$xscale,&$yscale) {
		parent::Stroke($img,$xscale,$yscale);
		$this->line->Stroke($img,$xscale,$yscale);
	}
} // Class

/* EOF */
?>