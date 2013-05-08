<?php
require_once('journalmanager.php');
$data = get_press_release($_REQUEST['id'], $_REQUEST['pid'], $_REQUEST['lng']);

$allowed_interface_languages = array('pt', 'es', 'en');
$allowed_content_languages = array('pt', 'es', 'en','it','ge','fr');

if (in_array($_REQUEST['lng'], $allowed_languages)){
  $lng = $_REQUEST['lng'];
}else{
  $lng = 'en';
}

if (in_array($_REQUEST['tlng'], $allowed_languages)){
  $tlng = $_REQUEST['tlng'];
}else{
  $tlng = 'en';
}

  $url = '/scielo.php?script=sci_issutoc&pid='.substr($_REQUEST['pid'], 0, 19).'&tlng='.$tlng;

?>
<!DOCTYPE html>
<html>
  <head>
  <meta http-equiv="Content-Type" content="text/xhtml; charset=utf-8"/>
  <title>SciELO - Scientific Electronic Library Online</title>
  <link rel="stylesheet" href="/applications/scielo-org/css/public/style-en.css" type="text/css" media="screen"></link>
  </head>
  <body>
    <div class="container">
      <div class="level2">
        <div class="top">
          <div id="parent">
            <img src="/img/<?=$lng?>/scielobre.gif" alt="SciELO - Scientific Electronic Library Online"></img>
          </div>
        </div>
        <div class="middle">
          <div id="collection">
            <h3>PRESS RELEASE</h3>
            <div class="content">
                <?foreach ($data['meta'] as $meta) {?>
                <?if ($data['prs']['type'] === 'issue'){?>
                  <?$url = '/scielo.php?script=sci_issuetoc&pid='.$meta['issue']['id'].'&tlng='.$tlng;?>
                <?}else{?>
                  <?$url = '/scielo.php?script=sci_arttext&pid='.$meta['article']['id'].'&tlng='.$tlng;?>
                <?}?>
                <h3 style="font-size: 90%;">
                  <?=$meta['citation']?>
                  <a href="javascript:void(0);"
                     class="nomodel"
                     style="text-decoration: none;"
                     onclick="if (window.opener) { window.opener.location.href = '<?=$url?>'; window.close(); } else { window.location.href = '<?=$url?>';}"
                     rel="nofollow">See the <?=$data['prs']['type']?></a>
                </h3>
                <?}?>
              <?=$data['prs']['content']?>
            </div> <!-- content -->
          </div> <!-- collection -->
        </div> <!-- middle -->
      </div> <!-- level2 -->
    </div> <!-- container -->
  </body>
</html>
