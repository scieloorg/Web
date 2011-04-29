<?php
  $redirect = "./scielo.php";
  if ($_REQUEST['lang'])
          $redirect .= "?lang=" . $_REQUEST['lang'];

  header("Location: " . $redirect);
?>