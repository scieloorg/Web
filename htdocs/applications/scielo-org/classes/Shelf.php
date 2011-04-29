<?php 
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
/**
*Prateleira do usuário
*
*Guarda informações sobre a prateleira do usuário
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

	require_once(dirname(__FILE__).'/ShelfDAO.php');
	require_once(dirname(__FILE__).'/Article.php');
/**
*	Quantos itens aparecerão na tela!?
*/

	define("PAGE_SIZE",3);

	class Shelf {
	
		function Shelf(){
		}
		
		function setRate($rate){
			$this->_data['rate'] = $rate;
		}

		function getRate(){
			return $this->_data['rate'];
		}

		
		function setDirectory($data){
			$this->_data['directory'] = $data;
		}

		function getDirectory(){
			return $this->_data['directory'];
		}
		
		function setShelf_id($shelf_id){
			$this->_data['shelf_id'] = $shelf_id;
		}

		function getShelf_id(){
			return $this->_data['shelf_id'];
		}
		
		function setArticle($article){
			$this->_data['article'] = $article;
		}

		function getArticle(){
			return $this->_data['article'];
		}

		function setPID($value){
			$this->_data['pid'] = $value;
		}
		
		function getPID(){
			return $this->_data['pid'];
		}
		
		function setUserID($value){
			$this->_data['userID'] = $value;
		}

		function getUserID(){
			return $this->_data['userID'];
		}
		
		function setCitedStat($value){
			$this->_data['cited_stat'] = $value;
		}
		
		function getCitedStat(){
			return $this->_data['cited_stat'];
		}

		function setAccessStat($value){
			$this->_data['access_stat'] = $value;
		}
		
		function getAccessStat(){
			return $this->_data['access_stat'];
		}

		function setVisible($value){
			$this->_data['visible'] = $value;
		}
		function getVisible(){
			return $this->_data['visible'];
		}

		function getListShelf($page,$params){
			$shelfDAO = new ShelfDAO();
			$count = PAGE_SIZE;
			$from = $count * $page;
			return $shelfDAO->getListShelf($this,$from,$count,$params);
		}

		function isInShelf(){
			$shelfDAO = new ShelfDAO();
			$result = $shelfDAO->isInShelf($this);
			return $result;
		}

		function hasAlerts(){
			$shelfDAO = new ShelfDAO();
			$result = $shelfDAO->hasAlerts($this);
			return $result;
		}
		
		function addArticleToShelf(){
			$shelfDAO = new ShelfDAO();
			if(!$this->isInShelf())
				$shelfDAO->AddArticleToShelf($this);
		}

		function updateArticleInShelf(){
			$shelfDAO = new ShelfDAO();
			$result = $shelfDAO->UpdateArticleInShelf($this);
			return $result;
		}
		
		function updateArticleRate(){
			$shelfDAO = new ShelfDAO();
			$result = $shelfDAO->UpdateArticleRate($this);
			return $result;
		}

		function removeArticleFromShelf(){
			$shelfDAO = new ShelfDAO();
			$shelfDAO->removeArticleFromShelf($this);
		}
/**
retorna uma lista dos artigos marcados para alerta de Citação
*/
		function getCitedAlertList(){
			$shelfDAO = new ShelfDAO();
			return $shelfDAO->getCitedAlertList($this);
		}
/**
retorna uma lista dos artigos marcados para alerta de acesso
*/
		function getAccessedAlertList(){
			$shelfDAO = new ShelfDAO();
			return $shelfDAO->getAccessedAlertList($this);
		}
/**
*Atualiza os campos do objeto shelf com os dados que estao gravados no banco
@returns void essa função altera os campos do objeto Shelf que a chamou, atualizando os valores dos seus campos
*/
		function getShelfItem(){
			$shelfDAO = new ShelfDAO();
			$tmp = $shelfDAO->getShelfItem($this);

			$this->setShelf_id($tmp->getShelf_id());
			$this->setRate($tmp->getRate());
			$this->setDirectory($tmp->getDirectory());
			$this->setPID($tmp->getPID());
			$this->setCitedStat($tmp->getCitedStat());
			$this->setAccessStat($tmp->getAccessStat());
			$this->setUserID($tmp->getUserID());
			$this->setVisible($tmp->getVisible());
			$this->setArticle($tmp->getArticle());
	        }

/**
*
*usamos ceil() pq ele aredonda PRA CIMA!!!!!
*/
		function getTotalPages($itensPerPage = PAGE_SIZE){
		    $shelfDAO = new ShelfDAO();
		    $total = $shelfDAO->getTotalItens($this);
		    return ceil ($total/$itensPerPage);
		}

		function getCount(){
		    $shelfDAO = new ShelfDAO();
		    return $shelfDAO->getTotalItens($this);
		}

		function updateShelfDirectory(){
		    $shelfDAO = new ShelfDAO();
		    return $shelfDAO->updateShelfDirectory($this);
		}
		
		function moveAllToAnotherDirectory($removeDir){
		    $shelfDAO = new ShelfDAO();
		    return $shelfDAO->moveAllToAnotherDirectory($this,$removeDir);
		}
		
		function deleteAllOfDirectory($removeDir){
		    $shelfDAO = new ShelfDAO();
		    return $shelfDAO->deleteAllOfDirectory($this,$removeDir);
		}

	}
?>
