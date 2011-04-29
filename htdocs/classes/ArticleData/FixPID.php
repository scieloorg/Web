<?php

	class FixPID {

		function FixPID($fileName){
			if (file_exists($fileName)){
				$this->pidList = parse_ini_file($fileName,true);
			} 
		}
		function getFixedPid($badPid){
			return $this->pidList[$badPid];
		}
	}

?>