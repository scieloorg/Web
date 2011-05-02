<?php 
/*
*@package	Scielo.org
*@version      1.0
*@author       Marcelo Sanches(msanches@bireme.br)
*@copyright     BIREME

*Prateleira do usuário
*
*Guarda informações sobre a prateleira do usuário
*@package	Scielo.org
*@version      1.0
*@author       Marcelo Sanches(msanches@bireme.br)
*@copyright     BIREME

mysql -u scielo -pscielo scieloorgusers
senha: scielo
database: scieloorgusers
tabelas: users, profiles, profile_article, articles

*/
	require_once(dirname(__FILE__).'/MyProfileArticleDAO.php');
	require_once(dirname(__FILE__).'/Article.php');

	class MyProfileArticle {
	
		function MyProfileArticle(){
		}

		function setUserID($value){
			$this->_data['userID'] = $value;
		}

		function getUserID(){
			return $this->_data['userID'];
		}
		
		//function getListShelf(){
		//	$shelfDAO = new ArticleProfileDAO();
		//	return $shelfDAO->getListShelf($this);
		//}

		function getMyProfileArticleList(){
			$this->articleProfileDAO = new MyProfileArticleDAO();
			return $this->articleProfileDAO->getMyProfileArticleList($this);
		}

		function getMyProfiles()
		{
			//$articleProfileDAO = new MyProfileArticleDAO();
			return $this->articleProfileDAO->getMyProfiles();
		}
	}
?>
