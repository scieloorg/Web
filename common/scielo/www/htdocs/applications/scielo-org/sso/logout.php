<?
$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def",true);
$useSGU = intval($ini['sgu']['enabled'])?true:false;
/*
Faz o logout na instancia (ou seja "mata" os cookies de usuario) 
*/
    session_start();
    setcookie("userID","",0,"/");
    setcookie("firstName","",0,"/");
    setcookie("lastName","",0,"/");
	setcookie("email","",0,"/");

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
		setcookie("userToken","",0,"/");
		setcookie("tokenVisit","",0,"/");
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