<?php


	class ArticleReferenceService {

		function ArticleReferenceService(){			
		}
		function setXSLTransformer($t){
			$this->transformer = $t;								
		}
		/*
		Este servi�o retorna a refer�ncia bibliogr�fica de um artigo SciELO.

		Usa 
		http://xxx.scielo.xx/scielo.php?script=sci_isoref&pid=S0034-89102008000300001&lng=en&presentation=onlyref&format=&standard

		que � o mesmo script de "Como citar", acrescido dos par�metros presentation, format, standard. 
		Sem estes par�metros resulta na p�gina "como citar".
		Com estes par�metros resulta no texto da refer�ncia:
		format= full ou short (default)
		standard = vancouv-e, nbr6023-e, iso-e (default)
		textLink = true, se desej�vel ter o link para o artigo no t�tulo do artigo

		As modifica��es foram m�nimas. 
		J� havia a sci_artref.xsl que j� continha como a refer�ncia � feita nas normas iso, abnt, vancouver para formato eletr�nico.
		Modifiquei o sci_isoref.xsl para verificar qual o tipo de apresenta��o s� refer�ncia ou p�gina como citar e aplicar o template correspondente � esta escolha. 
		Modifiquei sci_artref.xsl por causa dos par�metros format e standard.
		*/
		function getReferenceByPid($server, $pid_or_arrayPid, $interfaceLang, $textLang, $textLink = false, $standard = 'iso-e', $format='short', $sep = '<br/>'){			
                  if (is_array($pid_or_arrayPid)){
                          foreach ($pid_or_arrayPid as $pid_item){
                                  $textref .= $this->getReference($pid_item, $interfaceLang, $textLang, $textLink, $standard, $format).$sep;
                          }
                  } else {
                          $parameters = '&pid='.$pid_or_arrayPid.'&tlng='.$textLang.'&lng='.$interfaceLang.'&presentation=onlyref&format='.$format.'&standard='.$standard.'&textlink='.$textLink;

                          if (!$textref) {
                                  $call = $server.'/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_isoref.xis&def=scielo.def.php&nrm=iso&sln=en&script=sci_isoref&PATH_TRANSLATED=../htdocs/'.$parameters;

                                  $xml = file_get_contents($call);
                                  if ($xml) {
                                          $pathXSL = substr($xml, strpos($xml, '<PATH_XSL>')+ strlen('<PATH_XSL>'));
                                          $pathXSL = substr($pathXSL, 0, strpos($pathXSL, '</PATH_XSL>'));

                                          $this->transformer->setXslBaseUri($pathXSL);
                                          $this->transformer->setXml($xml);
                                          $this->transformer->setXslFile($server."/xsl/sci_isoref.xsl");
                                          $this->transformer->transform();

                                          $textref = $this->transformer->getOutput()."<!-- fez corretamente -->";
                                  }
                          }

                  }

                  //mb_detect_encoding($textref, "ISO-8859-1", "UTF-8");
                  return $textref;
		}
		function getFormattedReference($article, $interfaceLang, $textLang, $textLink = false){			
			switch ($interfaceLang){
				case "en":
					$v  = "v. "; $i = "n. "; $s = "suppl. "; $and = " and ";
					break;
				case "es":
					$v  = "vol. "; $i = "no. "; $s = "supl. "; $and = " y ";
					break;
				case "pt":
					$v  = "vol. "; $i = "no. "; $s = "supl. "; $and = " e ";
					break;
			}
			
			$author = $article->getAuthors($article->getAuthorXML(), 1, $article->getURL(), 'iso', $and);
			if ($author || $article->getTitle()){
				$textref = $author.'. ';
				$textref .= '<b>';
				if ($textLink){
					$textref .= '<a href="'.$article->getURL().'/scielo.php?script=sci_arttext&pid='.$article->getPID().'&tlng='.$textLang.'&lng='.$interfaceLang.'">';
				}
				$textref .= $article->getTitleByLang($article->getTitle(), $interfaceLang);
				if ($textLink){
					$textref .= '</a>';
				}
				$textref .= '</b>. ' ;
				$textref .= $article->getSerial(). ' '.$article->getYear().', ';
				$textref .= $v.$article->getVolume();
				
				if ($article->getVolume() && $article->getNumber()){
					$textref .= ', ';
					$textref .= $i.$article->getNumber();
				}
				
				if (($article->getVolume() || $article->getNumber()) && $article->getSuppl()){
					$textref .= ', ';
					$textref .= $article->getSuppl();
				}

				if ($article->getPages()) {
					if ($article->getVolume() || $article->getNumber()) $textref .= ', ';
					$textref .= 'pp. '.$article->getPages();	
				}
				
				$textref .= '.';
				$textref .= ' ISSN '.$article->getISSN();
				$textref .= '.';
			}
			return $textref;

			/*
			CAMPOS, C�lia Maria Teixeira de, HAMAD, Ant�nio Jos� Sim�es, AMANTE, Edna Regina et al.  Protein profile in freeze-dried chicken embryo eggs with different periods of development. Braz. J. Vet. Res. Anim. Sci., 2003, vol.40 suppl.1, p.9-13. ISSN 1413-9596.
			*/
		}
	}

?>