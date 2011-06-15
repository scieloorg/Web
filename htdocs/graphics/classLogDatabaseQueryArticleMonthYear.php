<?php
include_once ("classLogDatabaseQueryControlInfo.php");

class LogDatabaseQueryArticleMonthYear extends LogDatabaseQueryControlInfo
{
	// ------------------------------------------------------------------------------------------
	// ------------------------------   Private Data Members   ----------------------------------
	// ------------------------------------------------------------------------------------------

    var $_dti = "",
        $_dtf = "",
        $_debug = "",
        $_pid = "";

    var $_tableName = "";
    var $_titleName = "";
    var $_source = "";        
	// ------------------------------------------------------------------------------------------
	// --------------------------------     Constructor     -------------------------------------
	// ------------------------------------------------------------------------------------------

    function LogDatabaseQueryArticleMonthYear ($deffile)
    {
        LogDatabaseQueryControlInfo::LogDatabaseQueryControlInfo ($deffile);

//        $this->_tableName = $this->_defFile->getVar("TABLE_JOURNALS_NAME");
//        $this->_titleName = $this->_defFile->getVar("TABLE_TITLE_NAME");
//        $this->_source = $this->_defFile->getVar("TITLE_SOURCE");

        $this->_tableName = $this->_defFile->getVar("TABLE_ART_LANG_NAME");
    }

	// ------------------------------------------------------------------------------------------
	// ----------------------------------   Private Methods   -----------------------------------
	// ------------------------------------------------------------------------------------------
        
    function _CreateQueryString ()
    {
/*    
        $query  = "SELECT YEAR($this->_tableName.date) as year, " .
                         "MONTH($this->_tableName.date) as month, " . 
                         "$this->_titleName.shorttit as stitle, " .
                         "SUM($this->_tableName.cnt_art) as count " . 
                   "FROM $this->_tableName, $this->_titleName";
                                      
        $where = " WHERE $this->_tableName.issn = $this->_titleName.issn AND $this->_titleName.source='$this->_source'";
*/
        $query  = "SELECT YEAR(date) as year, " .
                         "MONTH(date) as month, " . 
                         "shorttit as stitle, " .
                         "SUM(count) as total " . 
                   "FROM $this->_tableName";
        
        $where = "";                               
        if ($this->_pid)
        {
            if ( is_array($this->_pid) )
            {
                $where .= " WHERE (issn = '" . $this->_pid[0] . "'";
                
                for ($i = 1; $i < sizeof ($this->_pid); $i++)
                {
                    $where .= " OR issn = '" . $this->_pid[$i] . "'";
                }
                $where .= ") ";
            }
            else
            {
                $where .= " WHERE issn = '$this->_pid'";
            }
        }
         
        
		$group = " GROUP BY issn, year, month";
		$order = " ORDER BY stitle, year, month";
              
        $query .=  $where . $group . $order;
//        echo $query;
        return $query;
    }
    
    
    function _getErrorXML ($errorcode)
    {
        if (!$this->_debug)
        {
            $response  = "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>\n";
        }
        $response .= "<MYSQL_ERROR>\n";
        $response .= $this->_getControlInfoXML ();
        $response .= " <LANG>" . $this->GetInterfaceLanguage() ."</LANG>\n";
        $response .= " <ERRORCODE>" . $errorcode . "</ERRORCODE>\n";
        $response .= "<EMAIL>" . $this->_defFile->getVar ("ADMIN_EMAIL") ."</EMAIL>\n";
        $response .= "</MYSQL_ERROR>\n";

        return $response;
    }
    
