<?php
require_once('journalmanager.php');

$prs = get_press_releases_by_issue_id($_REQUEST['id']);

print json_encode($prs);
?>