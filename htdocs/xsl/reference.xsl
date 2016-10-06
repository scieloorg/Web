<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:util="http://dtd.nlm.nih.gov/xsl/util" xmlns:mml="http://www.w3.org/1998/Math/MathML" exclude-result-prefixes="util xsl">

	<xsl:output method="html" version="1.0" encoding="ISO-8859-1" indent="yes"/>

    <xsl:variable name="languages" select="document('../xml/en/language.xml')"/>
	<xsl:variable name="person-strings" select="document('viewnlm-v2_scielo.xsl')/*/util:map[@id='person-strings']/item"/>

	<xsl:include href="../xsl/viewnlm-v2_scielo.xsl"/>
	<xsl:include href="../xsl/scielo_pmc_references.xsl"/>
	<xsl:variable name="LANGUAGE" select="/root/vars/lang"/>
	<xsl:variable name="service_log" select="/root/vars/service_log"/>
    <xsl:variable name="lang" select="/root/vars/lang"/>
	<xsl:variable name="applserver" select="/root/vars/applserver"/>	
	<xsl:variable name="pathhtdocs" select="/root/vars/htdocs"/>
    <xsl:variable name="translations" select="document(concat('../xml/',$lang,'/translation.xml'))/translations"/>
	
	<xsl:template match="/">
		<div class="articleList">
			<ul>
				<xsl:choose>
					<xsl:when test="//record">
						<xsl:apply-templates select="//record"/>
					</xsl:when>
					<xsl:when test="//references-from-xml//ref">
						<xsl:apply-templates select="//references-from-xml//ref"/>					
					</xsl:when>
				</xsl:choose>
				<xsl:if test="//Isis_Total[occ = 0] and not(//references-from-xml)">
					<xsl:apply-templates select="//Isis_Total[occ = 0]" mode="notFound"/>							
				</xsl:if>
			</ul>
		</div>
	</xsl:template>
	<xsl:template match="record">
		<xsl:variable name="refpid" select="concat(field[@tag = 880]/occ,format-number(field[@tag = 888]/occ,'#00000'))"/>
		<xsl:variable name="pid" select="field[@tag = 880]/occ"/>
		<xsl:apply-templates select="field[@tag =704 ]/occ"/>[ <a href="http://{$applserver}/scieloOrg/php/reflinks.php?refpid={$refpid}&amp;lng={$lang}&amp;pid={$pid}" target="_blank"><xsl:if test="$service_log = 1"><xsl:attribute name="onClick">callUpdateArticleLog('referencias_artigo_links');</xsl:attribute></xsl:if><xsl:value-of select="$translations/xslid[@id='reference']/text[@find = 'findReferenceOnLine']"/></a> ]<br/><br/>
	</xsl:template>

	<xsl:template match="occ" mode="notFound">
		<xsl:value-of select="$translations/xslid[@id='reference']/text[@find = 'not_found']"/>
	</xsl:template>

</xsl:stylesheet>
