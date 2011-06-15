<?php

    $u = $_REQUEST['url'];
    //$u = str_replace('|', '&', $_REQUEST['url']);
    //$u = str_replace('!', '?', $_REQUEST['url']);
    switch ($_REQUEST['translator']) {
        case 'google':
            $call = 'http://translate.google.com/translate?sl='.$_REQUEST['tlang'].'&tl='.$_REQUEST['tlang2'].'&u='.urlencode($u).'&skpa=on';
            break;
        case 'win':
            $call = 'http://www.microsofttranslator.com/BV.aspx?ref=AddIn&lp='.$_REQUEST['tlang'].'_'.$_REQUEST['tlang2'].'&a='.urlencode($u).'&skpa=on';
            break;
    }
    $defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def.php", true);

    if ($defFile['LOG']['ACTIVATE_LOG']){
        if ($defFile['LOG']['SERVER_LOG'] && $defFile['LOG']['SCRIPT_LOG_NAME'] && $defFile['LOG']['ACCESSSTAT_LOG_DIRECTORY']){
            $imgUrl = 'http://';
            $imgUrl .= $defFile['LOG']['SERVER_LOG'];
            $imgUrl .= '/' . $defFile['LOG']['SCRIPT_LOG_NAME'];
            //$imgUrl .= '?app=' . $defFile['SITE_INFO']['APP_NAME'];
            $imgUrl .= '?app=' . $_SERVER["HTTP_HOST"];
            $imgUrl .= '&page=transl-'.$_REQUEST['script'].'-' . $_REQUEST['tlang'].'-'.$_REQUEST['tlang2'];
            $imgUrl .= '&pid=' . $_REQUEST['pid'];
            $imgUrl .= '&lang=' . $_REQUEST['lang'];
            $imgUrl .= '&tlng=' . $_REQUEST['tlang'];

            $strReturn = file_get_contents($imgUrl);
        }
    }
   
    header('Location: '.$call);
?>
