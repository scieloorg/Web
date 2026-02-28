<?php

class ArticleReferenceService {

    function __construct()
    {
        $this->ArticleReferenceService();
    }

    function ArticleReferenceService()
    {
    }

    function setXSLTransformer($t)
    {
        $this->transformer = $t;
    }

    function getReferenceByPid($server, $pid_or_arrayPid, $interfaceLang, $textLang, $textLink = false, $standard = 'iso-e', $format = 'short', $sep = '<br/>')
    {
        $textref = '';

        if (is_array($pid_or_arrayPid)) {
            foreach ($pid_or_arrayPid as $pid_item) {
                $textref .= $this->getReference($pid_item, $interfaceLang, $textLang, $textLink, $standard, $format) . $sep;
            }
        } else {
            $parameters = '&pid=' . $pid_or_arrayPid . '&tlng=' . $textLang . '&lng=' . $interfaceLang . '&presentation=onlyref&format=' . $format . '&standard=' . $standard . '&textlink=' . $textLink;

            // Prefer main SciELO endpoint, which already works with local WXIS execution.
            $callScielo = $server . '/scielo.php?script=sci_isoref' . $parameters;
            $textref = @file_get_contents($callScielo);
            if ($textref) {
                $textref = preg_replace('/<!DOCTYPE[^>]*>/i', '', $textref);
                $textref = preg_replace('/<!--.*?-->/s', '', $textref);
                $textref = trim($textref);
            }

            if (!$textref) {
                // Legacy fallback: direct CGI call.
                $call = $server . '/cgi-bin/wxis.exe?IsisScript=ScieloXML/sci_isoref.xis&def=scielo.def.php&nrm=iso&sln=en&script=sci_isoref&PATH_TRANSLATED=../htdocs/' . $parameters;
                $xml = @file_get_contents($call);

                if ($xml) {
                    $pathXSL = substr($xml, strpos($xml, '<PATH_XSL>') + strlen('<PATH_XSL>'));
                    $pathXSL = substr($pathXSL, 0, strpos($pathXSL, '</PATH_XSL>'));

                    $this->transformer->setXslBaseUri($pathXSL);
                    $this->transformer->setXml($xml);
                    $this->transformer->setXslFile($server . '/xsl/sci_isoref.xsl');
                    $this->transformer->transform();

                    $textref = $this->transformer->getOutput() . '<!-- fez corretamente -->';
                }
            }
        }

        return $textref;
    }

    function getFormattedReference($article, $interfaceLang, $textLang, $textLink = false)
    {
        switch ($interfaceLang) {
            case 'en':
                $v = 'v. ';
                $i = 'n. ';
                $s = 'suppl. ';
                $and = ' and ';
                break;
            case 'es':
                $v = 'vol. ';
                $i = 'no. ';
                $s = 'supl. ';
                $and = ' y ';
                break;
            case 'pt':
                $v = 'vol. ';
                $i = 'no. ';
                $s = 'supl. ';
                $and = ' e ';
                break;
        }

        $author = $article->getAuthors($article->getAuthorXML(), 1, $article->getURL(), 'iso', $and);
        if ($author || $article->getTitle()) {
            $textref = $author . '. ';
            $textref .= '<b>';
            if ($textLink) {
                $textref .= '<a href="' . $article->getURL() . '/scielo.php?script=sci_arttext&pid=' . $article->getPID() . '&tlng=' . $textLang . '&lng=' . $interfaceLang . '">';
            }
            $textref .= $article->getTitleByLang($article->getTitle(), $interfaceLang);
            if ($textLink) {
                $textref .= '</a>';
            }
            $textref .= '</b>. ';
            $textref .= $article->getSerial() . ' ' . $article->getYear() . ', ';
            $textref .= $v . $article->getVolume();

            if ($article->getVolume() && $article->getNumber()) {
                $textref .= ', ';
                $textref .= $i . $article->getNumber();
            }

            if (($article->getVolume() || $article->getNumber()) && $article->getSuppl()) {
                $textref .= ', ';
                $textref .= $article->getSuppl();
            }

            if ($article->getPages()) {
                if ($article->getVolume() || $article->getNumber()) {
                    $textref .= ', ';
                }
                $textref .= 'pp. ' . $article->getPages();
            }

            $textref .= '.';
            $textref .= ' ISSN ' . $article->getISSN();
            $textref .= '.';
        }

        return $textref;
    }
}

?>
