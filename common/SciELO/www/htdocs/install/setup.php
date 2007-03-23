<?
require("old2new.php");
require("setup.inc");

$SETUP_VERSION = "1.4";

if ( !isset($lang) ) $lang = "es";

$CGI_VARS = ( $HTTP_SERVER_VARS ? $HTTP_SERVER_VARS : $_SERVER );
$serverId = $CGI_VARS["HTTP_HOST"];

$requestURI = ereg_replace("[\\]+","/",( $CGI_VARS["REQUEST_URI"] ? $CGI_VARS["REQUEST_URI"] : $CGI_VARS["PATH_INFO"] ));

if ($requestURI =="")
{
	$requestURI= str_replace("[\\]+","/",$CGI_VARS["SCRIPT_NAME"]);
}

if ( strstr($requestURI,"?") != false )
{
	$requestURI = substr($requestURI,0,strrpos($requestURI,'?'));
}

// DOCUMENT_ROOT variable declaration

if ( !isset($DOCUMENT_ROOT) ){
	$documentRoot = ereg_replace("[\\]+","/",$CGI_VARS["PATH_TRANSLATED"]);
}else{
  	$documentRoot = ereg_replace("[\\]+","/",$DOCUMENT_ROOT);
}
	
$pos = strpos($documentRoot,$requestURI);
if ( $pos != false )
{
	$documentRoot = substr($documentRoot,0,$pos);
}

if ( substr($documentRoot,1,1) == ":" )
{
	$documentRoot = substr($documentRoot,2);
}
$documentRootLength = strlen($documentRoot);
if ( substr($documentRoot,$documentRootLength-1,1) == "/" )
{
	$documentRoot = substr($documentRoot,0,$documentRootLength-1);
}

// END DOCUMENT_ROOT variable declaration

if ( strstr($documentRoot,"/") != false )
{
	$serverRoot = substr($documentRoot,0,strrpos($documentRoot,'/'));
}

$pathData = str_replace("install/setup.php", "",$requestURI);
$message = $messageArray[$lang];

$pathDbase = $serverRoot . "/bases" . $pathData;
$pathCgi = $serverRoot . "/cgi-bin" . $pathData;
	
?>
<!-- SETUP VERSION <? echo $SETUP_VERSION ?> -->

<html>
<head>
	<title><? print_r($message["title"]) ?></title>
	<STYLE TYPE="text/css">
	<!--
	BODY{
		font-family : Verdana, Arial, Helvetica, sans-serif;
	}
	TD{
		font-family : Verdana, Arial, Helvetica, sans-serif;
		font-size: 9pt;
	}
	-->
	</STYLE>	
</head>

<body>

<form action="setup-run.php" method="post">
<?	
	print "<input type=\"hidden\" name=\"lang\" value=\"$lang\">";
	print "<input type=\"hidden\" name=\"productID\" value=\"$productID\">";
?>

<table border="0" width="90%">
	<tr>
		<td align="right"><? print_r($message["language"]) ?></td>
	</tr>
</table>

<table border="1" width="610" cellspacing="1" cellpadding="1" align="center" bgcolor="#B3CEEC">
	<TR>
		<td width="100%">
            <table border="0" width="100%" cellpadding="1" cellspacing="0"><tr>
		<TD align="left" bgcolor="#666699" valign="center">
			<img src="logo_bireme.gif">
		</TD>
		<TD align="right" bgcolor="#666699" valign="center">
			<font face="Verdana" size="2" color="white"><b><? print_r($message["title"]) ?></b></font>		
		</TD></tr>
            </table>
            </td>
	</TR>
	<TR>
		<TD bgcolor="#D9E4EC" width="100%">
		<br>		
			<? print_r($message["server"]) ?><p>			
			<table width="100%" border="0" cellspacing="5" cellpadding="3">
            	<tr>
       	       	 	 <td width="100%">
					 	<? print_r($message["para1"]); ?></font>
					</td>
				</tr>
			</table>
			<table width="100%" border="0" cellspacing="5" cellpadding="3">
            	<tr>
       	        	<td width="25%">
						<? print_r($message["server"]); ?></font>
					</td>
            		<td width="75%">
						<? 
						 print "<input type=\"text\" name=\"serverId\" value=\"$serverId\" size=\"40\">&nbsp;<font size=\"1\">";
		                 print ($message["obs2"]) . "</font>";
						?>
			  		</td>
            	</tr>
            	<tr>
              	  	<td width="25%">
                  		<? print_r($message["server_path"]); ?>
                    </td>
              	  	<td width="75%">
                  		<? 
				  			print "<input type=\"text\" name=\"documentRoot\" value=\"$documentRoot\" size=\"40\">&nbsp;<font size=\"1\">";
		                  	print ($message["obs2"]) . "</font>";
					    ?>
			        </td>
            	</tr>
			</table>
			<table width="100%" border="0" cellspacing="5" cellpadding="3">
	            <tr>
    	   	        <td width="100%">
						<? print_r($message["para2"]); ?>
					</td>
            	</tr>
			</table>
          	<table width="100%" border="0" cellspacing="5" cellpadding="3">
            	<tr>
	      	        <td width="25%">
            		      <? print_r($message["htdocs"]); ?>
                    </td>
					<td width="75%">
		                  <? print "<input type=\"text\" name=\"pathData\" value=\"$pathData\" size=\"40\">&nbsp;<font size=\"1\">";
        		          print_r($message["obs2"]);
						  print "</font>"; ?>
			  		</td>
            	</tr>
				<tr>
                    <td width="25%">
        	    	  	<? print_r($message["cgi_path"]); ?>
                    </td>
              	  	<td width="75%">
		                <? print "<input type=\"text\" name=\"pathCgi\" value=\"$pathCgi\" size=\"40\">&nbsp;<font size=\"1\">";
	                    print_r($message["obs2"]);
						print "</font>"; ?>
			  		</td>
            	</tr>
	            <tr>
					<td width="25%">
                	  <? print_r($message["db_path"]); ?>
                    </td>
              	  	<td width="75%">
	                  <? print "<input type=\"text\" name=\"pathDbase\" value=\"$pathDbase\" size=\"40\">&nbsp;<font size=\"1\">";
    	              print_r($message["obs2"]);
					  print "</font>"; ?>
			  		</td>
            	</tr>
			</table>
			<table width="100%" border="0" cellspacing="5" cellpadding="3">
	            <tr>
    	   	        <td width="100%">
						<? print_r($message["para3"]); ?>
			  		</td>
            	</tr>
			</table>
			<br>
			<div align="center">
			<input type="submit" name="set" value="<? print_r($message["apply"]) ?>">
		</div>
		<br>
		
		</TD>
	</TR>
</table>	

</form>
</body>
</html>
