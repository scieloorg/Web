<?php

/**
 * O Flash não encherga como deveria o & e outras caracteres para isso 
 * precisamos converter a url para que ele não ignore 
 * as variaveis apos o & da pagina requestGraphic
 *
 */
function flashentities($string)
{
	return str_replace(array("&","'"),array("%26","%27"),$string);
}

/* Estamos usando a função que esta no arquivo flash.js, por causa de um bug do IE */
function open_flash_chart_object( $width, $height, $url )
{
  echo '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="'.$width.'" height="'.$height.'" id="graph-2" align="middle">';
  echo '<param name="allowScriptAccess" value="sameDomain" />';
  echo '<param name="movie" value="open-flash-chart.swf?width='. $width .'&height='. $height .'&data='. flashentities($url) .'" /><param name="quality" value="high" /><param name="bgcolor" value="#FFFFFF" />';
  echo '<embed src="open-flash-chart.swf?width='. $width .'&height='. $height .'&data='. flashentities($url) .'" quality="high" bgcolor="#FFFFFF" width="'. $width .'" height="'. $height .'" name="open-flash-chart" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />';
  echo '</object>';
}

?>
