<?php

require_once(dirname(__FILE__)."/GrandeAreaDAO.php");

class GrandeArea{

	//Origem da tabela, CNPq, UE, ScienTI, etc...
	var $_tabela = 'cnpq';

	//Id, classico!
	var $_id_grande_area = '';

	//SubAreas
	var $_sub_areas = array();

	//Descricao
	var $_descricao = "";

	//Idioma da visualização dos dados
	var $_lang = 'pt';


	//Construtor ?
	function GrandeArea($tabela = 'cnpq', $lang="pt", $descricao = "", $id = '', $subareas=array())
	{
		$this->_tabela = $tabela;
		$this->_id_grande_area = $id;
		$this->_descricao = $descricao;
		$this->_sub_areas = $subareas;
		$this->_lang = $lang;
	}

	function setTabela($param){
		$this->_tabela = $param;
	}

	function setLang($param){
		$this->_lang = $param;
	}

	function setID($param){
		$this->_id_grande_area = $param;
	}

	function setDescricao($param){
		$this->_descricao = $param;
	}


	function setSubAreas($param){
		$this->_sub_areas = $param;
	}

	function getTabela(){
		return ($this->_tabela);
	}

	function getLang(){
		return ($this->_lang);
	}

	function getID(){
		return ($this->_id_grande_area);
	}
	
	function getDescricao(){
		return $this->_descricao;
	}

	function getSubAreas(){

		if($this->_sub_areas == array()){
			$grandeAreaDAO = new GrandeAreaDAO($this);
			$this->_sub_areas = $grandeAreaDAO->getSubAreas();
		}

		return ($this->_sub_areas);
	}

	function getGrandeAreas(){
		$grandeAreaDAO = new GrandeAreaDAO($this);
		$lista = $grandeAreaDAO->getGrandeAreas();
		return $lista;
	}

	function loadGrandeArea(){
		$dao = new GrandeAreaDAO($this);

		$aux = $dao->loadGrandeArea();
		$this->setID($aux->getID());
		$this->setDescricao($aux->getDescricao());
	}


}

?>