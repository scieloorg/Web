<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="xsl/public/components/default/metasearch.xsl"/>
	<xsl:variable name="metaTexts" select="document('applications/scielo-org/xml/labels.xml')"/>
	<xsl:variable name="metaInstances" select="document(concat('applications/scielo-org/xml/',$lang,'/metaSearchInstances.xml'))"/>	
	
	<xsl:template match="metasearch">

		<div id="search" style="display: block;">
			<h3>
				<span>
					<xsl:value-of select="text[@id = 'search_title']" />
				</span>
			</h3>
			<form name="searchForm" action="#" method="POST" onsubmit="return(executeSearch());">
				<input type="hidden" name="lang"   value="{$lang}" />
				<input type="hidden" name="group"  value="&lt;?= $_REQUEST['id'] ?&gt;" />
				<!--input type="hidden" name="engine" value="metaiah"/-->
				<input type="hidden" name="view" value="&lt;?= $def['RESULT'] ?&gt;"/>
				
				<div class="searchItens">
					<div id="method">	
						<label><xsl:value-of select="$metaTexts//labels[@lang=$lang]/metaSearch/method" /></label><br/>
						<select name="engine">
							<option value="&lt;?=$IAHService?&gt;"><xsl:value-of select="$metaTexts//labels[@lang=$lang]/metaSearch/by_word" /></option>
							<option value="applications/scielo-org/trigrama"><xsl:value-of select="$metaTexts//labels[@lang=$lang]/metaSearch/lexical_proximity" /></option>
							<option value="applications/scielo-org/google_scholar"><xsl:value-of select="$metaTexts//labels[@lang=$lang]/metaSearch/google_scholar" /></option>
							<option value="applications/scielo-org/collexis"><xsl:value-of select="$metaTexts//labels[@lang=$lang]/metaSearch/similarity" /></option>
						</select>
					</div>
					<div id="searchExpression">
						<label><xsl:apply-templates select="text[@id = 'search_entryWords']" /></label><br/>
						<input type="text" name="expression" class="expression" />
					</div>
					<div id="where">
						<label><xsl:value-of select="$metaTexts//labels[@lang=$lang]/metaSearch/where" /></label><br/>
						<select name="where"  onChange="javascript:changeInstanceIndexes(this.selectedIndex);">
							<xsl:apply-templates select="$metaInstances//instance"/>
						</select>
					</div>		
					<input type="submit" value="{text[@id = 'search_submit']}" name="submit" class="submit" />
					<br/><br/>
					<xsl:apply-templates select="$metaInstances//instance" mode="instaceIndexLinks"/>
 				</div>
			</form>
		</div>

		<!-- div AJAX search result -->
       	<!--div id="searchResult" style="display: none;">
           	 <div class="portletTools">
                 <a href="#" onclick="javascript:executeSearch();"><img class="portletRefresh" src="../image/common/refresh.png" border="0"/></a><a href="#" onclick="portletClose('searchResult');"><img class="portletClose" src="../image/common/close.png" border="0"/></a>
   	         </div>
       	     <h3>
			 	<span><xsl:value-of select="text[@id = 'search_results']"/></span>
			</h3>
            <div id="result">				 	
   	        </div>
        </div-->
	</xsl:template>
	
	<xsl:template match="instance">	
		<option value="{concat(googleCode,'|',iahCode,'|',collexisCode,'|',indexCode)}"><xsl:value-of select="@name"/></option>
	</xsl:template>
	
	<xsl:template match="instance" mode="instaceIndexLinks">
		<xsl:choose>
			<xsl:when test="position() = 1">
				<div id="{concat('instance_',position())}" style="display: block;">
					<span id="indexes">
						<xsl:value-of select="$metaTexts//labels[@lang=$lang]/metaSearch/index" /> (<xsl:value-of select="@name"/>): 
						<xsl:apply-templates select="links/*" mode="getLinks"/>
					</span>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div id="{concat('instance_',position())}" style="display: none;">
					<span id="indexes">
						<xsl:value-of select="$metaTexts//labels[@lang=$lang]/metaSearch/index" /> (<xsl:value-of select="@name"/>): 
						<xsl:apply-templates select="links/*" mode="getLinks"/>						
					</span>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="getLinks">
		<xsl:if test="position() != 1">,&#160;</xsl:if><a href="/applications/scielo-org/iah/search.php?mode=index&amp;url={.}"><xsl:value-of select="@name" /></a>
	</xsl:template>
	
</xsl:stylesheet>