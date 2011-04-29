<?php
/**
*@package	Scielo.org
*@version      1.0
*@author       Fabio Batalha(santosfa@bireme.ops-oms.org)
*@copyright     BIREME
*/
/**
*Classe de acesso a tabela de Links
*/

	require_once(dirname(__FILE__)."/../users/DBClass.php");
	require_once(dirname(__FILE__)."/Links.php");

class LinksDAO {

/**
* Construtor da Classe DirectoryDAO
*/
	function LinksDAO(){
		
		$this->_db = new DBClass();
	}
/**
* Adiciona um diretório a prateleira
*
* @param Shelf $profile Objeto Prateleira do usuário
*
* Ele pega os dados que estão armazenados nos campos da classe e persiste no Banco de dados
* o campo usuário é auto increment - é inserido pelo Banco de dados
*/
	function AddLink($link){
		$strsql = "INSERT INTO
							user_links
								(user_id, name, url, description, in_home)
							VALUES (
								'".$link->getUser_id()."','".$link->getName()."','".$link->getUrl()."',
								'".$link->getDescription()."',".$link->getInHome().")";
		$result = $this->_db->databaseExecInsert($strsql);
		return $result;
	}

/**
* Remove um registro da prateleira
*
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function removeLink($link){
		$strsql = "DELETE FROM user_links WHERE link_id = ".$link->getLink_id()." and user_id = ".$link->getUser_id();
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}

	
/**
*Retorna um registro da tabela directories definido pelo campo directory_id
*
*@param Links
*/
	function getLink($link){
		$strsql = "SELECT * FROM user_links WHERE link_id = ".$link->getLink_id()." and user_id = ".$link->getUser_id();

		$result = $this->_db->databaseQuery($strsql);
		$linkItem = array();
		for($i = 0; $i < count($result); $i++)
		{
			$link = new Links();
			$link->setLink_id($result[$i]['link_id']);
			$link->setUser_id($result[$i]['user_id']);
			$link->setName($result[$i]['name']);
			$link->setUrl($result[$i]['url']);
			$link->setDescription($result[$i]['description']);
			$link->setInHome($result[$i]['in_home']);
			$link->setRate($result[$i]['rate']);
			array_push($linkItem, $link);
		}
		return $linkItem;
	}

/**
*Retorna um array de objetos Links
*
*Lê a base de dados, e retorna um array de objetos Shelf
*@param Shelf shelf objeto shelf que contém o ID do usuário que se quer ter a shelf carregada
*@param integer from
*@param integer count
*
*@returns mixed Array de objetos Shelf
*/
	function getLinkList($link, $from=0, $count=-1,$params){
//	function getDirectoryList($directory, $from=0, $count=-1){

		switch ($params["sort"]){
			case "rate":
				$sort = "rate desc";
			break;
			case "date":
				$sort = "link_id desc";
			break;
			default:
				$sort = "rate desc";
			break;
		}
		
		$strsql = "SELECT * FROM user_links WHERE user_id = ".$link->getUser_id()." order by ".$sort;

        if($count > 0){
		    $strsql .= " LIMIT $from,$count";
		}
		
		$result = $this->_db->databaseQuery($strsql);
		$linkList = array();
		for($i = 0; $i < count($result); $i++)
		{
			$link = new Links();
			$link->setLink_id($result[$i]['link_id']);
			$link->setUser_id($result[$i]['user_id']);
			$link->setName($result[$i]['name']);
			$link->setUrl($result[$i]['url']);
			$link->setDescription($result[$i]['description']);
			$link->setInHome($result[$i]['in_home']);
			$link->setRate($result[$i]['rate']);
			array_push($linkList, $link);
		}
		return $linkList;
	}
	
/**
*Retorna um registro da tabela directories definido pelo campo directory_id
*
*@param Links
*/
	function getInHomeLinks($link){
		$strsql = "SELECT * FROM user_links WHERE user_id = ".$link->getUser_id()." and in_home=1 order by rate desc";

		$result = $this->_db->databaseQuery($strsql);
		$linkList = array();
		for($i = 0; $i < count($result); $i++)
		{
			$link = new Links();
			$link->setLink_id($result[$i]['link_id']);
			$link->setUser_id($result[$i]['user_id']);
			$link->setName($result[$i]['name']);
			$link->setUrl($result[$i]['url']);
			$link->setDescription($result[$i]['description']);
			$link->setInHome($result[$i]['in_home']);
			$link->setRate($result[$i]['rate']);
			array_push($linkList, $link);
		}
		return $linkList;
	}
	
/*
*Verifica se o Artigo já se encontra na shelf do usuário
*Verifica se o artigo já esta na shelf independente do status visible
*@returns boolean
*/
	function linkExist($link){
		$strsql = "SELECT * FROM user_links WHERE name = '".$link->getName()."' and user_id =".$link->getUser_id();
		$result = $this->_db->databaseQuery($strsql);

		if(count($result) > 0){
			return true;
		}else{
			return false;
		}
	}

    function getTotalItens($link){
		$strsql = "SELECT count(*) as total FROM user_links WHERE user_id=".$link->getUser_id();
		$result = $this->_db->databaseQuery($strsql);
		return $result[0]['total'];
    }
	
	function updateLink($link){
		$strsql = "UPDATE user_links set name='".$link->getName()."', user_id=".$link->getUser_id().", url='".$link->getUrl()."', description='".$link->getDescription()."', in_home=".$link->getInHome()." WHERE link_id=".$link->getLink_id()." and user_id=".$link->getUser_id();
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}

	function UpdateLinkRate($link){
		$strsql = "Update user_links SET rate=".$link->getRate()." WHERE link_id=".$link->getLink_id() . " and user_id=".$link->getUser_id();
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}
	
		function deleteFromHome($link){
			$strsql = "Update user_links SET in_home=0 WHERE link_id=".$link->getLink_id() . " and user_id=".$link->getUser_id();		
			$result = $this->_db->databaseExecUpdate($strsql);
			return $result;
		}

		function addInHome($link){
			$strsql = "Update user_links SET in_home=1 WHERE link_id=".$link->getLink_id() . " and user_id=".$link->getUser_id();
			$result = $this->_db->databaseExecUpdate($strsql);
			return $result;
		}
}

?>
