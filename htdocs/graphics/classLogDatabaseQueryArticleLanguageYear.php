<?php
include_once ("classLogDatabaseQueryControlInfo.php");

define ("MYSQL_SUCCESS", 0);

class LogDatabaseQueryArticleLanguageYear extends LogDatabaseQueryControlInfo
{
	// ------------------------------------------------------------------------------------------
	// ------------------------------   Private Data Members   ----------------------------------
	// ------------------------------------------------------------------------------------------

    var $_dti = "",
        $_dtf = "",
        $_pid = "";

    var $_tableName = "";
    var $_titleName = "";
    var $_source = "";        
	// ------------------------------------------------------------------------------------------
	// --------------------------------     Constructor     -------------------------------------
	// ------------------------------------------------------------------------------------------

    function LogDatabaseQueryArticleLanguageYear ($deffile)
    {
        LogDatabaseQueryControlInfo::LogDatabaseQueryControlInfo ($deffile);

/*
        $this->_tableName = $this->_defFile->getVar("TABLE_JOURNALS_NAME");
        $this->_titleName = $this->_defFile->getVar("TABLE_TITLE_NAME");
        $this->_source = $this->_defFile->getVar("TITLE_SOURCE");
*/
        $this->_tableName = $this->_defFile->getVar("TABLE_ART_LANG_NAME");        
    }

	// ------------------------------------------------------------------------------------------
	// ----------------------------------   Private Methods   -----------------------------------
	// ------------------------------------------------------------------------------------------
        
    function _CreateQueryString ()
    {
/*    
        $query  = "SELECT lang, " .
                         "YEAR($this->_tableName.date) as year, " .
                         "$this->_titleName.shorttit as stitle, " .
                         "SUM($this->_tableName.cnt_art) as count " . 
                   "FROM $this->_tableName, $this->_titleName";
                                      
        $where = " WHERE $this->_tableName.issn = $this->_titleName.issn AND $this->_titleName.source='$this->_source'";
        if ($this->_pid)
        {
            if ( is_array($this->_pid) )
            {
                $where .= " AND ($this->_tableName.issn = '" . $this->_pid[0] . "'";
                
                for ($i = 1; $i < sizeof ($this->_pid); $i++)
                {
                    $where .= " OR $this->_tableName.issn = '" . $this->_pid[$i] . "'";
                }
                $where .= ") ";
            }
            else
            {
                $where .= " AND $this->_tableName.issn = '$this->_pid'";
            }
        }
*/

        $query  = "SELECT lang, YEAR(date) as year, " .
                         "shorttit as stitle, " .
                         "SUM(count) as total " . 
                   "FROM $this->_tableName";

        $where = "";   
        $hasWhereClause = false;        
                                    
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
            
            $hasWhereClause = true;                    
        }
        
        if ($this->_dti)
        {
            $where .= $hasWhereClause ? " AND " : " WHERE ";
            $where .= "YEAR(date) >= $this->_dti";
            $hasWhereClause = true;
        }
        
        if ($this->_dtf)
        {
            $where .= $hasWhereClause ? " AND " : " WHERE ";
            $where .= "YEAR(date) <= $this->_dtf";
            
            $hasWhereClause = true;        
        }
        
		$group = " GROUP BY issn, lang, year";
		$order = " ORDER BY stitle, lang, year";
              
