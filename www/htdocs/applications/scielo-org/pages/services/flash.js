/**
 * O IE quando vai renderizar um swf ele coloca bordas
 * para resolver isso basta chamar o swf de um javascript externo
 */
function GerarSWF(url, largura, altura)
{
	document.writeln( '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"' +
		'codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0"'+
		'width="'+largura+'" height="'+ altura +'" id="graph-2" align="middle">');
	document.writeln('<param name="allowScriptAccess" value="sameDomain" />');
	document.writeln( '<param name="movie" value="open-flash-chart.swf?width='+ largura +
		'&height='+ altura+ '&data='+ url +'" /><param name="quality" value="high" />'+
		'<param name="bgcolor" value="#FFFFFF" />');
	document.writeln( '<embed src="open-flash-chart.swf?width='+ largura +'&height='+ altura+ 
		'&data='+ url +'" quality="high" bgcolor="#FFFFFF" width="'+largura+'" height="'+altura+
		'" name="open-flash-chart" align="middle" allowScriptAccess="sameDomain" '+
		'type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />');
	document.writeln( '</object>');
}