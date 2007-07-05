<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
<xsl:variable name="from" select="//from"/>
<xsl:variable name="to">
	<xsl:choose>
		<xsl:when test="normalize-space(//to)=''">99999999</xsl:when>
		<xsl:otherwise><xsl:value-of select="//to"/></xsl:otherwise>	
	</xsl:choose>
</xsl:variable>
<xsl:variable name="domain" select="//domain"/>
	<xsl:template match="/">
		<html>
			<body>				
				<xsl:apply-templates select="//record" mode="total"/>
				<table border="1" width="100%">
					<tr>
						<td></td><td>PID</td><td>DATE</td><td>STATUS</td><td>LINKS</td>
					</tr>					
					<xsl:apply-templates select="//record" mode="content"/>					
				</table>
			</body>
		</html>
	</xsl:template>

		<xsl:template match="record" mode="content">
			<xsl:if test="(normalize-space(field[@tag = 10]/occ) &gt;= normalize-space($from)) and  (normalize-space(field[@tag = 10]/occ) &lt;= normalize-space($to))">
				<tr>
					<td>
						<xsl:value-of select="position()"/>
					</td>
					<td>
						<a href="http://{$domain}/scielo.php?script=sci_abstract&amp;pid={field[@tag = 880]/occ}&amp;lng=en&amp;nrm=iso&amp;tlng=pt" target="_blank"><xsl:value-of select="field[@tag = 880]/occ"/></a>
					</td>
					<td>
						<xsl:value-of select="field[@tag = 10]/occ"/>
					</td>
					<td>
						<xsl:value-of select="field[@tag = 30]/occ"/>
					</td>
					<td>
						<a href="crossrefxml.php?pid={field[@tag = 880]/occ}" target="_blank">crossref xml</a>
					</td>
				</tr>
			</xsl:if>
		</xsl:template>
		
		<xsl:template match="record" mode="total">
			<xsl:if test="(normalize-space(field[@tag = 10]/occ) &gt;= normalize-space($from)) and  (normalize-space(field[@tag = 10]/occ) &lt;= normalize-space($to))">
                        	<xsl:if test="position() = last()">Total: <xsl:value-of select="position()"/></xsl:if>
			</xsl:if>									
		</xsl:template>

	
</xsl:stylesheet>
