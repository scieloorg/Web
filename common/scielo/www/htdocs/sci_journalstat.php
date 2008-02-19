<?php
include ("classLogDatabaseQuery.php");

define ("LOGDEF", "scielo.def.php");
define ("MYSQL_SUCCESS", 0);

class LogDatabaseQueryJournal extends LogDatabaseQuery
{
	// ------------------------------------------------------------------------------------------
	// ------------------------------   Private Data Members   ----------------------------------
	// ------------------------------------------------------------------------------------------

    var $_dti = "",
        $_dtf = "",
        $_pid = "";
//    var $_errorcode = 0;
    var $_tableName = "";
        
	// ------------------------------------------------------------------------------------------
	// --------------------------------     Constructor     -------------------------------------
	// ------------------------------------------------------------------------------------------

    function LogDatabaseQueryJournal ($deffile)
    {
        LogDatabaseQuery::LogDatabaseQuery ($deffile);

        $this->_tableName = $this->_defFile->getVar("TABLE_JOURNALS_NAME");
    }

	// ------------------------------------------------------------------------------------------
	// ----------------------------------   Private Methods   -----------------------------------
	// ------------------------------------------------------------------------------------------
        
    function _CreateQueryString ()
    {
        $query  = "select issn, min(date) as dt, sum(cnt_ser) as cser, sum(cnt_toc) as ctoc, sum(cnt_art) as cart, sum(cnt_oth) as coth from $this->_tableName";
        $hasFilter = false;

        if ($this->_pid)
        {
            $query .= " where issn = '$this->_pid'";
            $hasFilter = true;
        }
        
        if ($this->_dti)
        {        
            $query .= ($hasFilter ? " and " : " where ") . "date >= '$this->_dti'";
            $hasFilter = true;
        }
        if ($this->_dtf)
        {
            $query .= ($hasFilter ? " and " : " where ") . "date <= '$this->_dtf'";
            $hasFilter = true;
        }
		$query .= " group by issn";
        
        return $query;
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
        
		$buffer = "";

		while (	$row = mysql_fetch_array ($result) )
		{
           $buffer = $buffer . "^i" . $row["issn"] . "^d" . $row["dt"] . 
                     "^h" . $row["cser"] . "^t" . $row["ctoc"] . "^a" . $row["cart"] . "^o" . $row["coth"] . "%0A";
		}
								                       
        return $buffer;
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

/***************************************************************************************************/
/****************************************    MAIN CODE    ******************************************/
/***************************************************************************************************/

$log = new LogDatabaseQueryJournal(LOGDEF);

if ( isset($dti) ) $log->SetInitialDate ($dti);
if ( isset($dtf) ) $log->SetFinalDate ($dtf);
if ( isset($pid) ) $log->SetPid ($pid);

$result = $log->ExecuteQuery();
$errorcode = $log->getMySQLErrorCode();

$response = $errorcode;

if ($errorcode == MYSQL_SUCCESS)
{
    $response .= "%0A" . $log->getInitDate();
    $response .= "%0A" . $log->getLastDate();
    $response .= "%0A" . $result;
}

$log->destroy();

echo $response;
?>