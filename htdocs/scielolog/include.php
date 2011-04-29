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
?>
