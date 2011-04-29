<?php 
	class DefFile
	{
		var $defName,
		    $keys,
			$_error;
		var $sections;
		function DefFile($defName)
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
			return $this->keys[$key];
		}        
		function getSection($section)
		{
			return $this->sections[$section];
		}        
		function xDefFile($defName)
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