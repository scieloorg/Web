<?xml version="1.0" encoding="iso-8859-1"?>
	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" />

	<xsl:variable name="letter" select="/root/http-info/cgi/letter"/>
	<xsl:variable name="lang" select="/root/http-info//lang" />
	<xsl:variable name="texts" select="document(concat('xml/',$lang,'/bvs.xml'))/bvs/texts" />	

	<xsl:variable name="sorted">
		<xsl:apply-templates select="//item" mode="sort">
			<xsl:sort select="title"/>
		</xsl:apply-templates>
	</xsl:variable>

	<xsl:template match="/">
		<div id="collection">
			<h3><span><xsl:value-of select="$texts/text[@id = 'alphabetic.title']"/></span></h3>
			<div id="breadCrumb">
			    <a href="/index.php?lang={$lang}">home</a>
				&gt; <xsl:value-of select="$texts/text[@id = 'alphabetic.home']"/>
			</div>
		   <div class="content">
	  	     <ul>
			   <xsl:apply-templates select="$sorted//item" mode="all"/>
			</ul>
		   </div>
		</div>
	</xsl:template>
	
	<xsl:template match="item" mode="sort">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="item" mode="all">		
		<xsl:variable name="previous" select="translate(normalize-space(preceding-sibling::item[position() = 1]/title),'ÁÉÍÓÚ','AEIOU')"/>
		<xsl:variable name="current" select="translate(normalize-space(title),'Á','A')"/>
		
		<xsl:if test="substring($current,1,1) != substring($previous,1,1)">
			<h3><xsl:value-of select="substring($current,1,1)"/></h3>
		</xsl:if>
		<li>
			<a href="{link}" target="_blank"><xsl:value-of select="title"/></a>
		</li>
	</xsl:template>

</xsl:stylesheet>