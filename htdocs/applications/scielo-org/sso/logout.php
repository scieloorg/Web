<?
$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def.php",true);
$useSGU = intval($ini['sgu']['enabled'])?true:false;

function sso_cookie_options($expires)
{
    return array(
        'expires' => $expires,
        'path' => '/',
        'secure' => (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off'),
        'httponly' => true,
        'samesite' => 'Lax'
    );
}

function sso_clear_cookie($name)
{
    setcookie($name, "", sso_cookie_options(0));
}

/*
Faz o logout na instancia (ou seja "mata" os cookies de usuario) 
*/
    session_start();
    sso_clear_cookie("userID");
    sso_clear_cookie("firstName");
    sso_clear_cookie("lastName");
    sso_clear_cookie("email");

    unset($_COOKIE['userID']);
    unset($_COOKIE['checkedLogin']);
    unset($_COOKIE['firstName']);
    unset($_COOKIE['lastName']);
    unset($_COOKIE['email']);

	if($useSGU){
		/*
			se estiver usando SGU e estiver no portal regional (Scielo.org), chama o logout do SGU
		*/
		if($ini['this']['url'] == $ini['scielo_org_urls']['home'])
		{
			require_once(dirname(__FILE__)."/../users/UserClassWS.php");
			$usr = new UserClass();
			$usr->setToken($_COOKIE['userToken']);
			$usr->logout();
		}
		sso_clear_cookie("userToken");
		sso_clear_cookie("tokenVisit");
		unset($_COOKIE['userToken']);
	}

ob_start();

?>
<html>
<body>
<p>Logout</p>
</body>
</html>

<?

ob_flush();

?>
