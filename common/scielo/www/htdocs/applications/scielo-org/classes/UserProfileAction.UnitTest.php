<?php 
ini_set('display_errors', 'On');
//alterando o path para a procura de includes, assim
//achamos o ADODB em lib . . .
error_reporting(E_ALL ^ E_NOTICE );

	$DirNameLocal = dirname(__FILE__).'/';

	require_once($DirNameLocal."../users/UserProfileClass.php");
	require_once("UserProfileAction.php");
	$profile = new UserProfileClass();
	
	$profilesToCreate[] = $profile;
	
	$userProfileAction = new UserProfileAction();
	$userProfileAction->generateProfileArticleRelationship($profilesToCreate);
//	$userProfileAction->deactivateProfile($profilesToDeactivate, $userID);
	
?>
