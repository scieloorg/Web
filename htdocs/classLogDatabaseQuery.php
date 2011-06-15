<?php
//  LogDatabaseQuery
//  Class that extends a Log Database functionality to include queries (APG - 7/6/2001)

include ("classLogDatabase.php");

class LogDatabaseQuery extends LogDatabase
{ 
 function LogDatabaseQuery($defFile)
 {
  LogDatabase::LogDatabase($defFile);
  
  $result = ereg("^([^\:\/]+)(\:[0-9]+)?$",$this->_hostIP,$arr);
  
  if ($result)
   $this->_hostIP = $arr[1];
  else
   exit(1);
 }  
 
 function destroy()
 {
  // Destructor
  
  LogDatabase::destroy();
 }
  
 function getInitDate($table)
 {
  // Obtains the value of the date field of the first record in the database
 
  $queryString = "SELECT MIN(date) FROM $table";
  
  // Interpret Query
  $result = $this->runQuery($queryString);
  
  if (!$result && $this->getMySQLErrorCode()!=0)
   return 0;
   
  $row = mysql_fetch_row($result);
  
  return $row[0];
 }
 
 function getLastDate($table)
 {
  // Obtains the value of the date field of the last record in the database
 
  $queryString = "SELECT MAX(date) FROM $table";
  
  // Interpret Query
  $result = $this->runQuery($queryString);
  
  if (!$result && $this->getMySQLErrorCode()!=0)
   return 0;
   
  $row = mysql_fetch_row($result);
  
  return $row[0];
 }

 function query($queryString)
 {
  // Queries the Log Database
  // Parameters: 
  //  queryString - Value of the Query String
  
  // Open connection with database server
  if (!$this->openMySQLServerConnection())
   return 0;
 
  // Make $_dbname the active database
  
  if (!$this->setAsMySQLActiveDatabase())
   return 0;
  
  // Interpret Query
  $result = $this->runQuery($queryString);
  
  if (!$result)
   return 0;
 
  return $result;
 }
}
?>