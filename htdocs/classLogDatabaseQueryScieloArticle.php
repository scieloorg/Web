<?php
//  LogDatabaseQueryScieloArticle
//  Class that defines an Article Query to the Scielo Log Database (APG - 30/7/2001)

include ("classLogDatabaseQueryScielo.php");

class LogDatabaseQueryScieloArticle extends LogDatabaseQueryScielo
{
 function LogDatabaseQueryScieloArticle($defFile)
 {
  // Constructor
  
  LogDatabaseQueryScielo::LogDatabaseQueryScielo($defFile);
  
  // Change table name
  $this->_tableName = $this->_defFile->getVar("TABLE_ARTICLES_NAME");
 }
 
 function destroy()
 {
  // Destructor
  
  LogDatabaseQueryScielo::destroy();
 }
 
 function mostRequested_ISSN($issn,$idate,$fdate,$access,$cpage,$nlines,$tpages,$maccess)
 {
  $dnlines = 30; // Default number of lines
  $this->constructStatistics($issn,$idate,$fdate,$access,$dnlines,$cpage,$nlines,$tpages,$maccess);
 }
 
 function mostRequested()
 {
 }
}
?>