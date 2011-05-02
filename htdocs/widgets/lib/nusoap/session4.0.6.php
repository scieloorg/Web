<?php
class Session
{
	// Inicia uma sess�o e recupera os valores das vari�veis registradas.
	// Se $name != "" atualiza o nome da sess�o corrente
	// Se $id != "" atualiza o id da sess�o corrente
	function Session($name = "", $id = "")
	{
		if (!empty($name))
		{
			session_name($name);
		}
		if (!empty($id))
		{
			session_id($id);
		}
		session_start();
		}
	
	// Retorna o nome da sess�o corrente
	function getSessionName()
	{
		return session_name();
	}
	
	// Retorna o id da sess�o corrente
	function getSessionID()
	{
		return session_id();
	}

	// Registra uma vari�vel de sess�o
	//  $varname � o nome da vari�vel de sess�o
	//  $value � o valor a ser atribu�do
	function register($varname, $value)
	{
		$GLOBALS[$varname] = $value;
 		session_register($varname);
	}
	
	// Desregistra vari�vel da sess�o
	function unregister($varname)
	{
	    if ( $this->isRegistered($varname) )
    	{
        	session_unregister($varname);
	    }
	}
	
	// Pega o valor da vari�vel registrada
	function getValue($varname)
	{
		return $GLOBALS[$varname];
	}
	
	// Verifica se a vari�vel com nome $varname est� registrada ou n�o
	function isRegistered($varname)
	{
		return session_is_registered($varname);
	}
	
	// Destr�i a sess�o
	function logout()
	{
	    // Unregister session variables
    	session_unset();
    
		session_destroy();        

	    // Set cookie expire date to 0 => delete cookie.
		$sessionPath = session_get_cookie_params();
		setcookie(session_name(), "", 0, $sessionPath["path"], $sessionPath["domain"]); 
	}
}
?>