<?php
	require_once("makedir.php");
	class File {
	
		function File($fileName){
			$this->fileName = $fileName;
			/*if ($id && $path){
				$this->fileName = $path.$this->getSubDir($id).$this->fileName;
			}*/
		}
		/*
		function getSubDir($id){
			$length = strlen($id);
			$subDir = substr($id, $length, 1).'/'.substr($id, $length-1, 1).'/'.$id.'/';
			return $subDir;
		}*/
		function set_name($content){
			$this->_name = $content;
		}
		function set_size($content){
			$this->_size = $content;
		}
		function set_type($content){
			$this->_type = $content;
		}
		function set_error($content){
			$this->_error = $content;
		}
		function get_name(){
			return $this->_name;
		}
		function get_filename(){
			return $this->fileName;
		}
		function get_type(){
			return $this->_type;
		}
		function get_size(){
			return $this->_size;
		}
		function get_error(){
			return $this->_error;
		}
		function identifyType(){
			$pext = strrpos($this->get_filename(),'.');
			$ext = substr($this->get_filename(),$pext+1);
			switch($ext){
				case "xml":
					$type = "text/xml";
					break;
				case "pdf":
					$type = "application/pdf";
					break;
				case "ps":
					$type = "application/postscript";
					break;
				case "doc":
					$type = "application/msword";
					break;
				case "?":
					$type = "application/wordperfect";
					break;
				case "rtf":
					$type = "application/rtf";
					break;
				case "htm":
				case "html":
					$type = "text/html";
					break;
				case "txt":
					$type = "text/plain";
					break;
				case "gif":
					$type = "image/gif";
					break;
				default:		
					break;
			}
			return $type;
		}
		function read(){
			$content ='';
			if (file_exists($this->fileName)){
				$fp = fopen($this->fileName, "rw");
				if ($fp) {
					if (filesize($this->fileName)>0){
						$content = fread($fp, filesize($this->fileName));
					} else {
						die("File->read() file size ".$this->fileName."=".filesize($this->fileName));
					}
				}
				fclose($fp);
			} else {
				//die("File->read() ".	$this->fileName);
			}
			return $content;
		}
		
		function write($content){
			createDirStructure(dirname($this->fileName), '', $s_err_msg, $i_err_code, 0775);
			if (file_exists($this->fileName)){
				if (!is_writable($this->fileName)) {
					if (ini_get('safe_mode')){
					
					} else {
	               		if (!chmod($this->fileName, 0777)) {
							$r = true;
    		           	}
					}
           		}		
			}

			$fp = fopen($this->fileName, "w");
			if ($fp){
		        fwrite($fp, $content);
			}
			fclose($fp);
			if (!is_writable($this->fileName)) {
				if (ini_get('safe_mode')){
				
				} else {
	              		if (!chmod($this->fileName, 0400)) {
							$r = true;
	  		           	}
				}
           	}	
			$r = (file_exists($this->fileName) && (filesize($this->fileName)==strlen($content)));
			return $r;
		}
		
		function isCompressed($fileType=""){
			if ($fileType){
				if ($fileType == 'application/zip'){
					return true;
				}
			} else {
			
			}
			return false;
		}
		
		function extractFiles($arrayExpectedFileName, $extractionDir, &$compressedFileNames,  &$result){
			$zip = zip_open(current($this->fileName));
			if ($zip) {
				reset($arrayExpectedFileName);
				$i = 0;
				$r = true;
				
			    while ($zip_entry = zip_read($zip)) {
					$doit = false;
					$compressedFileName = basename(zip_entry_name($zip_entry));
					if (arrayContainsData($arrayExpectedFileName)){
						$found = array_search($arrayExpectedFileName, $compressedFileName);
						
						if ($arrayExpectedFileName[$found] != $compressedFileName){
							$message[count($message)] = "UNEXPECTED_FILE";
							$r = false;
						} else {
							$doit = true;
						}
					} else {
						$doit = true;
					}
					if ($doit){
						if (zip_entry_open($zip, $zip_entry, "r")) {
				            $buf = zip_entry_read($zip_entry, zip_entry_filesize($zip_entry));
				            zip_entry_close($zip_entry);
							
							$compressedFileNames[$i] = $compressedFileName;
							$compressedFiles[$i] = $extractionDir.'/'.$compressedFileName; 
							$file = new File($compressedFiles[$i]);
							//$file->write($buf);
				        }
					}
					$result[$i] = $r;
					$i++;
					next($arrayExpectedFileName);
			    }
			}		
		    zip_close($zip);
		}				
	}
	
?>