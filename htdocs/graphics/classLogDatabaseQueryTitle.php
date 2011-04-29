<?php
include_once ("classLogDatabaseQuery.php");

class LogDatabaseQueryTitle extends LogDatabaseQuery
{
	// ------------------------------------------------------------------------------------------
	// ------------------------------   Private Data Members   ----------------------------------
	// ------------------------------------------------------------------------------------------

    var $_pid = "";

    var $_tableName = "";
	// ------------------------------------------------------------------------------------------
	// --------------------------------     Constructor     -------------------------------------
	// ------------------------------------------------------------------------------------------

    function LogDatabaseQueryTitle ($deffile)
    {
        LogDatabaseQuery::LogDatabaseQuery ($deffile);
        $this->_tableName = $this->_defFile->getVar("TABLE_ART_LANG_NAME");
    }

	// ------------------------------------------------------------------------------------------
	// ----------------------------------   Private Methods   -----------------------------------
	// ------------------------------------------------------------------------------------------
        
    function _CreateQueryString ($filter)
    {
        $query  = "SELECT shorttit as stitle, issn" .
                   " FROM $this->_tableName";
                   
        if ($filter && $this->_pid)
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
        
		$group = " group by issn";
		$order =  " order by stitle";
              
        $query .=  $where . $group . $order;
        return $query;
    }
    
    
    function ExecuteQuery ($filter)
    {
        $query = $this->_CreateQueryString ($filter);
//echo $query;        		
        if (! ($result = $this->query($query)) )
		{
			return "";
		}
                
        return $result; 
    }        
         
    function SetPid ($pid)
    {
        if ($pid)
        {
            $this->_pid = $pid; 
        }
    }
        
    function GetTitles($filter)
    {         
         $result = $this->ExecuteQuery ($filter);
         $titles = "";
         $count = 0;
         
         while ($row = mysql_fetch_array($result))
         {
            $titles [$count]["issn"] = $row["issn"];
            $titles [$count++]["title"] = $row["stitle"];
         }
         return $titles;
    }
}