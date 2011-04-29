<?php
	require_once(dirname(__FILE__)."/../users/DBClass.php");
	require_once(dirname(__FILE__)."/ProfileArticle.php");

/**
*@package	Scielo.org
*@version      1.0
*@author       Andr� Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

/**
*Classe de Usu�rios do Scielo regional
*
*Encapsula as func�es CRUD em uma classe, assim temos "independencia" do Banco de dados
*a ser utilizado.
*Guarda al�m das informa��es b�sicas do usu�rio as inform��es sobre o perfil do usu�rio (as
*palavras-chave que ele ir� entrar no cadastro que ir� determinar o seu perfil atrav�s de trigramas
*@package	Scielo.org
*@version      1.0
*@author       Andr� Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
class ProfileArticleDAO {


/**
* Construtor da Classe ArticleDAO
*/
	function ProfileArticleDAO(){
		
		$this->_db = new DBClass();
	}



/**
* Adiciona um perfil de usu�rio no Banco de Dados
*
* @param UserProfileClass $profile Objeto Perfil do usu�rio
*
* Ele pega os dados que est�o armazenados nos campos da classe e adiciona no Banco
*al�m de atualizar o campo ID do usu�rio
* @returns mixed $result O ID do usu�rio que foi inserIDo no banco de dados ou um array em casso de "erro" (login duplicado)
*/
	function AddProfileArticle($profile_article){

		$strsql = "INSERT INTO profile_article (
		PID, 
		profile_id, 
		process_date,
		relevance,
		is_new
		) 
		VALUES ('".$profile_article->getPID()."','".$profile_article->getProfileID()."','".date("Ymd")."','".$profile_article->getRelevance()."','1')";

		$result = $this->_db->databaseExecInsert($strsql);
//		die(var_dump($result));
		return $result;
	}

/**
* Altera os dados do perfil do usu�rio no Banco de Dados
*
* Ele pega os dados que est�o armazenados nos campos da classe e adiciona no Banco
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function UpdateProfileArticle($profile_article){
		$strsql = 'UPDATE profile_article SET 		
		process_date = "'.date("Y-m-d H:i:s").'",
		relevance = "'.$profile_article->getRelevance().'",
		is_new = "'.$profile_article->getIsNew().'"
		
		WHERE PID = "'.$profile_article->getPID().'" and profile_id = "'.$profile_article->getProfileID().'"';

		$result = $this->_db->databaseExecUpdate($strsql);

		return $result;
	}

/**
* Consulta os dados dos perfis de um usu�rio no Banco de Dados
*
* @param $userId id do usu�rio
* 
* @returns array of UserProfile 
*/
	function getProfileArticle($PID, $profileId){
		$strsql = "SELECT * FROM  profile_article WHERE PID = '".$PID."' and profile_id='".$profileId."'";
		$arr = $this->_db->databaseQuery($strsql);
		$profile_article = $this->load($arr[0]);
		return $profile_article;
	}

/**
* Carrega nos campos da classe os valores que est�o armazenados no Banco de Dados
* @param integer $ID IDentificador do usu�rio
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function load($p){
		$profile_article = new ProfileArticle();
		$profile_article->setPID($p['PID']);
		$profile_article->setProfileID($p['profile_id']);
		$profile_article->setPublicationDate($p['process_date']);
		$profile_article->setRelevance($p['relevance']);
		$profile_article->setIsNew($p['is_new']);
		return $profile_article;
	}

	function deleteRelationship($profileID){
		$strsql = "DELETE FROM profile_article WHERE profile_id='".$profileID."' and  is_new='3'"; 
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}

	function setAsDeleted($profileID){
		$strsql = 'UPDATE profile_article SET 		
		is_new = "3"		
		WHERE profile_id = "'.$profileID.'"';
		$result = $this->_db->databaseExecUpdate($strsql);

		return $result;
	}
}

?>
