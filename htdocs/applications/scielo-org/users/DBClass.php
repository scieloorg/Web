<?php
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

/**
*Classe de Banco de Dados do Scielo regional
*
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/


class DBClass{


/**
* Objeto de conexão com o banco de dados
* @var Object $_conn
*/
var $_connScielo = null;

/**
* Endereço do host
* @var string $_host
*/
//var $_host = "127.0.0.1";
var $_host = "";


/**
* Nome do usuário do BD
* @var string $_user
*/
//var $_user = $DBUser;
var $_user = "";

/**
* Senha do usuário do BD
* @var string $_password
*/
var $_password = "";

/**
* Nome do databse
* @var string $_db
*/
var $_db = "";

function DBClass(){

     $fileDef = parse_ini_file(dirname(__FILE__)."/../../../scielo.def.php");
     $this->_password = $fileDef["DB_USER_SCIELO_PASSWORD"];
     $this->_db  = $fileDef["DB_SCIELO"];
     $this->_user = $fileDef["DB_USER_SCIELO"];
     $this->_host = $fileDef["DB_HOST_SCIELO"];

               $this->_connScielo = mysql_pconnect($this->_host, $this->_user, $this->_password);
                if (!$this->_connScielo) {
                    error_log("Não foi possível conectar ao banco SciELO: ".mysql_error());
                    die("Não foi possível conectar ao banco de dados");
                }

                if (!mysql_select_db($this->_db)) {
                    error_log("Não pude selecionar o banco SciELO: ".mysql_error());
                    die("Não pude selecionar o banco de dados");
                }
        }

	function __construct(){
		$this->DBClass();
	}


	
	function databaseExecInsert($query){
		$result = mysql_query($query,$this->_connScielo);
		if($result)
		{
			return(mysql_insert_id());
		}else{
			error_log("A consulta falhou: ".mysql_error());
			return (array("A consulta falhou"));
		}
	}

	function databaseExecUpdate($query){
		$result = mysql_query($query,$this->_connScielo);
		$error = mysql_error();
		if ($error){
			error_log("A consulta falhou: ".$error);
			die("A consulta falhou");
		}
		return(mysql_affected_rows());
	}

	function databaseQuery($query){
		$result = mysql_query($query,$this->_connScielo);
		if (!$result) {
			error_log("A consulta falhou: ".mysql_error());
			die("A consulta falhou");
		}
		
		$recordSet = array();
		
		while ($row = mysql_fetch_assoc($result)) {
			array_push($recordSet, $row);
		}

		return($recordSet);
	}

	function fechaConexao(){
		mysql_close($this->_connScielo);

		
	}



}

?>
