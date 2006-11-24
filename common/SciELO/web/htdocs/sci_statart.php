<?php 
 include ("classLogDatabaseQueryScieloArticle.php");

 $scieloLogQueryArticle = new LogDatabaseQueryScieloArticle("scielo.def");

 $scieloLogQueryArticle->mostRequested_ISSN($pid,$dti,$dtf,$access,$cpage,$nlines,$tpages,$maccess);
 $scieloLogQueryArticle->destroy();
 $scieloLogQueryArticle = null;

?>