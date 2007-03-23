<?php
$dir = dirname(__FILE__)."/";

include($dir."DBClass.php");
include($dir."UserProfileClass.php");
require($dir."../includes/phpmailer/class.phpmailer.php");

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
class UserClass {
/**
* Identificador do usuário
* @var integer
*/
	var $_id = 0;
/**
* Primeiro nome do Usuário
* @var string
*/
	var $_firstName = '';
/**
* Segundo nome do Usuário
* @var string
*/
	var $_lastName = '';
/**
* O sexo do usuário
* @var string
*/
	var $_gender = '';
/**
* O nome de Login do usuário (é único no sistema porém não é chave)
* @var string
*/
	var $_login = '';
/**
* Endereço de e-mail do usuário
* @var string
*/
	var $_email = '';
/**
* Senha do usuário, é gravado no bando o MD5 da senha do usuário e não a própria senha por essa razão é um char[32] pois o MD5 tem sempre o mesmo tamanho
* @var char[32]
*/
	var $_password  = '';

/**
* Os perfis que o usuário irá preencher no seu cadastro (do qual serão gerados trigramas para cada um)
* @var Object[] ProfileClass
*/
	var $_profiles  = array();

/**
* Referencia a classe mailer
* @var Object phpMailer classe de mailer
*/
	var $_mail  = null;

/**
* Construtor da Classe UserClass
*
* @param string $firstName Primeiro nome do Usuário
* @param string $lastName Segundo nome do Usuário
* @param string $login O nome de Login do usuário (é único no sistema porém não é chave)
* @param string $email  Endereço de e-mail do usuário
* @param char[32] $password senha do usuário, é gravado no bando o MD5 da senha do usuário e não a própria senha por essa razão é um char[32] pois o MD5 tem sempre o mesmo tamanho
*/
	function UserClass($firstName='', $lastName='', $gender='', $login='', $email='', $password=''){
		$this->_firstName = $firstName;
		$this->_lastName = $lastName;
		$this->_gender = $gender;
		$this->_login = $login;
		$this->_email = $email;
		$this->_db = new DBClass();
		$this->_mail = new PHPMailer();
		/*
		prevenindo gravar o Hash de null no banco
		*/
		if($password != ''){
			$this->_password = md5($password);
		}else{
			$this->_password = '';
		}
	}


/**
* "Zera" os campos da classe para que o loadUser os recarrege
*/
	function clearFields(){
		$this->_id = 0;
		$this->_firstName = '';
		$this->_lastName = '';
		$this->_gender = '';
		$this->_login = '';
		$this->_email = '';
		$this->_password  = '';
		$this->_profiles  = array();
	}

/**
* Atribuí um valor para o campo ID da classe
* @param integer $id Identificador do usuário
*/
	function setID($id){
		$this->_id = $id;
	}

/**
* Atribuí um valor para o campo firstName da classe
* @param string $firstName Primeiro nome do Usuário
*/
	function setFirstName($firstName){
		$this->_firstName = $firstName;
	}

/**
* Atribuí um valor para o campo lastName da classe
* @param string $lastName Segundo nome do Usuário
*/
	function setLastName($lastName){
		$this->_lastName = $lastName;
	}

/**
* Atribuí um valor para o campo gender da classe
* @param string $gender O sexo do usuário
*/
	function setgender($gender){
		$this->_gender = $gender;
	}


/**
* Atribuí um valor para o campo login da classe
* @param string $login O nome de Login do usuário (é único no sistema porém não é chave)
*/
	function setLogin($login){
		$this->_login = $login;
	}

/**
* Atribuí um valor para o campo email da classe
* @param string $email  Endereço de e-mail do usuário
*/
	function setEmail($email){
		$this->_email = $email;
	}

/**
* Adiciona um profile á instancia em memória da classe UserClass
* @param Object [] $ProfileClass Uma instancia do Objeto Profile
*/
	function setProfiles($profile, $name=''){
//se o argumento é uma string, significa que estamos criando o usuário ainda, logo, devemos criar um
//objeto UserProfileClass, setar os seus atributos e adicionar à lista de Perfis do Usuário
		if(is_string($profile)){
			$p = new UserProfileClass();
			$p->setUserID($this->getID());
			$p->setProfileText($profile);
			$p->setProfileName($name);
			array_push ($this->_profiles, $p);
//se o argumento é um objeto significa que estamos recuperando o usuário da base, e já trazemos o objeto
//UserProfileClass "pronto" precisamos apenas adicionar à lista de Perfis do Usuário
		}else	if (is_object($profile)){
			array_push ($this->_profiles, $profile);
		}
	}

/**
* Atribuí um valor para o campo password da classe
* @param char[32] $password senha do usuário, é gravado no bando o MD5 da senha do usuário e não a própria senha por essa razão é um char[32] pois o MD5 tem sempre o mesmo tamanho
*/
	function setPassword($password){
		$this->_password = $password;	
	}


/**
* Recupera um valor para o campo ID da classe
* @param integer $id Identificador do usuário
*/
	function getID(){
		return (trim($this->_id));
	}

/**
* Recupera um valor para o campo firstName da classe
* @returns string $firstName Primeiro nome do Usuário
*/
	function getFirstName(){
		return (trim($this->_firstName));
	}

/**
* Recupera um valor para o campo lastName da classe
* @returns string $lastName Segundo nome do Usuário
*/
	function getLastName(){
		return (trim($this->_lastName));
	}


/**
* Recupera um valor para o campo gender da classe
* @returns string $login O nome de Login do usuário (é único no sistema porém não é chave)
*/
	function getGender(){
		return (trim($this->_gender));
	}

/**
* Recupera um valor para o campo login da classe
* @returns string $login O nome de Login do usuário (é único no sistema porém não é chave)
*/
	function getLogin(){
		return (trim($this->_login));
	}

/**
* Recupera um valor para o campo email da classe
* @returns string $email  Endereço de e-mail do usuário
*/
	function getEmail(){
		return (trim($this->_email));
	}

/**
* Recupera um valor para o campo profiles da classe
* @returns Object [] ProfileClass O Array contendo os profiles do usuário
*/
	function getProfiles(){
		return ($this->_profiles);
	}

/**
* Recupera um valor para o campo password da classe
* @returns char[32] $password senha do usuário, é gravado no bando o MD5 da senha do usuário e não a própria senha por essa razão é um char[32] pois o MD5 tem sempre o mesmo tamanho
*/
	function getPassword(){
		return (trim($this->_password));
	}

/**
* Adiciona um usuário no Banco de Dados
*
* Ele pega os dados que estão armazenados nos campos da classe e adiciona no Banco
*além de atualizar o campo ID do usuário
* @returns mixed $result O id do usuário que foi inserido no banco de dados ou um array em casso de "erro" (login duplicado)
*/
	function AddUser(){

	if($this->loginExists($this->getLogin()))
		return array("ERROR"=>"Login já existente");


		$strsql = "INSERT INTO users (user_firstname, user_lastname, user_gender, user_login, user_email, user_password) VALUES ('".$this->_firstName. "','".$this->_lastName. "','". $this->_gender."','". $this->_login. "','".$this->_email. "','".md5($this->_password). "')";
		$result = $this->_db->databaseExecInsert($strsql);

		$this->setID($result);
		foreach($this->_profiles as $profile)
		{

			$strsql = "INSERT INTO scielo_user_profiles (user_id, profile_text, profile_name) VALUES (".$this->getID().",'".$profile->getProfileText()."','".$profile->getProfileName()."')";
			$this->_db->databaseExecInsert($strsql);
		}
		$this->loadUser($result);
		return $result;
	}

/**
* Altera os dados do usuário no Banco de Dados
*
* Ele pega os dados que estão armazenados nos campos da classe e adiciona no Bancp
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function UpdateUser(){

	if($this->loginExists($this->getLogin(), $this->getID()))
		return array("ERROR"=>"Login já existente");
//atualizando os dados do usuário
		
		$strsql = "UPDATE users SET user_firstname = '".$this->getFirstName()."', user_lastname = '".$this->getLastName()."', user_gender = '".$this->getGender()."', user_login = '".$this->getLogin()."' , user_email = '".$this->getEMail()."'";
		if($this->getPassword() != '')
			$strsql .= " , user_password = '".md5($this->getPassword())."'";
		$strsql .= " WHERE user_id = ".$this->getID();

			$this->_db->databaseExecUpdate($strsql);
//atualizando os dados dos perfis do usuário
		$perfis = $this->getProfiles();

		foreach($perfis as $perfil){
			$strsql = "UPDATE scielo_user_profiles SET profile_text = '".$perfil->getProfileText()."', profile_name = '".$perfil->getProfileName()."' WHERE user_id = ".$perfil->getUserID()." and profile_id = ".$perfil->getProfileID()." ";
			$this->_db->databaseExecUpdate($strsql);
		}
		$this->loadUser($this->getID());
	}

/**
* Carrega nos campos da classe os valores que estão armazenados no Banco de Dados
* @param integer $id Identificador do usuário
* @returns integer $sucess 1 em caso de sucesso, 0 em caso de erro
*/
	function loadUser($id){

		$this->clearFields();

//carregando os dados do usuário
		$strsql = "SELECT * FROM  users WHERE users.user_id = ".$id;
		$ret = $this->_db->databaseExecInsert($strsql);
		$arr = $this->_db->databaseQuery($strsql);
		if(count($arr) > 0){
			$this->setID($arr[0]['user_id']);
			$this->setFirstName($arr[0]['user_firstname']);
			$this->setLastName($arr[0]['user_lastname']);
			$this->setGender($arr[0]['user_gender']);
			$this->setLogin($arr[0]['user_login']);
			$this->setEMail($arr[0]['user_email']);

	//carregando os dados do profile do usuário
			$strsql = "SELECT * FROM  scielo_user_profiles WHERE user_id = ".$id;
			$ret = $this->_db->databaseExecInsert($strsql);
			$arr = $this->_db->databaseQuery($strsql);

			foreach($arr  as $p)
			{
				$profile = new UserProfileClass();
				$profile->setUserID($p['user_id']);
				$profile->setProfileID($p['profile_id']);
				$profile->setProfileText($p['profile_text']);
				$profile->setProfileName($p['profile_name']);
				$this->setProfiles($profile);
			}
			return 1;
		}
		else
		{
			return 0;
		}
	}

/**
* Verifica se o login que estamos tentando inserir na base já existe
* @param string $login Login que estamos tentando inserir
* @returns integer $sucess 1 se o login já existir e 0 se o login não existir
*/
	function loginExists($login, $id=0){
		if($id == 0)
			$strsql = "SELECT user_login FROM users WHERE user_login = '".trim($login)."'" ;
		else
			$strsql = "SELECT user_login FROM users WHERE user_login = '".trim($login)."' AND user_id <> ".$id ;
		$res = $this->_db->databaseQuery($strsql);
		if(count($res) > 0)
			return 1;
		else
			return 0;
		
	}

/**
* Verifica se o login e senha que estão nos campos do objeto, se o login for válido os demais campos do objeto serão preenchidos
* @returns mixed $sucess 1 se o login e senha forem válidos ou 0 se o login não for válido
*/
	function validateUser(){
		$strsql = "SELECT * FROM users WHERE user_login = '".$this->getLogin()."' AND user_password = '".md5($this->getPassword())."'" ;
		$res = $this->_db->databaseQuery($strsql);

		if(count($res) > 0)
		{
			$this->loadUser($res[0]['user_id']);
			return 1;
		}
		else
			return 0;
	}

/**
* Gera uma nova senha e envia para o email cadastrado do usuário
* @returns mixed $sucess 1 a senha foi enviada com sucesso ou um array com a descricao do erro
*/
	function createNewPassword(){

		$strsql = "SELECT * FROM users WHERE user_login = '".$this->getLogin()."'" ;
		$res = $this->_db->databaseQuery($strsql);
		if(count($res) == 0)
		{
			return array("ERROR"=>"1");
		}
		else
		{
			$newPassword = substr(md5(rand()),0,7);
			$strsql = "UPDATE users SET user_password = '".md5($newPassword)."' WHERE user_login = '".$this->getLogin()."'" ;

			$this->_db->databaseQuery($strsql);
			$msg = "<p>Você está recebendo uma nova senha para acessar o portal Scielo</p>";
			$msg .= "<p><b>Senha:</b> ".$newPassword."</p>";

			$this->_mail->From     = "scielo@bireme.br";
			$this->_mail->FromName = "Scielo";
			$this->_mail->Subject  = "Envio de Nova senha";
			$this->_mail->Host     = "brm.bireme.br";
			$this->_mail->Mailer   = "smtp";
			$this->_mail->IsHTML(true);

			$this->_mail->Body = $msg;
			$this->_mail->AddAddress($res[0]['user_email'], $res[0]['user_firstname']." ". $res[0]['user_lastname']);
			$send = $this->_mail->Send();

			if(!$send)
				return array("ERROR" => $this->_mail->ErrorInfo);
			else
				return 1;
		}
	}

}

?>