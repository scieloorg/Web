<?php
//  LogDatabaseQueryScieloIssue
//  Class that defines an Issue Query to the Scielo Log Database (APG - 30/7/2001)

include ("classLogDatabaseQueryScielo.php");

class LogDatabaseQueryScieloIssue extends LogDatabaseQueryScielo
{
 function LogDatabaseQueryScieloIssue($defFile)
 {
  // Constructor
  
  LogDatabaseQueryScielo::LogDatabaseQueryScielo($defFile);
  
  // Change table name
  $this->_tableName = $this->_defFile->getVar("TABLE_ISSUES_NAME");
 }
 
 function destroy()
 {
  // Destructor
  
  LogDatabaseQueryScielo::destroy();
 }
 
 function mostRequested_ISSN($issn,$idate,$fdate,$access,$cpage,$nlines,$tpages,$maccess)
 {
  $dnlines = 80; // Default number of lines
  $this->constructStatistics($issn,$idate,$fdate,$access,$dnlines,$cpage,$nlines,$tpages,$maccess);
 }
 
 function mostRequested()
 {
 }
}
?>