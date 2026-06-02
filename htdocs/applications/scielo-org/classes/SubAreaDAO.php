<?php

require_once(dirname(__FILE__)."/../users/DBClass.php");

class SubAreaDAO{


var $_db = null;


	function SubAreaDAO(){
		$this->_db = new DBClass();
	}

	function __construct(){
		$this->SubAreaDAO();
	}

	function sqlInt($value){
		return intval($value);
	}

	function langColumn($lang){
		return in_array($lang, array('pt', 'en', 'es')) ? $lang : 'pt';
	}


	function loadSubArea($subArea,$lang=''){
		$strsql = "SELECT * FROM sub_area WHERE id_sub_area = ".$this->sqlInt($subArea->getID());

		$row = $this->_db->databaseQuery($strsql);

		$sub = new SubArea();

		$sub->setID($row[0]['id_sub_area']);
		$sub->setGrandeAreaID($row[0]['id_grande_area']);


		if($lang != '')
		{
			$sub->setDescricao($row[0][$this->langColumn($lang)]);
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