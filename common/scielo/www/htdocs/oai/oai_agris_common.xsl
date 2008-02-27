<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:ags="http://purl.org/agmes/1.1/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:agls="http://www.naa.gov.au/recordkeeping/gov_online/agls/1.2" xmlns:dcterms="http://purl.org/dc/terms/">

<xsl:output method="xml"/>
<xsl:variable name="spacechar">00</xsl:variable>

<xsl:template match="/">
	<ags:resources>		
		<xsl:apply-templates select="//article/front"/>
	</ags:resources>
</xsl:template>

<xsl:template match="title-group" mode="title">
	<dc:title xml:lang="{article-title/@xml:lang}"><xsl:value-of select="article-title"/></dc:title>
</xsl:template>

<xsl:template match="contrib" mode="creator">
	<ags:creatorPersonal><xsl:value-of select="normalize-space(concat(name/surname,', ',name/given-names))"/></ags:creatorPersonal>
</xsl:template>

<xsl:template match="publisher" mode="publisher">
	<dc:publisher>
		<ags:publisherName><xsl:value-of select="publisher-name"/></ags:publisherName>
	</dc:publisher>
</xsl:template>

<xsl:template match="pub-date[@pub-type='pub']" mode="date">
	<dc:date>
		<dcterms:dateIssued><xsl:value-of select="year"/></dcterms:dateIssued>
	</dc:date>
</xsl:template>

<xsl:template match="kwd" mode="subject">
	<dc:subject><xsl:value-of select="."/></dc:subject>		
</xsl:template>

<xsl:template match="abstract" mode="description">
	<dc:description>
		<dcterms:abstract xml:lang="{@xml:lang}"><xsl:value-of select="p"/></dcterms:abstract>
	</dc:description>
</xsl:template>

<xsl:template match="article-meta" mode="identifier">
	<dc:identifier scheme="dcterms:URI">http://www.scielo.br/scielo.php?script=sci_arttext&amp;pid=<xsl:value-of select="article-id"/></dc:identifier>
	<dc:identifier scheme="dcterms:DOI">10.1590/<xsl:value-of select="article-id"/></dc:identifier>
</xsl:template>

<xsl:template match="title-group" mode="language">
	<dc:language scheme="ags:ISO639-1"><xsl:value-of select="article-title/@xml:lang"/></dc:language>
</xsl:template>

<xsl:template match="front">	
		<ags:resource ags:ARN="SC{concat(substring(article-meta/article-id,11,4),$spacechar,substring(article-meta/article-id,17,2),substring(article-meta/article-id,22,2) )}">
			<xsl:apply-templates select=".//title-group" mode="title"/>
			<dc:creator>
				<xsl:apply-templates select=".//contrib-group/contrib" mode="creator"/>
			</dc:creator>
			<xsl:apply-templates select=".//publisher" mode="publisher"/>
			<xsl:apply-templates select=".//pub-date[@pub-type='pub']" mode="date"/>
			<xsl:apply-templates select=".//kwd-group/kwd" mode="subject"/>
			<xsl:apply-templates select=".//abstract" mode="description"/>
			<xsl:apply-templates select=".//article-meta" mode="identifier"/>
			<dc:type>journal article</dc:type>
			<dc:format>text/xml</dc:format>
			<xsl:apply-templates select=".//title-group" mode="language"/>				
			<xsl:apply-templates select="article-meta" mode="article-id"/>
			<agls:availability>
				<ags:availabilityLocation>SCIELO</ags:availabilityLocation>
				<!--ags:availabilityNumber><xsl:value-of select="article-meta/article-id"/></ags:availabilityNumber-->
			</agls:availability>
			<ags:citation>
		              <xsl:apply-templates select="journal-meta/publisher/publisher-name" mode="citationTitle"/>
	               		 <xsl:apply-templates select="journal-meta/issn" mode="issn"/>
		              <xsl:apply-templates select="article-meta" mode="volnum"/>
		              <xsl:apply-templates select="article-meta/pub-date[@pub-type='pub']/year" mode="year"/>
			</ags:citation>
		</ags:resource>			
</xsl:template>

<xsl:template match="publisher-name" mode="citationTitle">
	<ags:citationTitle><xsl:value-of select="normalize-space(.)"/></ags:citationTitle>
</xsl:template>

<xsl:template match="issn" mode="issn">
	<ags:citationIdentifier scheme="ags:ISSN"><xsl:value-of select="normalize-space(.)"/></ags:citationIdentifier>
</xsl:template>

<xsl:template match="article-meta" mode="volnum">
	<ags:citationNumber><xsl:apply-templates select="volume" mode="volnum"/><xsl:apply-templates select="numero" mode="volnum"/></ags:citationNumber>
</xsl:template>

<xsl:template match="volume" mode="volnum">vol.<xsl:value-of select="normalize-space(.)"/></xsl:template>

<xsl:template match="numero" mode="volnum">num.<xsl:value-of select="normalize-space(.)"/></xsl:template>

<xsl:template match="year" mode="year">
	<ags:citationChronology>
		<xsl:value-of select="normalize-space(.)"/>
	</ags:citationChronology>
</xsl:template>

<!--xsl:template match="article-meta" mode="article-id">
	<dc:relation>
  		<dcterms:references scheme="ags:DOI">10.1590/<xsl:value-of select="article-id"/></dcterms:references> 
  	</dc:relation>
</xsl:template-->

</xsl:stylesheet>
