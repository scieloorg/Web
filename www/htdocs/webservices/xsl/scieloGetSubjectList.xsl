<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes"/>

	<xsl:variable name="applServer" select="//vars/applServer"/>
	<xsl:variable name="country" select="//vars/country"/>
	<xsl:variable name="subject" select="//vars/subject"/>
	<xsl:variable name="regionalScielo" select="//vars/regionalScielo"/>
	<xsl:variable name="sorted">
				<xsl:apply-templates select="//record" mode="sort">
					<xsl:sort select="subject/occ"/>
				</xsl:apply-templates>
	</xsl:variable>

	<xsl:template match="/">

		<rss version="0.91">
			<channel>
				<title>SciELO Get Subject List</title>
				<link>http://<xsl:value-of select="//applServer"/></link>
				<description>get_list_subject</description>
				<language>pt-br</language>
				<xsl:apply-templates select="$sorted//record"/>
			</channel>
		</rss>
	</xsl:template>
	
	<xsl:template match="record" mode="sort">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="record">
		<xsl:variable name="current" select="normalize-space(subject/occ)"/>
		<xsl:variable name="previous" select="normalize-space(preceding-sibling::record[position() = 1]/subject/occ)"/>
		<xsl:variable name="pid" select="issn/occ"/>
		<xsl:variable name="sta" select="publicationStatus/occ"/>

		<xsl:if test="($current != $previous)">
			<xsl:if test="$sta = 'C'">
				<item>
                                        <title><xsl:value-of select="subject/occ"/></title>
                                        <link><xsl:value-of select="concat('http://',$regionalScielo,'/webservices/php/get_titles.php?type=subject&amp;param=',$current,'&amp;collection=',$applServer)"/></link>
                                        <description>Lista de Revista do Assunto <xsl:value-of select="$current"/> </description>
                                </item>
			</xsl:if>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
