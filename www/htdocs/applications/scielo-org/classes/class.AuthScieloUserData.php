<?php
/**
  * Classe com dados dos usuários autenticados do Scielo
  *
  * @author Gustavo Fonseca
  *	@version 0.1
  */
class AuthScieloUserData
{	
	var $userSession;	// Session do usuário
	var $userID;		// ID do usuário
	var $ip;			// Ip do Usuário
	var $port;			// Porta que o Usuário está acessando
	var $searchExp;		// Expressão de busca se houver
	var $parentPID;		// PID de origem do artigo sendo acessado
	var $url;			// URL do serviço que o cliente está acessando
	var $title;			// Titulo do Artigo que o cliente está acessando
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
	 * @return int ID do usuário
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
	 * @return int ID do usuário
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
	 * @return int IP do usuário
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
	 * @return int O numero da porta que o usuário está usando para acessar
	 * o Scielo
	 */
	function getPort()
	{
		return $this->port;
	}
	/**
	 * Seta a porta que o usuário está usando para acessar o Scielo
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
	 * @return string A expressão de busca utilizada pelo usuário
	 * o Scielo
	 */
	function getSearchExp()
	{
		return $this->searchExp;
	}
	/**
	 * Define a expressão de busca utilizada pelo usuário
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
	 * @return string parentPID da página acessada
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
	 * @return string PID da página acessada
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
	 * @return string Titulo da página acessada
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
	 * @return string Retorna a lingua do navegador do usuário
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
