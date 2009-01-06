<?php
    include_once ("classLogDatabaseQueryTitle.php");
    
    define ("LOGDEF", "../scielo.def.php");
?>
<html>
<head>
<title>SciELO - Scientific electronic library online</title>
<link rel="STYLESHEET" type="text/css" href="/css/scielo.css">

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
<a href="http://www.scielo.org">
<img alt="Scientific Electronic Library Online" border="0" src="/img/en/scielobre
.gif">
</a>
<br>
<img src="/img/assinat.gif" border="0">
</p>
      

<a name="visartlang"><h2>The number of visited Articles per Language (log scale)</a></h2>
<?php
$log = new LogDatabaseQueryTitle(LOGDEF);
$flagAll = false;

if (!$issn or $issn[0] == "All")
{
    echo "<p>All article's visits for all journals, grouped by language, since 1998.</p>\n";
    $flagAll = true;
}
else
{
    echo "<p>All article's visits, grouped by language, since 1998, for the following titles:<br>\n";
    echo "<ul>\n";
    
    $log->setPid ($issn);
    
    $titles = $log->GetTitles (true);
    
    for ($i = 0; $i < count($titles); $i++)
    {
        echo "<li>" . $titles[$i]["title"] . "</li>\n";
    }
    echo "</ul>\n";
}
?>
<table border="0" align="center" width="80%">
<tr>
<td>
<?php
if ($flagAll)
    echo "<img src=\"/graphics/GraphLanguageYear.php\"/>\n";
else
{
    echo "<img src=\"/graphics/GraphLanguageYear.php?pid[]=" . $issn[0];
    for ($i = 1; $i < count ($issn); $i++)
    {
        echo "&pid[]=" . $issn[$i];
    }
    echo "\"/>\n";
}    
?>
</td>
<td rowspan="2" align="right" valign="top">
<form action="" method="POST" name="languages" action="http:/graphics/index.php">
<b>Choose a Journal</b><br/>
<select name="issn[]" multiple="1" size="20">
	<option value="All">Library Collection</option>
    <?php
        $titles = $log->GetTitles (false);
        $log->destroy();
        
        for ($i = 0; $i < count($titles); $i++)
        {
            echo "<option value=\"" . $titles[$i]["issn"] . "\">" . $titles[$i]["title"] . "</option>\n";
        }
        
    ?>
</select>
<br/>
<input type="submit" value="Go!"/>
</form>
</tr>
<tr><td align="right">
<small>
<?php
if ($flagAll)
    echo "<!--a href=\"http:/scielop?script=sci_artlangyearstat&lng=en\">View Data</a-->\n";
else
{
    echo "<!--a href=\"http:/scielop?script=sci_artlangyearstat&lng=en&pid[]=" . $issn[0];
    for ($i = 1; $i < count ($issn); $i++)
    {
        echo "&pid[]=" . $issn[$i];
    }
    echo "\">View Data</a-->\n";
}    
?>
</small>
</td></tr>
</table>
</p>



<hr>
<p align="center">
<font class="nomodel" color="#0000A0" size="-2">SciELO - Scientific Electronic L
ibrary Online<br>FAPESP - BIREME<br>Rua Botucatu, 862 - Vila Clementino<br>04023
-901 São Paulo SP - Brasil<br>
                        Tel.: (55 11) 5576-9863<br>
                        Fax: (55 11) 5575-8868</font>
<br>
<a class="email" href="mailto:scielo@bireme.br">
<img src="/img/e-mailt.gif" border="0">
<br>
<font color="#0000A0" size="2">scielo@bireme.br</font>
</a>
</p>
</body>
</html>
