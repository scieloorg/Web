<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">


<!--xsl:output method="html" encoding="iso-8859-1" /-->
<xsl:include href="sci_common.xsl"/>
<xsl:include href="sci_mysqlerror.xsl"/>

<xsl:template match="QUERY_RESULT">
	<html>
	<head>
		<title>
			<xsl:choose>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Journal articles requests by language and year</xsl:when>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Acessos a artigos de revistas por idioma e por ano</xsl:when>
				<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Accesos a artículos de revistas por idioma y por año</xsl:when>                        
			</xsl:choose>
		</title>

		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
	</head>
	
	<body bgColor="#ffffff">
		<xsl:call-template name="PrintPageHeaderInfo" />
	</body>
	
	</html>
</xsl:template>

<xsl:template name="PrintPageHeaderInfo">
	<table cellspacing="0" cellpadding="0" width="100%">
		<tr>
		<td width="20%">
		<p align="center">
			<!--a>
				<xsl:attribute name="href">http://<xsl:value-of 
						select="CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of 
						select="CONTROLINFO/SCIELO_INFO/PATH_DATA" />scielo.php?lng=<xsl:value-of
						select="CONTROLINFO/LANGUAGE" />&amp;nrm=<xsl:value-of
						select="CONTROLINFO/STANDARD" /></xsl:attribute-->

				<img>
						<xsl:attribute name="src">http://<xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_DATA" /><xsl:value-of 
							select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG" /><xsl:value-of
							select="CONTROLINFO/LANGUAGE" />/fbpelogp.gif</xsl:attribute>
						<xsl:attribute name="alt">Scientific Electronic Library Online</xsl:attribute>
						<xsl:attribute name="border">0</xsl:attribute>
				</img>
			<!--	/a-->                    
		</p>
		</td>
		<td width="80%">
			<blockquote>
					<p align="left">
						<font face="Arial" color="#800000" size="4">
							<xsl:choose>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'en' ">Library Collection</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'pt' ">Coleção da biblioteca</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE = 'es' ">Colección de la biblioteca</xsl:when>
							</xsl:choose>
						</font>
					</p>
			</blockquote>
		</td>
		</tr>
	</table><br/>
<table width="100%" align="center" border="0" cellpadding="0" cellspacing="3">   
        <tr>
            <td width="40%" bgColor="#e1e6e6" rowspan="2">
			<b>
				<xsl:choose>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'en' ">Journal (# Requests)</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'es' ">Revista (Total)</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'pt' ">Revista (Total)</xsl:when>
				</xsl:choose>
			</b>
	     </td>
            <td width="60%" align="center" bgColor="#e1e6e6" colspan="14">
			<b>
				<xsl:choose>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'en' ">Article requests by language and year</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'es' ">Accesos a artículos de revistas por idioma y por año</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'pt' ">Acessos a artigos por idioma e por ano</xsl:when>
				</xsl:choose>				
			</b>
	     </td>
        </tr>

        <tr>
            <td width="20%" align="center" bgColor="#e1e6e6">
			<b>
				<xsl:choose>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'en' ">Language (# Requests)</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'es' ">Idioma (Total)</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'pt' ">Idioma (Total)</xsl:when>
				</xsl:choose>							
			</b>
	     </td>
            <td width="20%" align="center" bgColor="#e1e6e6">
			<b>
				<xsl:choose>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'en' ">Year</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'es' ">Año</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'pt' ">Ano</xsl:when>
				</xsl:choose>							
			</b>
	     </td>
            <td width="20%" align="center" bgColor="#e1e6e6">
			<b>
				<xsl:choose>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'en' ">Article Requests</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'es' ">Accesos a artículos</xsl:when>
					<xsl:when test="CONTROLINFO/LANGUAGE = 'pt' ">Acessos a artigos</xsl:when>
				</xsl:choose>							
			</b>
	     </td>
	 </tr>
	 <xsl:apply-templates select="TITLE" />
	 <xsl:apply-templates select="TOTAL" />
</table>	
</xsl:template> 	

<xsl:template match="TITLE">
	<xsl:variable name="nRows" select="count(LANGUAGE/YEAR)" />
	
	<tr><td colspan="4"></td></tr>
	<tr>	
		<xsl:choose>
			<xsl:when test="$nRows= 1">
				<td width="40%" bgColor="#edecee" valign="center"><b><xsl:value-of select="@NAME" /> (<xsl:value-of select="@TOTAL"/>)</b></td>			
			</xsl:when>
			<xsl:otherwise>
				<td width="40%" bgColor="#edecee" rowspan="{$nRows}" valign="center"><b><xsl:value-of select="@NAME" /> (<xsl:value-of select="@TOTAL"/>)</b></td>
			</xsl:otherwise>
		</xsl:choose>	
		<xsl:apply-templates select="LANGUAGE" />
	</tr>		
</xsl:template>

