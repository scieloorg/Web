<?php
/**
*@package	    Scielo.org
*@version       1.0
*@author        André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
/**
*Classe de Usuários do Scielo regional
*
*Encapsula as funcões CRUD em uma classe, assim temos "independencia" do Banco de dados
*a ser utilizado.
*Guarda além das informações básicas do usuário as informções sobre o perfil do usuário (as
*palavras-chave que ele irá entrar no cadastro que irá determinar o seu perfil através de trigramas
*@package	    Scielo.org
*@version       1.0
*@author        André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
require_once(dirname(__FILE__)."/../users/DBClass.php");
require_once(dirname(__FILE__)."/Article.php");
require_once(dirname(__FILE__)."/AccessArticle.php");

class ArticleDAO {

/**
* Construtor da Classe ArticleDAO
*/
	function ArticleDAO(){

//	$fileDef = parse_ini_file(dirname(__FILE__)."/../../../scielo.def.php");
//		$DBparams["password"] = $fileDef["DB_USER_SCIELO_PASSWORD"];
//		$DBparams["db"] = $fileDef["DB_SCIELO"];
//		$DBparams["user"] = $fileDef["DB_USER_SCIELO"];
//		$DBparams["host"] = $fileDef["DB_HOST_SCIELO"];
//		$this->_db = new DBClass($DBparams);
		$this->_db = new DBClass();

	}

	function __construct(){
		$this->ArticleDAO();
	}

	function sqlText($value){
		return mysql_real_escape_string((string)$value);
	}

	function sqlXml($value){
		return $this->sqlText(str_replace("'","&apos;",$value));
	}

	function sqlInt($value){
		return intval($value);
	}



/**
* Adiciona um artigo à base
*
* @param Article $article Objeto Artigo
*
* Ele pega os dados que estão armazenados nos campos da classe e adiciona no Banco
* @returns mixed $result
*/
	function AddArticle($article){
		$strsql = "INSERT INTO scieloorgusers.articles (
		PID, 
		url,
		title, 
		serial, 
		volume, 
		number, 
		suppl, 
		year, 
		authors_xml, 
		keywords_xml,
		abstract_xml,
		process_date,
		publication_date,
		wp_post_id,
		wp_url,
		wp_post_date
		) 
		VALUES ('".$this->sqlText($article->getPID())."','"
		.$this->sqlText($article->getURL())."','"
		.$this->sqlXml($article->getTitle())."','"
		.$this->sqlText($article->getSerial())."','"
		.$this->sqlText($article->getVolume())."','"
		.$this->sqlText($article->getNumber())."','"
		.$this->sqlText($article->getSuppl())."','"
		.$this->sqlText($article->getYear())."','"
		.$this->sqlXml($article->getAuthorXML())."','"
		.$this->sqlXml($article->getKeywordXML())."','"
		.$this->sqlXml($article->getAbstractXML())."','"
		.date('Y-m-d H:i:s')."','"
		.$this->sqlText(formatDate($article->getPublicationDate()))."',"
		.$this->sqlInt($article->getWpPostID()).",'"
		.$this->sqlText($article->getWpURL())."','"
		.$this->sqlText($article->getWpPostDate())."'"
		.")";
		$result = $this->_db->databaseExecInsert($strsql);
		return $result;
	}

/**
* Altera os dados do perfil do usuário no Banco de Dados
*
* Ele pega os dados que estão armazenados nos campos da classe e adiciona no Banco
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function UpdateArticle($article){
	
		$strsql = "UPDATE scieloorgusers.articles SET
						title = '".$this->sqlXml($article->getTitle())."',
						serial = '".$this->sqlText($article->getSerial())."',
						volume = '".$this->sqlText($article->getVolume())."',
						number = '".$this->sqlText($article->getNumber())."',
						suppl = '".$this->sqlText($article->getSuppl())."',
						year = '".$this->sqlText($article->getYear())."',
						authors_xml = '".$this->sqlXml($article->getAuthorXML())."',
						keywords_xml = '".$this->sqlXml($article->getKeywordXML())."',
						abstract_xml = '".$this->sqlXml($article->getAbstractXML())."',
						publication_date = '".$this->sqlText(formatDate($article->getPublicationDate()))."'
					WHERE PID = '".$this->sqlText($article->getPID())."'";

		$result = $this->_db->databaseExecUpdate($strsql);

		return $result;
	}

/**
* Função que atualiza apenas os campos wp_post_id e o campo wp_url para comentários
*  
*/
	function updatePosts($article){
	
		$strsql = "UPDATE scieloorgusers.articles SET
						wp_post_id = ".$this->sqlInt($article->getWpPostID()).",
						wp_url = '".$this->sqlText($article->getWpURL())."',
						wp_post_date = '".$this->sqlText($article->getWpPostDate())."' 
					WHERE PID = '".$this->sqlText($article->getPID())."'";

		$result = $this->_db->databaseExecUpdate($strsql);

		return $result;
	}

