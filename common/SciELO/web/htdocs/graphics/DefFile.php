<?php 
	class DefFile
	{
		var $defName,
		    $keys,
			$_error;
		
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
				}			
			}

			fclose($fd);
			$this->_error = 0;
		}
		
		function getError()
		{
			return $this->_error;
		}
	}
?>