<?php
require_once('journalmanager.php');

$articles_prs = get_issues_press_releases_by_journal_id($_REQUEST['id']);

echo('<ul class="pressReleases">');
foreach ($articles_prs as $article){
    echo('<li>');
    echo('<a href="/pressrelease/pressrelease_display.php?id='.$article['id'].'"><b>'.substr($article["created_at"], 0, 7).' '.$article["issue_label"].'</b><br/>'.substr($article["title"], 0, 10).'</a>');
    echo('</li>');
}
echo('</ul>');
?>