/**
* Consulta os dados dos perfis de um usuário no Banco de Dados
*
* @param $userId id do usuário
* 
* @returns array of UserProfile 
*/
	function getArticle($PID){
		$strsql = "SELECT * FROM  scieloorgusers.articles WHERE articles.PID = '".$this->sqlText($PID)."'";
		
		$arr = $this->_db->databaseQuery($strsql);
		$article = $this->loadArticle($arr[0]);
		return $article;
	}


/**
* Consulta os dados dos perfis de um usuário no Banco de Dados
*
* @param $userId id do usuário
* 
* @returns array of UserProfile 
*/
	function getPostDate($PID){
		$strsql = "SELECT wp_post_date FROM  scieloorgusers.articles WHERE articles.PID = '".$this->sqlText($PID)."'";
		//die($strsql);
		$arr = $this->_db->databaseQuery($strsql);
		$postDate = $arr[0]["wp_post_date"];
		//die($postDate);
		return $postDate;
	}


/**
* Consulta os se o PID existe no Banco de Dados
*
* @returns array of true/false 
*/
	function getArticleByPID($PID){
		$strsql = "SELECT PID FROM  scieloorgusers.articles WHERE articles.PID = '".$this->sqlText($PID)."'";
		$arr = $this->_db->databaseQuery($strsql);
		if(isset($arr[0])){
		return true;
		}
		return false;
	}

	/**
* Consulta os se o pw_post_id existe no Banco de Dados
*
* @returns array of true/false 
*/
	function getWpPostByID($PID){
		$strsql = "SELECT wp_post_id FROM  scieloorgusers.articles WHERE articles.PID = '".$this->sqlText($PID)."'";
		$arr = $this->_db->databaseQuery($strsql);
		if($arr[0]["wp_post_id"]!= 0){
		return true;
		}
		return false;
	}
	/**
* Consulta os se o pw_post_id existe no Banco de Dados
*
* @returns array of value 
*/
	function getWpPostByIDValue($PID){
		$strsql = "SELECT wp_post_id FROM  scieloorgusers.articles WHERE articles.PID = '".$this->sqlText($PID)."'";
		$arr = $this->_db->databaseQuery($strsql);
		if($arr[0]["wp_post_id"]!= 0){
		return $arr[0]["wp_post_id"];
		}
		return $arr[0]["wp_post_id"];
	}

/**
* Carrega nos campos da classe os valores que estão armazenados no Banco de Dados
* chamada pela getArticle para devolver o objeto artigo para a classe Article
* @param integer $ID IDentificador do usuário
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function loadArticle($p){
		$article = new Article();
		$article->setPID($p['PID']);
		$article->setTitle($p['title']);
		$article->setSerial($p['serial']);
		$article->setVolume($p['volume']);
		$article->setNumber($p['number']);
		$article->setSuppl($p['suppl']);
		$article->setYear($p['year']);
		$article->setUrl($p['url']);
		$article->setAuthorXML($p['authors_xml']);
		$article->setKeywordXML($p['keywords_xml']);
		$article->setAbstractXML($p['abstract_xml']);
		$article->setWpPostID($p['wp_post_id']);
		$article->setWpURL($p['wp_url']);
		return $article;
	}

	function getCitedList($article_obj){
		$strsql = "select pid_cited from scieloorgusers.cited where pid='".$this->sqlText($article_obj->getPID())."'";
		$result = $this->_db->databaseQuery($strsql);
		$citedList = array();
		for($i = 0; $i < count($result); $i++)
		{
			$article = $this->getArticle($result[$i]['pid_cited']);
			array_push($citedList, $article);
		}
		return $citedList;
	}

	function getAccessStatistics($article_obj){
		$strsql = "select * from scieloorgusers.access_stat where pid='".$this->sqlText($article_obj->getPID())."'";
		$result = $this->_db->databaseQuery($strsql);
		$accessStatisticsList = array();
		//die("total".count($result));
		for($i = 0; $i < count($result); $i++)
		{
			$access_article = new AccessArticle();
			$access_article->setPID($result[$i]['PID']);
			$access_article->setDate($result[$i]['date']);
			$access_article->setCount($result[$i]['count']);
			array_push($accessStatisticsList, $access_article);
		}
		return $accessStatisticsList;
	}

}
function formatDate($date){

	/*$a = substr($date,0,4);
	$m = substr($date,4,2);
	$d = substr($date,6,2);
	$x = $a.'-'.$m.'-'.$d.' 00:00:00';
	*/
	return $date;
}
?>
