<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="yes" />

<xsl:param name="xml-path" />
<xsl:variable name="base-path" select="substring-before($xml-path,'xml/')"/>	

<xsl:variable name="group" select="/root/http-info/cgi/group"/>

<xsl:template match="/">		
		<xsl:apply-templates select="/bvs/collectionList"/>
</xsl:template>

<xsl:template match="collectionList">	
	<define>
		<!-- sources -->
		<sourceList>
			<xsl:for-each select=".//item[@type = 'collection']">
				<xsl:apply-templates select="document(concat($base-path,@file))/*" mode="source-list">
					<xsl:with-param name="colid" select="@id"/>
				</xsl:apply-templates>	
			</xsl:for-each>	
		</sourceList>	
		<!-- free search -->
		<search>
			<xsl:for-each select=".//item[@type = 'collection']">
				<xsl:apply-templates select="document(concat($base-path,@file))/*" mode="search">
					<xsl:with-param name="colid" select="@id"/>
				</xsl:apply-templates>		
			</xsl:for-each>			
		</search>
		
		<!-- topic -->		
		<xsl:for-each select=".//item[@type = 'topic']">
			<xsl:apply-templates select="document(concat($base-path,@file))/*" mode="topic">
				<xsl:with-param name="topid" select="@id"/>
			</xsl:apply-templates>	
		</xsl:for-each>			
		
		<!--		
		<xsl:apply-templates select="document(item[@href = 'topic']/@file)/*"/>
		-->
	</define>
</xsl:template>


<xsl:template match="topic" mode="topic">
	<xsl:param name="topid"/>

	<xsl:apply-templates select=".//item[info-source/@search-parameters | .//info-source/@search-parameters]" mode="topic">
		<xsl:with-param name="topid" select="$topid"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="collection" mode="source-list">
	<xsl:param name="colid"/>
	
	<xsl:choose>
		<xsl:when test="$group != ''">
			<xsl:apply-templates select="//item[@id = $group]" mode="source-group">	
				<xsl:with-param name="colid" select="$colid"/>
			</xsl:apply-templates>
		</xsl:when>			
		<xsl:otherwise>
			<!-- aplica para item que possue um item configurado com metapesquisa
			<xsl:apply-templates select="//item[item/meta-search/@base-search-url]" mode="source-group">
				<xsl:with-param name="colid" select="$colid"/>
			</xsl:apply-templates>
			-->
			<!-- aplica para item em qualquer nivel --> 	
			<xsl:apply-templates select="./item[.//meta-search/@base-search-url | meta-search/@base-search-url]" mode="source-group">
				<xsl:with-param name="colid" select="$colid"/>
			</xsl:apply-templates>			
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="collection" mode="search">
	<xsl:param name="colid"/>
	
	<xsl:choose>
		<xsl:when test="$group != ''">
			<xsl:apply-templates select="//item[@id = $group]//item[meta-search/@base-search-url]" mode="search">
				<xsl:with-param name="colid" select="$colid"/>	
			</xsl:apply-templates>			
		</xsl:when>			
		<xsl:otherwise>				
			<xsl:apply-templates select="//item[meta-search/@base-search-url]" mode="search">
				<xsl:with-param name="colid" select="$colid"/>				
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>		
</xsl:template>


<xsl:template match="item" mode="source-group">	
	<xsl:param name="colid"/>
	<group>
		<xsl:attribute name="label"><xsl:apply-templates select="text()"/></xsl:attribute>
		<xsl:if test="meta-search/@base-search-url">
			<xsl:apply-templates select="." mode="source-list">
				<xsl:with-param name="colid" select="$colid"/>
			</xsl:apply-templates>					
		</xsl:if>
		<xsl:apply-templates select=".//item[meta-search/@base-search-url]" mode="source-list">
			<xsl:with-param name="colid" select="$colid"/>
		</xsl:apply-templates>
	</group>	
</xsl:template>

<xsl:template match="*" mode="source-list">
	<xsl:param name="colid"/>
	<item>
		<xsl:attribute name="id"><xsl:value-of select="concat($colid,'-',@id)"/></xsl:attribute>
		<xsl:attribute name="label"><xsl:apply-templates select="text()"/></xsl:attribute>
		<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
		<xsl:apply-templates select="meta-search" mode="source-list"/>	
	</item>
</xsl:template>


<xsl:template match="item" mode="search">
	<xsl:param name="colid"/>
	<item>
		<xsl:attribute name="source"><xsl:value-of select="concat($colid,'-',@id)"/></xsl:attribute>			
		<xsl:apply-templates select="meta-search" mode="search"/>	
	</item>
</xsl:template>

<xsl:template match="item" mode="topic">
	<xsl:param name="topid"/>
	
	<topic>
		<xsl:attribute name="id"><xsl:value-of select="concat($topid,'-',@id)"/></xsl:attribute>
		<xsl:attribute name="label"><xsl:apply-templates select="text()"/></xsl:attribute>
		<xsl:apply-templates select="meta-search" mode="topic"/>	
	</topic>	
</xsl:template>


<xsl:template match="meta-search" mode="source-list" >
		<xsl:apply-templates select="@*[not(name() = 'search-parameters')]" mode="attribute"/>
</xsl:template>

<xsl:template match="meta-search" mode="search" >
		<xsl:apply-templates select="@search-parameters" mode="attribute"/>
</xsl:template>

<xsl:template match="meta-search" mode="topic" >
	<xsl:apply-templates select="info-source"/>
</xsl:template>

<xsl:template match="info-source">
	<xsl:variable name="id" select="@id"/>
	
	<item>
		<xsl:attribute name="source"><xsl:apply-templates select="@id"/></xsl:attribute>		
		<xsl:apply-templates select="@search-parameters" mode="attribute"/>
	</item>
</xsl:template>

<xsl:template match="@*" mode="attribute">
			<xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>	
</xsl:template>

<xsl:template match="item/text()">
		<xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="text()"/>

<xsl:template match="*[@available = 'no']"/>
<xsl:template match="*[@available = 'no']" mode="source-list"/>
<xsl:template match="*[@available = 'no']" mode="search"/>
<xsl:template match="*[@available = 'no']" mode="topic"/>
<xsl:template match="*[@available = 'no']" mode="search-group"/>

</xsl:stylesheet>
