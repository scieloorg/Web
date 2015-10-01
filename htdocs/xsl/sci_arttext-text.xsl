<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:include href="sci_navegation.xsl"/>

<xsl:template match="SERIAL">
	<html>
		<head>
			<title>
				<xsl:value-of select="ISSUE/ARTICLE/TITLE" />
			</title>
			<meta http-equiv="Pragma" content="no-cache" />
			<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />
			<link rel="STYLESHEET" TYPE="text/css" href="/css/scielo2.css" />
		</head>		
		<body bgcolor="#FFFFFF" link="#000080" vlink="#800080" onunload="CloseLattesWindow();">

			<xsl:call-template name="NAVBAR">
				<xsl:with-param name="bar1">articles</xsl:with-param>
				<xsl:with-param name="bar2">articlesiah</xsl:with-param>
				<xsl:with-param name="home">1</xsl:with-param>
				<xsl:with-param name="alpha">
					<xsl:choose>
						<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' ">0</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
				<xsl:with-param name="scope" select="TITLEGROUP/SIGLUM"/>
			</xsl:call-template>

			<center>
				<span>
				<font class="nomodel" size="+1" color="#000080"><xsl:value-of select="TITLEGROUP/TITLE" disable-output-escaping="yes" /></font><br/>
				<font class="nomodel" size="-1" color="#000080">
				<xsl:apply-templates select="//ISSN">
					  <xsl:with-param name="LANG" select="normalize-space(CONTROLINFO/LANGUAGE)" />
				</xsl:apply-templates>
				</font>
				</span>
			</center><br/>
						
			<table border="0" width="100%">
			<tr>
			<td width="3%">&#160;</td>
			<td width="94%">
				<table width="100%" border="0">
					<tr>
					<td width="75%">
			
					<xsl:if test="TITLEGROUP/SIGLUM != 'bjmbr' ">
					<p align="LEFT"><br/>
						<xsl:apply-templates select="ISSUE/STRIP" />
					</p>
					</xsl:if>
			
					<p align="LEFT">
						<xsl:if test="ISSUE/ARTICLE/@PDF">
							<font face="Symbol">&#174;</font> <a style="text-decoration: none;">
								<xsl:call-template name="AddScieloLink">
									<xsl:with-param name="seq" select="CONTROLINFO/PAGE_PID" />
									<xsl:with-param name="script">sci_pdf</xsl:with-param>				 									<xsl:with-param name="txtlang"><xsl:value-of select="ISSUE/ARTICLE/@TRANSLATION"/></xsl:with-param>
		
								</xsl:call-template>
                                <font class="nomodel" size="2" style="text-decoration: none;">
                                    <xsl:value-of select="$translations/xslid[@id='sci_arttext-text']/text[@find = 'download_article_in_pdf_format']"/>
                                </font>
							</a>							
						</xsl:if>
					</p>
					</td>
					<td width="25%">
						<xsl:call-template name="PrintArticleInformationArea">
							<xsl:with-param name="LATTES" select="ISSUE/ARTICLE/LATTES" />
						</xsl:call-template>					
					</td>
					</tr>
				</table>
				<xsl:value-of select="ISSUE/ARTICLE/BODY" disable-output-escaping="yes" />
			</td>
			<td width="3%">&#160;</td>
			</tr>
			</table>
			<hr/><p align="center">	
				<xsl:apply-templates select="/SERIAL/COPYRIGHT" />
				<xsl:apply-templates select="/SERIAL/CONTACT" />
			</p>
		</body>
	</html>
</xsl:template>

<xsl:template match="STRIP">
   <font color="#800000">
	<xsl:call-template name="SHOWSTRIP" >
	 <xsl:with-param name="SHORTTITLE" select="SHORTTITLE"/>
        <xsl:with-param name="VOL" select="VOL" />
        <xsl:with-param name="NUM" select="NUM" />
        <xsl:with-param name="SUPPL" select="SUPPL" />
        <xsl:with-param name="CITY"  select="CITY" />
        <xsl:with-param name="MONTH" select="MONTH" />
        <xsl:with-param name="YEAR" select="YEAR" />
	</xsl:call-template>
   </font>
</xsl:template>

</xsl:stylesheet>
