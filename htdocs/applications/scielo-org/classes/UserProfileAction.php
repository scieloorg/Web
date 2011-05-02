<?php  
	ini_set("include_path",".");
	ini_set("display_errors", "1");
	error_reporting(E_ALL ^E_NOTICE);

	require_once(dirname(__FILE__)."/ArticleDAO.php");
	require_once(dirname(__FILE__)."/ProfileArticleDAO.php");
	require_once(dirname(__FILE__)."/../users/UserProfileDAO.php");
	require_once(dirname(__FILE__)."/GrandeArea.php");
	require_once(dirname(__FILE__)."/SubArea.php");
	require_once(dirname(__FILE__)."/services/TrigramaService.php");

	class UserProfileAction {
		function userProfileChanged($currentProfiles, $profilesFromForm, &$profilesToCreate, &$profilesToDeactivate){
			foreach ($profilesFromForm as $key=>$profileFromForm){

				if ($currentProfiles[$key]){
					$currentText = $currentProfiles[$key]->getProfileText();
				}
				if ((trim($profileFromForm->getProfileText()) != $currentText)) {
					$profilesToCreate[] = $profileFromForm;
					
					if ($currentText){
						$profilesToDeactivate[] = $currentProfiles[$key];
					}
				}
			}
			for ($i=$key+1; $i<count($currentProfiles);$i++){
				$profilesToDeactivate[] = $currentProfiles[$i];
			}
			return ($profilesToDeactivate && $profilesToCreate);
		}		
		
		function generateProfileArticleRelationship($profilesToCreate){
			if ($profilesToCreate){

				// chamar serviço de associar palavras do perfil com os artigos
				// deste resultado tratar o xml para
				// gerar registros na tabela de profile_article, 
				// associando perfil a PID do artigo
				$trigramaService = new TrigramaService();
				$articleDAO = new ArticleDAO();
				$profileArticleDAO = new ProfileArticleDAO();

				foreach ($profilesToCreate as $newProfile){
					$subArea = new SubArea();

					$subArea->setID($newProfile->getSubAreaID());
					$subArea->loadSubArea();

					$grandeArea = new GrandeArea();

					$grandeArea->setLang('');
					$grandeArea->setID($newProfile->getGrandeAreaID());

					$grandeArea->loadGrandeArea();

					$trigramaString = "";
					$trigramaString .= $newProfile->getProfileText();
					$trigramaString .= " ".$subArea->getDescricao();
					$trigramaString .= " ".$grandeArea->getDescricao();

					$trigramaService->setParams($trigramaString);

					$articles = $trigramaService->getArticles();

					$profileArticleDAO->setAsDeleted($newProfile->getProfileID());

					foreach ($articles as $article){
						$foundArticle = $articleDAO->getArticle($article->getPID());

						if (!$foundArticle || !$foundArticle->getPID()){
							$articleDAO->AddArticle($article);
						} else {
							$articleDAO->UpdateArticle($article);
						}

						$foundProfileArticle = $profileArticleDAO->getProfileArticle($article->getPID(), $newProfile->getProfileID());

						$profileArticle = new ProfileArticle();

						$profileArticle->setPID($article->getPID());
						$profileArticle->setProfileID($newProfile->getProfileID());
						$profileArticle->setRelevance($article->getRelevance());
						if ($foundProfileArticle->getIsNew() == "3"){
							$profileArticle->setIsNew(0);
							$profileArticleDAO->UpdateProfileArticle($profileArticle);
						} else {
							$profileArticle->setIsNew(1);
							$profileArticleDAO->AddProfileArticle($profileArticle);
						}
					}
					$profileArticleDAO->deleteRelationship($newProfile->getProfileID());
				}
			}
		}


		function deactivateProfile($profilesToDeactivate, $userId){
			
			if ($profilesToDeactivate){
				$profileDAO = new UserProfileDAO();
				foreach ($profilesToDeactivate as $profile){
					if ($profile){
						$profile->setProfileStatus("off");
						$profile->setUserID($userId);
						$profileDAO->updateUserProfile($profile);
					}
				}
			}
		}
		

		function old_userProfileChanged($currentProfiles, $profilesFromForm, &$profilesToCreate, &$profilesToDeactivate){
			foreach ($currentProfiles as $currentProfile){
				$id = $currentProfile->getProfileID();
				$current[$id] = &$currentProfile;
			}
			foreach ($profilesFromForm as $newProfile){
				$id = $newProfile->getProfileID();
				$new[$id] = &$newProfile;
			}
	
			foreach ($new as $k=>$n){
				if ($n->getProfileText() != '') {
					if ($current[$k]){
						if ($n->getProfileText() != $current[$k]->getProfileText()){
							$profilesToCreate[$k] = &$n;
						}
					} else {
						$profilesToCreate[$k] = &$n;
					}
				}
			}
			foreach ($current as $k=>$c){
				if (!$new[$k]){
					$profilesToDeactivate[] = $k;
				}
			}
			return (!$profilesToDeactivate && !$profilesToCreate);
		}
		
	}
?>