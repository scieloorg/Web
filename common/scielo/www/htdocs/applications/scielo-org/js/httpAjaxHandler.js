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
            	xmlHttp.overrideMimeType('text/xml');                
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
function callUpdateArticleLog( serviceName )
{	
	// Informações sobre o visitante
	var browserV = navigator.appName + " ..#.. " + navigator.appCodeName + 
		" ..#.. " + navigator.appVersion + " ..#.. " + navigator.userAgent;
	var idiomaV;					
	var resolucaoV = screen.width +"X"+ screen.height+" "+ screen.colorDepth +" bits";
	var SOV = navigator.platform;	// Sistema Operacional 
	var suporteV = "";				// Mime-types suportados pelo cliente
	var tituloV = document.title;	// Titulo do Documento
	var urlV = document.URL;		// URL do Documento

	var dados = "";					// Dados a serem enviados
	var url = "/applications/scielo-org/ajax/updateLog.php";	//	url para onde mandamos os dados
	var i = 0;

	// O IE trata de um jeito a linguagem padrão, e o Firefox e Opera de outra maneira
	if(!navigator.systemLanguage)
		idiomaV = navigator.language;
	else
		idiomaV = navigator.systemLanguage;
	
	serviceName = serviceName.toString();

	// Personalizando nome dos serviços
	if(serviceName.replace(/ /g,"") == "access")
		serviceName = "estatisticas_de_acesso";
	else if(serviceName.replace(/ /g,"") == "cited_Google")
		serviceName = "citado_por_google";
	else if(serviceName.replace(/ /g,"") == "related")
		serviceName = "similares_em_scielo";
	else if(serviceName.replace(/ /g,"") == "related_Google")
		serviceName = "similares_em_google";
	else if(serviceName.replace(/ /g,"") == "send_mail")
		serviceName = "enviar_este_artigo_por_email";
	else if(serviceName.replace(/ /g,"") == "cited_SciELO"){
		serviceName = "citado_por_scielo";
	}


	if(navigator.appName != "Microsoft Internet Explorer")
	{
		// Agora sabemos por exemplo se o visitante suporta Flash, Applet, etc...
		for(i = 0; i < navigator.mimeTypes.length - 1; i++)
			suporteV += navigator.mimeTypes[i].type + " ..#.. ";
		suporteV += navigator.mimeTypes[i].type;
	}
	// OBS: Implementar na proxima versão detector de mimetypes para o IE 

	dados = (String)("servico=" + serviceName + "&browser=" + browserV.replace(/;/g, " ") 
		+ "&idioma=" + idiomaV.replace(/;/g, " ") + "&resolucao=" + resolucaoV.replace(/;/g, " ") 
		+ "&SO=" + SOV.replace(/;/g, " ") + "&suporte=" + suporteV.replace(/;/g, " ") 
		+ "&url=" + escape(urlV.replace(/;/g, " ")) + "&titulo=" + escape(tituloV.replace(/;/g, " ")) );

	// inicializa a XMLHttpRequest
	httpInit();
	
	xmlHttp.open("POST", url, true);
	xmlHttp.onreadystatechange = UpdateRate;  

	// Definimos os Headers para usarmos o método POST
	xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded"); 
	xmlHttp.setRequestHeader("Content-Length",dados.length);
	xmlHttp.setRequestHeader("Cache-Control","no-store, no-cache, must-revalidate");
	xmlHttp.setRequestHeader("Cache-Control","post-check=0, pre-check=0");
	xmlHttp.setRequestHeader("Pragma", "no-cache");
	
	// Enviamos os dados via POST
    xmlHttp.send(dados);	
}

function UpdateRate(){
    //var resultPortlet = document.getElementById("searchResult");
    //var result = document.getElementById("result");
    //var buffer = "";
    //resultPortlet.style.display="block"; 

    //result.innerHTML = "<div align='center'><img src='../image/common/loading.gif' border='0'></div>";

    if (xmlHttp.readyState == 4) {

        if (xmlHttp.status == 200) {		
      	    //var responseXml = xmlHttp.responseXML;
   			var responseText = xmlHttp.responseText; 
			rateResult = responseText;  //descomentado

        }
		else {
			alert(xmlHttp.status);
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