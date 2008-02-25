<?php
/**
 * Classe que grava os acessos de usuários autenticados a cada servido do Scielo
 *
 * @author Gustavo Fonseca
 * @since 19/02/2008
 * @version 0.1
 */
class AuthUserDataLog extends log
{
	var $serviceName;	//Nome do servico acionado
	var $fields;		//Array contendo informacoes a serem salvas 
	/**
	 * Construtor
	 * @param string $serviceName
	 * @param Object $userData
	 */
	function AuthUserDataLog($serviceName, $userData)
	{
		
		$this->serviceName = $serviceName;
	
		$this->setDirectory();
	
		// Definindo dados do usuario
		$this->fields['userSession'] = $userData->getUserSession();
		$this->fields['userID'] = $userData->getID();
		$this->fields['ip'] = $userData->getIp();
		$this->fields['port'] = $userData->getPort();		
		//$this->fields['searchExp'] = $userData->getsearchExp();
		$this->fields['parentPID'] = $userData->getParentPID();
		$this->fields['PID'] = $userData->getPID();
		$this->fields['url'] = $userData->getURL();
		//$this->fields['title'] = $userData->getTitle();
		//$this->fields['script'] = $userData->getScript();
		//$this->fields['language'] = $userData->getLanguage();

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
		 * estatisticas de um determinado servico
		 *
		 **/
		//$this->fileName = str_replace(" ", "", $this->serviceName.$fileName);
		$this->fileName = str_replace(" ", "", $this->serviceName);
	}

	function sendMailAdmin($message)
	{
		if ( defined('LOG_ADMIN') and (LOG_ADMIN != 0))
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