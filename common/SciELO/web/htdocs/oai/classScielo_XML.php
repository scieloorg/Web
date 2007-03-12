<?php
	include_once("classDefFile.php");

	class Scielo_XML
	{
		var $_def = null;
		var $_error = "";

		function Scielo_XML ( $def )
		{
			$this->_def = new DefFile ( $def );

			if ($this->_def->_error)
			{
				$this->_error = "Could not open def file: $def.";
			}
		}

		function getXML ( $script, $params = "", $debug = false )
		{
	    	$url  = "http://";
			$url .= $this->_def->getKeyValue("SERVER_SCIELO");
			$url .= $this->_def->getKeyValue("PATH_WXIS_SCIELO");
			$url .= $this->_def->getKeyValue("PATH_DATA");
			$url .= "?IsisScript=";
			$url .= $this->_def->getKeyValue("PATH_SCRIPTS");
			$url .= "$script.xis";
			$url .= "&sln=" . $this->_def->getKeyValue("STANDARD_LANG");

			if ( is_array ( $params ) )
			{
				foreach ( $params as $key => $value )
				{
					$url .= "&" . $key . "=" . trim ( $value );
				}
			}

			@$fd = fopen ( $url,"r" );

			if ( !$fd )
			{
				$this->_error = "Could not open url: |$url|.";
				return false;
			}

			$buffer = "";
            
            if ( $debug )
            {
                $buffer .= "<!-- url: $url -->";
            }

			while ( !feof ( $fd ) )
			{
    			$buffer .= fread ( $fd, 1024 );
    		}

    		fclose ( $fd );
//			die("here");
			return $buffer;
		}

		function getError ()
		{
			return $this->_error;
		}
	}
?>