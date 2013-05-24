<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="translations-j" select="document('../xml/journalStatus.xml')//translation[@lang=$interfaceLang]"/>
	
	<!--xsl:template match="term" mode="collection_name">
		<xsl:value-of select="substring-before(.,'COLLECTION_NAME')"/>
		<xsl:value-of select="$SITE_NAME"/>
		<xsl:value-of select="substring-after(.,'COLLECTION_NAME')"/>
	</xsl:template-->
	
	<xsl:template match="date-status" mode="display-hist">
		<li>			
			<xsl:apply-templates select="." mode="display-hist-status">
				<xsl:with-param name="is_first"><xsl:if test="position()=1">yes</xsl:if></xsl:with-param>
				
			</xsl:apply-templates></li>		
	</xsl:template>
	<xsl:template match="date-status|current-status" mode="display-hist-status">
		<xsl:param name="is_first">yes</xsl:param>
		<xsl:apply-templates select="@date"/>: <xsl:apply-templates select="@status"><xsl:with-param name="is_first_admission"><xsl:value-of select="$is_first"/></xsl:with-param></xsl:apply-templates>
		<xsl:if test="@status='D' and ../..//NEWTITLE">;
			<xsl:value-of select="$translations-j//term[@code='continue-as']"/> <xsl:apply-templates select="../..//NEWTITLE"/>
		</xsl:if>				
	</xsl:template>
	<xsl:template match="date-status/@status | current-status/@status">
		<xsl:param name="is_first_admission">no</xsl:param>
		<xsl:variable name="code"><xsl:value-of select="."/></xsl:variable>
		<xsl:choose>
			<xsl:when test=".='C'">
				<xsl:choose>
					<xsl:when test="$is_first_admission='yes'">
						<xsl:apply-templates select="$translations-j//term[@code='admitted']" mode="collection_name"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$translations-j//term[@code='readmitted']" mode="collection_name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$translations-j//term[@code=$code]"/></xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<xsl:template match="date-status/@date | current-status/@date">
		<xsl:if test="substring(.,5,2)!='00'">
			<xsl:call-template name="GET_MONTH_NAME">
				<xsl:with-param name="LANG" select="$interfaceLang"/>
				<xsl:with-param name="MONTH" select="substring(.,5,2)"/>
				<xsl:with-param name="ABREV" select="1"/>
			</xsl:call-template>&#160;
		</xsl:if>
		<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
	
	
	
	<xsl:template match="*" mode="display-msg-current-list">
		<xsl:param name="count"/>
		<p>
			<xsl:value-of select="$translations-j//term[@code='current-titles']"/>
 - <xsl:value-of select="$count"/>&#160;
			<xsl:value-of select="$translations-j//term[@code='journal-list']"/>
		</p>
	</xsl:template>
	<xsl:template match="*" mode="display-msg-not-current-list">
		<xsl:param name="count"/>
		<p>
			<xsl:value-of select="$translations-j//term[@code='not-current-titles']"/>
 - <xsl:value-of select="$count"/>&#160;
			<xsl:value-of select="$translations-j//term[@code='journal-list']"/>
		</p>
	</xsl:template>
	
	
	<!--
	
	-->
	
	<xsl:template match="journal-status-history" mode="display-status-info">
		<xsl:if test=".//current-status/@status!='C' and .//current-status/@status!=''">
			<!--&#160; [ -->
			<span class="status-info-alphabetic-list">
				<xsl:apply-templates select=".//current-status" mode="display-hist-status"></xsl:apply-templates>
			</span>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="journal-status-history" mode="display-hist">
		<br/>
		<small>
			<a name="note"/>
			<a class="note2" href="#top">*</a>
			<xsl:apply-templates select="$translations-j//term[@code='hist']" mode="collection_name"/>
		</small>
		<ul>
			<xsl:apply-templates select=".//date-status" mode="display-hist"><xsl:sort select="@date"  order="ascending"/></xsl:apply-templates>
			
		</ul>
	</xsl:template>
	
	<xsl:template match="SERIAL" mode="journal-history">
		<xsl:comment>journal-history</xsl:comment>
		<p>			
			<br/>
			<small>
				<xsl:apply-templates select=".//journal-status-history" mode="display-hist"/>
			</small>
		</p>
	</xsl:template>
	
</xsl:stylesheet>
