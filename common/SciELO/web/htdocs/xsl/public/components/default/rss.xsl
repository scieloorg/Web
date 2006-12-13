<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="rss">
		<xsl:variable name="component" select="@id"/>
		<xsl:variable name="rssData" select="$bvsRoot/collectionList//item[@id = $component]" />	
		
		<div class="RSS">			
			<h3>
			    <xsl:choose>
				  <xsl:when test="$rssData/@href != ''">
					<a href="{$rssData/@href}"><xsl:apply-templates select="$rssData" mode="component"/></a>
				  </xsl:when>
				  <xsl:otherwise>
					<xsl:apply-templates select="$rssData" mode="component"/>
				  </xsl:otherwise>
			    </xsl:choose>			  
			</h3>
			<xsl:text disable-output-escaping = "yes" >&lt;?</xsl:text> 
				$url = "<xsl:value-of select="url"/>";
				include("../php/show_rss.php");
			<xsl:text disable-output-escaping = "yes" >?&gt;</xsl:text> 
		</div>
		
	</xsl:template>
	
	<xsl:template match="item[@img]" mode="component">
		<img src="{@img}" alt="{text()}" />
	</xsl:template>

	<xsl:template match="item" mode="component">
		<span>
			<xsl:value-of select="."/>
		</span>	
	</xsl:template>


</xsl:stylesheet>