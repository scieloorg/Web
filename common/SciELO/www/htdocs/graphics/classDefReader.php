<?php
	include("DefFile.php");
	
	class defReader extends DefFile
	{	
		var $script, 
			$lng, 
			$nrm, 
			$pid;
			
// --------------------------------------------------------------------------------

		function defReader($defName)
		{
			$this->DefFile($defName);
		}
		
// --------------------------------------------------------------------------------

		function generateXMLLink()
		{
			$link = $link . "http://";
			$link = $link . $this->keys["SERVER_SCIELO"];
			$link = $link . $this->keys["PATH_WXIS_SCIELO"];
			$link = $link . $this->keys["PATH_DATA"];
			$link = $link . "?IsisScript=";
			$link = $link . $this->keys["PATH_SCRIPTS"];
			$link = $link . "$this->script.xis";
			
			$link = $link . "&def=$this->defName";
			
			$link = $link . "&lng=" . 
				strtolower($this->lng ? $this->lng : $this->keys["STANDARD_LANG"]);
				
			$link = $link . "&sln=" . strtolower($this->keys["STANDARD_LANG"]);
						
			$link = $link . "&nrm=" .
				 strtolower($this->nrm ? $this->nrm : "iso");
				 
			if ($this->pid) $link = $link . "&pid=$this->pid";

			return $link;
		}

// --------------------------------------------------------------------------------

		function generateXSLLink()
		{
			$link = $this->keys["PATH_XSL"];
			$link = $link . "$this->script.xsl";
		
			return $link;
		}

// --------------------------------------------------------------------------------

		function setScript($script)
		{
		    $this->script = $script;
		}

// --------------------------------------------------------------------------------

		function setLanguage($language)
		{
			$this->lng = $language;
		}

// --------------------------------------------------------------------------------

		function setNorma($norma)
		{
			$this->nrm = $norma; 
		}
		
// --------------------------------------------------------------------------------
		
		function setPID($pid)
		{
			$this->pid = $pid;
		}
		
// --------------------------------------------------------------------------------

		function getKeyValue($key)
		{
			return $this->keys[$key];
		}
	}
?>
