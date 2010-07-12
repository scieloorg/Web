<?
/**
*
*Fun��es "�teis"
*
*@package	Scielo.org
*@version      1.2
*@author       Andr� Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/
require_once(dirname(__FILE__)."/../classes/domit-1/xml_domit_lite_include.inc.php");
require_once(dirname(__FILE__)."/../../../php/include.php");

/**
 * Extrai os titulos do XML
 * 
 * Retorna (se possivel) o Titulo do artigo no mesmo idioma da interface Scielo,
 * se n�o encontra um Titulo no idioma corrente retorna o 1o titulo encontrado
 * 
 * 07/08/2007 -> Adicionado o parametro lang. Antes as vezes tinha no mesmo idioma,
 * mas retornava de outro porque $lang era NULL
 *
 * @param String authorsXML XML contendo os titulos
 * @retuns String String com titulo
 */
function getTitle($titleXML, $lang = '')
{
    $domLiteDocument =& new DOMIT_Lite_Document();
    $domLiteDocument->parseXML($titleXML);
    $nodes =& $domLiteDocument->getElementsByPath("/TITLES/TITLE");
    /*
    por padr�o vai o primeiro title que ele achar
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

    return  utf8_encode($article_title);
}

/**
*Extrai os autores do XML e retorna uma String com os nomes em forma de link
*
*Para cada autor no XML, monta um link para pesquisa no IAH do Scielo onde
*o artigo esta.
*
*@param String authorsXML XML contendo os autores
*@param boolean link Informa se a fun��o ir� devolver uma string com Links para busca por autor via iAH na Instancia
*@param String domain Dominio da instancia Scielo para onde ser� apontada a busca pelo autor
*@retuns String String com os autores com ou sem link para pesquisa iAH
*/
function getAutors($authorsXML, $link=false,$domain=""){

    $domLiteDocument =& new DOMIT_Lite_Document();
    $sucess = $domLiteDocument->parseXML(str_replace("\\\\\\","",$authorsXML));

	$article_autors = "";
/**
* $sucess indica que o XML foi "parseado" com sucesso, e � bem formado
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
		return utf8_encode($article_autors);
}

/**
*Exporta dados bibliogr�ficos para BibTex
*
*Exporta dados bibliogr�ficos para BibTex
*
*@param String entryType Tipo de referencia (livro, artigo, etc) caso seja fornecida uma referencia invalida sera retornada uma msg de erro contendo a lista v�lida de entidades
*@param Array fields Array associativo 'field' => 'valor', se informado, ser� ignorado os demais argumentos
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
*Tipos de entidade padr�o
*/
	$entryTypes = array('article', 'book','booklet','conference','inbook','incollection',
									'inproceedings','manual','mastersthesis','misc','phdthesis',
									'proceedings','techreport','unpublished','patent','collection');
/**
*Nomes dos campos padr�o
*/
	$fieldNames = array('address', 'annote', 'author', 'booktitle', 'chapter', 'crossref', 'edition', 'editor',
									'howpublished', 'institution', 'journal', 'key', 'month', 'note', 'number', 'organization',
									'pages', 'publisher', 'school', 'series', 'title', 'type', 'volume', 'year', 'affiliation',
									'abstract', 'contents', 'copyright', 'ISBN', 'ISSN', 'keywords', 'language',
									'location', 'LCCN', 'mrnumber', 'price', 'size', 'URL');

	if(!in_array($entryType,$entryTypes))
	{
		return "Os tipos de registro v�lidos s�o: ".print_r($entryTypes,true);
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
* Se n�o esta usando o parametro fields, monta o registro com os valores n�o nulos dos demais parametros
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
* Se ele o PHP chegou at� aqui � pq n�o deu erro.
*/
	$search = array('@entryType@si',"@citKey@si","@fields@si");
	$replace = array($entryType, 'scielo:cit', $fields);

	return preg_replace($search, $replace, $BibTeXRecord);
}


?>
