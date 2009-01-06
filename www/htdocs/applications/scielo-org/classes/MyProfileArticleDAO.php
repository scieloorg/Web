<?php
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME

*Encapsula as funcões CRUD em uma classe, assim temos "independencia" do Banco de dados
*a ser utilizado.
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

	require_once(dirname(__FILE__)."/../users/DBClass.php");
	require_once(dirname(__FILE__)."/MyProfileArticle.php");
	require_once(dirname(__FILE__)."/Article.php");

class MyProfileArticleDAO {

/**
* Construtor da Classe MyProfileArticleDAO
*/
	function MyProfileArticleDAO()
	{
		$this->my_profiles = array();
		$this->_db = new DBClass();
	}

	function setMyProfiles($user_id)
	{
		$query_profiles = "SELECT profile_id, profile_name FROM profiles WHERE user_id = '".$user_id."' AND profile_status = 'on' ORDER BY profile_id";
        $profiles_result = $this->_db->databaseQuery($query_profiles);
		

		$this->my_profiles = $profiles_result;
	}

	function getMyProfiles()
	{
		return $this->my_profiles;
	}

	function getMyProfileArticleList($article_profile){
		// 1 - SELECT nos profiles do Usuarios
		// 2 - Pra cada Profile: pego a lista de artigos (olho na profiele_article
		// 3 - devolvo array de perfis com os artigos
		$this->setMyProfiles($article_profile->getUserID());
		$profiles_result = $this->getMyProfiles();
		//$articleProfileList[] = array();   
		for($p = 0; $p < count($profiles_result); $p++)
		{
			$profile_id = $profiles_result[$p]['profile_id'];
			$profile_name = $profiles_result[$p]['profile_name'];
			$articleProfileList[intval($profile_id)] = array();

			$order = $_GET['order'];

			switch($order)
			{
				case "date":
					$order_by = " ORDER BY articles.publication_date desc";
				    break;
				case "relevance":
					$order_by = " ORDER BY relevance desc";
				    break;
				default:
					$order_by = null;
			}
			$where_new = (isset($_GET['new'])?' and is_new=1':null);
			
			$strsql = "SELECT profile_article.*,articles.publication_date FROM profile_article,articles WHERE articles.PID = profile_article.PID and profile_id = '".$profile_id."'".$where_new." ".$order_by;

			$result = $this->_db->databaseQuery($strsql);
			for($i = 0; $i < count($result); $i++)
			{
				$relevance = $result[$i]['relevance'];
				$query_article = "SELECT * FROM articles WHERE PID = '".$result[$i]['PID']."' LIMIT 1";
				$article_result = $this->_db->databaseQuery($query_article);
				$articleProfile = new MyProfileArticle();
				$article = new Article();
				$article->setPID($article_result[0]['PID']);
				$article->setURL($article_result[0]['url']);
				$article->setTitle($article_result[0]['title']);
				$article->setSerial($article_result[0]['serial']);
				$article->setVolume($article_result[0]['volume']);
				$article->setNumber($article_result[0]['number']);
				$article->setSuppl($article_result[0]['suppl']);
				$article->setYear($article_result[0]['year']);
				$article->setAuthorXML($article_result[0]['authors_xml']);
				$article->setKeywordXML($article_result[0]['keywords_xml']);
				$article->setRelevance($relevance);
				$article->setPublicationDate($article_result[0]['publication_date']);

				array_push($articleProfileList[$profile_id], array($profile_name,$article));
				//die(var_dump($articleProfileList));
			}
		}

		//var_dump($articleProfileList);die;
		return $articleProfileList;
	}
}

?>
