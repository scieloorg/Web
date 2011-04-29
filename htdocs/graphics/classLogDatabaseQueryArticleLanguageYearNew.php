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
                         "shorttit as stitle, issn," .
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

		$group = " GROUP BY issn, lang, year";
		$order = " ORDER BY stitle, lang, year";
              
        $query .=  $where . $group . $order;
//echo $query;
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
        $response .= $this->_getControlInfoXML ();
        
        $firstTime = true;
        $currentTitle = "";
        $currentLanguage = "";
        $breakTitle = false;
        
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
                
				$query1 = "SELECT cnt FROM langaux1 WHERE issn=\"".$row["issn"]."\"";
				$result1 = $this->query($query1);
				$row1 =  mysql_fetch_array ($result1);
				
                $response .= " <TITLE NAME=\"" . $row["stitle"]."\" TOTAL=\"".$row1["cnt"]."\">\n";
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
				
				
				$query2 = "SELECT cnt FROM langaux WHERE issn=\"".$row["issn"]."\" AND lang=\"".$row[lang]."\"";
				$result2 = $this->runQuery($query2);
				$row2 =  mysql_fetch_array ($result2);

                $response .= "  <LANGUAGE CODE=\"" . $row["lang"] . "\" TOTAL=\"". $row2["cnt"]."\">\n";
                $currentLanguage = $row["lang"];
            }
            
            $response .= "   <YEAR NUMBER=\"" . $row["year"] . "\">" . $row["total"] . "</YEAR>\n";
            
        }
		
        $response .= "  </LANGUAGE>\n";
        $response .= " </TITLE>\n";
		
		$query3 = "SELECT year,lang,cnt FROM langaux2";
		$result3 = $this->query($query3);
		
        $currentYear = "";
        $currentLanguage = "";

		$response .= "<TOTAL>\n";
        while ( $row =  mysql_fetch_array ($result3) )
		{
         if ($row["year"] != $currentYear)
		 {
		  if ($currentYear != "") $response .= "</TOTALYEAR>\n";
		   
		  $response .= "<TOTALYEAR YEAR=\"".$row["year"]."\">\n";
		  $currentYear = $row["year"];
		 }

         if ($row["lang"] != $currentLang)
		 { 
		  $response .= "<TOTALLANG LANG=\"".$row["lang"]."\" TOTAL=\"".$row["cnt"]."\"/>\n";
		  $currentYear = $row["year"];
		 }
        }
		
		$response .= "</TOTALYEAR>\n";
		$response .= "</TOTAL>\n";
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
     
    function SetInitialDate ($date)
    {
        if ($date)
        {
            $this->_dti = $date; 
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
            $this->_dtf = $date; 
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
