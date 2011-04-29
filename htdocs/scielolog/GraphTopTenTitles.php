<?php
include_once ("classLogDatabaseQueryTopTenTitles.php");
include_once ("jpgraph/jpgraph.php");
include_once ("jpgraph/jpgraph_pie.php");

define ("LOGDEF", "../scielo.def");
define ("MYSQL_SUCCESS", 0);

class PlotTopTenTitles
{
    var $_data;
    var $_legends;

    function _setValues()
    {
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

        $sum = 0;        
        for ($i = 0; $i < mysql_num_rows ($result); $i++)
        {
            $row = mysql_fetch_array ($result);
            
            $this->_data [$i] = $row ["total"];
            $sum += $this->_data [$i];
            
            $this->_legends [$i] = $row ["title"];
        }
        
        $this->_data [ sizeof ($this->_data) ] = $total - $sum;
        $this->_legends [ sizeof ($this->_legends) ] = "Other Titles";

        $log->destroy ();
    }
        
    function plot()
    {
        $this->_setValues ();

        // Create the Pie Graph. 
        $graph = new PieGraph (500,300);
        $graph->SetShadow ();

        // Create
        $p1 = new PiePlot ($this->_data);
        // Set A title for the plot
        $p1->SetLegends ($this->_legends);
        $p1->SetSize (.3);
        $p1->SetCenter (.28,.5);
        
        $txt = new Text ("Most Visited Titles", 0.15, 0.05);
        
        $txt->SetFont(FONT1_BOLD);
        
        $graph->Add ($p1);
        $graph->AddText ($txt);
        $graph->Stroke ();        
        
    }
}

$plot = new PlotTopTenTitles();
$plot->plot();
?>
