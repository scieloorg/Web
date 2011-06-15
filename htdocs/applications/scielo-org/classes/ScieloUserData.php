<?php
/**
  * Classe com dados dos usu�rios do Scielo
  *
  * @author Deivid Martins
  *	@version 0.1
  */
class ScieloUserData
{	
	var $browser;		// Navegador
	var $ip;			// Ip do Usu�rio
	var $language;		// Idioma do Visitante
	var $name;			// Nome do host se possivel
	var $os;			// Sistema Operacional
	var $port;			// Porta que o Usu�rio est� acessando
	var $resolution;	// Resolu��o
	var $support;		// Mime Types Suportados... Com isso saberemos se o usu�rio por pode
						// rodar o Flash ou o Applet Java, etc...
	var $title;			// Titulo do Artigo que o cliente est� acessando
	var $url;			// URL do servi�o que o cliente est� acessando
	
	/**
	 * Construtor
	 * @access public
	 */
	function ScieloUserData()
	{
		$this->setIp();
		$this->setPort();
		$this->setName();
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
	 * Retorna uma String
	 * 
	 * @access public
	 * @return string Com o nome do host ou com ip caso ele n�o consiga
	 * achar o dom�nio de acesso
	 */
	function getName()
	{
		return $this->name;
	}
	/**
	 * Tenta obter o nome do host que o usu�rio est� acessando
	 * 
	 * @access public
	 */
	function setName()
	{
		$this->name = gethostbyaddr($this->ip);
	}
	/**
	 * @access public
	 * @return array string Retorna um array com todos os dados poss�veis
	 * sobre o navegador do usu�rio
	 */
	function getBrowser()
	{
		return $this->browser;
	}
	/**
	 * @access public
	 * @param string $browser
	 */
	function setBrowser($browser)
	{
		$this->browser = array();
		$this->browser = explode("..#..", $browser );
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
	/**
	 * @access public
	 * @return string Retorna o Sistema Operacional do Usu�rio
	 */
	function getOS()
	{
		return $this->os;
	}
	/**
	 * @access public
	 * @param string $OS
	 */
	function setOS($OS)
	{
		$this->os = $OS;
	}
	/**
	 * @access public
	 * @return string Retorna a resolu��o 
	 */
	function getResolution()
	{
		return $this->resolution;
	}
	/**
	 * @access public
	 * @param string $resolution 
	 */
	function setResolution( $resolution )
	{
		$this->resolution = $resolution;
	}
	/**
	 * @access public
	 * @return array Contendo os MIME-TYPES que o usu�rio suporta
	 */
	function getSupport()
	{

		return $this->support;
	}
	/**
	 * @access public
	 * @param string $support 
	 */
	function setSupport($support)
	{
		$this->support = array();
		$this->support = explode("..#..", $support);
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
	 * @return string URL da p�gina acessada
	 */
	function getURL()
	{
		return $this->url;
	}
	/**
	 * @access public
	 * @param string $url
	 */
	function setURL($url)
	{
		$this->url = $url;
	}
		
}


?>