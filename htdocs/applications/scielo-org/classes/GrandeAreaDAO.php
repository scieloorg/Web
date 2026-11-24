<?php

require_once(dirname(__FILE__)."/../users/DBClass.php");
require_once(dirname(__FILE__)."/GrandeArea.php");
require_once(dirname(__FILE__)."/SubArea.php");

class GrandeAreaDAO{


var $_db = null;

var $_grande_area = null;

	function GrandeAreaDAO($grandeArea){
		$this->_db = new DBClass();
		$this->_grande_area = $grandeArea;
	}

	function __construct($grandeArea){
		$this->GrandeAreaDAO($grandeArea);
	}

	function sqlInt($value){
		return intval($value);
	}

	function langColumn(){
		$lang = $this->_grande_area->getLang();
		return in_array($lang, array('pt', 'en', 'es')) ? $lang : 'pt';
	}

	function getSubAreas(){
		$strsql = "SELECT * FROM sub_area WHERE id_grande_area = ".$this->sqlInt($this->_grande_area->getID());

		$rs = $this->_db->databaseQuery($strsql);

		$subAreas = array();
		$sub = new SubArea();

		foreach($rs as $row)
		{
			$sub->setID($row['id_sub_area']);
			$sub->setGrandeAreaID($row['id_grande_area']);
			$sub->setDescricao($row[$this->langColumn()]);
			array_push($subAreas, $sub);
		}

		return ($subAreas);
	}

	function getGrandeAreas(){
		$strsql = "SELECT * FROM grande_area";

		$rs = $this->_db->databaseQuery($strsql);

		$grandeAreas = array();
		$grande = new GrandeArea();

		foreach($rs as $row)
		{
			$grande->setID($row['id_grande_area']);
			$grande->setLang($this->_grande_area->getLang());
			$grande->setDescricao($row[$this->langColumn()]);
			array_push($grandeAreas, $grande);
		}
		return ($grandeAreas);
	}

	function loadGrandeArea(){
		$strsql = "SELECT * FROM grande_area WHERE id_grande_area = ".$this->sqlInt($this->_grande_area->getID());

		$row = $this->_db->databaseQuery($strsql);

		$sub = new GrandeArea();
		
		$sub->setID($row[0]['id_grande_area']);

		if($this->_grande_area->getLang() != '')
		{

			$sub->setDescricao($row[0][$this->langColumn()]);
		}else{
			$sub->setDescricao($row[0]['pt'].$row[0]['en'].$row[0]['es']);
		}

		return ($sub);
	}

}

?>