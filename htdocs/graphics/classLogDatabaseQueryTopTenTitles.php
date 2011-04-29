<?php
include_once ("classLogDatabaseQuery.php");

class  LogDatabaseQueryTopTenTitles extends LogDatabaseQuery
{
//    var $_tittable = "";
    var $_table = "";
    
    function LogDatabaseQueryTopTenTitles ($deffile)
    {
        LogDatabaseQuery::LogDatabaseQuery ($deffile);

        $this->_table = $this->_defFile->getVar("TABLE_ART_LANG_NAME");
//        $this->_tittable = "biblio.title";
    }
    
    function _getQuery ()
    {
/*    
        $columns = "$this->_tittable.shorttit as title, sum($this->_table.cnt_art) as count";
        $tables = "$this->_table, $this->_tittable";
        $where_clause = "$this->_tittable.issn = $this->_table.issn";
        $group_clause = "$this->_table.issn";
        $query = "select $columns from $tables where $where_clause group by $group_clause";
*/        

        $columns = "shorttit as title, sum(count) as total";
        $tables = "$this->_table";
        $group_clause = "issn";
        $order = "total desc";
        $limit = 10;
        
        $query = "select $columns from $tables group by $group_clause order by $order limit $limit";
        
//        echo $query;
        return $query;
    }
    
    function executeQuery ()
    {
        $query = $this->_getQuery ();
        
        if (! ($result = $this->query ($query)) )
		{
			return false;
		}
        
        return $result;
    }
    
    function getTotalArticles ()
    {
        $query = "select sum(count) as total from $this->_table";

        if (! ($result = $this->query ($query)) )
		{
			return 0;
		}
        
        $row = mysql_fetch_array ($result);
        
        return $row["total"];
    }
}
?>