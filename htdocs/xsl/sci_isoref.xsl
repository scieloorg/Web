<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:include href="sci_common.xsl"/>
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>
	<xsl:variable name="LANG" select="normalize-space(//CONTROLINFO/LANGUAGE)"/>
	<xsl:variable name="XML">
		<xsl:copy-of select="."/>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test=".//PRESENTS-ONLY-REF">
				<xsl:comment>..</xsl:comment>
				<xsl:apply-templates select="." mode="reference"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="how-to-cite"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="reference">
		<xsl:apply-templates select=".//ARTICLE" mode="print-ref">
			<xsl:with-param name="TEXTLINK" select="..//PRESENTS-ONLY-REF/@textlink"/>
			<xsl:with-param name="FORMAT" select="..//PRESENTS-ONLY-REF/@format"/>
			<xsl:with-param name="NORM" select=".//PRESENTS-ONLY-REF/@standard"/>
			<xsl:with-param name="LANG" select="$LANG"/>
			<xsl:with-param name="reviewType"><xsl:if test=".//ARTICLE/@hcomment!='1' or not(.//ARTICLE/@hcomment)">provisional</xsl:if></xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="*" mode="how-to-cite">
		<html>
			<head>
				<title>
					<xsl:value-of select="TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/>&#160;
				
						<xsl:call-template name="GetStrip">
						<xsl:with-param name="vol" select=".//ARTICLE/ISSUEINFO/@VOL"/>
						<xsl:with-param name="num" select=".//ARTICLE/ISSUEINFO/@NUM"/>
						<xsl:with-param name="suppl" select=".//ARTICLE/ISSUEINFO/@SUPPL"/>
						<xsl:with-param name="lang" select="$LANG"/>
						<xsl:with-param name="reviewType">
							<xsl:if test=".//ARTICLE/@hcomment!='1' or not(.//ARTICLE/@hcomment)">provisional</xsl:if>
						</xsl:with-param>
					</xsl:call-template>;
				
					<xsl:value-of select=".//CONTROLINFO/PAGE_PID"/>
				</title>
				<meta http-equiv="Pragma" content="no-cache"/>
				<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<link rel="STYLESHEET" type="text/css" href="/css/screen2.css"/>
			</head>
			<body>
				<div class="container">
					<div class="level2">
						<div class="top">
							<div id="parent">
								<img src="/img/{$LANG}/scielobre.gif" alt="{$translations/xslid[@id='sci_isoref']/text[@find = 'scientific_electronic_library_online']}"/>
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
		</div>
	</xsl:template>
	<xsl:template name="PrintPageTitle">
		<xsl:value-of select="$translations/xslid[@id='sci_isoref']/text[@find = 'how_to_cite']"/>
	</xsl:template>
	<xsl:template name="Formats">
		<xsl:value-of select="$translations/xslid[@id='sci_isoref']/text[@find = 'bibliographical_formats']"/>
	</xsl:template>
	<xsl:template match="standard">
		<xsl:param name="data"/>
		<li>
			<h5>
				<xsl:apply-templates select="label[@lang=$LANG]"/>
			</h5>
			<xsl:if test="../PRESENTS-ONLY-REF">
				<xsl:comment>inicio-MY-REFERENCE</xsl:comment>
			</xsl:if>
			<xsl:apply-templates select="$data" mode="print-ref">
				<xsl:with-param name="NORM" select="@id"/>
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="reviewType"><xsl:if test="$data/@hcomment!='1' or not($data/@hcomment)">provisional</xsl:if></xsl:with-param>

			</xsl:apply-templates>
			<xsl:if test="../PRESENTS-ONLY-REF">
				<xsl:comment>fim-MY-REFERENCE</xsl:comment>
			</xsl:if>
		</li>
	</xsl:template>
	<xsl:template match="standard[@id='apa']">
		<xsl:param name="data"/>
		<li>
			<h5>
				<xsl:apply-templates select="label[@lang=$LANG]"/>
			</h5>
			<xsl:if test="../PRESENTS-ONLY-REF">
				<xsl:comment>inicio-MY-REFERENCE</xsl:comment>
			</xsl:if>
			<xsl:value-of select="$data/APA" disable-output-escaping="yes"/>
		 <xsl:if test="../PRESENTS-ONLY-REF">
				<xsl:comment>fim-MY-REFERENCE</xsl:comment>
			</xsl:if>
		</li>
		
	</xsl:template>
	<!--xsl:template match="*" mode="print-ref">
		<xsl:param name="NORM"/>
			<xsl:call-template name="PrintAbstractHeaderInformation">
				<xsl:with-param name="LANG" select="$LANG"/>
				<xsl:with-param name="AUTHLINK">0</xsl:with-param>
				<xsl:with-param name="NORM" select="$NORM"/>
			</xsl:call-template>
	</xsl:template-->
</xsl:stylesheet>
