var xmlHttp = false;
var metaengine = "";
var rateResult = "";


function httpInit()
{
	if (window.XMLHttpRequest)
	{ // Mozilla, Safari,...
		xmlHttp = new XMLHttpRequest();

		if (xmlHttp.overrideMimeType)
		{
            	xmlHttp.overrideMimeType('text/plain');
        }
     }else if (window.ActiveXObject)
		{ // IE
			try {
           		xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
        	}
			catch (e){
        		try {
        			xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        		}catch (e) {
				}
        	}
     	}
		if (!xmlHttp) {
    	   	alert('Cannot create an XMLHTTP instance');
       		return false;
    	}
}


/**
 * Pega todas as informações possíveis sobre o visitante, alem de incrementar
 * o log de acesso de serviços
 *
 * @author Deivid Martins
 * @param serviceName String nome do serviço acessado
 *
 */
function callUpdateArticleLog( serviceName ) /* modified by Gustavo Fonseca (gustavo.fonseca@bireme.org) */
{
	var urlV = document.URL; /* URL do Documento */
	var pid = urlV.substr(urlV.lastIndexOf('pid=')+4,23);
	var lang = urlV.substr(urlV.lastIndexOf('tlng=')+5,2);

	var dados = "";	/* Dados a serem enviados */
	var url = "/applications/scielo-org/ajax/updateIsisLog.php"; /* url para onde mandamos os dados */

	serviceName = serviceName.toString();

	dados = (String)("?serviceName=" + serviceName + "&pid=" + pid + "&lang=" + lang);

	/* inicializa a XMLHttpRequest */
	httpInit();
	xmlHttp.open("GET", url+dados, true);
	xmlHttp.onreadystatechange = UpdateRate;

    xmlHttp.send(null);
}

function UpdateRate(){
    if (xmlHttp.readyState == 4) {
        if (xmlHttp.status == 200) {
   			ajaxResponse = xmlHttp.responseText;
        }
    }
}

function httpClose(){
	xmlHttp.abort();
}
function portletClose(portletId){
	httpClose();
    var portlet = document.getElementById(portletId);
    portlet.style.display = "none";
    return;
}
