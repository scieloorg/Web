<?php

include_once("old2new.inc");

class RequestVars
{
    var $_request = array();

    function RequestVars ()
    {
        global $HTTP_GET_VARS, $HTTP_POST_VARS, $REQUEST_URI, $SCRIPT_NAME;
        if (strpos($REQUEST_URI,"?") === false)
		{
		
		//-------------------------
		$QSCnav = $REQUEST_URI; 
		$QSCscript = $SCRIPT_NAME; 
		$QSCnav = ereg_replace('^$script', "", $QSCnav); 
		$QSCvars = explode("/", $QSCnav);
		$QSCArray = array();
		
		// Para atribuir as variáveis recebidas pelo php.
		for ($QSCi = 1; $QSCi < count($QSCvars); $QSCi++)
		{
			$QSCpos = strpos($QSCvars[$QSCi], "_");
			if ($QSCpos)
			{
				$QSCvar = substr($QSCvars[$QSCi], 0, $QSCpos);
				$QSCArray[$QSCvar] = substr($QSCvars[$QSCi], $QSCpos+1);
//				$GLOBALS[$QSCvar] = $QSCArray[$QSCvar];
			}
			else
			{
				$QSCvar = $QSCvars[$QSCi];
				$QSCArray[$QSCvar]="";
			}
		}
		//---------------------------
		$this->_request = array_merge ($HTTP_GET_VARS, $HTTP_POST_VARS, $QSCArray);
		}
		else
		{
        $this->_request = array_merge ($HTTP_GET_VARS, $HTTP_POST_VARS);
		}
		/*
		print_r($REQUEST_URI);
		print_r($SCRIPT_NAME);		
		print_r($this->_request);
		*/
    }
    
    function getRequestValue ($key, &$value)
    {
        if ( !isset ($this->_request[$key]) ) return false;
            
        $value = $this->_request[$key];
        return true;
    }
    
    function getQueryString ()
    {
        $query = "";
        
        reset ($this->_request);
        $count = sizeof ($this->_request);
        
        while ( list($key, $value) = each ($this->_request) )
        {
            if ( is_array ($value) ) 
            {
                $query .= $key . "[]=" . $value[0];
                
                for ($i = 1; $i < sizeof($value); $i++) 
                {
                    $query .= "&" . $key . "[]=" . $value[$i];
                }
            }
            else
            {
                $query .= "$key=$value";
            }
            if (--$count > 0) $query .= "&";
        }
        
        return $query;
    }    
}

?>