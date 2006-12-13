<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:include href="file:///d:/sites/scielo/web/htdocs/xsl/sci_common.xsl"/>

<xsl:output method="html" indent="no" />

<xsl:template match="STATISTICS_BY_JOURNAL">
<html>
	<head>
		<title><xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes" /> - <xsl:call-template 
			name="PrintPageTitle" /></title>
		
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
		
		<link rel="STYLESHEET" type="text/css" href="/css/scielo.css" />
	</head>
	
	<body bgcolor="#FFFFFF">
		<table cellpadding="0" cellspacing="0" width="100%">  
			<tr>    
			<td width="35%">
				<p align="center">
					<a>
						<xsl:call-template name="AddScieloLink">
							<xsl:with-param name="script">sci_serial</xsl:with-param>
							<xsl:with-param name="seq" select="ISSN" />
						</xsl:call-template>

						<img>
							<xsl:attribute name="src">http://<xsl:value-of 
								select="CONTROLINFO/SCIELO_INFO/SERVER" />/<xsl:value-of 
								select="CONTROLINFO/SCIELO_INFO/PATH_SERIMG" /><xsl:value-of 
								select="TITLEGROUP/SIGLUM" />/plogo.gif</xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of 
								select="TITLEGROUP/SHORTTITLE" /></xsl:attribute>
							<xsl:attribute name="border">0</xsl:attribute>
						</img>
					</a>
				</p>
			</td>
			<td align="center" width="65%">
				<blockquote>      
					<p align="left">
						<FONT class="nomodel" color="#000080" size="+1"><xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes" /></FONT><br/>							<xsl:apply-templates select="ISSN">
							<xsl:with-param name="LANG" select="CONTROLINFO/LANGUAGE" />
						</xsl:apply-templates>
					</p>    
				</blockquote>    
			</td>  
			</tr>  
			<tr>    
			<td colspan="2"></td>  
			</tr>  
			<tr>    
			</tr>  
			<tr>    
			<td width="35%">&#160;</td>    
			<td width="65%">
				<xsl:if test="CONTROLINFO/ENABLE_STAT_LINK = 1">
				<blockquote>      
					<p>
						<font class="nomodel" color="#0000A0"><b><xsl:call-template name="PrintUsageReportTitle" /></b></font>
					</p>    
				</blockquote>    
				<blockquote>
				<ul>
					<li>
						<a>
							<xsl:call-template name="AddScieloLogLink">
								<xsl:with-param name="script">sci_journalstat</xsl:with-param>
								<xsl:with-param name="pid" select="ISSN" />
							</xsl:call-template><xsl:choose>
								<xsl:when test=" CONTROLINFO/LANGUAGE='en' ">Journal requests</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE='pt' ">Acessos às revistas</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE='es' ">Acceso a las revistas</xsl:when>
							</xsl:choose>
						</a>
					</li>
					<li>
						<a>
							<xsl:call-template name="AddScieloLogLink">
								<xsl:with-param name="script">sci_statiss</xsl:with-param>
								<xsl:with-param name="pid" select="ISSN" />
							</xsl:call-template><xsl:choose>
								<xsl:when test=" CONTROLINFO/LANGUAGE='en' ">Issue requests</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE='pt' ">Acessos aos fascículos</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE='es' ">Acceso a los ejemplares</xsl:when>
							</xsl:choose>
						</a>
					</li>
					<li>
						<a>
							<xsl:call-template name="AddScieloLogLink">
								<xsl:with-param name="script">sci_statart</xsl:with-param>
								<xsl:with-param name="pid" select="ISSN" />
							</xsl:call-template><xsl:choose>
								<xsl:when test=" CONTROLINFO/LANGUAGE='en' ">Article requests</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE='pt' ">Acessos aos artigos</xsl:when>
								<xsl:when test=" CONTROLINFO/LANGUAGE='es' ">Acceso a los artículos</xsl:when>
							</xsl:choose>
						</a>
					</li>
				</ul>
				</blockquote>
				</xsl:if>
			</td>  
			</tr>
		</table>

		<xsl:if test="CONTROLINFO/ENABLE_CIT_REP_LINK = 1">
		<xsl:apply-templates select="BIBLIOMETRIC_INFO" />
		</xsl:if>
			
		<p>&#160;</p>

		<xsl:apply-templates select="COPYRIGHT" />

	</body>
</html>
</xsl:template>

<xsl:template name="PrintPageTitle">
	<xsl:choose>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='en' ">Journal statistics</xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='pt' ">Estatísticas de revistas</xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='es' ">Estadísticas de revistas</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="PrintUsageReportTitle">
	<xsl:choose>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='en' ">Site usage reports</xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='pt' ">Relatórios de utilização do site</xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='es' ">Informes de uso del sítio</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="PrintCitationTitle">
	<xsl:choose>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='en' ">Journal citation reports</xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='pt' ">Relatórios de citações de revistas</xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='es' ">Informes de citas de revistas</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="COPYRIGHT">
	<xsl:call-template name="COPYRIGHTSCIELO"/>
</xsl:template>

