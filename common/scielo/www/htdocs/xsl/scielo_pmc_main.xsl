<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:util="http://dtd.nlm.nih.gov/xsl/util"  xmlns:mml="http://www.w3.org/1998/Math/MathML">
	<!--xsl:output method="xhtml" omit-xml-declaration="yes" indent="yes" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/-->
		<!-- <xsl:output method="xml" encoding="utf-8"/>

		Variables
	-->
	<xsl:variable name="orientalLanguages" select="'ar'"/>
	<!--xsl:variable name="layout" select="'ar'"/-->
	
	<xsl:variable name="var_IMAGE_PATH">
		<xsl:choose>
			<xsl:when test="//PATH_SERIMG and //SIGLUM and //ISSUE">
				<xsl:value-of select="//PATH_SERIMG"/>
				<xsl:value-of select="//SIGLUM"/>/<xsl:if test="//ISSUE/@VOL">v<xsl:value-of select="//ISSUE/@VOL"/>
				</xsl:if>
				<xsl:if test="//ISSUE/@NUM">n<xsl:value-of select="//ISSUE/@NUM"/>
				</xsl:if>
				<xsl:if test="//ISSUE/@SUPPL">s<xsl:value-of select="//ISSUE/@SUPPL"/>
				</xsl:if>/</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="//image-path"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="var_IMAGES_INFO" select="//images-info"/>
	<xsl:variable name="languages" select="document('../xml/pt/language.xml')"/>
	<xsl:variable name="person-strings" select="document('./viewnlm-v2_scielo.xsl')//util:map[@id='person-strings']/item"/>

	
	<xsl:include href="viewnlm-v2_scielo.xsl"/>
	<xsl:include href="scielo_pmc.xsl"/>
	<xsl:include href="scielo_pmc_front.xsl"/>
	<xsl:include href="scielo_pmc_table.xsl"/>
	<xsl:include href="scielo_pmc_fig.xsl"/>
	<xsl:include href="scielo_pmc_references.xsl"/>
	
	
	<!--xsl:include href="../generic/viewnlm-v2_scielo.xsl"/>
	<xsl:include href="./text_front.xsl"/>
	<xsl:include href="../generic/scielo_pmc_table.xsl"/>
	<xsl:include href="../generic/scielo_pmc_fig.xsl"/>
	<xsl:include href="../generic/scielo_pmc_references.xsl"/>
	<xsl:include href="../generic/scielo_pmc.xsl"/>
	<xsl:include href="check/show-xml.xsl"/>
	<xsl:include href="check/check_xmllang.xsl"/>
	<xsl:include href="check/check_aff.xsl"/>
	<xsl:include href="check/check_references.xsl"/-->
	
	<!--
	
	-->
	<xsl:template match="*" mode="css">
		<link rel="stylesheet" type="text/css" href="/css/common.css"/>
		<link rel="stylesheet" type="text/css" href="/css/pmc/ViewNLM.css"/>
		<link rel="stylesheet" type="text/css" href="/css/pmc/ViewScielo.css"/>
	</xsl:template>
	<!--
	
	-->
	<xsl:template match="ARTICLE[fulltext]">
		<xsl:apply-templates select="." mode="make-a-piece"/>
	</xsl:template>
</xsl:stylesheet>
