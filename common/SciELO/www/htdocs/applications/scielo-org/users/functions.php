<?
/**
*
*Funções "úteis"
*
*@package	Scielo.org
*@version      1.2
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
require_once(dirname(__FILE__)."/../classes/domit-1/xml_domit_lite_include.inc.php");
require_once(dirname(__FILE__)."/../../../php/include.php");

/**
*Extrai os titulos do XML
*
* Retorna (se possivel) o Titulo do artigo no mesmo idioma da interface Scielo,
* se não encontra um Titulo no idioma corrente retorna o 1o titulo encontrado
*
*@param String authorsXML XML contendo os titulos
*@retuns String String com titulo
*/
function getTitle($titleXML)
{
    $domLiteDocument =& new DOMIT_Lite_Document();
    $domLiteDocument->parseXML($titleXML);
    $nodes =& $domLiteDocument->getElementsByPath("/TITLES/TITLE");
    /*
    por padrão vai o primeiro title que ele achar
    */
    $node = $nodes->item(0);
    if($node)
        $article_title = $node->getText();
    /*
    procura um titulo no lang corrente para exibir
    */
    for($j = 0; $j < $nodes->getLEngth(); $j++)
	{
        $node = $nodes->item($j); 
        $lang_article = $node->getAttribute("LANG");
        if($lang_article == $lang)
        $article_title = $node->getText();
    }
    return  $article_title;
}

/**
*Extrai os autores do XML e retorna uma String com os nomes em forma de link
*
*Para cada autor no XML, monta um link para pesquisa no IAH do Scielo onde
*o artigo esta.
*
*@param String authorsXML XML contendo os autores
*@param boolean link Informa se a função irá devolver uma string com Links para busca por autor via iAH na Instancia
*@param String domain Dominio da instancia Scielo para onde será apontada a busca pelo autor
*@retuns String String com os autores com ou sem link para pesquisa iAH
*/
function getAutors($authorsXML, $link=false,$domain=""){

    $domLiteDocument =& new DOMIT_Lite_Document();
    $sucess = $domLiteDocument->parseXML(str_replace("\\\\\\","",$authorsXML));

	$article_autors = "";
/**
* $sucess indica que o XML foi "parseado" com sucesso, e é bem formado
*/
	if($sucess)
	{
		$names =& $domLiteDocument->getElementsByPath("//NAME");
		$surnames =& $domLiteDocument->getElementsByPath("//SURNAME");

		for($n = 0; $n < $names->getLEngth();$n++)
		{
			$nameNode = $names->item($n);
			$surnameNode = $surnames->item($n);

			$nameText = $nameNode->getText();
			$surnameText = $surnameNode->getText();
			$searchText = str_replace(" ","+",$nameText . $surnameText);

			if(!$link)
			{
				$article_autors .= $surnameText .", ".$nameText."; ";
			}else{
				$searchText = urlencode(str_replace(" ","+",$surnameText ." " .$nameText));
				if(!strstr($domain,"http://"))
				{
					$domain = "http://".$domain;
				}
				$url = $domain."/cgi-bin/wxis.exe/iah/?IsisScript=iah/iah.xis&base=article^dlibrary&format=iso.pft&lang=i&nextAction=lnk&indexSearch=AU&exprSearch=".$searchText;

				$article_autors .= '<a href="'.$url.'" target="blank">'. $surnameText .", ".$nameText."; </a> ";
			}
		}
	}
		$article_autors = substr($article_autors,0,strlen($article_autors)-1);
		return $article_autors;
}

/**
*Exporta dados bibliográficos para BibTex
*
*Exporta dados bibliográficos para BibTex
*
*@param String entryType Tipo de referencia (livro, artigo, etc) caso seja fornecida uma referencia invalida sera retornada uma msg de erro contendo a lista válida de entidades
*@param Array fields Array associativo 'field' => 'valor', se informado, será ignorado os demais argumentos
*@param String author 
*@param String title
*@param String journal
*@param String volume
*@param String number
*@param String year
*@param String abstract
*@returns String Os dados do artigo no formato BibTex
*/
function export2BibTeX($entryType = '', $fieldsArray=array(), $author = '', $title = '', $journal = '',
																$volume = '', $number = '', $year = '', $abstract = ''){

/**
*"Carimbo" de um registro BibTex
*/

$BibTeXRecord = "@entryType{citKey,\nfields\n}";

/**
*Tipos de entidade padrão
*/
	$entryTypes = array('article', 'book','booklet','conference','inbook','incollection',
									'inproceedings','manual','mastersthesis','misc','phdthesis',
									'proceedings','techreport','unpublished','patent','collection');
/**
*Nomes dos campos padrão
*/
	$fieldNames = array('address', 'annote', 'author', 'booktitle', 'chapter', 'crossref', 'edition', 'editor',
									'howpublished', 'institution', 'journal', 'key', 'month', 'note', 'number', 'organization',
									'pages', 'publisher', 'school', 'series', 'title', 'type', 'volume', 'year', 'affiliation',
									'abstract', 'contents', 'copyright', 'ISBN', 'ISSN', 'keywords', 'language',
									'location', 'LCCN', 'mrnumber', 'price', 'size', 'URL');

	if(!in_array($entryType,$entryTypes))
	{
		return "Os tipos de registro válidos são: ".print_r($entryTypes,true);
	}
/**
* Se esta usando o parametro fields, verifica se todos os nomes de campos estao OK, depois monta o registro
*/


	if(count($fieldsArray) > 0)
	{

		$fieldErrors = "";

		//verificando se os campos sao "validos"
		foreach($fieldsArray as $field => $value )
		{
			if(!in_array($field, $fieldNames)){
				$fieldErrors .= " ". $field ." ";
			}else{
				$fields .= "\t".$field . " = {" .$value."},\n";
			}
		}
		//se tem erros retorna quais os campos invalidos . . .
		if($fieldErrors != "")
		{
			return "Os seguintes campos sao invalidos: " . $fieldErrors;
		}else{
			//tirando a virgula "extra" que sobra
			$fields = substr($fields, 0, strlen($fields)-2);
		}
	}else{
/**
* Se não esta usando o parametro fields, monta o registro com os valores não nulos dos demais parametros
*/	
		$fields = "";


		if($author != ""){
			$fields .= "\tauthor = {".$author."},\n";
		}
		if($title != ""){
			$fields .= "\ttitle = {".$title."},\n";
		}

		if($journal != ""){
			$fields .= "\tjournal = {".$journal."},\n";
		}

		if($volume != ""){
			$fields .= "\tvolume = {".$volume."},\n";
		}
		if($number != ""){
			$fields .= "\tnumber = {".$number."},\n";
		}
		if($year != ""){
			$fields .= "\tyear = {".$year."},\n";
		}
		if($abstract != ""){
			$fields .= "\tabstract = {".$abstract."},\n";
		}

		if($fields != "")
		{
			//tirando a virgula "extra" que sobra
			$fields = substr($fields, 0, strlen($fields)-2);
		}else{
			return "Informe uma matriz contendo os campos=>valores ou preencha os demais parametros de chamada";
		}
	}
/**
* Se ele o PHP chegou até aqui é pq não deu erro.
*/
	$search = array('@entryType@si',"@citKey@si","@fields@si");
	$replace = array($entryType, 'scielo:cit', $fields);

	return preg_replace($search, $replace, $BibTeXRecord);
}


?>
