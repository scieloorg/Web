<?php
include_once(dirname(__FILE__)."/class.XSLTransformer.php");

class XSLTransformerOAI extends XSLTransformer{

	function getOutput(){
		return $this->output;		
	}

}
?>
