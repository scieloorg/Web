<?php

function wxisParameterList ( $list )
{
	$param = "<parameters>\n";
	foreach ($list as $key => $value)
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
