<?php
//  LogDefFile
//  Class that defines a Log Definition File (APG - 7/5/2001)

include ("DefFile.php");

class LogDefFile extends DefFile
{ 
 function LogDefFile($name)
 {
  // Constructor
  DefFile::DefFile($name);
 }
 
 function destroy()
 {
  // Destructor
 }
 
 function getVar($varName)
 {
  return $this->keys[$varName];
 }
}

?>