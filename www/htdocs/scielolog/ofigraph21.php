<?php
include_once("../applications/scielo-org/users/langs.php");

	$pid=$_REQUEST['pid'];
	
	include_once ("include_grafico.php");
     
    

?>
<html>
<head>
<title>SciELO - Scientific electronic library online</title>
<link rel="STYLESHEET" type="text/css" href="/graphics/css/scielo.css">

<script language="javascript" src="someFunctions.js">
</script>
<script>
<!--
function myWindow(year)
{
	img = "GraphPlotArticleYear.php?year=" + year;
	CreateWindowHeader("SciELO Statistics",img,"en");
	CreateWindowFooter();
	OpenWindow();
	return true;
}
-->
</script>
</head>
<body link="#000080" vlink="#800080" bgcolor="#ffffff">
<p align="center">
<a href="/">
<img alt="Scientific Electronic Library Online" border="0" src="/img/es/scielobre.gif">
</a>
<br><img src="/img/assinat.gif" border="0"></p>
 
<a name="visartmonth"><h2><?=VISITED_ARTICLES_BY_MONTH?></h2></a>
<?php

//$log = new LogDatabaseQueryTitle(LOGDEF);
//$flagAll = false;

if (!$pid or $pid[0] == "All")
{
    echo "<p>".OFIGRAPH21_SENTENCE1."</p>\n";
    $flagAll = true;
}
else
{
    echo "<p>".OFIGRAPH21_SENTENCE2.":<br>\n";
    echo "<ul>\n";
    
    //$log->setPid ($pid);
    //$titles = $log->GetTitles (true);
    
	$titles=get_titulo($pid);
    for ($i = 0; $i < count($titles); $i++)  {
        echo "<li>" . $titles[$i]["title"] . "</li>\n";
    }
    echo "</ul>\n";
}

?>

<p>
<table border="0" align="center" width="80%"><tr><td>
<?php
if ($flagAll)
    //echo "<img src=\"/graphics/GraphVisitsMonthAllYears.php\"/>\n";
	echo "<img src=\"scielograph21.php\"/>\n";
else
{
    //echo "<img src=\"/graphics/GraphVisitsMonthAllYears.php?pid[]=" . $pid[0];
	echo "<img src=\"scielograph21.php?pid[]=" . $pid[0];
	for ($i = 1; $i < count ($pid); $i++)
    {
        echo "&pid[]=" . $pid[$i];
    }
    echo "\"/>\n";
	
} 
   
?>
</td>
<td rowspan="2" align="right" valign="top">
<form action="" method="POST" name="months" action="/graphics/index.php">

<b><?=OFIGRAPH21_SELECT_JOURNAL?></b><br/>
<select name="pid[]" multiple="1" size="20">
	<option value="All"><?=OFIGRAPH21_LIBRARY_COLLECTION?></option>
    <?php
        //$titles = $log->GetTitles (false);
        //$log->destroy();
	    $titles=lista_titulos(); 
	
        for ($i = 0; $i < count($titles); $i++)
        {
            echo "<option value=\"" . $titles[$i]["issn"] . "\">" . $titles[$i]["title"] . "</option>\n";
        }
        
    ?>
</select>
<br/>
<input type="submit" value="<?=OFIGRAPH21_EJECUTAR?>"/>
</form>
<br/>
</td>
</tr>
<tr><td align="right">
<small>
<?php


if ($flagAll)
    echo "<a href=\"/scielolog/ofiartmonthyear.php?lng=es\">".OFIGRAPH21_SEE_THE_DATA."</a>\n";
else
{
    echo "<a href=\"/scielolog/ofiartmonthyear.php?lng=es&pid[]=" . $pid[0];
    for ($i = 1; $i < count ($pid); $i++)
    {
        echo "&pid[]=" . $pid[$i];
    }
    echo "\">".OFIGRAPH21_SEE_THE_DATA."</a>\n";
}
    
?>
</small>
</td></tr>
</table>

<hr>

<p align="center">
&#169;
<font class="nomodel" size="-1">
<?php
echo(date('Y'));
?>

</font>
<i><font class="nomodel" color="#0000A0" size="-1"><?=$defFile["SITE_INFO"]["SHORT_NAME"]?><br></i>
<img src="/img/en/e-mailt.gif" alt="<?=$defFile["SITE_INFO"]["E_MAIL"]?>" border="0"><br>
<a class="email" href="maito:<?=$defFile["SITE_INFO"]["E_MAIL"]?>"><?=$defFile["SITE_INFO"]["E_MAIL"]?></a>
</center>
</p>
</body></html>
