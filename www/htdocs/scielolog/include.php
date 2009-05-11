<?php

function wxisParameterList ( $list )
{
	$param = "<parameters>\n";
	reset($list);
	while ( list($key, $value) = each($list) )
	{
		if ( $value != "" )
		{
			$param .= "   <" . $key . ">" . $value . "</" . $key . ">\n";
		}
	}
	$param .= "</parameters>\n";

	return $param;
}


function xml_xsl ( $xmlContent, $xslFile )
{
	$p = xslt_create();
//	$args = array ( '/_xml' => $xmlContent );
//    $result = xslt_process($p, 'arg:/_xml', $xslFile, NULL, $args);
       $xslContents = join('', file($xslFile));
       //xslt_set_encoding($p, 'ISO-8859-1');
       //$xslContents = file($xslFile);
       $args = array ( '/_xml' => $xmlContent, '/_xsl' => $xslContents);


        $result = xslt_process ($p, 'arg:/_xml', 'arg:/_xsl', NULL, $args);
        if ($result) {
                    $result2return = $result;
                }
                else {
            $err = "Error: " . xslt_error ($p) . " Errorcode: " . xslt_errno ($p);
		    $result2return = $err;
                }

	xslt_free($p);

//	return str_replace("charset=UTF-8","charset=ISO-8859-1",$result);
//	return utf8_decode($result);
//      return $result2return;
	return utf8_decode($result2return);
	
}

/*
function xml_xsl ( $xmlContent, $xslFile )
{

	$p = xslt_create(void);

	$args = array("/_xmlinput", $xmlContent, "/_output", 0, 0);

	$runFlag = xslt_run($p, $xslFile, "arg:/_xmlinput", "arg:/_output", 0, $args);
	

	if ( $runFlag )
	{
		$result = utf8_decode(xslt_fetch_result($p,"arg:/_output"));
	}
	else
	{
		$result = $runFlag;
	}
	
	xslt_free($p);
	return $result;
}
*/
?>
