<?
//verifica se jah tem o cookie de logado, se nao chama o Login na instancia
error_reporting(E_ALL);
require('header.php');

$origem = "http://".$_SERVER["SERVER_NAME"].$_SERVER["SCRIPT_NAME"];
$destinoLogin = "http://test.scielo.org/users/sso.php";
$destinoLogout = "http://test.scielo.org/users/loginSSO.php?logout=true&origem=".$origem;

if(isset($_REQUEST['logout']))
{
    setcookie("userID","",0,"/");
    setcookie("userFirstName","",0,"/");
    setcookie("userLastName","",0,"/");
    header("Location: ".$destinoLogout);
}

if((!isset($_REQUEST['userID'])) && (!isset($_COOKIE['userID'])))
{
    echo '<a href="'. $destinoLogin  .'?origem='.$origem.'&redirect=true">Entrar</a>';
}else{

    if(!isset($_COOKIE['userID'])) {
        setcookie("userID",$_REQUEST['userID'],time()+3600,"/");
        setcookie("userFirstName",$_REQUEST['firstName'],time()+3600,"/");
        setcookie("userLastName",$_REQUEST['lastName'],time()+3600,"/");
        header("Location: ".$origem);
    }else{
	echo $_COOKIE['userFirstName']." ".$_COOKIE['userLastName'];
	echo '<br /><br /><a href="?logout">Sair</a>';
    }
}

?>
