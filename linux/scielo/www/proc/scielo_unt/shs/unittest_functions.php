<?
$ERRORS[0]="WXIS|missing error|parameter|IsisScript expected|";
$ERRORS[1]="WXIS|fatal error|unavoidable|trmread/leaf/less|";
$ERRORS[2]="WXIS|fatal error|unavoidable|leafread/ock|";
$ERRORS[3]="WXIS|missing error";
$ERRORS[4]="WXIS|fatal error";
$ERRORS[5]="WXIS|execution error";

function getErrors($content,$url){
	global $ERRORS;
	for ($i=0 ; $i<count($ERRORS) ; $i++){

		$pos = strpos($content, $ERRORS[$i]);
		if (!($pos === false)) {
			echo "ERROR FOUND: ".$ERRORS[$i]." - ".$url."\n";
			return;
		}

	}
}

function formatURL($URL){
	$URL = str_replace(' ','%20',$URL);
	return $URL;
}
?>
