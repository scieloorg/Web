<?php
include_once ("classLogDatabaseQueryArticleLanguageYear.php");
include_once ("jpgraph/jpgraph.php");
include_once ("jpgraph/jpgraph_log.php");
include_once ("jpgraph/jpgraph_bar.php");

define ("LOGDEF", "../scielo.def");

class PlotLanguageYear
{
    var $_data = "";
    var $_legend = Array ("English", "Spanish", "Portuguese", "French");
    var $_years = "";
    
    function _setValues($pid)
    {
        $log = new LogDatabaseQueryArticleLanguageYear (LOGDEF);
                        
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
            $this->_years[$count] = $year;            
            $this->_data [$count++] = Array (0, 0, 0, 0);
        }
                        
        for ($i = 0; $i < mysql_num_rows ($result); $i++)
        {
           $row = mysql_fetch_array ($result);
           $iyear = $row["year"] - $iniYear;

           switch ($row["lang"])
           {
                case 'es': $ilang = 1; break;
                case 'pt': $ilang = 2; break;
                case 'fr': $ilang = 3; break;
                default: $ilang = 0;
           }

           $this->_data [$ilang][$iyear] += $row["total"];
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
        $colors = Array ("yellow", "green", "blue", "red");

        srand (1);
        for ($i = 0; $i < sizeof($this->_data); $i++)
        {
            $bplot[$i] = new BarPlot($this->_data[$i]);
            $color = $colors[$i];
            $bplot[$i]->SetFillColor ($color);
            $bplot[$i]->SetLegend ($this->_legend[$i]);
        }

        $gbplot = new GroupBarPlot($bplot);
        $graph->Add($gbplot);        
        
        $graph->title->Set ("# of Visited Articles per Language (log scale)");
        $graph->title->SetFont (FONT2_BOLD);
        $graph->xaxis->SetTickLabels ($this->_years);
        $graph->ygrid->Show(true,true);
        $graph->xaxis->SetFont (FONT1_BOLD);
        $graph->yaxis->SetFont (FONT1_BOLD);
        $graph->Stroke();
    }
}

$plot = new PlotLanguageYear ($year);

$plot->plot ($pid);

?>
