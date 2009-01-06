<?php

require_once(dirname(__FILE__)."/SubAreaDAO.php");

class SubArea{

	var $_id_sub_area;

	var $id_grande_area;

	var $_descricao;

	function setID($param){
		$this->_id_sub_area = $param;
	}

	function setGrandeAreaID($param){
		$this->id_grande_area = $param;
	}

	function setDescricao($param){
		$this->_descricao = $param;
	}

	function getID(){
		return ($this->_id_sub_area);
	}

	function getGrandeAreaID(){
		return ($this->id_grande_area);
	}

	function getDescricao(){
		return ($this->_descricao);
	}

	function loadSubArea(){
		$dao = new SubAreaDAO();
		$aux = $dao->loadSubArea($this);
		$this->setID($aux->getID());
		$this->setGrandeAreaID($aux->getGrandeAreaID());
		$this->setDescricao($aux->getDescricao());
	}


}

?>