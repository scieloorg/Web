<?php
    include_once ("classLogDatabaseQueryTitle.php");
    
    define ("LOGDEF", "../scielo.def");
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
 


<a name="visartmonth"><h2>The number of visited Articles per month (log scale)</h2></a>
<?php
$log = new LogDatabaseQueryTitle(LOGDEF);
$flagAll = false;

if (!$pid or $pid[0] == "All")
{
    echo "<p>All article's visits for all journals, grouped by month, since 1998.</p>\n";
    $flagAll = true;
}
else
{
    echo "<p>All article's visits, grouped by month, since 1998, for the following titles:<br>\n";
    echo "<ul>\n";
    
    $log->setPid ($pid);
    
    $titles = $log->GetTitles (true);
    
    for ($i = 0; $i < count($titles); $i++)
    {
        echo "<li>" . $titles[$i]["title"] . "</li>\n";
    }
    echo "</ul>\n";
}
?>


<p>
<table border="0" align="center" width="80%">
<tr><td>
<?php
if ($flagAll)
    echo "<img src=\"/graphics/GraphVisitsMonthAllYears.php\"/>\n";
else
{
    echo "<img src=\"/graphics/GraphVisitsMonthAllYears.php?pid[]=" . $pid[0];
    for ($i = 1; $i < count ($pid); $i++)
    {
        echo "&pid[]=" . $pid[$i];
    }
    echo "\"/>\n";
}    
?>
</td>
<td rowspan="2" align="right" valign="top">
<form action="" method="POST" name="months" action="http:/graphics/index.php">
<b>Choose a Journal</b><br/>
<select name="pid[]" multiple="1" size="20">
	<option value="All">Library Collection</option>
    <?php
        $titles = $log->GetTitles (false);
        $log->destroy();
        
        for ($i = 0; $i < count($titles); $i++)
        {
            echo "<option value=\"" . $titles[$i]["issn"] . "\">" . $titles[$i]["title"] . "</option>\n";
        }
        
    ?>
	<!--option value="issn">Braz J Med Biol Res</option>
	<option value="issn">Braz J Med Biol Res</option>
	<option value="issn">Braz J Med Biol Res</option-->
</select>
<br/>
<!--b>Choose an Article's Language</b>
<select name="language">
	<option value="issn">All</option>
	<option value="issn">English</option>
	<option value="issn">Spanish</option>
	<option value="issn">Portuguese</option>
</select>
<br/-->
<input type="submit" value="Go!"/>
</form>
<br/>
<!--b>Choose a Year (All Titles)</b>
<br/>
<a href="javascript:void();" onclick="myWindow(1998);">1998</a>
<a href="javascript:void();" onclick="myWindow(1999);OpenWindow();">1999</a>
<a href="javascript:void();" onclick="myWindow(2000);OpenWindow();">2000</a>
<br/>
<br/><a href="AllArticle.php">All options, one report</a-->
</td>
</tr>
<tr><td align="right">
<small>
<?php
if ($flagAll)
    echo "<a href=\"http:/scielop?script=sci_artmonthyearstat&lng=en\">View Data</a>\n";
else
{
    echo "<a href=\"http:/scielop?script=sci_artmonthyearstat&lng=en&pid[]=" . $pid[0];
    for ($i = 1; $i < count ($pid); $i++)
    {
        echo "&pid[]=" . $pid[$i];
    }
    echo "\">View Data</a>\n";
}    
?>
</small>
</td></tr>
</table>




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
