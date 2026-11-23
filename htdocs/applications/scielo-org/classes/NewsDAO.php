<?php
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
/**
*Noticias do Usúario
*
*Encapsula as funcões CRUD em uma classe, assim temos "independencia" do Banco de dados a ser utilizado.
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

	require_once(dirname(__FILE__)."/../users/DBClass.php");
	require_once(dirname(__FILE__)."/News.php");

class NewsDAO {


	function NewsDAO(){
		
		$this->_db = new DBClass();
	}

	function __construct(){
		$this->NewsDAO();
	}

	function sqlText($value){
		return mysql_real_escape_string((string)$value);
	}

	function sqlInt($value){
		return intval($value);
	}

	function sqlBool($value){
		return $value ? 1 : 0;
	}

	function addNews($news){

		$strsql = "INSERT INTO
							user_news
								(user_id,
									rss_url,
									in_home)
							VALUES (
								'".$this->sqlText($news->getUserID())."',
								'".$this->sqlText($news->getRSSURL())."',
								'".$this->sqlBool($news->getInHome())."')";

		$result = $this->_db->databaseExecInsert($strsql);
		return $result;
	}

	function updateNews($news){

		$fields = array();

		if($news->getUserID() != '')
			$fields[] = "user_id = '".$this->sqlText($news->getUserID())."'";

		if($news->getRSSURL() != '')
			$fields[] = "rss_url = '".$this->sqlText($news->getRSSURL())."'";

		if($news->getInHome() != '')
			$fields[] = "in_home = '".$this->sqlBool($news->getInHome())."'";

		if(count($fields) == 0){
			return 0;
		}

		$strsql = "UPDATE user_news SET ".implode(", ", $fields);
		$strsql .= " WHERE news_id = ".$this->sqlInt($news->getID())." ";

		return $this->_db->databaseExecUpdate($strsql);
	}
	

	function removeNews($news){
		$strsql = "DELETE FROM user_news WHERE user_id = '".$this->sqlText($news->getUserID())."' AND news_id = ".$this->sqlInt($news->getID());
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}

/**
*Retorna um array de objetos News
*
*Lê a base de dados, e retorna um array de objetos News
*@param News news objeto news que contém o ID do usuário que se quer as news carregadas
*@param integer from
*@param integer count
*
*@returns mixed Array de objetos news
*/
	function getNewsList($news, $from=0, $count=-1){
		$filter = "";
		$filterTb = "";
		$where = "";
/*
		$directory_id = $news->getDirectory();
		if (  isset($directory_id)   ){
			if ($directory_id == 0){
				$filter = " and user_news.directory_id=".$directory_id;			
			}else{
				$filterTb = ", directories";
				$filter = " and user_news.directory_id=directories.directory_id  and user_news.directory_id=".$directory_id;
			}
		}
*/
		if($news->getID() != ''){
			$where = " and user_news.news_id = " .$this->sqlInt($news->getID());
		}

		$strsql = "SELECT * FROM user_news ".$filterTb." WHERE user_news.user_id = '".$this->sqlText($news->getUserID())."' ".$filter.$where;

        if($count > 0){
		    $strsql .= " LIMIT ".$this->sqlInt($from).",".$this->sqlInt($count);
		}

		$result = $this->_db->databaseQuery($strsql);
		$newsList = array();
		
		for($i = 0; $i < count($result); $i++)
		{
			$news = new News();
	
			$news->setID($result[$i]['news_id']);
			$news->setRSSURL($result[$i]['rss_url']);
			$news->setInHome($result[$i]['in_home']);
			$news->setUserID($result[$i]['user_id']);

			array_push($newsList, $news);
		}
		return $newsList;
	}


	function getRssInHome($news){
		$strsql = "SELECT * FROM user_news WHERE user_news.user_id = '".$this->sqlText($news->getUserID())."' and user_news.in_home = 1";

		$result = $this->_db->databaseQuery($strsql);

		$news = new News();
		$news->setID($result[0]['news_id']);
		$news->setRSSURL($result[0]['rss_url']);
		$news->setInHome($result[0]['in_home']);
		$news->setUserID($result[0]['user_id']);

		return $news;
	}

        function getTotalItens($news){
			$filter = "";
		/*
			$directory_id = $news->getDirectory();
			if (  isset($directory_id)    )
				$filter = " and directory_id=".$directory_id;
		*/
			$strsql = "SELECT count(*) as total FROM user_news WHERE user_id = '".$this->sqlText($news->getUserID())."'".$filter ;
			$result = $this->_db->databaseQuery($strsql);
			return $result[0]['total'];
		}
		
		function updateNewsDirectory($news){
			$strsql = "Update user_news SET directory_id=".$this->sqlInt($news->getDirectory())." WHERE news_id=".$this->sqlInt($news->getnews_id());
			$result = $this->_db->databaseExecUpdate($strsql);
		}


		function showInHome($news){
			$strsql = "Update user_news SET in_home = 0 where user_id = '".$this->sqlText($news->getUserID())."'";
			$this->_db->databaseExecUpdate($strsql);
			$strsql = "Update user_news SET in_home = 1 where news_id = ".$this->sqlInt($news->getID());
			$this->_db->databaseExecUpdate($strsql);
		}
}

?>
