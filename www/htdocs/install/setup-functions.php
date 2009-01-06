<?php

$wxis_host = $serverId;
$wxis_action = "/cgi-bin/wxis.exe" . $pathData . "install/";


function readConfig($configFile)
{
	
    $rCconf_file = $configFile;
    $fp = fopen($rCconf_file, "r");
    if ($fp)
    {
        $contents = fread ($fp, filesize("$rCconf_file"));
        fclose ($fp);
		
        $lines = explode ("\n", $contents);
        $i=0;
        foreach($lines as $lnsep)
        {
		  if ( $lnsep == "" or substr($lnsep, 0, 1) == ";" ) { 
		  	continue;
		  }
		  
          $tmp1 = explode("##", $lnsep);
          foreach($tmp1 as $ln)
          {
             $tmp2 = explode("=", $ln);
             $rCconfig[$i][$tmp2[0]] = trim($tmp2[1]);
		 $tmp2 = NULL;
          }
	    $tmp1 = NULL;	
          $i++;
        }
        return $rCconfig;
    }
    else
    {
      die ("Error reading the configuration file...");
    }
}


function saveConfig($configFile,$rCconfig,$rCServerId)
{
    global $documentRoot, $pathData;
    $rCconf_file = $configFile;
    $fp = fopen($rCconf_file, "wb");

    if ($fp)
    {
       for ( $j = 0; $j < sizeof ( $rCconfig ); $j++ )
       {
           $content = "";
           $i = 1;
    	     reset($rCconfig[$j]);
         
           foreach($rCconfig[$j] as $cf_key => $cf)
           {
               if ($cf_key == "Find")
               {
               	continue;
               }
               else
               {
                  if ( $cf_key == "Replace" )
			{
                     if ( $cf != "[SERVERNAME]" )
                     {
               	      $content .= "Find=" . $cf;
                     }
                     else
			   {
			   	$content .= "Find=" . $rCServerId . "##";
                        $content .= "Replace=[SERVERNAME]";
                     }
                  }
			else
			{
			   $content .= $cf_key . "=" . $cf;
                  }
               	if ($i < sizeof($rCconfig[$j])-1)
               	{
                  	$content .= "##";
                  	$i++;
               	}
		   }
           }
           if ( !$rCconfig[$j]["Replace"] )
	     {
			$content .= "##Find=" . $documentRoot . $pathData;
           }
	     $content .= "\n";
           $rt = fwrite($fp, $content);
           if (!$rt)
           {
              fclose ($fp);
              die("01 Error writing file...");
           }
        }
 
        fclose ($fp);
    }
    else
    {
        die("02 Error opening file...");
    }
    return TRUE;
}

function wxis_url ( $IsisScript, $param )
{
	global $wxis_host;
	global $wxis_action;

	$request = "http://" . $wxis_host . $wxis_action . "?" . "IsisScript=" . $IsisScript;

	while (list($key, $value) = each($param))
	{
		if ($value != "")
		{
			$request .= "&" . $key . "=" . $value;
		}
	}

	return $request;
}


function CreateAndImport($lcDir,$lcName, $lcMst)
{
	global $documentRoot;
	global $pathData;
	global $message;

	$setup["db"] = $lcMst;
	$setup["file"] = $lcName;
	$setup["path"] = $lcDir;	
	if ( strstr($lcName,'.') == '.vl'){
		$setup["type"] = "VLine";
	}

	echo "\n\n<!-- wxis_import_url : " . wxis_url('import.xis', $setup) . "-->\n\n";
	$isis_status = getDoc( wxis_url('import.xis', $setup) );

	if ($isis_status != "0")
	{
	   die(' <font color="#ff0000">'. $message["error-wxis"] . '</font>' );
	}

	
}

function CreateDatabase($lcDir, $lcMst)
{
	global $documentRoot;
	global $pathData;
	
	$setup["db"] = $lcDir . $lcMst;

	echo "\n\n<!-- wxis_create_url : " . wxis_url('createdb.xis', $setup) . "-->\n\n";
	$isis_status = getDoc( wxis_url('createdb.xis', $setup) );
	if ($isis_status != "0")
	{
	   die(' <font color="#ff0000">'. $message["error-wxis"] . '</font>' );
	}
}

function CreateInverted($lcDir,$lcName,$lcInverted)
{
	global $documentRoot;
	global $pathData;

	$setup["db"] = $lcName;	
	$setup["path"] = $lcDir;

	echo "\n\n<!-- wxis_inverted_url : " . wxis_url('fullinv.xis', $setup) . "-->\n\n";
	$isis_status = getDoc( wxis_url('fullinv.xis', $setup) );

	if ($isis_status != "0")
	{
	  die(' <font color="#ff0000">'. $message["error-wxis"] . '</font>' );
	}

}

function getDoc ( $docURL )
{
	global $xmlBuffer;
	$freadMaxLength = 5000;
	$docContent = "";

	$fp = fopen ($docURL, "r");
	$docContent = "";
	if ($fp)
	{
		while (!feof ($fp)) {
		    $buffer= fgets($fp, 8096);
			$docContent.= $buffer;
		}
		fclose ($fp);
	}	
	
	return $docContent;
}


?>
