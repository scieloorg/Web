<?php
class StringXML {

    function getContent($tag, $s)
    {
        $r = '';
        $p = strpos($s, "<$tag>");
        if ($p !== false) {
            $x = substr($s, $p + strlen("<$tag>"));
            $p = strpos($x, "</$tag>");
            if ($p !== false) {
                $r = substr($x, 0, $p);
            }
        }
        return $r;
    }
}
?>
