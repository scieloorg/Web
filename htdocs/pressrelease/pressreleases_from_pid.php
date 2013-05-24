<?php
require_once('journalmanager.php');

$prs = get_press_releases_by_pid($_REQUEST['pid'],$_REQUEST['lng']);

print $prs;
?>
