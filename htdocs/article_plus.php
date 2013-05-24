<?php

if ($_REQUEST['pid'] && $_REQUEST['tlng'] && $_REQUEST['lng']){

    if ($_REQUEST['debug'] == 'XML' || $_REQUEST['debug'] == 'On') {
        $url = 'http://' . $_SERVER['SERVER_NAME'] . '/scielo.php?script=sci_arttext_plus&pid=' . $_REQUEST['pid'] . '&lng=' . $_REQUEST['lng'] . '&tlng=' . $_REQUEST['tlng'] . '&nrm=iso&debug=' . $_REQUEST['debug'];

    } else {
        $url = 'http://' . $_SERVER['SERVER_NAME'] . '/scielo.php?script=sci_arttext_plus&pid=' . $_REQUEST['pid'] . '&lng=' . $_REQUEST['lng'] . '&tlng=' . $_REQUEST['tlng'] . '&nrm=iso';
    }
    $c = file_get_contents($url);
    if (strlen($c) == 0) {
    	header("Location: " . $url);
    } else {
    	echo $c;
    }
 } 
?>