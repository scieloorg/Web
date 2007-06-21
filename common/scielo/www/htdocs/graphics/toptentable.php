<html>
<head>
	<title>
        <?php 
        switch ($lng)
        {
            case 'pt': echo "Dez t&iacute;tulos mais visitados"; break;
            case 'es':  "Dez t&iacute;tulos m&aacute;s visitados";  break;
            default:  "Top ten titles";
        }
        ?>
    </title>
</head>

<body>
<table border="0" cellpadding="0" cellspacing="2" width="400" align="center">
<tr>
    <td widht="250" bgColor="#e1e6e6">
    <b>
    <?php
    switch ($lng)
    {
        case 'pt': echo "T&iacute;tulos";  break;
        case 'es': echo "T&iacute;tulos";  break;
        default:  echo "Titles";
    }
    ?>
    </b>
    </td>
    <td width="150" bgColor="#e1e6e6">
    <b>
    <?php
    switch ($lng)
    {
        case 'pt': echo "N&uacute;mero de acessos a artigos";  break;
        case 'es': echo "N&uacute;mero de accessos a art&iacute;culos";  break;
        default:  echo "Number of article requests";
    }
    ?>
    </b>
    </td>
</tr>
<?php
include_once ("classLogDatabaseQueryTopTenTitles.php");

define ("LOGDEF", "../scielo.def");
define ("MYSQL_SUCCESS", 0);

$log = new LogDatabaseQueryTopTenTitles (LOGDEF);
        
$total = $log->getTotalArticles();

if ($total == 0)
{
    if ( ($error = $log->getMySQLError) != MYSQL_SUCCESS )
    {
        echo "Error: " . $log->getMySQLError();
    }
    else
    {
        echo "Total: 0";
    }
    exit;
}

if ( ! ($result = $log->executeQuery()) )
{
    echo "Error: " . $log->getMySQLError();
    exit;
}

$log->destroy ();

$sum = 0;        
for ($i = 0; $i < mysql_num_rows ($result); $i++)
{
    $row = mysql_fetch_array ($result);
    echo "<tr>\n";
    echo "    <td widht=\"250\" bgColor=\"#f5f5eb\">" . ($i+1) . ". " . $row ["title"] . "</td>\n";
    echo "    <td widht=\"150\" bgColor=\"#f5f5eb\" align=\"right\">" . $row ["total"] . "</td>\n";
    echo "</tr>\n";
    
    $sum += $row ["total"];    
}
?>
<tr><td bgColor="#f5f5eb">&nbsp;</td><td bgColor="#f5f5eb">&nbsp;</td></tr>
<tr>
    <td widht="250"  bgColor="#f5f5eb">
    <?php
    switch ($lng)
    {
        case 'pt': echo "Outros t&iacute;tulos";  break;
        case 'es': echo "Otros t&iacute;tulos";  break;
        default:  echo "Other Titles";
    }
    ?>
    </td>
    <td widht="150" bgColor="#f5f5eb" align="right"><?php echo $total - $sum ?></td>
</tr>
<tr><td bgColor="#f5f5eb">&nbsp;</td><td bgColor="#f5f5eb">&nbsp;</td></tr>
<tr>
    <td widht="250" bgColor="#f5f5eb"><font color="red">Total</font></td>
    <td widht="150" bgColor="#f5f5eb" align="right"><font color="red"><?php echo $total?></font></td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr>
<td colspan="2">
<a href="index.php#topten">
<?php 
    switch ($lng)
    {
        case 'pt': echo "Voltar";  break;
        case 'es': echo "Volver";  break;
        default:  echo "Back";
    }
?>
</a>
</td>
</tr>
</table>

</body>
</html>
