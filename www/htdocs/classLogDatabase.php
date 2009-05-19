<?php
//  LogDatabase
//  Class that defines a Log Database (APG - 7/5/2001)

include_once ("classLogDefFile.php");
include_once ("classMySQLDatabase.php");

class LogDatabase extends MySQLDatabase
{
 var $_mainTableName;     // Main Table Name
 var $_defFile;           // Definition File
  
 function LogDatabase($defFile)
 {
  $this->_defFile = new LogDefFile($defFile);
  $this->_mainTableName = $this->_defFile->getVar("TABLE_NAME");
 
  $hostIP = $this->_defFile->getVar("SERVER_LOG");
  $user = $this->_defFile->getVar("MYSQL_USER"); 
  $password = $this->_defFile->getVar("MYSQL_PASSWORD"); 
  $dbname = $this->_defFile->getVar("DB_NAME");
  $adminEmail = $this->_defFile->getVar("ADMIN_EMAIL");
  
  MySQLDatabase::MySQLDatabase($hostIP,$user,$password,$dbname,$adminEmail,true);
 }
 
 function destroy()
 {
  // Destructor

  $this->_mainTableName = null;
  
  $this->_defFile->destroy();
  $this->_defFile = null;  
  
  MySQLDatabase::destroy();
 }
} 
?>