<?php
// ==========================================================================
// File: 			TESTSUIT_JPGRAPH.PHP
// Created:			2001-02-24
// Last updated: 	08/03/01 21:30 by johanp@aditus.nu
// Description: 	Generate a page with all individual test graphs suitable
//						for visual inspection. Note: This script must be run from
//						the same directory as where all the individual test graphs
//						are.
//	Ver: 				1.0
//
// Notes:	This script can be called with a parameter type=1 or type=2
// 			which controls wheter the images should be in situ on the page (2)
//				or just as a link (1). If not specified defaults to (1).
// ==========================================================================

// Default to 1 if not explicetly specified
if( !isset($type) )
	$type=1;

function GetArrayOfTestGraphs($dp) {
	if( !chdir($dp) )
		die("Can't change to directory: $dir");	
	$d = dir($dp);
	while($entry=$d->read()) {
		if( strstr($entry,"x") &&  strstr($entry,".php"))
   		$a[] = $entry;
   }
   $d->Close();
	return $a;
}

function MakeTxtFiles($flist) {
	foreach($flist as $f) {
		$t=substr($f,0,strlen($f)-3)."txt";
		if( file_exists($t) ) unlink($t);
		if( !copy($f,$t) )
			die("Failed to copy: $f");
	}
}	


$tf=GetArrayOfTestGraphs(getcwd());
sort($tf);
MakeTxtFiles($tf);

echo "<h2>Visual test suit for JpGraph</h2><p>";
echo "Number of tests: ".count($tf)."<p>";
echo "<strong>Note:</strong> The script for each graph is visible by clicking on the graph<p>";

echo "<ol>";
for($i=0; $i<count($tf); ++$i) {
	switch( $type ) {
		case 1:
			echo "<li><a href=\"".$tf[$i]."\">".substr($tf[$i],0,strlen($tf[$i])-4)."</a>";
			if( isset($showdate) )
				echo "[".date("Y-m-d H:i",filemtime($tf[$i]))."]";
			echo "\n";
			break;
		case 2:
			echo "<li><a href=\"".substr($tf[$i],0,strlen($tf[$i])-3)."txt\">
					<img src=\"".$tf[$i]."\" border=0 align=top></a>
					<br><strong>Filename:</strong> <i>".substr($tf[$i],0,strlen($tf[$i])-4)."</i><br>&nbsp;";
			if( $showdate )
				echo " [".date("Y-m-d H:i",filemtime($tf[$i]))."]";
			echo "\n";
			break;	
	}		
}
echo "</ol>";
echo "<p>Test suit done.";

/* EOF */
?>