<xsl:template name="CreateBibLink">
	<xsl:param name="pid" />
	<xsl:param name="script" />
	<xsl:param name="wh1" />
	<xsl:param name="wh2" />
	
	<xsl:attribute name="href">http://<xsl:value-of 
			select="//CONTROLINFO/SCIELO_INFO/SERVER" /><xsl:value-of 
			select="//CONTROLINFO/SCIELO_INFO/PATH_CGI-BIN" /><xsl:value-of select="$script" />/usr_fbpe/lng_<xsl:value-of 
			select="//CONTROLINFO/LANGUAGE" />&amp;pid=<xsl:value-of select="$pid" />/wh1_<xsl:value-of select="$wh1" />/wh2_<xsl:value-of 
			select="$wh2" /></xsl:attribute>
</xsl:template>

<xsl:template match="BIBLIOMETRIC_INFO">
	<table cellpadding="0" cellspacing="0" width="100%">  
		<tr>    
			<td colspan="2"></td>  
		</tr>  
		<tr>    
			<td width="35%">&#160;</td>
			<td width="65%">
				<blockquote>      
					<p>
						<font class="nomodel" color="#0000A0">
							<b><xsl:call-template name="PrintCitationTitle" /></b>
						</font>
					</p>    
				</blockquote>    
			</td>  
		</tr>  
		<tr>    
			<td width="35%"></td>    
			<td width="65%">
				<blockquote>      
					<ul>        
						<xsl:call-template name="PrintSourceDataListing" />
						<xsl:apply-templates select="HALF_LIFE" />
						<xsl:apply-templates select="CITED" />
						<xsl:apply-templates select="CITING" />
					</ul>    
				</blockquote>    
			</td>  
		</tr>
	</table>
</xsl:template>

<xsl:template name="PrintSourceDataListing">
	<li>
	<xsl:choose>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='en' ">Source Data Listing
			<br/> - <a>
				<xsl:call-template name="CreateBibLink">
					<xsl:with-param name="pid" select="/STATISTICS_BY_JOURNAL/ISSN" />
					<xsl:with-param name="script">bibjcrsdl2</xsl:with-param>
					<xsl:with-param name="wh1">1997</xsl:with-param>
					<xsl:with-param name="wh2">1998</xsl:with-param>
				</xsl:call-template>all years
			</a>
		</xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='pt' ">Lista de dados fonte
			<br/> - <a>
				<xsl:call-template name="CreateBibLink">
					<xsl:with-param name="pid" select="/STATISTICS_BY_JOURNAL/ISSN" />
					<xsl:with-param name="script">bibjcrsdl2</xsl:with-param>
					<xsl:with-param name="wh1">1997</xsl:with-param>
					<xsl:with-param name="wh2">1998</xsl:with-param>
				</xsl:call-template>todos os anos
			</a>
		</xsl:when>
		<xsl:when test=" //CONTROLINFO/LANGUAGE='es' ">Lista de datos fuente
			<br/> - <a>
				<xsl:call-template name="CreateBibLink">
					<xsl:with-param name="pid" select="/STATISTICS_BY_JOURNAL/ISSN" />
					<xsl:with-param name="script">bibjcrsdl2</xsl:with-param>
					<xsl:with-param name="wh1">1997</xsl:with-param>
					<xsl:with-param name="wh2">1998</xsl:with-param>
				</xsl:call-template>todos los años
			</a>
		</xsl:when>
	</xsl:choose>
	</li>
</xsl:template>

<xsl:template match="HALF_LIFE">
	<xsl:if test="count(YEAR) != 0">
		<li>
		<xsl:choose>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='en' ">Journal Half-Life Listing</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='pt' ">Lista de vida média das revistas</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='es' ">Lista de vida media de las revistas</xsl:when>
		</xsl:choose><br/> - <xsl:apply-templates select="YEAR">
			<xsl:with-param name="script">bibjcrjhl2</xsl:with-param>
		</xsl:apply-templates>
		</li>
	</xsl:if>	
</xsl:template>

<xsl:template match="CITED">
	<xsl:if test="count(YEAR) != 0">
		<li>
		<xsl:choose>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='en' ">Cited Journal Listing</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='pt' ">Lista de revistas citadas</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='es' ">Lista de revistas citadas</xsl:when>
		</xsl:choose><br/> - <xsl:apply-templates select="YEAR">
			<xsl:with-param name="script">bibjcrcjl2</xsl:with-param>
		</xsl:apply-templates>
		</li>
	</xsl:if>
</xsl:template>

<xsl:template match="CITING">
	<xsl:if test="count(YEAR) != 0">
		<li>
		<xsl:choose>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='en' ">Citing Journal Listing</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='pt' ">Lista de revistas citantes</xsl:when>
			<xsl:when test=" //CONTROLINFO/LANGUAGE='es' ">Lista de revistas que citan</xsl:when>
		</xsl:choose><br/> - <xsl:apply-templates select="YEAR">
			<xsl:with-param name="script">bibjcrcl2</xsl:with-param>
		</xsl:apply-templates>
		</li>
	</xsl:if>
</xsl:template>

<xsl:template match="YEAR">
	<xsl:param name="script" />
	
	<xsl:if test="position() != 1">, </xsl:if><a>
		<xsl:call-template name="CreateBibLink">
			<xsl:with-param name="pid" select="/STATISTICS_BY_JOURNAL/ISSN" />
			<xsl:with-param name="script"><xsl:value-of select="$script" /></xsl:with-param>
			<xsl:with-param name="wh1"><xsl:value-of select="." /></xsl:with-param>
			<xsl:with-param name="wh2">0</xsl:with-param>
		</xsl:call-template><xsl:value-of select="." />
	</a>
</xsl:template>

</xsl:stylesheet>
