<?php 
 include ("classLogDatabaseQueryScieloIssue.php");

 $scieloLogQueryIssue = new LogDatabaseQueryScieloIssue("scielo.def");

 $scieloLogQueryIssue->mostRequested_ISSN($pid,$dti,$dtf,$access,$cpage,$nlines,$tpages,$maccess);
 $scieloLogQueryIssue->destroy();
 $scieloLogQueryIssue = null;

?>