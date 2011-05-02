<?php
	function createDirectory($s_directory, $i_code) {
		/*
			0 -> function creates $s_directory
			1 -> does not create because already exists
			2 -> does not create because of bad luck... :)
		*/

		if (!is_dir($s_directory)){
			$r = mkdir($s_directory, $i_code);
		} else {
			chmod($s_directory, $i_code);
		}
		if ($r) {
			chmod($s_directory, $i_code);
			return 0;
		} else {
			if (file_exists($s_directory)) {
				return 1;			
			} else {
				return 2;
			}
		}
	}
	
	function createDirStructure($diretory, $s_root, &$s_err_msg, &$i_err_code, $i_chmod) {
		/*
			e.g. $i_chmod  -->  0700
			$s_root  --> is the root which your $directory will be created
		*/
		$p = strrpos ($s_root, "/");		
		if ($p>0) {
			if ($p == (strlen($s_root)-1)) {
				$s_root = substr($s_root, 0, $p) ;
			}
		} 

		//--ini-correcao para Windows
		$p = strpos ($diretory, ":/");		
		if ($p >0)  {
			$diretory = substr( $diretory, $p+1) ;
		} 
		//--fim-correcao para Windows
		
		$p = strrpos ($diretory, "/");		
		if ($p != (strlen($diretory)-1)) {
			$diretory = $diretory . "/" ;
		} 
		
		if (substr ($diretory, 0, 1) == '/') {
			$diretory = substr($diretory, 1);
		} 		
	
		$i=0;
		while ($diretory) {
			$p =  strpos ($diretory, "/");
			$s_root = $s_root . '/' . substr($diretory, 0, $p) ;

			switch (createDirectory($s_root, $i_chmod)) {
				case 0:
					$b_error = TRUE;
					$s_err_msg = "The directory structure <i>$s_level</i> has been created succesfully!";
					$i_err_code = 0;
					break;
				case 1:
					$b_error = FALSE;
					$s_err_msg = "The directory structure <i>$s_level</i> already exists!";
					$i_err_code = 1;
					break;
				case 2:
					$b_error = FALSE;
					$s_err_msg = "Error creating the directory structure <i>$s_level</i>";
					$i_err_code = 2;
					break;	
				default:
					break;
			}

			$i++;
			$diretory = substr($diretory, $p + 1);
		}
		return $b_error;
	}
?>