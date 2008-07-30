<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:template match="*">		
		<xsl:copy>
		<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="article|text">
		<article>
			<xsl:apply-templates select="@doctopic" mode="type"/>
			<xsl:apply-templates select="." mode="front"/>
			<xsl:apply-templates select="." mode="body"/>
			<xsl:apply-templates select="." mode="back"/>
		</article>
	</xsl:template>
	<xsl:template match="@doctopic" mode="type">
		<xsl:attribute name="article-type"><xsl:choose><xsl:when test=".='oa'">research-article</xsl:when><xsl:when test=".='ab'">abstract</xsl:when><xsl:when test=".='an'">announcement</xsl:when><xsl:when test=".='co'">article-commentary</xsl:when><xsl:when test=".='cr'">case-report</xsl:when><xsl:when test=".='ed'">editorial</xsl:when><xsl:when test=".='le'">letter</xsl:when><xsl:when test=".='ra'">review-article</xsl:when><xsl:when test=".='sc'">rapid-communication</xsl:when><xsl:when test=".='??'">addendum</xsl:when><xsl:when test=".='??'">book-review</xsl:when><xsl:when test=".='??'">books-received</xsl:when><xsl:when test=".='??'">brief-report</xsl:when><xsl:when test=".='??'">calendar</xsl:when><xsl:when test=".='??'">collection</xsl:when><xsl:when test=".='??'">correction</xsl:when><xsl:when test=".='??'">discussion</xsl:when><xsl:when test=".='??'">dissertation</xsl:when><xsl:when test=".='??'">in-brief</xsl:when><xsl:when test=".='??'">introduction</xsl:when><xsl:when test=".='??'">meeting-report</xsl:when><xsl:when test=".='??'">news</xsl:when><xsl:when test=".='??'">obituary</xsl:when><xsl:when test=".='??'">oration</xsl:when><xsl:when test=".='??'">partial-retraction</xsl:when><xsl:when test=".='??'">product-review</xsl:when><xsl:when test=".='??'">reply</xsl:when><xsl:when test=".='??'">reprint</xsl:when><xsl:when test=".='??'">retraction</xsl:when><xsl:when test=".='??'">translation</xsl:when><xsl:otherwise>other</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template match="*" mode="front">
		<front>
		<xsl:apply-templates select="." mode="journal-meta"/>
		<xsl:apply-templates select="." mode="article-meta"/>
		</front>
	</xsl:template>
	<xsl:template match="article|text" mode="journal-meta">
		<journal-meta>
			<xsl:copy-of select=".//journal-id"/>
			<journal-id journal-id-type="publisher">
				<xsl:value-of select="@issn"/>
			</journal-id>
			<xsl:copy-of select=".//journal-title"/>
			<abbrev-journal-title abbrev-type="publisher">
				<xsl:value-of select="@stitle"/>
			</abbrev-journal-title>
			<issn>
				<xsl:value-of select="@issn"/>
			</issn>
			<publisher>
				<publisher-name>MISSING</publisher-name>
			</publisher>
		</journal-meta>
	</xsl:template>
	<xsl:template match="article|text" mode="article-meta">
		<xsl:variable name="l" select="./@language"/>
		<article-meta>
			<article-id pub-id-type="publisher">S<xsl:value-of select="@issn"/>
				<xsl:value-of select="substring(@dateiso,1,4)"/>
				<xsl:value-of select=".//issue-seqno"/>--MISSING--<xsl:value-of select="substring-after(100000 + @order,'1')"/>
			</article-id>
			<xsl:apply-templates select="." mode="article-title"/>
			<xsl:apply-templates select=".//authgrp" mode="front"/>
			<xsl:apply-templates select=".//aff"/>
			<pub-date pub-type="pub">
				<month>
					<xsl:value-of select="substring(@dateiso,5,2)"/>
				</month>
				<year>
					<xsl:value-of select="substring(@dateiso,1,4)"/>
				</year>
			</pub-date>
			<xsl:apply-templates select="@volid | @issueno | @supplvol | @supplno | @fpage | @lpage"/>
			<xsl:apply-templates select=".//hist"/>
			<xsl:apply-templates select=".//abstract[@language=$l]"/>
			<xsl:apply-templates select=".//abstract[@language!=$l]" mode="trans"/>
			<xsl:apply-templates select=".//keygrp"/>
			<xsl:apply-templates select=".//report"/>
			<xsl:apply-templates select=".//confgrp"/>
		</article-meta>
	</xsl:template>
	<xsl:template match="*" mode="article-title">
		<xsl:variable name="l" select="./@language"/>
		<title-group>
			<article-title xml:lang="{$l}">
				<xsl:value-of select=".//title[@language=$l]"/>
			</article-title>
			<xsl:apply-templates select=".//front//title[@language!=$l]" mode="trans-title"/>
		</title-group>
	</xsl:template>
	<xsl:template match="title" mode="trans-title">
		<trans-title xml:lang="{@language}">
			<xsl:value-of select="."/>
		</trans-title>
	</xsl:template>
	<xsl:template match="authgrp" mode="front">
		<contrib-group>
			<xsl:apply-templates select="author|corpauth" mode="front"/>
		</contrib-group>
	</xsl:template>
	<xsl:template match="author" mode="front">
		<contrib contrib-type="author">
			<name>
				<surname>
					<xsl:value-of select="surname"/>
				</surname>
				<given-names>
					<xsl:value-of select="fname"/>
				</given-names>
			</name>
			<xref ref-type="aff" rid="{@rid}"/>
		</contrib>
	</xsl:template>
	<xsl:template match="corpauth" mode="front">
		<contrib contrib-type="author">
			<collab>
				<xsl:value-of select="orgdiv"/>, <xsl:value-of select="orgname"/>
			</collab>
			<xref ref-type="aff" rid="{@rid}"/>
		</contrib>
	</xsl:template>
	<xsl:template match="aff">
		<aff id="{@id}">
			<xsl:if test="@orgdiv2">
				<xsl:value-of select="@orgdiv2"/>,
			</xsl:if>
			<xsl:if test="@orgdiv1">
				<xsl:value-of select="@orgdiv1"/>,
			</xsl:if>
			<xsl:if test="@orgname">
				<xsl:value-of select="@orgname"/>,
			</xsl:if>
			<xsl:value-of select="city"/>,
			<xsl:value-of select="country"/>
		</aff>
	</xsl:template>
	<xsl:template match="@volid | volid">
		<volume>
			<xsl:value-of select="."/>
		</volume>
	</xsl:template>
	<xsl:template match="@issueno | issueno">
		<issue>
			<xsl:value-of select="."/>
		</issue>
	</xsl:template>
	<xsl:template match="@supplvol | @supplno | suppl">
		<supplement>
			<xsl:value-of select="."/>
		</supplement>
	</xsl:template>
	<xsl:template match="@fpage | fpage">
		<fpage>
			<xsl:value-of select="."/>
		</fpage>
	</xsl:template>
	<xsl:template match="@lpage | lpage">
		<lpage>
			<xsl:value-of select="."/>
		</lpage>
	</xsl:template>
	<xsl:template match="pages">
		<page-range>
			<xsl:value-of select="."/>
		</page-range>
	</xsl:template>
	<xsl:template match="hist">
		<history>
			<xsl:apply-templates select="received | revised | accepted "/>
		</history>
	</xsl:template>
	<xsl:template match="received | revised | accepted">
		<date date-type="{name()}">
			<day>
				<xsl:value-of select="substring(@dateiso,7,2)"/>
			</day>
			<month>
				<xsl:value-of select="substring(@dateiso,5,2)"/>
			</month>
			<year>
				<xsl:value-of select="substring(@dateiso,1,4)"/>
			</year>
		</date>
	</xsl:template>
	<xsl:template match="abstract" mode="trans">
		<trans-abstract xml:lang="{@language}">
			<xsl:apply-templates/>
		</trans-abstract>
	</xsl:template>
	<xsl:template match="abstract">
		<abstract xml:lang="{@language}">
			<xsl:apply-templates/>
		</abstract>
	</xsl:template>
	<xsl:template match="keygrp">
		<kwd-group xml:lang="{keyword[1]/@language}">
			<xsl:apply-templates select="keyword"/>
		</kwd-group>
	</xsl:template>
	<xsl:template match="keyword">
		<kwd>
			<xsl:apply-templates/>
		</kwd>
	</xsl:template>
	<xsl:template match="report">
		<contract-num>
			<xsl:value-of select="rsponsor/contract"/>
		</contract-num>
		<contract-sponsor>
			<xsl:value-of select="rsponsor/orgname"/>
			<xsl:value-of select="rsponsor/orgdiv"/>
		</contract-sponsor>
	</xsl:template>
	<xsl:template match="confgrp">
		<conference>
			<conf-date>
				<xsl:value-of select="date"/>
			</conf-date>
			<conf-name>
				<xsl:value-of select="confname"/>
			</conf-name>
			<conf-num>
				<xsl:value-of select="no"/>
			</conf-num>
			<conf-loc>
				<xsl:value-of select="city"/>
				<xsl:if test="city and state">, </xsl:if>
				<xsl:value-of select="state"/>
				<xsl:if test="city or state">, </xsl:if>
				<xsl:value-of select="country"/>
			</conf-loc>
			<conf-sponsor>
				<xsl:value-of select="sponsor"/>
			</conf-sponsor>
		</conference>
	</xsl:template>
	<xsl:template match="*" mode="body">
		<body>
			<xsl:apply-templates select="body|xmlbody"/>
		</body>
	</xsl:template>
	<xsl:template match="body">
		<![CDATA[<xsl:value-of select="." disable-output-escaping="yes"/>]]>
	</xsl:template>
	<xsl:template match="xmlbody">
		<!--xsl:apply-templates select="*|text()"/-->
	</xsl:template>
	<xsl:template match="subsec | sec">
		<sec>
			<xsl:apply-templates select="@*|*|text()"/>
		</sec>
	</xsl:template>
	<xsl:template match="tabwrap">
		<table-wrap>
			<xsl:apply-templates select="@*|*|text()"/>
		</table-wrap>
	</xsl:template>
	<xsl:template match="figgrp">
		<fig>
			<xsl:apply-templates select="@*|*|text()"/>
		</fig>
	</xsl:template>
	<xsl:template match="graphic/@href">
		<xsl:attribute name="xlink:href"><xsl:value-of select="."/></xsl:attribute>		
	</xsl:template>
	<xsl:template match="*" mode="back">
		<back>
			<xsl:apply-templates select="back/vancouv | back/abnt6023 | back/iso690 | back/other "/>
		</back>
	</xsl:template>
	<xsl:template match="vancouv | abnt6023 | iso690 | other ">
		<ref-list>
			<xsl:apply-templates select="vcitat | acitat | icitat | ocitat "/>
		</ref-list>
	</xsl:template>
	<xsl:template match="vcitat | acitat | icitat | ocitat ">
		<ref id="R{position()}">
			<xsl:apply-templates select="no"/>
			<xsl:variable name="type">
				<xsl:choose>
					<xsl:when test="viserial">journal</xsl:when>
					<xsl:when test="vmonog">book</xsl:when>
					<xsl:when test=".//confgrp">confproc</xsl:when>
					<xsl:when test=".//degree">thesis</xsl:when>
					<xsl:when test=".//patgrp">patent</xsl:when>
					<xsl:otherwise>other</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<citation citation-type="{$type}">
				<xsl:apply-templates select="*[name()!='no']"/>
			</citation>
		</ref>
	</xsl:template>
	<xsl:template match="back//no">
		<label>
			<xsl:value-of select="."/>
		</label>
	</xsl:template>
	<xsl:template match="back//author">
		<person-group person-group-type="author">
			<name>
				<surname>
					<xsl:value-of select="surname"/>
				</surname>
				<given-names>
					<xsl:value-of select="fname"/>
				</given-names>
			</name>
		</person-group>
	</xsl:template>
	<xsl:template match="back//*[contains(name(),'corpaut')]">
		<collab>
			<xsl:value-of select="orgdiv"/>, <xsl:value-of select="orgname"/>
		</collab>
	</xsl:template>
	<xsl:template match="back//title">
		<article-title xml:lang="{@language}">
			<xsl:value-of select="."/>
			<xsl:if test="../subtitle">: <xsl:value-of select="../subtitle"/>
			</xsl:if>
		</article-title>
	</xsl:template>
	<xsl:template match="back//stitle">
		<source>
			<xsl:value-of select="."/>
		</source>
	</xsl:template>
	<xsl:template match="back//date">
		<day>
			<xsl:value-of select="substring(@dateiso,7,2)"/>
		</day>
		<month>
			<xsl:value-of select="substring(@dateiso,5,2)"/>
		</month>
		<year>
			<xsl:value-of select="substring(@dateiso,1,4)"/>
		</year>
	</xsl:template>
	<xsl:template match="back//cited">
		<access-date>
			<xsl:value-of select="."/>
		</access-date>
	</xsl:template>
	<xsl:template match="back//pubname">
		<publisher-name>
			<xsl:value-of select="."/>
		</publisher-name>
	</xsl:template>
	<xsl:template match="back//*[contains(name(),'monog')]//city">
		<publisher-loc>
			<xsl:value-of select="."/>
		</publisher-loc>
	</xsl:template>
</xsl:stylesheet>