    function _getMysqlResultXML ( $queryResult )
    {       
        if (!$this->_debug)
        {
            $response  = "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>\n";
        }
        $response .= "<QUERY_RESULT>\n";
        $response .= $this->_getControlInfoXML ();
        
        $firstTime = true;
        $currentTitle = "";
        $currentYear = "";
        $breakTitle = false;
        
        $iniYear = substr ($this->getInitDate(), 0, 4);
        $finYear = substr ($this->getLastDate(), 0, 4);
        $count = 0;

        for ($year = $iniYear; $year <= $finYear; $year++)
        {
            $totalyear [$count++] = Array (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        }
        
        while ( $row =  mysql_fetch_array ($queryResult) )
        {
            if ($row["stitle"] != $currentTitle)
            {
                if (!$firstTime)
                {
                    $response .= "  </YEAR>\n";
                    $response .= " </TITLE>\n";
                }
                else
                {
                    $firstTime = false;
                }
                
                $response .= " <TITLE NAME=\"" . $row["stitle"] . "\">\n";
                $currentTitle = $row["stitle"];
                $breakTitle = true;
            }
            
            if ($row["year"] != $currentYear or $breakTitle)
            {
                if (!$breakTitle) 
                {
                    $response .= "  </YEAR>\n";
                }
                else
                {
                    $breakTitle = false;
                }
                   
                $response .= "  <YEAR NUMBER=\"" . $row["year"] . "\">\n";

                $currentYear = $row["year"];
            }
            
//            $response .= "   <MONTH NUMBER=\"" . $row["month"] . "\">" . $row["count"] . "</MONTH>\n";
            $response .= "   <MONTH NUMBER=\"" . $row["month"] . "\">" . $row["total"] . "</MONTH>\n";
            
           $iyear = $row["year"] - $iniYear;            
           $imonth = $row["month"] - 1;
           $totalyear [$iyear][$imonth] += $row["total"];            
        }

        $response .= "  </YEAR>\n";
        $response .= " </TITLE>\n";
        $response .= " <TOTAL>\n";
        for ($year = $iniYear; $year <= $finYear; $year++)
        {
            $response .= "  <YEAR NUMBER=\"" . $year . "\">\n";
            
            for ($month = 1; $month <= 12; $month++)
            {
                if ($totalyear[$year-$iniYear][$month-1])
                {
                    $response .= "   <MONTH NUMBER=\"" . $month . "\">" . $totalyear[$year-$iniYear][$month-1] . "</MONTH>\n";
                }
            }

        $response .= "  </YEAR>\n";
        }
        
        $response .= " </TOTAL>\n";
        $response .= "</QUERY_RESULT>\n";
        
        return $response;
    }
    
	// ------------------------------------------------------------------------------------------
	// ---------------------------------   Public Methods   -------------------------------------
	// ------------------------------------------------------------------------------------------
    function getInitDate()
    {
        return LogDatabaseQuery::getInitDate ($this->_tableName);
    }
    
    function getLastDate()    
    {
        return LogDatabaseQuery::getLastDate ($this->_tableName);
    }
    
    function ExecuteQuery ()
    {
        $query = $this->_CreateQueryString ();
        		
        if (! ($result = $this->query($query)) )
		{
			return "";
		}
                
        return $result; 
    }        
    
    function getResultXML ()
    {
        $result = $this->ExecuteQuery();

        $errorcode = $this->getMySQLError();

        $response = "";

        if ($errorcode == MYSQL_SUCCESS)
        {
            $response = $this->_getMysqlResultXML ($result);
        }
        else
        {
            $response = $this->_getErrorXML ($errorcode);
        }
        
        return $response;
    }
    
	// ------------------------------------------------------------------------------------------
	// --------------------   Public Acessor Methods (Get/Set Properties) -----------------------
	// ------------------------------------------------------------------------------------------   
     
    function SetPid ($pid)
    {
        if ($pid)
        {
            $this->_pid = $pid; 
        }
    }
    
    function GetPid()
    {
        return $this->_pid;
    }
    
    function SetDebug ($debug)
    {
        if ($debug)
        {
            $this->_debug = $debug; 
        }
    }
    
    function GetDebug()
    {
        return $this->_debug;
    }
    
/*    
    function GetErrorCode()
    {
        return $this->_errorcode;
    }
*/    
}