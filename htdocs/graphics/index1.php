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
<table align="center" width="90%" border="0" bgcolor="#AAAAAA">
<tr valign="top">
<td><a href="#topten"><small>Top ten visited Journals</small></a></td>
<td><a href="#visartmonth"><small>Articles per month</small></a></td>
<td><a href="#visartlang"><small>Articles per Language</small></a></td>
<td><a href="fi1999.html"><small>Factor of Impact per Journal (1999)</small></a></td>
<td><a href="fi2000.html"><small>Factor of Impact per Journal (2000)</small></a></td>
<td><a href="top15.html"><small>Top 15 most cited publications</small></a></td>
</tr>
</table>
      
<h1>SciELO General Statistics</h1>
<!-- Los diez titulos mas visitados -->
<p>
<table align="center" border="0"  width="90%">
<tr><td valign="top" width="500">
<a name="topten"><h2>Top Ten Titles</h2></a>
<br>
<img src="/graphics/GraphTopTenTitles.php"/>
<br><small><a href="toptentable.php">View Data</a></small>
</td>
<td valign="top" width="30%">
<form method="POST" name="months" action="http:/graphics/index1.php">
<b>Choose a Journal</b><br/>
<select name="pid[]" multiple="1" size="20">

<?php
$flagAll = false;
$todas = "<option value=\"All\"";
if (!$pid or $pid[0] == "All")
{
    $todas .= " selected=\"true\"";
    $flagAll = true;
}
$todas .=  ">Library Collection</option>";
echo $todas . "\n";
$log = new LogDatabaseQueryTitle(LOGDEF);
$titles = $log->GetTitles (false);
        /* $log->destroy(); */

/* Intento marcar las revistas seleccionadas */
    $seleccionados = "";
if ($pid and $pid[0] != "All")
{
    $log->setPid ($pid);
    $mititles = $log->GetTitles (true);
    $counttitles = count($mititles);
}       
else
{
    $counttitles = 0;
}

        for ($i = 0; $i < count($titles); $i++)
        {
            echo "<option value=\"" . $titles[$i]["issn"] . "\"";
	    
    	    for ($j = 0; $j < $counttitles; $j++)
    		{
            	  if ($mititles[$j]["title"] == $titles[$i]["title"])
		  { 
                       $seleccionados .= "<option>" . $mititles[$j]["title"] . "</option>\n";
                       echo " selected=\"true\"";
                  }
    		}
            echo ">" . $titles[$i]["title"] . "</option>\n";
        }
echo "</select>\n";

    ?>
<br/>
<input type="submit" value="Go!"/>
</form>
</td>
</tr>
</table>
</p>
<p>
<table border="0"  width="80%">
<tr>
</tr>
</table>
</p>
<p>
<?php
$log = new LogDatabaseQueryTitle(LOGDEF);

/* Aqui unifico los arrays */
$issn=$pid;
/* fin de la modificacion */
?>
</p>
<!-- Los articulos mas visitados -->

<a name="visartmonth"><h2>The number of visited Articles per month (log scale)</h2></a>

Article's visits, grouped by month, since 1998.

<p>
<table border="0"  width="90%" align="center">
<tr><td width="600">
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
<br>
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
</td>
<td valign="top">
<?
if ($seleccionados != "")
{
 echo "Selected titles:<br>";
 echo "<select size=\"20\">" . $seleccionados . "</select>\n";
}       
else
{
 echo "All titles";
}
?>
</td>
</tr>
</table>
</p>

<!-- Visitas por Idioma -->
<a name="visartlang"><h2>The number of visited Articles per Language (log scale)</a></h2>
<p>
Article's visits for all journals, grouped by language, since 1998.
</p>
<p>
<table border="0"  width="90%" align="center">
<tr>
<td width="600">
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
<br>
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
</td>
<td rowspan="2" valign="top">
<?
if ($seleccionados != "")
{
 echo "Selected titles:<br>";
 echo "<select size=\"20\">" . $seleccionados . "</select>\n";
}       
else
{
 echo "All titles";
}
?>
</td>
</tr>
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
