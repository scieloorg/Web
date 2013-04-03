<?php
require_once('journalmanager.php');
$data = get_press_release($_REQUEST['id']);

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

?>
<html>
  <head>
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
            <h3>
              PRESS RELEASE (
                    <a href="javascript:void(0);"
                       class="nomodel"
                       style="text-decoration: none;"
                       onclick="if (window.opener) { window.opener.location.href = '<?=$data['prs']['url']?>'; window.close(); } else { window.location.href = '<?=$data['prs']['url']?>';}"
                       rel="nofollow">See the <?=$data['prs']['type']?></a> )
            </h3>
            <div class="content">
              <h3 style="font-size: 90%;">
                <?=$data['citation']?>
              </h3>
              <h1><?=$data['prs']['title'][$tlng]?></h1>
              <?=$data['prs']['body'][$tlng]?>
            </div> <!-- content -->
          </div> <!-- collection -->
        </div> <!-- middle -->
      </div> <!-- level2 -->
    </div> <!-- container -->
  </body>
</html>