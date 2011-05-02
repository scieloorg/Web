<?php 
/**
*@package	Scielo.org
*@version		1.0
*@author		André Otero(andre.otero@bireme.org)
*@copyright	BIREME
*/
/**
*	Minhas Noticias
*
*Guarda informações sobre os RSS's do usuário
*@package	Scielo.org
*@version		1.0
*@author		André Otero(andre.otero@bireme.org)
*@copyright	BIREME
*/
	require_once(dirname(__FILE__).'/NewsDAO.php');

/**
*	Quantos itens aparecerão na tela!?
* @const Integer
*/
	define("PAGE_SIZE",3);

	class News {
/**
* Primeiro nome do Usuário
* @var string
*/
		var $_user_id = "";
/**
* URL do RSS
* @var string
*/
		var $_rss_url = "";
/**
* Flag para a publicação no RSS na home
* @var boolean
*/
		var $_in_home = false;
/**
* Chave primária
* @var integer
*/
		var $_news_id = "";
		
		function News(){
		}
/**
*	Getters
*/
		function getID(){
			return $this->_news_id;
		}

		function getRSSURL(){
			return $this->_rss_url;
		}

		function getInHome(){
			return $this->_in_home;
		}

		function getUserID(){
			return $this->_user_id;
		}

/**
*	Setters
*/
		function setID($param){
			$this->_news_id = $param;
		}

		function setRSSURL($param){
			$this->_rss_url = $param;
		}

		function setInHome($param){
			$this->_in_home = $param;
		}

		function setUserID($param){
			$this->_user_id = $param;
		}

		function addNews(){
			$newsDAO = new NewsDAO();
			return $newsDAO->addNews($this);
		}

		function updateNews(){
			$NewsDAO = new NewsDAO();
			return $NewsDAO->updateNews($this);
		}
		
		function removeNews(){
			$NewsDAO = new NewsDAO();
			return $NewsDAO->removeNews($this);
		}

		function getNewsList(){
			$NewsDAO = new NewsDAO();
			return $NewsDAO->getNewsList($this);
		}

		function getRssInHome(){
			$NewsDAO = new NewsDAO();
			return $NewsDAO->getRssInHome($this);
		}


		function showInHome(){
			$NewsDAO = new NewsDAO();
			return $NewsDAO->showInHome($this);
		}
/**
*
*usamos ceil() pq ele aredonda PRA CIMA!!!!!
*/
		function getTotalPages($itensPerPage = PAGE_SIZE){
			$NewsDAO = new NewsDAO();
		    $total = $NewsDAO->getTotalItens($this);
		    return ceil ($total/$itensPerPage);
		}

	}
?>
