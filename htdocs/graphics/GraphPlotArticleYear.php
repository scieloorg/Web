<?
include_once ("classGraphLogDatabaseQueryArticlesPerYear.php");
include_once ("jpgraph/jpgraph.php");
include_once ("jpgraph/jpgraph_line.php");

define ("LOGDEF", "../scielo.def.php");

class PlotArticlesPerMonth
{
    var $_year = 0;
    var $_xaxisValues = "";
    var $_yaxisValues = "";
    var $_graphTitle = "";
    var $_months = Array ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
    
    function PlotArticlesPerMonth($year)
    {
        $this->_year = $year;
        $this->_graphTitle = "# of Visited Articles per Month for Year $year";
    }
    
    function _setValues()
    {
        $log = new LogDatabaseQueryArticlesPerYear (LOGDEF);
        $log->setYear ($this->_year);        
        if ( ! ($aux_array = $log->executeQuery()) )
        {
            echo "Error: " . $log->getMySQLError();
            exit;
        }

        $log->destroy ();
               
        for ($i = 0; $i < sizeof ($aux_array); $i++)
        {
            $month = $aux_array [$i][0];
            $this->_xaxisValues [$i] = $month < 1 || $month > 12 ? "" : $this->_months [$month - 1];
            $this->_yaxisValues [$i] = $aux_array [$i][1];
        }
    }
    
    function plot()
    {
        $this->_setValues();
 
        
        $graph = new Graph (380, 250);
        $graph->img->SetMargin(50,30,40,40);
        $graph->SetShadow ();
        $graph->SetColor("lightyellow");
        $graph->SetScale ("textlin");
        $graph->title->Set ($this->_graphTitle);
        $graph->yaxis->SetColor ("blue");
        $graph->xaxis->SetColor ("blue");
        
        $graph->title->SetFont (FONT1_BOLD);
        $graph->xaxis->SetTickLabels ($this->_xaxisValues);
        
        $lineplot=new LinePlot ($this->_yaxisValues);
        $lineplot->SetColor ("red");
        
        // Add the plot to the graph
        $graph->Add($lineplot);

        // Display the graph
        $graph->Stroke();        
    }  
}

if ( !isset ($year) )
{
    echo "<h1>Error</h1>";
    echo "<b>Missing parameter year</b><br>";
    echo " eg. http://server/GraphPlotArticleYear.php?year=2001";
    exit;
}

$plot = new PlotArticlesPerMonth ($year);
$plot->plot();
?>
