<?php
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

/**
*Classe de Profile de Usuários do Scielo regional
*
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright   BIREME
*/
class UserProfileClass{

/*
* Identificador do usuário
* @var integer $_user_id
*/
var $_user_id = '';

/*
* Identificador do Profile
* @var integer $_profile_id
*/
var $_profile_id = '';

/*
* Texto com as palavras chave do profile
* @var string $_profile_text
*/
var $_profile_text = '';

/*
* Nome do Perfil (Descricão Fornecida pelo Usuário)
* @var string $_profile_name
*/
var $_profile_name = '';

/*
* ID da Grande Area
* @var integer $_id_grande_area
*/
var $_id_grande_area = 0;

/*
* ID da Sub Area
* @var integer $_id_sub_area
*/
var $_id_sub_area = 0;

/**
*Construtor vazio
*/
	function UserProfileClass(){
	
	}

/*
*seters
*/
	function setUserID($userid){
		$this->_user_id = $userid;
	}

	function setProfileID($profileid){
		$this->_profile_id = $profileid;
	}

	function setProfileText($profiletext){
		$this->_profile_text = $profiletext;
	}

	function setProfileName($profilename){
		$this->_profile_name = $profilename;
	}

	function setProfileStatus($profileStatus){
		$this->_profile_status = $profileStatus;
	}

	function setCreationDate($creationDate){
		$this->_creationDate = $creationDate;
	}

	function setGrandeAreaID($param){
		$this->_id_grande_area = $param;
	}

	function setSubAreaID($param){
		$this->_id_sub_area = $param;
	}

/*
*geters
*/
	function getUserID(){
		return ($this->_user_id);
	}

	function getProfileID(){
		return ($this->_profile_id);
	}

	function getProfileText(){
		return ($this->_profile_text);
	}

	function getProfileName(){
		return ($this->_profile_name);
	}
	
	function getProfileStatus(){
		return $this->_profile_status;
	}

	function getCreationDate(){
		return ($this->_creationDate);
	}

	function getGrandeAreaID(){
		return ($this->_id_grande_area);
	}

	function getSubAreaID(){
		return ($this->_id_sub_area);
	}

}

?>