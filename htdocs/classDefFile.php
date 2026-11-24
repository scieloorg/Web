<?php 
	class DefFile
	{
		var $defName,
		    $keys,
			$_error;
		var $sections;
		var $x;

		function __construct($defName)
		{
			$this->DefFile($defName);
		}
		
		function xxDefFile($defName)
		{
			$this->defName = $defName;
			
			if ( !(@$fd = fopen($this->defName,"r")) )
			{
				$this->_error = 1;
				return;
			}
		
			while(!feof($fd))
			{		
				$contents = fgets($fd, 1024);

				if ($pos = strpos($contents, "="))
				{
					$key = trim(substr($contents,0,$pos));
					$value = trim(substr($contents,$pos+1));
				
					$this->keys[$key] = $value;

					if ($section){
						$this->sections[$section][$key] = &$this->keys[$key];
					}
				} else {
					$line = $contents;
					$this->x[] = $line;
					if ((strpos(' '.$line,'[')==1) && (strpos($line,']')>0)) {
						$section = substr($line,1,strpos($line,']')-1);
					} else {
					}
				}			
			}

			fclose($fd);
			$this->_error = 0;
		}
		
		function getError()
		{
			return $this->_error;
		}
        
		function getKeyValue($key)
		{
			return isset($this->keys[$key]) ? $this->keys[$key] : null;
		}

		function getSection($section)
		{
			return isset($this->sections[$section]) ? $this->sections[$section] : array();
		}

		function DefFile($defName)
		{
			$this->defName = $defName;
			if ( !(@$fd = fopen($this->defName,"r")) )
			{
				$this->_error = 1;
				return;
			}
			
			$this->sections = parse_ini_file($this->defName, true);
			$this->keys = parse_ini_file($this->defName, false);
			fclose($fd);
			$this->_error = 0;
		}
		
	}
?>
