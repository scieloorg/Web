<?php
/**
*@package	Scielo.org
*@version      1.0
*@author       Fabio Batalha(santosfa@bireme.ops-oms.org)
*@copyright     BIREME
*/
/**
*Classe de acesso a tabela de Directories
*/

	require_once(dirname(__FILE__)."/../users/DBClass.php");
	require_once(dirname(__FILE__)."/UserDirectory.php");

class DirectoryDAO {

/**
* Construtor da Classe DirectoryDAO
*/
	function DirectoryDAO(){
		
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
	function AddDirectory($directory){

		$strsql = "INSERT INTO
							directories
								(name,
								 offline,
								 user_id)
							VALUES (
								'".$directory->getName()."',0,
								 ".$directory->getUser_id().")";

		$result = $this->_db->databaseExecInsert($strsql);
		return $result;
	}

/**
* Remove um registro da prateleira
*
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function removeDirectoryFromShelf($directory){
		$strsql = "DELETE FROM directories WHERE directory_id = ".$directory->getDirectory_id();
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}

	
/**
*Retorna um registro da tabela directories definido pelo campo directory_id
*
*@param UserDirectory 
*/
	function getDirectory($directory){
		$strsql = "SELECT * FROM directories WHERE user_id = '".$directory->getUser_id()."' and directory_id = ".$directory->getDirectory_id()." and offline = 0";

		$result = $this->_db->databaseQuery($strsql);
		$directoryItem = array();
		for($i = 0; $i < count($result); $i++)
		{
			$directory = new UserDirectory();
			$directory->setDirectory_id($result[$i]['directory_id']);
			$directory->setName($result[$i]['name']);
			$directory->setOffline($result[$i]['offline']);
			$directory->setUser_id($result[$i]['user_id']);
			array_push($directoryItem, $directory);
		}
		return $directoryItem;
	}

/**
*Retorna um array de objetos Shelf
*
*Lê a base de dados, e retorna um array de objetos Shelf
*@param Shelf shelf objeto shelf que contém o ID do usuário que se quer ter a shelf carregada
*@param integer from
*@param integer count
*
*@returns mixed Array de objetos Shelf
*/
	function getDirectoryList($directory){
//	function getDirectoryList($directory, $from=0, $count=-1){
		$strsql = "SELECT * FROM directories WHERE user_id = '".$directory->getUser_id()."' and offline = 0 order by name";

		$result = $this->_db->databaseQuery($strsql);
		$directoryList = array();
		for($i = 0; $i < count($result); $i++)
		{
			$directory = new UserDirectory();
			$directory->setDirectory_id($result[$i]['directory_id']);
			$directory->setName($result[$i]['name']);
			$directory->setOffline($result[$i]['offline']);
			$directory->setUser_id($result[$i]['user_id']);
			array_push($directoryList, $directory);
		}
		return $directoryList;
	}
/*
*Verifica se o Artigo já se encontra na shelf do usuário
*Verifica se o artigo já esta na shelf independente do status visible
*@returns boolean
*/
	function directoryExist($directory){
		$strsql = "SELECT * FROM directories WHERE name = '".$directory->getName()."' and user_id =".$directory->getUser_id();
		$result = $this->_db->databaseQuery($strsql);

		if(count($result) > 0){
			return true;
		}else{
			return false;
		}
	}

    function getTotalItens($directories){
		$strsql = "SELECT count(*) as total FROM directories WHERE offline = 0";
		$result = $this->_db->databaseQuery($strsql);
		return $result[0]['total'];
    }
	
	function updateDirectory($directory){
		$strsql = "UPDATE directories set name='".$directory->getName()."', user_id=".$directory->getUser_id()." WHERE directory_id=".$directory->getDirectory_id();
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}
}

?>