<xsl:template match="LANGUAGE">
		<xsl:choose>
			<xsl:when test="position() = 1">
					<xsl:call-template name="LANGUAGE_CELL" />
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<xsl:call-template name="LANGUAGE_CELL" />
				</tr>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<xsl:template name="LANGUAGE_CELL">
	<xsl:variable name="nRows" select="count(YEAR)" />
		<xsl:choose>
			<xsl:when test="$nRows= 1">
				<td width="20%" bgColor="#edecee" valign="center">
					<b>
						<xsl:call-template name="GET_LANGUAGE">
							<xsl:with-param name="CODE" select="@CODE" />
						</xsl:call-template>
						(<xsl:value-of select="@TOTAL"/>)
					</b>
				</td>			
			</xsl:when>
			<xsl:otherwise>
				<td width="20%" bgColor="#edecee" rowspan="{$nRows}" valign="center">
					<b>
						<xsl:call-template name="GET_LANGUAGE">
							<xsl:with-param name="CODE" select="@CODE" />
						</xsl:call-template>
						(<xsl:value-of select="@TOTAL"/>)
					</b>
				</td>
			</xsl:otherwise>
		</xsl:choose>	
		<xsl:apply-templates select="YEAR" />
</xsl:template>

<xsl:template name="GET_LANGUAGE">
	<xsl:param name="CODE" />
	
	<xsl:choose>
		<xsl:when test="//CONTROLINFO/LANGUAGE = 'en'">
			<xsl:choose>
				<xsl:when test="$CODE = 'en'">english</xsl:when>
				<xsl:when test="$CODE = 'es'">spanish</xsl:when>
				<xsl:when test="$CODE = 'pt'">portuguese</xsl:when>
				<xsl:when test="$CODE = 'fr'">french</xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="//CONTROLINFO/LANGUAGE = 'es'">
			<xsl:choose>
			        <xsl:when test=" $CODE = 'en' "> inglés</xsl:when>
			        <xsl:when test=" $CODE = 'pt' "> portugués</xsl:when>
			        <xsl:when test=" $CODE = 'es' "> español</xsl:when>
			        <xsl:when test=" $CODE = 'fr' "> francés</xsl:when>
			</xsl:choose>
		</xsl:when>
		<xsl:when test="//CONTROLINFO/LANGUAGE = 'pt'">
			<xsl:choose>
			        <xsl:when test=" $CODE = 'en' "> inglês</xsl:when>
			        <xsl:when test=" $CODE = 'pt' "> português</xsl:when>
			        <xsl:when test=" $CODE = 'es' "> espanhol</xsl:when>
			        <xsl:when test=" $CODE = 'fr' "> francês</xsl:when>
			</xsl:choose>
		</xsl:when>
	</xsl:choose>

</xsl:template>

<xsl:template match="YEAR">
		<xsl:choose>
			<xsl:when test="position() = 1">
				<td width="20%" bgColor="#edecee" valign="center">
					<b><xsl:value-of select="@NUMBER" /></b>
				</td>
				<td width="20%" bgColor="#edecee" valign="center">
					<b><xsl:value-of select="." /></b>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td width="20%" bgColor="#edecee" valign="center">
						<b><xsl:value-of select="@NUMBER" /></b>
					</td>			
					<td width="20%" bgColor="#edecee" valign="center">
						<b><xsl:value-of select="." /></b>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<xsl:template match="TOTAL">
	<xsl:variable name="nRows" select="count(TOTALYEAR /TOTALLANG )" />
	
	<tr><td colspan="4"></td></tr>
	<tr>	
		<xsl:choose>
			<xsl:when test="$nRows= 1">
				<td width="40%" bgColor="#edecee" valign="center"><b>TOTAL</b></td>			
			</xsl:when>
			<xsl:otherwise>
				<td width="40%" bgColor="#edecee" rowspan="{$nRows}" valign="center"><b>TOTAL</b></td>
			</xsl:otherwise>
		</xsl:choose>	
		<xsl:apply-templates select="TOTALYEAR" />
	</tr>		
</xsl:template>

<xsl:template match="TOTALYEAR">
		<xsl:choose>
			<xsl:when test="position() = 1">
					<xsl:call-template name="TOTALYEAR_CELL" />
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<xsl:call-template name="TOTALYEAR_CELL" />
				</tr>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<xsl:template name="TOTALYEAR_CELL">
	<xsl:variable name="nRows" select="count(TOTALLANG)" />
		<xsl:choose>
			<xsl:when test="$nRows= 1">
				<td width="20%" bgColor="#edecee" valign="center">
					<b>
						<xsl:value-of select="@YEAR" />
					</b>
				</td>			
			</xsl:when>
			<xsl:otherwise>
				<td width="20%" bgColor="#edecee" rowspan="{$nRows}" valign="center">
					<b>
						<xsl:value-of select="@YEAR" />
					</b>
				</td>
			</xsl:otherwise>
		</xsl:choose>	
		<xsl:apply-templates select="TOTALLANG" />
</xsl:template>

<xsl:template match="TOTALLANG">
		<xsl:choose>
			<xsl:when test="position() = 1">
				<td width="20%" bgColor="#edecee" valign="center">
					<b>
						<xsl:call-template name="GET_LANGUAGE">
							<xsl:with-param name="CODE" select="@LANG" />
						</xsl:call-template>
					</b>
				</td>
				<td width="20%" bgColor="#edecee" valign="center">
					<b><xsl:value-of select="@TOTAL" /></b>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td width="20%" bgColor="#edecee" valign="center">
						<b>
							<xsl:call-template name="GET_LANGUAGE">
								<xsl:with-param name="CODE" select="@LANG" />
							</xsl:call-template>
						</b>
					</td>			
					<td width="20%" bgColor="#edecee" valign="center">
						<b><xsl:value-of select="@TOTAL" /></b>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>


	
</xsl:stylesheet>
