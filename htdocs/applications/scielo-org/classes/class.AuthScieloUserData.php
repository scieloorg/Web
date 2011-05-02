<?php
/**
  * Classe com dados dos usu�rios autenticados do Scielo
  *
  * @author Gustavo Fonseca
  *	@version 0.1
  */
class AuthScieloUserData
{	
	var $userSession;	// Session do usu�rio
	var $userID;		// ID do usu�rio
	var $ip;			// Ip do Usu�rio
	var $port;			// Porta que o Usu�rio est� acessando
	var $searchExp;		// Express�o de busca se houver
	var $parentPID;		// PID de origem do artigo sendo acessado
	var $url;			// URL do servi�o que o cliente est� acessando
	var $title;			// Titulo do Artigo que o cliente est� acessando
	var $script;		// Script utilizado
	var $language;		// Idioma do Visitante
		
	/**
	 * Construtor
	 * @access public
	 */
	function AuthScieloUserData()
	{
		$this->setIp();
		$this->setPort();		
	}	
	/**
	 * @access public
	 * @return int ID do usu�rio
	 */
	function getUserSession()
	{
		return $this->userSession;
	}
	/**
	 * @access public
	 */
	function setUserSession($sess)
	{
		$this->userSession = $sess;
	}	
	/**
	 * @access public
	 * @return int ID do usu�rio
	 */
	function getID()
	{
		return $this->userID;
	}
	/**
	 * @access public
	 */
	function setID($uid)
	{
		$this->userID = $uid;
	}		
	/**
	 * @access public
	 * @return int IP do usu�rio
	 */
	function getIp()
	{
		return $this->ip;
	}
	/**
	 * @access public
	 */
	function setIp()
	{
		$this->ip = getenv("REMOTE_ADDR");
	}
	/**
	 * @access public
	 * @return int O numero da porta que o usu�rio est� usando para acessar
	 * o Scielo
	 */
	function getPort()
	{
		return $this->port;
	}
	/**
	 * Seta a porta que o usu�rio est� usando para acessar o Scielo
	 * 
	 * @access public
	 * 
	 */
	function setPort()
	{
		$this->port = getenv("REMOTE_PORT");
	}	
	/**
	 * @access public
	 * @return string A express�o de busca utilizada pelo usu�rio
	 * o Scielo
	 */
	function getSearchExp()
	{
		return $this->searchExp;
	}
	/**
	 * Define a express�o de busca utilizada pelo usu�rio
	 * 
	 * @access public
	 * 
	 */
	function setSearchExp($searchExp)
	{
		$this->searchExp = $searchExp;
	}
	/**
	 * @access public
	 * @return string parentPID da p�gina acessada
	 */
	function getParentPID()
	{
		return $this->parentPID;
	}
	/** Seta a pid de origem
	 * @access public
	 * @param string $pid
	 */
	function setParentPID($pid)
	{
		$this->parentPID = $pid;
	}
	/**
	 * @access public
	 * @return string PID da p�gina acessada
	 */
	function getPID()
	{
		return $this->PID;
	}
	/** Seta o PID corrente
	 * @access public
	 * @param string $url
	 */
	function setPID($pid)
	{
		$this->PID = $pid;
	}
	
	/**
	 * @access public
	 * @return string PID corrente
	 */
	function getURL()
	{
		return $this->url;
	}
	/** Seta a url corrente e define o script sendo utilizado
	 * @access public
	 * @param string $url
	 */
	function setURL($url)
	{
		$this->url = $url;
	}	
	/**
	 * @access public
	 * @return string Titulo da p�gina acessada
	 */
	function getTitle()
	{
		return $this->title;
	}
	/**
	 * @access public
	 * @param string $title
	 */
	function setTitle($title)
	{
		$this->title = $title;
	}	
	/**
	 * @access public
	 * @return string Script .xis utilizado
	 */
	function getScript()
	{
		return $this->script;
	}
	/**
	 * @access public
	 * @param string $script
	 */
	function setScript($script) 
	{
		$this->script = $script;
	}	
	/**
	 * @access public
	 * @return string Retorna a lingua do navegador do usu�rio
	 */
	function getLanguage()
	{
		return $this->language;
	}
	/**
	 * @access public 
	 * @param string $language 
	 */
	function setLanguage($language)
	{
		$this->language = $language;
	}
		
}


?>
