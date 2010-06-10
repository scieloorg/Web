<?php
include_once ("classLogDatabaseQueryArticleMonthYear.php");
include_once ("jpgraph/jpgraph.php");
include_once ("jpgraph/jpgraph_log.php");
include_once ("jpgraph/jpgraph_bar.php");

define ("LOGDEF", "../scielo.def");

class PlotVisitsMonthAllYears
{
    var $_data = "";
    var $_legend = "";
    var $_months = Array ("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
    
    function _setValues($pid)
    {
        $log = new LogDatabaseQueryArticleMonthYear (LOGDEF);
                        
        $log->SetPid ($pid);
        if ( ! ($result = $log->executeQuery()) )
        {
            echo "Error: " . $log->getMySQLError();
            $log->destroy ();
            exit;
        }
        
        $date = $log->getInitDate();
        if ($date) $iniYear = substr ($date, 0, 4);
        
        $date = $log->getLastDate();        
        if ($date) $finYear = substr ($date, 0, 4);

        $count = 0;

        for ($year = $iniYear; $year <= $finYear; $year++)
        {
            $this->_legend [$count] = $year;
            $this->_data [$count++] = Array (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        }
                        
        for ($i = 0; $i < mysql_num_rows ($result); $i++)
        {
           $row = mysql_fetch_array ($result);
           $index = $row["year"] - $iniYear;
           $imonth = $row["month"] - 1;
           $this->_data [$index][$imonth] += $row["total"];
        }
        
        $log->destroy ();
    }
    
    function plot($pid)
    {
        $this->_setValues ($pid);
        
        $graph = new Graph(600,400);
        $graph->img->SetMargin(60,95,40,40);
        $graph->SetShadow();
        
        $graph->SetScale("textlog");
        $colors = Array ("hotpink", "green", "blue", "gold", "blueviolet", "deepskyblue", "brown", "cadetblue", "darksalmon", "cornflowerblue", "darkslateblue", "limegreen", "yellow", "navy", "slategray");

        srand (1);
        for ($i = 0; $i < sizeof($this->_data); $i++)
        {
            $bplot[$i] = new BarPlot($this->_data[$i]);
            if ($i < sizeof($colors))
            {
                $color = $colors[$i];
            }
            else
            {
                $r = rand(0, 255);
                $g = rand(0, 255);
                $b = rand(0, 255);
                $color = Array ( $r, $g, $b);            
            }
            $bplot[$i]->SetFillColor ($color);
            $bplot[$i]->SetLegend ($this->_legend[$i]);
        }

        $gbplot = new GroupBarPlot($bplot);
        $graph->Add($gbplot);        
        
        $graph->title->Set ("# of Visited Articles per Month (log scale)");
        $graph->title->SetFont (FONT2_BOLD);
        $graph->xaxis->SetTickLabels ($this->_months);
        $graph->ygrid->Show(true,true);
        $graph->xaxis->SetFont (FONT1_BOLD);
        $graph->yaxis->SetFont (FONT1_BOLD);
        $graph->Stroke();
    }
}

$plot = new PlotVisitsMonthAllYears ($year);

$plot->plot ($pid);

?>
