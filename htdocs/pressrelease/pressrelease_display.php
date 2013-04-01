<?php
require_once('journalmanager.php');
$data = get_press_release($_REQUEST['id']);
?>
<html>
  <head>
  <title></title>
  <link rel="stylesheet" href="/applications/scielo-org/css/public/style-en.css" type="text/css" media="screen"></link>
  </head>
  <body>
    <div class="container">
      <div class="level2">
        <div class="top">
          <div id="parent">
            <img src="/img/<?=$_REQUEST['lng']?>/scielobre.gif" alt="SciELO - Scientific Electronic Library Online"></img>
          </div>
          <div id="identification">
            <h1>
              <span>SciELO - Scientific Electronic Library Online</span>
            </h1>
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
                       rel="nofollow">See the issue</a> )
            </h3>
            <div class="content">
              <h3 style="font-size: 90%;">
                <? if ($data['prs']['type'] === 'issue'){ ?>
                  <?=$data['meta']['issue']['journal_abbrev_title']?>
                  <?=$data['meta']['issue']['vol']?>
                  <?=$data['meta']['issue']['num']?>
                  <?=$data['meta']['issue']['city']?>
                  <?=$data['meta']['issue']['year']?>
                <?}?>
                <? if ($data['prs']['type'] === 'article'){ ?>
                  <?=$data['meta']['article']['title']?>,
                  <?=$data['meta']['issue']['journal_abbrev_title']?>,
                  <?=$data['meta']['issue']['vol']?>
                  <?=$data['meta']['issue']['num']?>,
                  <?=$data['meta']['issue']['city']?>,
                  <?=$data['meta']['issue']['year']?>.
                <?}?>
              </h3>
              <?=$data['prs']['body']?>
            </div> <!-- content -->
          </div> <!-- collection -->
        </div> <!-- middle -->
      </div> <!-- level2 -->
    </div> <!-- container -->
  </body>
</html>