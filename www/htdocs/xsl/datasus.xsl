<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" version="1.0" indent="yes"/>

	<xsl:variable name="lang" select="/root/vars/lang"/>
	<xsl:variable name="applserver" select="/root/vars/applserver"/>
	<xsl:variable name="processCode" select="/root/vars/processCode"/>
	<xsl:variable name="texts" select="document('../applications/scielo-org/xml/texts.xml')/texts/language[@id = $lang]"/>



	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="count(root/areasgeo/areasgeo/arealist) &gt; 0">
				<table cellpadding="0" cellspacing="0" width="500px">
					<tr>
						<th width="15%">País</th>
						<th width="15%">Região</th>
						<th width="35%">Estado</th>
						<th width="35%">Município</th>
					</tr>
					<tr>
						<xsl:apply-templates select="root/areasgeo/areasgeo[position() = 1]/arealist/country"/>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$texts/text[find='dataFound']/replace"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="country">
			<td valign="top" width="15%"><a href="{@url}"><xsl:value-of select="@name"/></a></td>
			<td valign="top" width="85%" colspan="3"><xsl:apply-templates select="region"/></td>
	</xsl:template>

	<xsl:template match="region">
		
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td valign="top" width="18%"><a href="{@url}"><xsl:value-of select="@name"/></a></td>
					<td valign="top"><xsl:apply-templates select="state"/></td>
				</tr>
			</table>
					
	</xsl:template>

	<xsl:template match="state">
		
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td valign="top" width="50%"><a href="{@url}"><xsl:value-of select="@name"/></a></td>
					<td valign="top" width="50%"><xsl:apply-templates select="city"/></td>
				</tr>
			</table>
		
	</xsl:template>

	<xsl:template match="city">
		
			<a href="{@url}"><xsl:value-of select="@name"/></a><br/>
		
	</xsl:template>
	
</xsl:stylesheet>