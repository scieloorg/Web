<?php
/**
 * @desc Classe para gerenciamento de LOGS do sistema e de acoes do usuario
 * @package BVSLOG
 * @version 1.3
 * @author  Domingos Teruel <domingosteruel@terra.com.br>
 * @since 01 de setembro de 2004
 * @copyright  BIREME - SCI - 2004
*/


class log
{
    /**
     * @var string
     * @desc Path do diretorio de logs
     */
	var $log_dir;
	/**
     * @var string
     * @desc Path do diretorio de logs com permissão 777
     */
	var $directory;
	/**
	 * @var string
	 * @desc Nome do arquivo de log
	 */
	var $fileName;
	/**
	 * @var string
	 * @desc Recebe os valores do scielo.def
	 */
	var $def;

	var $fields  = Array();
	/**
	 * @var Array
	 * @desc Campos de informacao do log (linhas dos arquivos)
	 */

	/**
	 * @desc constructor
	 */
	function log()
	{
		$this->setDirectory();
	}
	/**
	 * @desc metodo que seta o diretorio onde os logs deveram ser escritos
	 * @param string LOG_DIR constante definida como o path para o dir de logs
	 */
	function setDirectory()
	{
		if (!isset($this->log_dir)){
			$this->def = parse_ini_file(dirname(__FILE__).'/../../../../scielo.def',true);
			$this->log_dir = $this->def['LOG']['SERVICES_LOG_DIRECTORY'];
		}

		if ( is_dir($this->log_dir) ){
			$this->directory = $this->log_dir;

		}else{

			if ( $this->mkdirs($this->log_dir,0775) ){
				$this->directory = $this->log_dir;
				//die("CREATED");
			}else{
				$this->logError("Unable to create directory " . $this->log_dir);
				//die("NOT CREATED");
			}
		}
	}
    /**
     * @desc metodo que define o nome do arquivo e log
     * @param string $fileName nome do arquivo de log
     */
	function setFileName($fileName)
	{
		$this->fileName = $fileName;
	}
	/**
	 * @desc cria arquivo no diretorio especificado ou abre arquivo se ja tiver sido criado
	 * @param string
	 */
	function openFileWriter()
	{
		if ( is_file($this->directory . $this->fileName) ){
			$fp = fopen ($this->directory .'/'. $this->fileName, "a+b");
		}else{
			$fp = fopen ($this->directory .'/'. $this->fileName, "a+b");
			$head = "date" . LOG_SEPARATOR . implode(LOG_SEPARATOR, array_keys($this->fields)) . "\r\n";
			chmod($this->directory .'/'. $this->fileName,0774);
			fwrite($fp, $head);
		}

		if ($fp){
			return $fp;
		}else{
			$this->logError("Unable to open log file " . LOG_DIR . $this->fileName);
		}
	}
	/**
	 * @desc grava no arquivo de log
	 */
	function writeLog()
	{
		$fp = $this->openFileWriter($this->directory,$this->fileName);
		$logLine = implode(LOG_SEPARATOR, $this->fields);

		$logInfo = date("Y-m-d H:i:s") . LOG_SEPARATOR . $logLine ."\r\n";
		if (!fwrite($fp, $logInfo)){
			$this->logError("Unable to write log file " . $this->log_dir . $this->fileName);
		}else{
			fclose($fp);
		}
	}

	/**
	 * @desc le arquivo e coloca em um array
	 */
	function readLog(){
		$text = file($this->directory.$this->fileName);
		//recupera array retirado do arquivo
		foreach ($text as $num_linha=>$linha) {
		    $leitura.= $linha;
		}
		echo '<textarea name="textareaLog" rows="30" cols="120">'.$leitura.'</textarea>';
	}

	/**
	 * @desc adiciona log de erro
	 */
	function logError($message)
	{
		$fp = fopen ($this->directory . "logerror.txt", "a+b");
		if ( !$fp ){
			$this->sendMailAdmin("Unable to open log file for update " . $this->directory . "logerror.txt");
		}else{
			if ( !fwrite($fp, $message) ){
				$this->sendMailAdmin("Unable to write in log file " . $this->directory . "logerror.txt");
			}else{
				$this->sendMailAdmin("Log error message: " . $message);
			}
		}
		return;
	}

	function sendMailAdmin($message)
	{
		if ( defined('LOG_ADMIN') and (LOG_ADMIN != 0)) {

			$headers = "MIME-Version: 1.0\n";
			$headers .= "Content-type: text/plain; charset=iso-8859-1\n";
			$headers .= "X-Priority: 1\n";
			$headers .= "X-MSMail-Priority: High\n";
			$headers .= "X-Mailer: php\n";
			$headers .= "To: " . LOG_ADMIN . "\n";
			$headers .= "From: log@bireme.br\n";

			return ( mail(LOG_ADMIN, "BVSLOG error", $message, $headers) );
		}
	}

	function mkdirs($strPath, $mode = "0775")
	{
		if ( is_dir($strPath) ) {
		 	return true;
		}
		$pStrPath = dirname($strPath);
		if ( ! $this->mkdirs($pStrPath, $mode) ){
			 return false;
		}
		$old_umask = umask(0);
		$mk = mkdir($strPath, $mode);
		umask($old_umask);
		return $mk;
	}

	/**
	 * @desc log de acessos ao ADM
	 */
	function logAccess()
    {
        $this->setFileName("access_log.txt");
        $ip   = getenv(REMOTE_ADDR); //guarda o endereco ip do host
        $host = gethostbyaddr($ip); //guarda o mome do host
        $text = "[".date('d/m/Y h:i:s')."] - $host;$ip;$data\n";
        $this->writeFile($text);
    }
    /**
     * @desc log das acoes do usuario no modulo ADM
     * @param string $text o acao executada ou outro texto referente
     */
    function adminlog($text)
    {
	   global $db, $PMF_CONF;
	   if (isset($PMF_CONF["enableadminlog"])) {
		  $db->query("INSERT INTO ".SQLPREFIX."tblog (id, time, usr, text, ip) VALUES ('','".time()."','{$_SESSION["idUser"]}','".nl2br(addslashes($text))."','{$_SERVER["REMOTE_ADDR"]}')");
		}
    }

}

?>