        $query .=  $where . $group . $order;
// echo $query;
        return $query;
    }
    
    
    function _getErrorXML ($errorcode)
    {
        $response  = "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>\n";
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
        $response  = "<?xml version=\"1.0\" encoding=\"iso-8859-1\" ?>\n";
        $response .= "<QUERY_RESULT>\n";
        $response .= $this->_createStatParamXML ();
        $response .= $this->_getControlInfoXML ();
        $response .= $this->_createCopyrightInfoXML ();
    
        $firstTime = true;
        $currentTitle = "";
        $currentLanguage = "";
        $breakTitle = false;
        
        $iniYear = substr ($this->getInitDate(), 0, 4);
        $finYear = substr ($this->getLastDate(), 0, 4);
        $count = 0;
        
        for ($year = $iniYear; $year <= $finYear; $year++)
        {
            $totalyear [$count++] = Array (0, 0, 0, 0);
        }
        

        while ( $row =  mysql_fetch_array ($queryResult) )
        {
            if ($row["stitle"] != $currentTitle)
            {
                if (!$firstTime)
                {
                    $response .= "  </LANGUAGE>\n";
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
            
            if ($row["lang"] != $currentLanguage or $breakTitle)
            {
                if (!$breakTitle)
                {
                    $response .= "  </LANGUAGE>\n";
                }
                else
                {
                    $breakTitle = false;                
                }
                
                $response .= "  <LANGUAGE CODE=\"" . $row["lang"] . "\">\n";
                $currentLanguage = $row["lang"];
            }
            
            $response .= "   <YEAR NUMBER=\"" . $row["year"] . "\">" . $row["total"] . "</YEAR>\n";
            
           $iyear = $row["year"] - $iniYear;
           
           $iLang = 0;
           switch ($row["lang"])
           {
                case 'es': $iLang = 1; break;
                case 'fr': $iLang = 2; break;
                case 'pt': $iLang = 3; break;
           }
           $totalyear [$iyear][$iLang] += $row["total"];            
            
        }        

        $response .= "  </LANGUAGE>\n";
        $response .= " </TITLE>\n";
        
        $response .= " <TOTAL>\n";
        
        for ($lang = 0; $lang <= 4; $lang++)
        {            
            $languageBreak = false;                

            for ($year = $iniYear; $year <= $finYear; $year++)
            {
                if ($totalyear[$year-$iniYear][$lang])
                {
                    if (!$languageBreak)
                    {     
                        switch ($lang)
                        {
                            case 1: $langCode = "es"; break;
                            case 2: $langCode = "fr" ; break;
                            case 3: $langCode = "pt" ; break;
                            default: $langCode = "en";
                        } 

                        $response .= "  <LANGUAGE CODE=\"" . $langCode ."\">\n";
                         
                        $languageBreak = true;
                    }

                    $response .= "   <YEAR NUMBER=\"" . $year . "\">" . $totalyear[$year-$iniYear][$lang] . "</YEAR>\n";                    
                }
            }

            if ($languageBreak)
            {
                $response .= "  </LANGUAGE>\n";
            }
        }
        
        $response .= " </TOTAL>\n";
        
        $response .= "</QUERY_RESULT>\n";
        
        return $response;
    }
    
    function _createStatParamXML ()
    {
        $startDate = substr( $this->getInitDate(), 0, 4 );
        $currentDate = substr( $this->getLastDate(), 0, 4 );
        
        $initialDate = $this->_dti ? $this->_dti : $startDate;
        $finalDate = $this->_dtf ? $this->_dtf : $currentDate;    
        $response  = " <STATPARAM>\n";
        $response .= "  <START_DATE>$startDate</START_DATE>\n";
        $response .= "  <CURRENT_DATE>$currentDate</CURRENT_DATE>\n";
        $response .= "  <FILTER>\n";
        $response .= "   <INITIAL_DATE>$initialDate</INITIAL_DATE>\n";
        $response .= "   <FINAL_DATE>$finalDate</FINAL_DATE>\n";
        $response .= "  </FILTER>\n";
        $response .= " </STATPARAM>\n";
        
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
     
    function SetInitialDate ($date)
    {
        if ($date)
        {
            $this->_dti = substr($date,0,4); 
        }
    }

    function GetInitialDate ()
    {
        return $this->_dti;
    }
    
    function SetFinalDate ($date)
    {
        if ($date)
        {
            $this->_dtf = substr($date,0,4); 
        }
    }

    function GetFinalDate ()
    {
        return $this->_dtf;
    }
    
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
/*    
    function GetErrorCode()
    {
        return $this->_errorcode;
    }
*/    
}

?>
