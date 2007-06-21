<?php
//  LogDatabase
//  Class that defines a Log Database (APG - 7/5/2001)

include_once ("classLogDefFile.php");

class LogDatabase
{
 var $_hostIP;            // Host IP
 var $_user;              // MySQL User
 var $_password;          // MySQL Password
 var $_dbname;            // Name of the MySQL Database
 var $_mainTableName;     // Main Table Name
 var $_defFile;           // Definition File
 var $_adminEmail;        // EMail of the person responsible for the database
 
 var $_dbh;               // MySQL Connection Handle
 var $_MySQLError;        // MySQL Error
 
 function LogDatabase($defFile)
 {
  $this->_defFile = new LogDefFile($defFile);
 
  $this->_hostIP = $this->_defFile->getVar("SERVER_LOG");
  $this->_user = $this->_defFile->getVar("MYSQL_USER"); 
  $this->_password = $this->_defFile->getVar("MYSQL_PASSWORD"); 
  $this->_dbname = $this->_defFile->getVar("DB_NAME");
  $this->_mainTableName = $this->_defFile->getVar("TABLE_NAME");
  $this->_adminEmail = $this->_defFile->getVar("ADMIN_EMAIL");
  
  $this->_MySQLError = 0;
 }
 
 function destroy()
 {
  // Destructor

  $this->_hostIP = null;
  $this->_user = null;
  $this->_password = null;
  $this->_dbname = null;
  $this->_mainTableName = null;
  $this->_adminEmail = null;
  $this->_MySQLError = null;
  
  $this->_defFile->destroy();
  $this->_defFile = null;  
  
  mysql_close($this->_dbh);
 }
 
 function _setMySQLError()
 {
  $this->_MySQLError = mysql_errno($this->_dbh);
 }
 
 function getMySQLError()
 {
  return $this->_MySQLError;
 }
 
 function openMySQLServerConnection()
 {
  // Open connection with database server
  if (!($this->_dbh=mysql_connect($this->_hostIP,$this->_user,$this->_password)))
  {
   $this->sendMySQLErrorMessage();
   return 0;
  }  
  return 1;
 }
 
 function setAsMySQLActiveDatabase()
 {
  // Make $_dbname the active database
  if (!mysql_select_db($this->_dbname,$this->_dbh))
  {
   // Just Set Error without sending a Message
   $this->_setMySQLError(); 
   return 0;
  }
  return 1;
 } 
 
 function runQuery($queryString)
 {
  // Runs a query
  if (!($result=mysql_query($queryString,$this->_dbh)))
  {
   $this->sendMySQLErrorMessage();
   return 0;
  }
  return $result;
 }
 
 function sendMySQLErrorMessage()
 {
  //Sends a message to the address given with information about the MySQL error

  $this->_setMySQLError(); 
  
  $body = "There was an error while trying to access the ".$this->_dbname;
  $body .= " Database:\n".$this->getMySQLError()." ".mysql_error($this->_dbh);
  $this->sendMessage($body);  				   
 }
 
 function sendMessage($body)
 {
  //Sends a message to the address given
  
  $subject = "Message from the Log Server";
  $body = $body."\n";
  echo $body;
  mail($this->_adminEmail,$subject,$body);
 }
}
?>