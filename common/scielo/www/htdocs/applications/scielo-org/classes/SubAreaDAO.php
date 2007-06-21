<?php

require_once(dirname(__FILE__)."/../users/DBClass.php");

class SubAreaDAO{


var $_db = null;


	function SubAreaDAO(){
		$this->_db = new DBClass();
	}


	function loadSubArea($subArea,$lang=''){
		$strsql = "SELECT * FROM sub_area WHERE id_sub_area = ".$subArea->getID();

		$row = $this->_db->databaseQuery($strsql);

		$sub = new SubArea();

		$sub->setID($row[0]['id_sub_area']);
		$sub->setGrandeAreaID($row[0]['id_grande_area']);


		if($lang != '')
		{
			$sub->setDescricao($row[0][$lang]);
		}else{
			/*
				jah que eh pra trigrama msm vai em todos os idiomas hehehe
			*/
			$sub->setDescricao($row[0]['pt'].$row[0]['en'].$row[0]['es']);
		}

		return ($sub);
	}

}


?>