<?php
//  MySQLDatabase
//  Class that defines a MySQL Database (APG - 27/11/2001)
//  Updates:
//    05/03/2002 - connection and active db stablished in constructor. (RS)

class MySQLDatabase
{
 var $_hostIP;            // Host IP
 var $_user;              // MySQL User
 var $_password;          // MySQL Password
 var $_dbname;            // Name of the MySQL Database
 var $_adminEmail;        // EMail of the person responsible for the database
 
 var $_dbh;               // MySQL Connection Handle
 var $_MySQLErrorCode;    // MySQL Error code
 var $_MySQLError;        // MySQL Error description
 
 function MySQLDatabase($hostIP,$user,$password,$dbname,$adminEmail="",$ignore=false)
 { 
  $this->_hostIP = $hostIP;
  
  if ($ignore) $this->_extractPortFromIP();
  
  $this->_user = $user; 
  $this->_password = $password; 
  $this->_dbname = $dbname;
  $this->_adminEmail = $adminEmail;
  
  $this->_MySQLError = "";
  $this->_MySQLErrorCode = 0;
  $this->openMySQLServerConnection();
 
  // Make $_dbname the active database  
  $this->setAsMySQLActiveDatabase();
 }
 
 function destroy()
 {
  // Destructor

  $this->_hostIP = null;
  $this->_user = null;
  $this->_password = null;
  $this->_dbname = null;
  $this->_adminEmail = null;
 
  $this->_MySQLError = null;
  
  mysql_close($this->_dbh);  
  $this->_dbh = null;
 }
 
 function _extractPortFromIP()
 {
  if (!strchr($this->_hostIP,":"))
   return;
  
  $result = ereg("^([^\:\/]+)(\:[0-9]+)?$",$this->_hostIP,$arr);
  
  if ($result)
   $this->_hostIP = $arr[1];
  else
   exit(1);
 }
 
 function _setMySQLError()
 {
  $this->_MySQLErrorCode = mysql_errno($this->_dbh);
  $this->_MySQLError = mysql_error($this->_dbh);
 }
 
 function getMySQLError()
 {
  return $this->_MySQLError;
 }

 function getMySQLErrorCode()
 {
  return $this->_MySQLErrorCode;
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
  // Sends a message to the address given with information about the MySQL error
  
  $this->_setMySQLError(); 
  
  $body = "There was an error while trying to access the ".$this->_dbname;
  $body .= " Database:\n".$this->getMySQLError()." ".mysql_error($this->_dbh);

  $this->sendMessage($body);  				   
 }
 
 function sendMessage($body)
 {
  //Sends a message to the address given
  
  if (!$this->_adminEmail)
  {
   return;
  }
  
  $filename = "tmpSQL/logmsg" . date("Ymd");
  $lastTime = $this->_getLastMessageTime($filename);
  $now = time();
  
  if ($now - $lastTime < 3600) 
  {
   return;
  }
  
  $subject = "Message from the Log Server";
  $body = $body."\n";
  
  mail($this->_adminEmail,$subject,$body);

  $this->_setLastMessageTime($filename,$now);
 }
 
 function _getLastMessageTime($filename) 
 {  
  $ts = 0;

  @$fd = fopen($filename, "rb");
  if ($fd) 
  {
   @$ts = (int) fread($fd, filesize($filename));
   @fclose($fd);
  }
  
  return $ts;
 }
 
 function _setLastMessageTime($filename,$timestamp) 
 {
  @$fd = fopen($filename, "wb");
  @fwrite($fd, (int) $timestamp);
  @fclose($fd);
 }
}
?>