<?php
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
/**
*Classe "prateleira" do usuário
*
*Encapsula as funcões CRUD em uma classe, assim temos "independencia" do Banco de dados
*a ser utilizado.
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

	require_once(dirname(__FILE__)."/../users/DBClass.php");
	require_once(dirname(__FILE__)."/Shelf.php");
	require_once(dirname(__FILE__)."/Article.php");

class ShelfDAO {

/**
* Construtor da Classe ArticleDAO
*/
	function ShelfDAO(){
		
		$this->_db = new DBClass();
	}

	function __construct(){
		$this->ShelfDAO();
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

	function sortClause($sort){
		switch ($sort){
			case "date":
				return "shelf_id desc";
			case "rate":
			default:
				return "rate desc";
		}
	}
/**
* Adiciona um artigo à prateleira
*
* @param Shelf $profile Objeto Prateleira do usuário
*
* Ele pega os dados que estão armazenados nos campos da classe e adiciona no Banco
*além de atualizar o campo ID do usuário
* @returns mixed $result O ID do usuário que foi inserIDo no banco de dados ou um array em casso de "erro" (login duplicado)
*/
	function AddArticleToShelf($shelf){

		if($shelf->getCitedStat()){
			$citedStat = $shelf->getCitedStat();
		}else{
			$citedStat = 0;
		}

		if($shelf->getAccessStat()){
			$accessStat = $shelf->getAccessStat();
		}else{
			$accessStat = 0;
		}
		

		$strsql = "INSERT INTO
							user_shelf
								(user_id,
								PID,
								cited_stat,
								access_stat,
								insert_date,
								visible)
							VALUES (
								'".$this->sqlText($shelf->getUserID())."',
								'".$this->sqlText($shelf->getPID())."',
								'".$this->sqlBool($citedStat)."',
								'".$this->sqlBool($accessStat)."',
								'".date('Y-m-d H:i:s')."',
								'".$this->sqlBool($shelf->getVisible())."')";

		$result = $this->_db->databaseExecInsert($strsql);
		return $result;
	}

/**
* Altera os dados do perfil do usuário no Banco de Dados
*
* Ele pega os dados que estão armazenados nos campos da classe e adiciona no Banco
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function UpdateArticleInShelf($shelf){
		$fields = array();
		
		if(($shelf->getCitedStat() === 0) || ($shelf->getCitedStat() === 1))
		{
			$fields[] = "cited_stat = '".$this->sqlBool($shelf->getCitedStat())."'";
		}

		if(($shelf->getAccessStat() ===0) || ($shelf->getAccessStat() ===1)){
			$fields[] = "access_stat = '".$this->sqlBool($shelf->getAccessStat())."'";
		}

		if(($shelf->getVisible() === 0) || ($shelf->getVisible() === 1)){
			$fields[] = "visible = '".$this->sqlBool($shelf->getVisible())."'";	
		}

		if(count($fields) == 0){
			return 0;
		}

		$strsql = "UPDATE user_shelf SET ".implode(", ", $fields);
		$strsql .= " WHERE user_id = '".$this->sqlText($shelf->getUserID())."' AND PID = '".$this->sqlText($shelf->getPID())."'";

		$result = $this->_db->databaseExecUpdate($strsql);

		return $result;
	}
	
	function UpdateArticleRate($shelf){
		$strsql = "Update user_shelf SET rate=".$this->sqlInt($shelf->getRate())." WHERE shelf_id=".$this->sqlInt($shelf->getShelf_id());
		
		$result = $this->_db->databaseExecUpdate($strsql);
	}

/**
* Remove um registro da prateleira
*
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function removeArticleFromShelf($shelf){
		$strsql = "DELETE FROM user_shelf WHERE user_id = '".$this->sqlText($shelf->getUserID())."' AND pid = '".$this->sqlText($shelf->getPID())."'";
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}


/**
*Retorna um objeto  
*
*Lê a base de dados, e retorna um array de objetos Shelf
*@param Shelf shelf objeto shelf que contém o ID do usuário que se quer ter a shelf carregada
*@returns Shelf shelf um objeto shelf atualizado
*/
	function getShelfItem($shelf){
		$strsql = "SELECT * FROM user_shelf, articles WHERE user_id = '".$this->sqlText($shelf->getUserID())."' and articles.pid = '".$this->sqlText($shelf->getPID())."' and user_shelf.pid = articles.pid";

		$result = $this->_db->databaseQuery($strsql);
		$shelf = new Shelf();
		$article = new Article();

		$article->setPID($result[0]['PID']);
		$article->setURL($result[0]['url']);
		$article->setTitle($result[0]['title']);
		$article->setSerial($result[0]['serial']);
		$article->setVolume($result[0]['volume']);
		$article->setNumber($result[0]['number']);
		$article->setSuppl($result[0]['suppl']);
		$article->setYear($result[0]['year']);
		$article->setAuthorXML($result[0]['authors_xml']);
		$article->setKeywordXML($result[0]['keywords_xml']);

		$shelf->setPID($result[0]['PID']);
		$shelf->setCitedStat($result[0]['cited_stat']);
		$shelf->setAccessStat($result[0]['access_stat']);
		$shelf->setUserID($result[0]['user_id']);
		$shelf->setVisible($result[0]['visible']);
		$shelf->setRate($result[0]['rate']);
		$shelf->setDirectory($result[0]['directory']);		
		$shelf->setArticle($article);
		return $shelf;	
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
	function getListShelf($shelf, $from=0, $count=-1,$params){
		$filter = "";
		$filterTb = "";
		$directory_id = $shelf->getDirectory();
		if (  isset($directory_id)   ){
			if ($directory_id == 0){
				$filter = " and user_shelf.directory_id=".$this->sqlInt($directory_id);			
			}else{
				$filterTb = ", directories";
				$filter = " and user_shelf.directory_id=directories.directory_id  and user_shelf.directory_id=".$this->sqlInt($directory_id);
			}
		}
		
		$sort = $this->sortClause(isset($params["sort"]) ? $params["sort"] : "");
		$strsql = "SELECT * FROM user_shelf, articles".$filterTb." WHERE user_shelf.user_id = '".$this->sqlText($shelf->getUserID())."' and user_shelf.pid = articles.pid and user_shelf.visible = 1 ".$filter." order by user_shelf.".$sort;

        if($count > 0){
		    $strsql .= " LIMIT ".$this->sqlInt($from).",".$this->sqlInt($count);
		}
		$result = $this->_db->databaseQuery($strsql);
		$shelfList = array();
		for($i = 0; $i < count($result); $i++)
		{
			$shelf = new Shelf();
			$article = new Article();
			$article->setPID($result[$i]['PID']);
			$article->setURL($result[$i]['url']);
			$article->setTitle($result[$i]['title']);
			$article->setSerial($result[$i]['serial']);
			$article->setVolume($result[$i]['volume']);
			$article->setNumber($result[$i]['number']);
			$article->setSuppl($result[$i]['suppl']);
			$article->setYear($result[$i]['year']);
			$article->setAuthorXML($result[$i]['authors_xml']);
			$article->setKeywordXML($result[$i]['keywords_xml']);
			
			$shelf->setShelf_id($result[$i]['shelf_id']);
			$shelf->setPID($result[$i]['PID']);
			$shelf->setCitedStat($result[$i]['cited_stat']);
			$shelf->setAccessStat($result[$i]['access_stat']);
			$shelf->setUserID($result[$i]['user_id']);
			$shelf->setVisible($result[$i]['visible']);
			$shelf->setRate($result[$i]['rate']);
			$shelf->setDirectory($result[$i]['directory_id']);
			$shelf->setArticle($article);
			array_push($shelfList, $shelf);
		}
		return $shelfList;
	}
/*
*Verifica se o Artigo já se encontra na shelf do usuário
*Verifica se o artigo já esta na shelf independente do status visible
*@returns boolean
*/
	function isInShelf($shelf){
		$strsql = "SELECT * FROM user_shelf WHERE user_id = '".$this->sqlText($shelf->getUserID())."' and pid ='".$this->sqlText($shelf->getPID())."'";

		$result = $this->_db->databaseQuery($strsql);

		if(count($result) > 0){
			return true;
		}else{
			return false;
		}
	}

/*
*Verifica se o Artigo possuí alertas cadastrados
*@returns boolean
*/
	function hasAlerts($shelf){
		$strsql = "SELECT * FROM user_shelf WHERE user_id = '".$this->sqlText($shelf->getUserID())."' and pid ='".$this->sqlText($shelf->getPID())."'";

		$result = $this->_db->databaseQuery($strsql);

		if(count($result) > 0){
			return true;
		}else{
			return false;
		}

		if(($result[0]['cited_stat'] == 1) || ($result[0]['access_stat'] == 1) )
		{
			return true;
		}else{
			return false;
		}

	}

/**
*Retorna um array de objetos Shelf
*Lê a base de dados, e retorna um array de objetos Shelf dos artigos marcados para alerta de citação
*@param Shelf shelf objeto shelf que contém o ID do usuário que se quer ter a shelf carregada
*@returns mixed Array de objetos Shelf
*/
	function getCitedAlertList($shelf){
		$strsql = "SELECT * FROM user_shelf, articles WHERE user_id = '".$this->sqlText($shelf->getUserID())."' and user_shelf.pid = articles.pid and user_shelf.cited_stat = 1";
		$result = $this->_db->databaseQuery($strsql);
		$shelfList = array();

		for($i = 0; $i < count($result); $i++)
		{
			$shelf = new Shelf();
			$article = new Article();

			$article->setPID($result[$i]['PID']);
			$article->setURL($result[$i]['url']);
			$article->setTitle($result[$i]['title']);
			$article->setSerial($result[$i]['serial']);
			$article->setVolume($result[$i]['volume']);
			$article->setNumber($result[$i]['number']);
			$article->setSuppl($result[$i]['suppl']);
			$article->setYear($result[$i]['year']);
			$article->setAuthorXML($result[$i]['authors_xml']);
			$article->setKeywordXML($result[$i]['keywords_xml']);

			$shelf->setPID($result[$i]['PID']);
			$shelf->setCitedStat($result[$i]['cited_stat']);
			$shelf->setAccessStat($result[$i]['access_stat']);
			$shelf->setUserID($result[$i]['user_id']);
			$shelf->setVisible($result[$i]['visible']);
			$shelf->setArticle($article);

			array_push($shelfList, $shelf);
		}
		return $shelfList;
	}

/**
*Retorna um array de objetos Shelf
*Lê a base de dados, e retorna um array de objetos Shelf dos artigos marcados para alerta de acesso
*@param Shelf shelf objeto shelf que contém o ID do usuário que se quer ter a shelf carregada
*@returns mixed Array de objetos Shelf
*/
	function getAccessedAlertList($shelf){
		$strsql = "SELECT * FROM user_shelf, articles WHERE user_id = '".$this->sqlText($shelf->getUserID())."' and user_shelf.pid = articles.pid and user_shelf.access_stat = 1";
		$result = $this->_db->databaseQuery($strsql);
		$shelfList = array();

		for($i = 0; $i < count($result); $i++)
		{
			$shelf = new Shelf();
			$article = new Article();

			$article->setPID($result[$i]['PID']);
			$article->setURL($result[$i]['url']);
			$article->setTitle($result[$i]['title']);
			$article->setSerial($result[$i]['serial']);
			$article->setVolume($result[$i]['volume']);
			$article->setNumber($result[$i]['number']);
			$article->setSuppl($result[$i]['suppl']);
			$article->setYear($result[$i]['year']);
			$article->setAuthorXML($result[$i]['authors_xml']);
			$article->setKeywordXML($result[$i]['keywords_xml']);

			$shelf->setPID($result[$i]['PID']);
			$shelf->setCitedStat($result[$i]['cited_stat']);
			$shelf->setAccessStat($result[$i]['access_stat']);
			$shelf->setUserID($result[$i]['user_id']);
			$shelf->setVisible($result[$i]['visible']);
			$shelf->setArticle($article);

			array_push($shelfList, $shelf);
		}
		return $shelfList;
	}


        function getTotalItens($shelf){
			$filter = "";
			$directory_id = $shelf->getDirectory();
			if (  isset($directory_id)    ){
				$filter = " and directory_id=".$this->sqlInt($directory_id);
			}
			$strsql = "SELECT count(*) as total FROM user_shelf WHERE user_id = '".$this->sqlText($shelf->getUserID())."' AND visible = 1 ".$filter ;
			$result = $this->_db->databaseQuery($strsql);
			return $result[0]['total'];
        }
		
		function updateShelfDirectory($shelf){
			$strsql = "Update user_shelf SET directory_id=".$this->sqlInt($shelf->getDirectory())." WHERE user_id = '".$this->sqlText($shelf->getUserID())."' and shelf_id=".$this->sqlInt($shelf->getShelf_id());
			$result = $this->_db->databaseExecUpdate($strsql);
		}
		
		function moveAllToAnotherDirectory($shelf,$removeDir){
			$strsql = "Update user_shelf SET directory_id=".$this->sqlInt($shelf->getDirectory())." WHERE user_id = '".$this->sqlText($shelf->getUserID())."' and directory_id=".$this->sqlInt($removeDir);
			$result = $this->_db->databaseExecUpdate($strsql);
		}
		
	function deleteAllOfDirectory($shelf,$removeDir){
		$strsql = "DELETE FROM user_shelf WHERE user_id = '".$this->sqlText($shelf->getUserID())."' AND directory_id = ".$this->sqlInt($removeDir);
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}
}

?>
