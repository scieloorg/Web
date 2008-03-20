<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="sci_navegation.xsl"/>
<xsl:include href="sci_error.xsl" />
<xsl:output method="html" indent="no" />

<xsl:variable name="forceType" select="//CONTROLINFO/ENABLE_FORCETYPE"/>



<xsl:template match="/">
	<html>
	<head>
		<title>
			<xsl:choose>
				<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']">
					Subject list of serials
				</xsl:when>
				<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']">
					Lista de periódicos por assunto
				</xsl:when>
				<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']">
					Lista de seriadas por materia
				</xsl:when>
			</xsl:choose>	
		</title>
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
		<link rel="STYLESHEET" type="text/css" href="/css/scielo.css" />
	</head>
	<body link="#0000ff" vlink="#800080" bgcolor="#ffffff">
		<xsl:call-template name="NAVBAR">
			<xsl:with-param name="bar1">serials</xsl:with-param>
			<xsl:with-param name="bar2">articlesiah</xsl:with-param>
			<xsl:with-param name="scope">library</xsl:with-param>
		</xsl:call-template>
		
		<table cellspacing="0" border="0" cellpadding="7" width="100%">
		<tr>
		<td width="26%">&#160;</td>
		<td width="74%">
		<font class="nomodel" size="+1" color="#000080">
		<xsl:choose>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']">
				Library Collection
			</xsl:when>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']">
				Coleção da biblioteca
			</xsl:when>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']">
				Colección de la biblioteca
			</xsl:when>
		</xsl:choose>
		</font>
		</td>
		</tr>
		</table><br/><br/>
		
		<xsl:apply-templates select="//LIST" />
		<xsl:apply-templates select="SUBJECTLIST/COPYRIGHT" />		
	</body>
	</html>		
</xsl:template>

<xsl:template match="LIST">
	<table width="100%">
	<tr>
	<td width="8%">&#160;</td>
	<td width="82%">
		<xsl:call-template name="Subjects" />

		<p align="LEFT">
		<font class="nomodel" color="#800000">
		<xsl:choose>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']">
				Subject list of serials
			</xsl:when>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']">
				Lista de periódicos por assunto
			</xsl:when>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']">
				Lista de seriadas por materia
			</xsl:when>
		</xsl:choose>
		</font>
		</p>
		<xsl:apply-templates select="SUBJECT" />
		<font class="divisoria">&#160;<br/></font><br/><br/>
	</td>
	<td width="10%">&#160;</td>
	</tr>
	</table>	
</xsl:template>

<xsl:template match="SUBJECT">
	<p class="section">
		<img>
			<xsl:attribute name="src"><xsl:value-of select="//PATH_GENIMG"/>lead.gif</xsl:attribute>
		</img>&#160;&#160;
		<font size="-1" color="#000080">
			<a>
				<xsl:attribute name="name">subj<xsl:value-of select="position()" /></xsl:attribute>
			<xsl:value-of select="@NAME"/>
			</a>
		</font><br/>
		<xsl:apply-templates select="SERIAL" />
	</p>
</xsl:template>

<xsl:template match="SERIAL">
	&#160;&#160;&#160;&#160;&#160;
	<font class="linkado" color="#000080">
		<xsl:choose>
			<xsl:when test="$forceType=0">
				<a>
					<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=<xsl:apply-templates select="." mode="sci_serial"/>&amp;pid=<xsl:value-of select ="TITLE/@ISSN"/>&amp;lng=<xsl:value-of select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/></xsl:attribute>
					<xsl:value-of select="TITLE" disable-output-escaping="yes" />
				</a> 				
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">http://<xsl:value-of select="//SERVER"/><xsl:value-of select="//PATH_DATA"/>scielo.php?script=<xsl:apply-templates select="." mode="sci_serial"/>&amp;pid=<xsl:value-of select ="TITLE/@ISSN"/>&amp;lng=<xsl:value-of  select="normalize-space(//CONTROLINFO/LANGUAGE)"/>&amp;nrm=<xsl:value-of select="normalize-space(//CONTROLINFO/STANDARD)"/></xsl:attribute>
					<xsl:value-of select="TITLE" disable-output-escaping="yes" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
			 - <xsl:value-of select="@QTYISS" />
		<xsl:choose>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']"> 
				 issues
			</xsl:when>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']"> 
				números
			</xsl:when>
			<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']"> 
				números
			</xsl:when>
		</xsl:choose>
	</font><br/>
</xsl:template>

<xsl:template match="COPYRIGHT">
	<xsl:call-template name="COPYRIGHTSCIELO"/>
</xsl:template>

<xsl:template name="Subjects">
	<p align="LEFT">
	<font class="nomodel" color="#800000">
	<xsl:choose>
		<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='en']">
			Subjects
		</xsl:when>
		<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='pt']">
			Assuntos
		</xsl:when>
		<xsl:when test="/SUBJECTLIST/CONTROLINFO[normalize-space(LANGUAGE)='es']">
			Materias
		</xsl:when>
	</xsl:choose>
	</font>
	</p>
	<table width="100%">
	<tr>
	<td>
	<xsl:attribute name="width">
		<xsl:choose>
			<xsl:when test="count(//SUBJECT) > 10">50%</xsl:when>
			<xsl:otherwise>100%</xsl:otherwise>
		</xsl:choose>	
	</xsl:attribute>
	<xsl:attribute name="valign">top</xsl:attribute>
	<xsl:for-each select="//SUBJECT[11 > position()]">
		&#160;&#160;&#160;&#160;&#160;&#160;
		<font size="-1" color="#000080">
			<a><xsl:attribute name="href">#subj<xsl:value-of select="position()" /></xsl:attribute><xsl:value-of 
	      	      select="@NAME" /></a><br/>
		</font>
	</xsl:for-each>
	</td>
	<xsl:if test="count(//SUBJECT) > 10">
	<td width="*" valign="top">
	<xsl:for-each select="//SUBJECT[position() > 10]">
		&#160;&#160;&#160;&#160;&#160;&#160;
		<font size="-1" color="#000080">
			<a><xsl:attribute name="href">#subj<xsl:value-of select="position() + 10" /></xsl:attribute><xsl:value-of 
	      	      select="@NAME" /></a><br/>
		</font>
	</xsl:for-each>
	</td>
	</xsl:if>
	</tr>
	</table>
</xsl:template>

</xsl:stylesheet>

