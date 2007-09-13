<?php
/**
 * Classe que grava os acessos a cada serviço do Scielo
 *
 * @author Deivid Martins
 * @since 15/08/2007
 * @version 0.1
 */
class UserDataLog extends log
{
	var $serviceName;
	/**
	 * Construtor
	 * @param string $serviceName
	 * @param Object $userData
	 */
	function UserDataLog($serviceName, $userData)
	{

		$this->serviceName = $serviceName;
		$this->setDirectory();

		// Definindo dados do usuário
		$this->fields['ip'] = $userData->getIp();
		$this->fields['language'] = $userData->getLanguage();
		$this->fields['nameHost'] = $userData->getName();
		$this->fields['OS'] = $userData->getOS();
		$this->fields['port'] = $userData->getPort();
		$this->fields['resolution'] = $userData->getResolution();
		$this->fields['title'] = $userData->getTitle();
		$this->fields['url'] = $userData->getURL();
		$browser = array();
		$support = array();
		$browser = $userData->getBrowser();
		$support = $userData->getSupport();

		$i = 0;
		for($i = 0; $i < count($browser) - 1; $i++)
			$this->fields['browser'] .= $browser[$i]." , ";
		$this->fields['browser'] .= $browser[$i];

		for($i = 0; $i < count($support) - 1; $i++)
			$this->fields['support'] .= $support[$i]." , ";
		$this->fields['support'] .= $support[$i];

	}
	/**
	 * Define o nome do arquivo a ser escrito
	 * @param string $fileName
	 */
	function setFileName($fileName)
	{
		/**
		 *
		 * Assim vai ficar mais facil quando quisermos ler
		 * estatisticas de um determinado serviço
		 *
		 **/
		//$this->fileName = str_replace(" ", "", $this->serviceName.$fileName);
		$this->fileName = str_replace(" ", "", $this->serviceName);
	}

	function sendMailAdmin($message)
	{
		if ( defined('LOG_ADMIN') )
		{
			$headers = "MIME-Version: 1.0\n";
			$headers .= "Content-type: text/plain; charset=iso-8859-1\n";
			$headers .= "X-Priority: 1\n";
			$headers .= "X-MSMail-Priority: High\n";
			$headers .= "X-Mailer: php\n";
			$headers .= "To: " . LOG_ADMIN . "\n";
			$headers .= "From: log@bireme.br\n";
			mail(LOG_ADMIN, "Scielo Log Error", $message, $headers);
			return true;
		}
	}

}
?>