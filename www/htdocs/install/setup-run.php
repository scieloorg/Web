<?
include("old2new.php");
include('this2that-functions.php');
include("setup-run.inc");
include('setup-functions.php');

if ( !$lang )
{
	$lang = "es";
}
$message = $messageArray[$lang];

?>
<html>
<head>
	<title><? print_r($message["title"]) ?></title>
</head>

<body>
<form name="setup" method="post">
<table border="1" width="630" cellspacing="1" cellpadding="5" align="center" bgcolor="#B3CEEC" >		
	<TR>
        <TD width="100%">
		  <table border="0" width="100%" cellpadding="1" cellspacing="0">
		    <tr>
			  <TD align="left" bgcolor="#666699" valign="center">
				<img src="logo_bireme.gif">
		  	  </TD>
			  <TD align="right" bgcolor="#666699" valign="center">
				<font face="Verdana" size="2" color="white"><b><? print_r($message["title"]) ?></b></font>		
			  </TD>
		    </tr>	
	     </table>		
		</td>		
	</TR>
	<TR>
		<TD bgcolor="#D9E4EC" width="100%">		
		<font face="Verdana" size="2">
		<p></p>
		<p><b>&raquo; <? print_r($message["msg1"]) ?></b></p>
		<div align="center">
			<input type="text" size="80" name="status"/>
		</div>
		<p></p>
		<p><b>&raquo; <? print_r($message["msg1"]) ?></b></p>
		<div align="center">
			<textarea cols="70" rows="8" name="statusdb"></textarea>
		</div>
		<p></p>
        </TD>
	</TR>
</table>		  
<?

$myConfigVars = readConfig("setup.ini");


$iniFind 	= array("(\[PATH_DATABASE\])", "(\[PATH_DATA\])", "(\[PATH_CGI-BIN\])", "(\[SERVERNAME\])", "(\[APPL_DIR\])","(\[DOCUMENT_ROOT\])");
$iniReplace = array($pathDbase, $documentRoot . $pathData, $pathCgi, $serverId, $pathData, $documentRoot . "/");


foreach($myConfigVars as $myVarsArray)
{

	$dir  = preg_replace ($iniFind, $iniReplace, $myVarsArray["Directory"]);
	$find = $myVarsArray["Find"];
	
	$replace = preg_replace ($iniFind, $iniReplace, $myVarsArray["Replace"]);
	
	if ( $myVarsArray["Replace"] == false ) { 
		$replace = "$documentRoot$pathData";
	}

	$file = $myVarsArray["FileType"];

	$options = array("-ifn","-R");
	//$options = array("-t","-R");
	echo "\n<!-- this2that \nfind=" .  $find . "\nreplace=" . $replace . "\ndirectory=" . $dir . "\nfiles= " . $file . " \n-->\n\n";
	$result = this2that ( $dir, $file, $find, $replace, $options );

	$status = $message["msg2"] . $dir . "  >  " . $message["msg3"] . $file;
	print '<script>document.setup.status.value ="' . $status . '";</script>';

	print ( "<!--" .  nl2br($result) . "-->");
	$resultLines = split("\n", $result);

	foreach ( $resultLines as $line )
	{
		if ( !ereg ("^rw", $line) )
		{
			$line_error .= $line;
		}
	}

	if ( $line_error !== "" )
	{	
		print "<p><font color='#ff3300'>" . $message["error"] . "</font></p>";
		break;
	}
}

if ( $line_error == ""){

	//$myNewConfig = saveConfig("setup.out",$myConfigVars,$serverId);	
	$myIAdminVars = readConfig("bases.ini");
	
	$ini2Find = array("(\[PATH_DATABASE\])", "(\[PATH_DATA\])", "(\[PATH_CGI-BIN\])", "(\[SERVERNAME\])");
	$ini2Replace = array($pathDbase, $documentRoot . $pathData, $pathCgi, $serverId);
	
	foreach($myIAdminVars as $myIAVars)
	{
		$IAdir  = preg_replace ($ini2Find, $ini2Replace, $myIAVars["Directory"]);
	
		$IAfile = $myIAVars["FileName"];
		$IAmst  = $myIAVars["Master"];
	      if ( !$myIAVars["Invert"] )
	      {
	         $IAfst = false;
	      }
	      else
	      {
		   $IAfst = $myIAVars["Invert"];
	      }
		  
		$status = "Base: " . $IAdir . $IAmst;
		
		$master_file = $IAdir . $IAmst . ".mst";
		if ( is_file($master_file) )
		{
			$status.= " (" . $message["master_exist"] . ")";
		}else{	
		    if ( $IAfile )
	    	{
				$IAresult = CreateAndImport($IAdir, $IAfile, $IAmst);	
			}else{
				$IAresult = CreateDatabase($IAdir, $IAmst);	
			}
		    if ( $IAfst )
	    	{
	        	 $IAresult = CreateInverted($IAdir, $IAmst, $IAfst);
			     $status.= "  Inverted: " . $IAmst;
		    }
		}	 
		print '<script>document.setup.statusdb.value +="> ' . $status . '\n\n";</script>'; 
	}
	
		if ( $line_error == "" )
		{
			'<script>document.setup.status.value ="' .  $message["end"] . '";</script>'; 
		}
}		
?>		

		<div align="center">
			<? 
				if ( $line_error == ""){
					print '<a href="' . $pathData . '">' . $message["home"] . '</a>';
				}else{
					print '<a href="javascript:history.back();">' . $message["back"] . '</a>';
				}	
			 ?>			
		</div><br>	
		</TD>
	</TR>
</table>	
</form>

</body>
</html>
