<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.3" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:param name="decsTexts" select="document(concat($xml-path,$lang,'/decsws.xml'))/texts" />

	<xsl:param name="decsData" select="$bvsRoot/collectionList//item[@id = $id]" />	

	<xsl:template match="decs">
		<div id="decs">
			<h3>
			 <span>
			  <xsl:choose>
				<xsl:when test="$decsData/@href != ''">
					<a href="{$decsData/@href}"><xsl:value-of select="$decsData/text()" /></a>
				</xsl:when>
				<xsl:otherwise>
					<a href="../php/level.php?lang={$lang}&amp;component={$id}"><xsl:value-of select="$decsData/text()" /></a>
				</xsl:otherwise>
			  </xsl:choose>	
			 </span>
			</h3>			
			<ul>
				<xsl:apply-templates select="item">
					<xsl:sort/>
				</xsl:apply-templates>
			</ul>
		</div>
	</xsl:template>
	
	<xsl:template match="item">
		<li>
			<a href="../php/decsws.php?lang={$lang}&amp;tree_id={@category}"><xsl:value-of select="text()"/></a>
		</li>
	</xsl:template>

</xsl:stylesheet>