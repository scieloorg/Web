<?php
include_once ("classLogDatabaseQuery.php");

class LogDatabaseQueryArticlesPerYear extends LogDatabaseQuery
{
    var $_tableName = "";
    var $_year = 0;
    
    function LogDatabaseQueryArticlesPerYear ($deffile)
    {
        LogDatabaseQuery::LogDatabaseQuery ($deffile);

        $this->_tableName = $this->_defFile->getVar("TABLE_JOURNALS_NAME");
    }
    
    function setYear ($year)
    {
        $this->_year = $year;
    }

    function getYear ()
    {
        return $this->_year;
    }
    
    function executeQuery ()
    {
        $query = "SELECT SUBSTRING(date, 5, 2) as month, SUM(cnt_art) as count FROM $this->_tableName WHERE YEAR(date) = $this->_year GROUP BY month";
//echo $query;
        if (! ($result = $this->query($query)) )
		{
			return false;
		}

        $result_array = Array();
        $ndx = 0;

		while (	$row = mysql_fetch_array ($result) )
		{
            $result_array[$ndx][0] = $row["month"];
            $result_array[$ndx++][1] = $row["count"];
		}
								                       
        return $result_array;
    }
    
    function getInitDate()
    {
        $query = "select min(date) from $this->_tableName";
        
        if (! ($result = $this->query($query)) )
		{
			return 0;
		}
        
        if (! ($row = mysql_fetch_array ($result)) )
        {
            return 0;
        }
        
        return $row[0];
    }
    
    function getLastDate()    
    {
        $query = "select max(date) from $this->_tableName";
        
        if (! ($result = $this->query($query)) )
		{
			return 0;
		}
        
        if (! ($row = mysql_fetch_array ($result)) )
        {
            return 0;
        }
        
        return $row[0];
    }

}
?>
