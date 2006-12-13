<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:param name="xml-path" />	
	
	<xsl:variable name="lang" select="/node()/@lang | /node()/@language" />
	<xsl:variable name="id" select="/node()/@id" />	
	<xsl:variable name="metaIAH" select="'../metaiah/search.php'" />	
	<xsl:variable name="bvsRoot" select="document(concat($xml-path,$lang,'/bvs.xml'))/bvs" />
	<xsl:variable name="texts" select="$bvsRoot/texts" />
	<xsl:variable name="define" select="/root/define"/>
	
	<xsl:include href="xsl/public/components/bvs.xsl" />
	<xsl:include href="xsl/public/components/texts.xsl" />
	<xsl:include href="xsl/public/components/warnings.xsl" />
	<xsl:include href="xsl/public/components/about.xsl" />
	<xsl:include href="xsl/public/components/otherversions.xsl" />
	<xsl:include href="xsl/public/components/portalList.xsl" />
	<xsl:include href="xsl/public/components/institutionList.xsl" />
	<xsl:include href="xsl/public/components/topicList.xsl" />
	<xsl:include href="xsl/public/components/collectionList.xsl" />
	<xsl:include href="xsl/public/components/communityList.xsl" />
	<xsl:include href="xsl/public/components/calls.xsl" />
	<xsl:include href="xsl/public/components/contact.xsl" />
	<xsl:include href="xsl/public/components/responsable.xsl" />
	<xsl:include href="xsl/public/components/metasearch.xsl" />
	<xsl:include href="xsl/public/components/metainfo.xsl" />
	<xsl:include href="xsl/public/components/decs.xsl" />
	<xsl:include href="xsl/public/components/rss.xsl" />
	<xsl:include href="xsl/public/components/service.xsl" />

	<xsl:template match="/">
		<xsl:apply-templates select="." mode="div"/>	
	</xsl:template>

	<xsl:template match="*" mode="div">			
		<xsl:apply-templates select="." />	
	</xsl:template>
	
	<xsl:template match="*[@available = 'no']">
		<xsl:comment>component <xsl:value-of select="name()"/> disable</xsl:comment>
	</xsl:template>

	<xsl:template match="xhtml">
		<xsl:variable name="collectionData" select="$bvsRoot/collectionList//item[@id = $id]" />	
		
		<div class="generic">
			<h3>
				<span>
				  <xsl:choose>
					<xsl:when test="$collectionData/@href != ''">
						<a href="{$collectionData/@href}"><xsl:value-of select="$collectionData/text()" /></a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$collectionData/text()" />
					</xsl:otherwise>
				  </xsl:choose>	
				</span>			
			</h3>					
			<div>
				<xsl:choose>
		            <xsl:when test="count(child::*) &gt; 0">						
		                 <xsl:copy-of select="content/* | content/text()" />
		            </xsl:when>
		            <xsl:otherwise>
		                  <xsl:value-of select="." disable-output-escaping="yes"/>
		            </xsl:otherwise>
		        </xsl:choose>			
			</div>					
		</div>		
	</xsl:template>

</xsl:stylesheet>
