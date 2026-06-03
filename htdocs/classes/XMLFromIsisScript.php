<?php

class XMLFromIsisScript {
    var $_xml;
    var $_pdfLink;
    var $_labels;

    function __construct($xml)
    {
        $this->XMLFromIsisScript($xml);
    }

    function XMLFromIsisScript($xml)
    {
        $this->_xml = $xml;
        $this->_pdfLink = "";
        $this->_labels = array();
    }

    function setPdfLink($pdfLink, $label)
    {
        $this->_pdfLink = $pdfLink;
        $this->_labels = ($label !== null && $label !== "") ? explode(';', $label) : array();
    }

    function getXml()
    {
        $this->_xml = $this->fixUtfEntities($this->_xml);
        $this->_xml = $this->replaceThisByContent($this->_xml);

        $p = strpos($this->_xml, '<BODY>');
        $p2 = strrpos($this->_xml, '</BODY>');

        if ($p === false || $p2 === false) {
            $p = strpos($this->_xml, '<body>');
            $p2 = strrpos($this->_xml, '</body>');
        }

        if ($p === false || $p2 === false || $p2 < $p) {
            return $this->_xml;
        }

        $body = substr($this->_xml, $p, $p2 - $p + 1);
        $xbody = $body;

        if (count($this->_labels) > 0 && strlen($this->_pdfLink) > 0) {
            foreach ($this->_labels as $l) {
                if ($l === "") {
                    continue;
                }
                $xbody = str_replace($l, '<a href="' . str_replace('&', '&amp;', $this->_pdfLink) . '">' . $l . '</a>', $xbody);
                if (strpos($l, 'dispo') !== false && ($xbody == $body)) {
                    $xbody = str_replace(scielo_utf8_encode($l), '<a href="' . str_replace('&', '&amp;', $this->_pdfLink) . '">' . $l . '</a>', $xbody);
                }
            }
        }

        if ($xbody != $body) {
            $this->_xml = substr($this->_xml, 0, $p) . $xbody . substr($this->_xml, $p2 + 1);
        }

        return $this->_xml;
    }

    function getSpecialXSL()
    {
        if (strpos($this->_xml, '<mml:math ') !== false) {
            $xsl = "_mathml";
        } else {
            $xsl = "_html";
        }
        return $xsl;
    }

    function fixUtfEntities($s)
    {
        $s = str_replace(chr(32) . chr(150) . chr(32), '&#32;&#150;&#32;', $s);
        $s = str_replace('�', '&#150;', $s);

        $s = str_replace(chr(31), '', $s);
        $s = str_replace('&#x2028;', '<p/>', $s);
        $s = str_replace('&#710;', '^', $s);
        $s = str_replace(' & ', ' &amp; ', $s);

        return $s;
    }

    function replaceThisByContent($parXML)
    {
        $xml = $parXML;

        $filename = $this->getContent('replace-this-by-content', $xml);

        if ($filename) {
            $filecontent = $this->returnBody($this->read($filename));

            $body = $this->getContent('part1', $filecontent);
            if ($body) {
                $references = $this->getContent('refs', $filecontent);
                $back = $this->getContent('part2', $filecontent);

                if ($references) {
                    $array_ref_original = explode('<!-- ref -->', $xml);
                    $array_ref_translation = explode('[citation]', $references);

                    $k = 0;
                    foreach ($array_ref_original as $item) {
                        if ($k && isset($array_ref_translation[$k])) {
                            $newItemEnd = strpos($item, '<!-- end-ref -->');
                            if ($newItemEnd !== false) {
                                $newItem = substr($item, 0, $newItemEnd);
                                $oldClose = strpos($array_ref_translation[$k], '[/citation]');
                                if ($oldClose !== false) {
                                    $oldItem = substr($array_ref_translation[$k], 0, $oldClose);
                                    $references = str_replace('[citation]' . $oldItem . '[/citation]', $newItem, $references);
                                }
                            }
                        }
                        $k++;
                    }
                }
                $filecontent = '<!-- inicio arquivo -->' . $body . $references . $back . '<!-- fim arquivo -->';
                $xml = $this->replaceBody($xml, $filecontent);
            } else {
                $body = $filecontent;
                $xml = str_replace('[replace-this-by-content]' . $filename . '[/replace-this-by-content]', '<!-- inicio arquivo -->' . $body . '<!-- fim arquivo -->', $xml);
                $xml = $this->replaceThisByContent($xml);
            }
        }

        return $xml;
    }

    function read($filename)
    {
        $s = file_get_contents($filename);
        return $s;
    }

    function getContent($tag, $s)
    {
        $x = "";
        $p = strpos($s, "[$tag]");
        if ($p !== false) {
            $x = substr($s, $p + strlen("[$tag]"));
            $p = strpos($x, "[/$tag]");
            if ($p !== false) {
                $x = substr($x, 0, $p);
            }
        }
        return $x;
    }

    function replaceBody($xml, $body)
    {
        $xmlNovo1 = "";
        $xmlNovo2 = "";

        $p = strpos($xml, "<BODY>");
        if ($p !== false) {
            $xmlNovo1 = substr($xml, 0, $p) . "<BODY><![CDATA[";
            $p = strpos($xml, "</BODY>");
            if ($p === false) {
                return $xml;
            }
            $xmlNovo2 = "]]>" . substr($xml, $p);
        } else {
            $p = strpos($xml, "<fulltext ");
            if ($p !== false) {
                $s = substr($xml, $p);
                $gt = strpos($s, ">");
                if ($gt === false) {
                    return $xml;
                }
                $p = $p + $gt + 1;
                $xmlNovo1 = substr($xml, 0, $p);
                $p = strpos($xml, "</fulltext>");
                if ($p === false) {
                    return $xml;
                }
                $xmlNovo2 = substr($xml, $p);
            }
        }

        if ($xmlNovo1 === "" && $xmlNovo2 === "") {
            return $xml;
        }

        return $xmlNovo1 . $body . $xmlNovo2;
    }

    function returnBody($body)
    {
        $bodyBegin = strpos(strtolower($body), '<body');
        if ($bodyBegin !== false) {
            $body = substr($body, $bodyBegin);
            $bodyBegin = strpos($body, '>');
            if ($bodyBegin !== false) {
                $body = substr($body, $bodyBegin + 1);
            }
        }
        $bodyEnd = strpos(strtolower($body), '</body>');
        if ($bodyEnd !== false) {
            $body = substr($body, 0, $bodyEnd);
        }
        return $body;
    }
}
?>
