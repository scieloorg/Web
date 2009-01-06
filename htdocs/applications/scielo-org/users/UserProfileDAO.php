<?php
$dir = dirname(__FILE__)."/";

require_once($dir."DBClass.php");
require_once($dir."UserProfileClass.php");

/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

/**
*Classe de Usuários do Scielo regional
*
*Encapsula as funcões CRUD em uma classe, assim temos "independencia" do Banco de dados
*a ser utilizado.
*Guarda além das informações básicas do usuário as informções sobre o perfil do usuário (as
*palavras-chave que ele irá entrar no cadastro que irá determinar o seu perfil através de trigramas
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
class UserProfileDAO {

/**
* Construtor da Classe UserProfileDAO
*/
	function UserProfileDAO(){
		
		$this->_db = new DBClass();
	}



/**
* Adiciona um perfil de usuário no Banco de Dados
*
* @param UserProfileClass $profile Objeto Perfil do usuário
*
* Ele pega os dados que estão armazenados nos campos da classe e adiciona no Banco
*além de atualizar o campo ID do usuário
* @returns mixed $result O ID do usuário que foi inserIDo no banco de dados ou um array em casso de "erro" (login duplicado)
*/
	function AddUserProfile($profile){

		$strsql = "INSERT INTO profiles (
		user_id, 
		profile_text, 
		profile_name,
		profile_status,
		creation_date,
		id_grande_area,
		id_sub_area)
		VALUES ('".$profile->getUserID()."','"
		.$profile->getProfileText()."','"
		.$profile->getProfileName()."','on','"
		.date("Y-m-d H:i:s")."',
		'".$profile->getGrandeAreaID()."',
		'".$profile->getSubAreaID()."')";
		$result = $this->_db->databaseExecInsert($strsql);

		return $result;
	}

/**
* Altera os dados do perfil do usuário no Banco de Dados
*
* Ele pega os dados que estão armazenados nos campos da classe e adiciona no Banco
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function UpdateUserProfile($profile){

	if($profile->getProfileID()){
		$strsql = "UPDATE profiles SET 	
		profile_text  = '".$profile->getProfileText()."', 
		profile_name  = '".$profile->getProfileName()."',   
		profile_status  = '".$profile->getProfileStatus()."',
		id_grande_area  = '".$profile->getGrandeAreaID()."',
		id_sub_area = '".$profile->getSubAreaID()."'
		WHERE user_id = '".$profile->getUserID()."' AND
		profile_id = '".$profile->getProfileID()."' ";
		$result = $this->_db->databaseExecUpdate($strsql);
		return $result;
	}else{
		return $this->AddUserProfile($profile);
	}

	}

/**
* Consulta os dados dos perfis de um usuário no Banco de Dados
*
* @param $userId id do usuário
* 
* @returns array of UserProfile 
*/
	function getUserProfiles($userId){
		$strsql = "SELECT * FROM  profiles WHERE user_id = '".$userId."'";
		
		$arr = $this->_db->databaseQuery($strsql);
		foreach($arr  as $p)
		{
			$profiles[] = $this->loadUserProfile($p);
		}
		return $profiles;
	}

/**
* Consulta os dados dos perfis de um usuário no Banco de Dados
*
* @param $userId id do usuário
* 
* @returns array of UserProfile 
*/
	function getUserProfilesStatusOn($userId){
		$strsql = "SELECT * FROM  profiles WHERE user_id = '".$userId."' and profile_status='on'";
//		die($strsql);
		$arr = $this->_db->databaseQuery($strsql);
		foreach($arr  as $p)
		{
			$profiles[] = $this->loadUserProfile($p);
		}
		return $profiles;
	}

/**
* Carrega nos campos da classe os valores que estão armazenados no Banco de Dados
* @param integer $ID IDentificador do usuário
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function loadUserProfile($p){
		$profile = new UserProfileClass();
		$profile->setUserID($p['user_id']);
		$profile->setProfileID($p['profile_id']);
		$profile->setProfileText($p['profile_text']);
		$profile->setProfileName($p['profile_name']);
		$profile->setProfileStatus($p['profile_status']);
		$profile->setCreationDate($p['creation_date']);
		$profile->setGrandeAreaID($p['id_grande_area']);
		$profile->setSubAreaID($p['id_sub_area']);

		return $profile;
	}


}

?>
