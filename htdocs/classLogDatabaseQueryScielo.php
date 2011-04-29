<?php
//  LogDatabaseQueryScielo
//  Class that defines a Query to the Scielo Log Database (APG - 7/5/2001)

include ("classLogDatabaseQuery.php");

class LogDatabaseQueryScielo extends LogDatabaseQuery
{
 var $_tableName;    // Name of the Statistics Related Table
 
 function LogDatabaseQueryScielo($defFile)
 {
  // Constructor
  
  LogDatabaseQuery::LogDatabaseQuery($defFile);
 }
 
 function destroy()
 {
  // Destructor
  $this->_tableName = null;
  
  LogDatabaseQuery::destroy();
 }
 
 function _getNoAccessList($maxaccess)
 {
  // Gets List Of Options for the Number of Access List
  $maxaux = $maxaccess-intval(substr($maxaccess,1));
    
  $buffer = "";
  for ($i=1; $i<=5 && $maxaux>=10; $i++)
  {
   $maxaux = intval($maxaux/2);
   $maxaux = $maxaux-intval(substr($maxaux,1));
   
   $buffer .= (($i==1)? "":",").strval($maxaux);
  }
  
  return $buffer;
 }
 
 function _getWhereClause($issn,$idate,$fdate)
 {
  if (!$issn && !$idate && !$fdate)
   return "";
  
  $whereClause = "WHERE";
  
  if ($issn)
   $whereClause .= " issn=\"$issn\"";

  if ($idate)
   $whereClause .= " ".($issn ? "AND ":" ")."date>=\"$idate\"";  
  if ($fdate)
   $whereClause .= " ".($issn || $idate ? "AND ":" ")."date<=\"$fdate\"";  
  
  return $whereClause;
 }

 function _getHavingClause($access)
 {
  if ($access)
   $havingClause = " HAVING total>=$access";
  else
   $havingClause = "";
   
  return $havingClause;
 }
 
 function _getLimitClause($tpages,$cpage,$nlines)
 {
  if ($tpages)
  {
   $iline = ($cpage-1)*$nlines;
   $limitClause = " LIMIT $iline,$nlines";
  } 
  else
   $limitClause = "";
  
  return $limitClause;
 }
 
 function _getQueryResult($queryString,$issn,$cpage,$nlines,$tpages,$maccess)
 {
  $result = $this->query($queryString);
  $buffer = $this->getMySQLErrorCode()."%0A".$this->getInitDate($this->_tableName)."%0A".$this->getLastDate($this->_tableName)."%0A";
    
  if (!$result)
   if ($this->getMySQLErrorCode()>0)
   {
    echo $buffer;
    exit(1);
   }
  
  $i=0;
  while ($row = mysql_fetch_row($result))
  {
   $i++;
   if ($i==1) 
   {
    if (!$maccess) $maccess = $row[2];
    $accesslist = $this->_getNoAccessList($maccess);
	$buffer .= $maccess."%0A".$accesslist."%0A".$cpage."%0A".$nlines."%0A";
   }
   
   if ((!$tpages && $i<=$nlines) || $tpages) 
    $buffer .= "$row[0],$row[1],$row[2]"."%0A";
  }
  
  if (!$tpages) $tpages= ceil($i/$nlines);
  $buffer .= $tpages."%0A";
  
  mysql_free_result($result);
  
  return $buffer;
 }
 
 function constructStatistics($issn,$idate,$fdate,$access,$dnlines,$cpage,$nlines,$tpages,$maccess)
 {
  $table = $this->_tableName;
 
  $queryString = "SELECT issn,ord,SUM(count) AS total FROM $table ";

  $whereClause  = $this->_getWhereClause($issn,$idate,$fdate);
  $havingClause = $this->_getHavingClause($access);
  
  if (!$cpage)  $cpage=1;
  if (!$nlines) $nlines=$dnlines;
  
  $queryString .= $whereClause." GROUP BY issn,ord".$havingClause." ORDER BY total DESC,issn,ord";
  $queryString .= $this->_getLimitClause($tpages,$cpage,$nlines);
  
  echo $this->_getQueryResult($queryString,$issn,$cpage,$nlines,$tpages,$maccess);
 }
}

?>