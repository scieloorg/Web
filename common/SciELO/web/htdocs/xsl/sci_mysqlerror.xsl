<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:template match="MYSQL_ERROR">
	
    <html>
	<head>
		<meta http-equiv="Pragma" content="no-cache"/>
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
		<style type="text/css">
			a {  text-decoration: none}
		</style>
		<title>
            <xsl:choose>
                <xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">MySql Error</xsl:when>
                <xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Erro de MySql</xsl:when>
                <xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Error de MySql</xsl:when>                                    
            </xsl:choose>        
        </title>
	</head>
	<body>
		<table cellspacing="0" border="0" cellpadding="7" width="600" align="center">
		<tr>
		<td valign="top" width="20%">
			<a>
				<xsl:attribute name="href">http://<xsl:value-of select="CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of 
					select="CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php/lng_<xsl:value-of 
					select="CONTROLINFO/LANGUAGE" /></xsl:attribute>
					 
					<img> 
						<xsl:attribute name="src"><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG" /><xsl:value-of 
							select="CONTROLINFO/LANGUAGE" />/fbpelogp.gif</xsl:attribute>							
						<xsl:attribute name="border">0</xsl:attribute>
						<xsl:attribute name="alt">Scientific Electronic Library Online</xsl:attribute>							
					</img><br/>
					
				<font size="1">Browse SciELO</font>
			</a>
		</td>
		<td width="80%">

		<xsl:choose>
			<xsl:when test="CONTROLINFO/LANGUAGE='en'">
				<font face="VERDANA" size="3" color="blue">
					<b>MySql database error</b>
				</font><br/><br/>
				<font face="verdana" size="2" color="black">
					<b>Error:&#160;<xsl:value-of select="ERRORCODE" /></b>
				</font><br/><br/>
				<font face="verdana" size="2" color="#800000">
					Click on the SciELO logo to browse the SciELO Library or use the browser "BACK" button to return to the previous page.<br/><br/>Please feel free to email us your questions, comments or concerns using the link below.
				</font>				
			</xsl:when>

			<xsl:when test="CONTROLINFO/LANGUAGE='pt'">
				<font face="VERDANA" size="3" color="blue">
					<b>Erro de banco de dados MySql</b>
				</font><br/><br/>
				<font face="verdana" size="2" color="black">
					<b>Erro:&#160;<xsl:value-of select="ERRORCODE" /></b>
				</font><br/><br/>
				<font face="verdana" size="2" color="#800000">
					Clique no logo da SciELO para visualizar a Biblioteca SciELO ou use o botão "BACK" do browser para voltar à página anterior.<br/><br/>Por favor envie-nos um email com suas perguntas, comentários ou sugestões usando o link abaixo.				</font>
			</xsl:when>

			<xsl:when test="CONTROLINFO/LANGUAGE='es'">
				<font face="VERDANA" size="3" color="blue">
					<b>Error de banco de datos MySql</b>
				</font><br/><br/>
				<font face="verdana" size="2" color="black">
					<b>Error:&#160;<xsl:value-of select="ERRORCODE" /></b>
				</font><br/><br/>
				<font face="verdana" size="2" color="#800000">
					Clique en el logo de SciELO para revisar la Biblioteca SciELO o use el botón "BACK" del visualizador para volver a la página anterior.<br/><br/>Agradeceríamos que nos enviaran emails con cualquier pregunta, comentario o sugerencia usando el link que aparece a continuación.
				</font>
			</xsl:when>
		</xsl:choose>
		
		</td>
		</tr>
		</table><br/>
		<center>
		<a>
			<xsl:attribute name="href">mailto:<xsl:value-of select="EMAIL" /></xsl:attribute>
			<img>
				<xsl:attribute name="src"><xsl:value-of 
					select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG" /><xsl:value-of 
					select="CONTROLINFO/LANGUAGE" />/e-mailt.gif</xsl:attribute>
				<xsl:attribute name="border">0</xsl:attribute>
				<xsl:attribute name="alt"><xsl:value-of select="EMAIL" /></xsl:attribute>
			</img>
		</a>
		</center>    
    </body>
    </html>
    
</xsl:template>

</xsl:stylesheet>

