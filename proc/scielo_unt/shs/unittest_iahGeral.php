<?
//####################################################
//#URLs do IAH na SCIELO com indices de toda a colecao
//####################################################

include_once("unittest_configure.php");
include_once("unittest_functions.php");

//Article Type
echo "Testando IAH - indice de tipo de documento \n";
$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^drbepid&format=iso.pft&lang=i&nextAction=show index&selectedIndex=^l1^nTa^pTipo de artigo^eTipo de artículo^iArticle type^xTA ^yTIPART^mTA_^tshort^rCollection&indexSearch=^nTa^pTipo de artigo^eTipo de artículo^iArticle type^xTA ^yTIPART^mTA_^tshort^rCollection";
$content = file_get_contents(formatURL($URL));
getErrors($content,$URL);


//Affiliation Organization
echo "Testando IAH - indice de Afiliação - Organização \n";
$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^dlibrary&format=iso.pft&lang=i&nextAction=show index&selectedIndex=^l1^nOr^pAfiliação - Organização^eAfiliación - Organización^iAffiliation - Organization^xOR ^yAFORG^mOR_^rCollection&indexSearch=^nOr^pAfiliação - Organização^eAfiliación - Organización^iAffiliation - Organization^xOR ^yAFORG^mOR_^rCollection";
$content = file_get_contents(formatURL($URL));
getErrors($content,$URL);


//#Affiliation Country
echo "Testando IAH - indice de Afiliação - País \n";
$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^dlibrary&format=iso.pft&lang=i&nextAction=show index&selectedIndex=^l1^nPp^pAfiliação - País, País^eAfiliación - Pais, Pais^iAffiliation - Country, Country^xPP ^yAFPAISPAIS^mPP_^rCollection&indexSearch=^nPp^pAfiliação - País, País^eAfiliación - Pais, Pais^iAffiliation - Country, Country^xPP ^yAFPAISPAIS^mPP_^rCollection";
$content = file_get_contents(formatURL($URL));
getErrors($content,$URL);


//Areas Geograficas
echo "Testando IAH - indice de Areas Geográficas \n";
$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^dlibrary&format=iso.pft&lang=i&nextAction=show index&selectedIndex=^l1^nAg^pÁreas geográficas^eGeographic areas^iÁreas geográficas^xAG ^yARTSCL^mAG_^rCollection&indexSearch=^nAg^pÁreas geográficas^eGeographic areas^iÁreas geográficas^xAG ^yARTSCL^mAG_^rCollection";
$content = file_get_contents(formatURL($URL));
getErrors($content,$URL);


$titles=parse_ini_file("issnList.txt");
$total=count($titles);
$count=0;
foreach ($titles as $key => $value) {
	$count++;
	echo $count."/".$total." - ".$value." - ".$key."\n";
	echo "Testando IAH - indice de Autor \n"; 
	$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^d".$value."&index=AU&format=iso.pft&lang=i&limit=".$key;
	$content = file_get_contents(formatURL($URL));
	getErrors($content,$URL);

        echo "Testando IAH - indice de Autor letra A \n";
	$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^d".$value."&index=AU&format=iso.pft&lang=i&limit=".$key." &indexRoot=A&nextAction=show index&selectedIndex=^l1^nAu^pAutor^eAutor^iAuthor^xAU ^yPREINV^uAU_^mAU_&indexSearch=^nAu^pAutor^eAutor^iAuthor^xAU ^yPREINV^uAU_^mAU_";
        $content = file_get_contents(formatURL($URL));
        getErrors($content,$URL);

        echo "Testando IAH - indice de Assunto letra A \n";
	$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^d".$value."&index=AU&format=iso.pft&lang=i&limit=".$key."&indexRoot=A&nextAction=show index&selectedIndex=^l1^nKw^pAssunto^eMateria^iSubject^xKW ^yPREINV^uKW_^mKW_&indexSearch=^nKw^pAssunto^eMateria^iSubject^xKW ^yPREINV^uKW_^mKW_";
        $content = file_get_contents(formatURL($URL));
        getErrors($content,$URL);

        echo "Testando IAH - indice de Resumo letra A \n";
	$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^d".$value."&format=iso.pft&lang=i&limit=".$key."&indexRoot=A&nextAction=show index&selectedIndex=^l1^nAb^pResumo^eResumen^iAbstract^xAB ^yPREINV^uAB_^mAB_&indexSearch=^nAb^pResumo^eResumen^iAbstract^xAB ^yPREINV^uAB_^mAB_";
        $content = file_get_contents(formatURL($URL));
        getErrors($content,$URL);

        echo "Testando IAH - indice de Titulo letra A \n";
	$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^d".$value."&format=iso.pft&lang=i&limit=".$key."&indexRoot=A&nextAction=show index&selectedIndex=^l1^nTi^pPalavras do título^ePalabras del título^iTitle words^xTI ^yPREINV^uTI_^mTI_&indexSearch=^nTi^pPalavras do título^ePalabras del título^iTitle words^xTI ^yPREINV^uTI_^mTI_";
        $content = file_get_contents(formatURL($URL));
        getErrors($content,$URL);

        echo "Testando IAH - indice de Ano de Publicacao \n";
	$URL = "http://".$domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^d".$value."&format=iso.pft&lang=i&limit=".$key."&nextAction=show index&selectedIndex=^l1^nYr^pAno de publicação^eAño de publicación^iPublication year^xYR ^yPREINV^uYR_^mYR_^tshort&indexSearch=^nYr^pAno de publicação^eAño de publicación^iPublication year^xYR ^yPREINV^uYR_^mYR_^tshort";
        $content = file_get_contents(formatURL($URL));
        getErrors($content,$URL);

}


echo "DONE";
?>
