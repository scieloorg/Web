<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="file:///home/scielo/www/htdocs/xsl/sci_common.xsl"/>
	<xsl:include href="file:///home/scielo/www/htdocs/xsl/sci_error.xsl"/>

	<xsl:output method="html"
        omit-xml-declaration="yes"
        indent="no"
        doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
					
	<xsl:variable name="LANG" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
				<xsl:variable name="XML">
					<xsl:copy-of select="." />
				</xsl:variable>
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/>&#160;
				
						<xsl:call-template name="GetStrip">
							<xsl:with-param name="vol" select=".//ARTICLE/ISSUEINFO/@VOL"/>
							<xsl:with-param name="num" select=".//ARTICLE/ISSUEINFO/@NUM"/>
							<xsl:with-param name="suppl" select=".//ARTICLE/ISSUEINFO/@SUPPL"/>
							<xsl:with-param name="lang" select="$LANG"/>
						</xsl:call-template>;
				
					<xsl:value-of select=".//CONTROLINFO/PAGE_PID"/>
					</title>
					<meta http-equiv="Pragma" content="no-cache"/>
					<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
					<link rel="STYLESHEET" type="text/css" href="/css/screen2.css"/>
					<script language="javascript" src="article.js"></script>
				</head>
			<body>
				<div class="container">
					<div class="level2">
						    <div class="top">
							<div id="parent">
								<img src="/img/en/scielobre.gif" alt="SciELO - Scientific Electronic Librery Online" />
						       </div>
						    </div>
						<div class="middle">
								<xsl:apply-templates select=".//ARTICLE"/>
						</div>
					</div>
				</div>
				<xsl:call-template name="UpdateLog"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="ARTICLE">
		<div class="content">
			<h3>
				<xsl:call-template name="PrintPageTitle"/>
			</h3>
			<div class="howToCite">
				<div class="topicFolder">
					<span>
						<h4>
							<xsl:call-template name="Formats"/>
						</h4>		
					</span>
								<xsl:call-template name="PrintExportCitationForRefecenceManagers">
									<xsl:with-param name="LANGUAGE" select="$LANG"/>
									<xsl:with-param name="pid" select="//CONTROLINFO/PAGE_PID"/>
								</xsl:call-template>
					<ul>
						<xsl:apply-templates select="//standard">
							<xsl:with-param name="data" select="."/>
						</xsl:apply-templates>
					</ul>
				</div>
			</div>
			<!-- a href="#" onClick="window.close();">
				<xsl:choose>
					<xsl:when test=" $LANG = 'en' ">Close</xsl:when>
					<xsl:when test=" $LANG = 'es' ">Cerrar</xsl:when>
					<xsl:when test=" $LANG = 'pt' ">Fechar</xsl:when>
				</xsl:choose>
			</a -->
		</div>
	</xsl:template>
	<xsl:template name="PrintPageTitle">
		<xsl:choose>
			<xsl:when test=" $LANG = 'en' ">How to cite </xsl:when>
			<xsl:when test=" $LANG = 'es' ">Como citar</xsl:when>
			<xsl:when test=" $LANG = 'pt' ">Como citar</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="Formats">
		<xsl:choose>
			<xsl:when test=" $LANG = 'en' ">Bibliographical Formats </xsl:when>
			<xsl:when test=" $LANG = 'es' ">Formatos Bibliográficos</xsl:when>
			<xsl:when test=" $LANG = 'pt' ">Formatos Bibliográficos</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="standard">
		<xsl:param name="data"/>
		<li>
			<h5>
				<xsl:apply-templates select="label[@lang=$LANG]"/>
			</h5>
			<xsl:apply-templates select="$data" mode="print-ref">
				<xsl:with-param name="NORM" select="@id"/>
			</xsl:apply-templates>
		</li>
	</xsl:template>
	<xsl:template match="*" mode="print-ref">
		<xsl:param name="NORM"/>
			<xsl:call-template name="PrintAbstractHeaderInformation">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="AUTHLINK">0</xsl:with-param>
				<xsl:with-param name="NORM" select="$NORM"/>
			</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
