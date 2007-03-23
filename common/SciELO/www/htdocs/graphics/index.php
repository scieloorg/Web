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
      
<h1>SciELO Statistics</h1>
Here we presents SciELO general statistics.
<ul>
<li><a href="#topten">Top ten visited Journals</a></li>
<!--li>Top ten visited Issues</li>
<li>Top ten visited Articles</li>
<li>Number of visited Journals per month (All and specific journals)</li>
<li>Number of visited Issues per month (All and specific journals)</li-->
<li><a href="#visartmonth">Number of visited Articles per month (All and specific journals)</a></li>
<li><a href="#visartlang">Number of visited Articles per Language (All and specific journals)</a></li>
<li>
	<!-- a href="fi1999.html">Factor of Impact per Journal (Year 1999)</a-->
	Journal Rankings on a two-year basis<br>
	 - <a href="http:/cgi-bin/bibjcrjr?usr=fbpe&wh1=1997&wh2=0&lng=en">1997</a>, 
	<a href="http:/cgi-bin/bibjcrjr?usr=fbpe&wh1=1998&wh2=0&lng=en">1998</a>, 
	<a href="http:/cgi-bin/bibjcrjr?usr=fbpe&wh1=1999&wh2=0&lng=en">1999</a>,
	<a href="http:/cgi-bin/bibjcrjr?usr=fbpe&wh1=2000&wh2=0&lng=en">2000</a>, 
	<a href="http:/cgi-bin/bibjcrjr?usr=fbpe&wh1=2001&wh2=0&lng=en">2001</a>
</li>
<li>
	<!-- a href="fi2000.html">Factor of Impact per Journal (Year 2000)</a-->
	Journal Rankings on a three-year basis<br>
	 - <a href="http:/cgi-bin/bibjcrac?usr=fbpe&wh1=1997&wh2=0&lng=en">1997</a>, 
	<a href="http:/cgi-bin/bibjcrac?usr=fbpe&wh1=1998&wh2=0&lng=en">1998</a>, 
	<a href="http:/cgi-bin/bibjcrac?usr=fbpe&wh1=1999&wh2=0&lng=en">1999</a>,
	<a href="http:/cgi-bin/bibjcrac?usr=fbpe&wh1=2000&wh2=0&lng=en">2000</a>,
	<a href="http:/cgi-bin/bibjcrac?usr=fbpe&wh1=2001&wh2=0&lng=en">2001</a>
</li>
<li><a href="top15.html">Top 15 most cited publications</a></li>
<li><a href="#">Medline</a></li>
</ul>
<a name="topten"><h2>Top Ten Titles</h2></a>
<table border="0" align="center" width="600">
<tr><td width="500">
<img src="/graphics/GraphTopTenTitles.php"/>
</td>
<td rowspan="2" align="right" valign="top">
<!--
<form action="" method="POST" name="journals">
<b>Choose a Journal</b><br/>
<select name="journal">
	<option value="issn">Library Collection</option>
	<option value="issn">Braz J Med Biol Res</option>
	<option value="issn">Braz J Med Biol Res</option>
	<option value="issn">Braz J Med Biol Res</option>
</select>
<br/>
<b>Choose an Article's Language</b>
<select name="language">
	<option value="issn">All</option>
	<option value="issn">English</option>
	<option value="issn">Spanish</option>
	<option value="issn">Portuguese</option>
</select>
<br/>
<input type="submit" value="Go!"/>
</form>
<br/><a href="AllArticle.php">All options, one report</a>
-->&nbsp;
</td>
</tr>
<tr><td align="right">
<small><a href="toptentable.php">View Data</a></small>
</td>
</tr>
</table>

<!--h2><a name="#">Top Ten Issues </a></h2>
<h2><a name="#">Top Ten Articles </a></h2>
<h2><a name="#">The number of visited Journals per month (log scale)</a></h2>
<h2>The number of visited Issues per month (log scale)</h2-->
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
    echo "<a href=\"http:/scielop?script=sci_artlangyearstat&lng=en\">View Data</a>\n";
else
{
    echo "<a href=\"http:/scielop?script=sci_artlangyearstat&lng=en&pid[]=" . $issn[0];
    for ($i = 1; $i < count ($issn); $i++)
    {
        echo "&pid[]=" . $issn[$i];
    }
    echo "\">View Data</a>\n";
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
