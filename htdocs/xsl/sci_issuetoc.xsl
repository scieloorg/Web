<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes" indent="no"/>

	<xsl:include href="sci_navegation.xsl"/>
	
	<xsl:variable name="num" select="//ISSUE/@NUM"/>
	<xsl:variable name="issuetoc_controlInfo" select="//CONTROLINFO"/>
	<xsl:template match="SERIAL">
		<HTML>
			<HEAD>
				<TITLE>
					<xsl:value-of select="//TITLEGROUP/SHORTTITLE" disable-output-escaping="yes"/> -
						<xsl:call-template name="GetStrip">
						<xsl:with-param name="vol" select="//ISSUE/@VOL"/>
						<xsl:with-param name="num" select="//ISSUE/@NUM"/>
						<xsl:with-param name="suppl" select="//ISSUE/@SUPPL"/>
						<xsl:with-param name="lang" select="//CONTROLINFO/LANGUAGE"/>
					</xsl:call-template>
				</TITLE>
				<LINK href="/css/scielo.css" type="text/css" rel="STYLESHEET"/>
				<style type="text/css">
					#pagination{
					    font-size:8pt;
					    border-bottom:1px solid #808080;
					    padding:5px;
					    margin:20px 0;
					    align:justified;
					    width:80%;
					    left:20%
					}
					#xpagination{
					    padding:5px;
					    margin:20px 0;
					}
					#pagination a{
					    font-size:8pt;
					    margin:0 4px;
					    padding:0 2px;
					    font-color:#000;
					    text-decoration:none
					}
					#pageNav{
					    text-align:right;
					    position:absolute;
					    right:20%}
					#pageOf{
					    text-align:left;
					}</style>
				<style type="text/css">
					a{
					    text-decoration:none;
					}</style>
				<META http-equiv="Pragma" content="no-cache"/>
				<META HTTP-EQUIV="Expires" CONTENT="Mon, 06 Jan 1990 00:00:01 GMT"/>
				<!-- link pro RSS aparecer automaticamente no Browser -->
				<xsl:call-template name="AddRssHeaderLink">
					<xsl:with-param name="pid" select="//CURRENT/@PID"/>
					<xsl:with-param name="lang" select="//LANGUAGE"/>
					<xsl:with-param name="server" select="CONTROLINFO/SCIELO_INFO/SERVER"/>
					<xsl:with-param name="script">rss.php</xsl:with-param>
				</xsl:call-template>
	            <xsl:if test="//show_readcube_epdf = '1'">
	                <script src="http://content.readcube.com/scielo/epdf_linker.js" type="text/javascript" async="true"></script>
	            </xsl:if>
			</HEAD>
			<BODY vLink="#800080" bgColor="#ffffff">
				<xsl:call-template name="NAVBAR">
					<xsl:with-param name="bar1">issues</xsl:with-param>
					<xsl:with-param name="bar2">articlesiah</xsl:with-param>
					<xsl:with-param name="scope" select="//TITLEGROUP/SIGLUM"/>
					<xsl:with-param name="home">1</xsl:with-param>
					<xsl:with-param name="alpha">
						<xsl:choose>
							<xsl:when test=" normalize-space(//CONTROLINFO/APP_NAME) = 'scielosp' "
								>0</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates select="//TITLEGROUP"/>
				<CENTER>
					<FONT color="#000080">
						<xsl:apply-templates select="//ISSUE_ISSN">
							<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
						</xsl:apply-templates>
					</FONT>
				</CENTER>
				<br/>
				<div class="content">
					<xsl:apply-templates select="//ISSUE"/>
				</div>
				<xsl:apply-templates select="." mode="footer-journal"/>
			
			<script type="text/javascript" src="/article.js"/>
			<xsl:if test="$journal_manager=1">
				<script type="text/javascript" src="/js/jquery-1.9.1.min.js"/>
				<script type="text/javascript">
					var lng = '<xsl:value-of select="//CONTROLINFO/LANGUAGE"/>';
					var ppid = '<xsl:value-of select="//PAGE_PID"/>';
					  function qry_prs() {
					    var url = "pressrelease/pressreleases_from_pid.php?lng="+lng+"&amp;pid="+ppid;
					    $.ajax({
					      url: url,
					      success: function (data) {
					      	jdata = jQuery.parseJSON(data);
					      	for (var item in jdata['article']){
					      		for (var npid in jdata['article'][item]['pid']){
						      		var pid = jdata['article'][item]['pid'][npid];
                                                                var url = '/pressrelease/pressrelease_display.php?id='+jdata['article'][item]['id']+'&amp;lng='+lng+'&amp;pid='+jdata['article'][item]['pid'];
                                                                url = url.replace(/(\r\n|\n|\r)/gm,"");
						      		var article_html='&#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font><a href="javascript: void(0);" onclick="OpenArticleInfoWindow(850,850,\''+url+'\')">Press Release</a>';
						      		$("#pr_"+pid).html(article_html);
						      		$("#pr_"+pid).show();
					      		}
					      	}
						if (jdata['issue'].length > 0 ){
							$("#pr_issue").show()	
						}
					      	for (var item in jdata['issue']){
					      		jdata['issue'][item];
								var url = '/pressrelease/pressrelease_display.php?id='+jdata['issue'][item]['id']+'&amp;pid='+ppid+'&amp;lng='+lng;
					      		var li = '';
					      		li += '<font face="Symbol" color="#000080">&#183; </font>';
					      		li += '<b style="font-size: 13px;">&#160;'+jdata['issue'][item]['title']+'</b>';
					      		li += '<br/>';
					      		li += '<br/>';
					      		li += '&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<font face="Symbol" color="#000080">&#183; </font>';
					      		li += '<a href="javascript: void(0);" onclick="OpenArticleInfoWindow(850,850,\''+url+'\')">Press Release</a>';
					      		$("#pr_issue_list").append('<li>'+li+'</li>');

					      	}
					      }
					    });
					  }
					  $(document).ready(function() {
					      qry_prs();
					  });
				</script>
			</xsl:if>
			</BODY>
		</HTML>
	</xsl:template>
	<xsl:template match="ISSUE">
		<TABLE width="100%" border="0">
			<TBODY>
				<TR>
					<TD width="8%">&#160;</TD>
					<TD width="82%">
						<P align="left">
							<xsl:apply-templates select="TITLE"/>
							<xsl:apply-templates select="STRIP"/>
						</P>
						<xsl:apply-templates select="PAGES"/>
						<xsl:if test="$journal_manager=1">
							<span id="pr_issue" style="display: none;">
								<table border="0">
									<tbody>
										<tr>
											<td class="section" colspan="2">
												<img>
												<xsl:attribute name="src"><xsl:value-of
												select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"
												/><xsl:value-of
												select="normalize-space(//CONTROLINFO/LANGUAGE)"
												/>/lead.gif</xsl:attribute>
												</img>&#160;Press Release </td>
										</tr>
										<tr>
											<td colspan="2">&#160;</td>
										</tr>
										<tr>
											<td/>
											<td>
												<ul id="pr_issue_list"
												style="padding-left: 0px; list-style: none;"
												> </ul>
											</td>
										</tr>
									</tbody>
								</table>
							</span>
						</xsl:if>
						<table border="0">
							<tbody>
                                                                <xsl:choose>
                                                                <xsl:when test="$journal_manager=1">
                                                                        <xsl:apply-templates select="SECTION[NAME != 'Press Release' or not(NAME)]"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:apply-templates select="SECTION"/>
                                                                </xsl:otherwise>
                                                                </xsl:choose>
							</tbody>
						</table>
						<xsl:apply-templates select="PAGES"/>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
	</xsl:template>
	<xsl:template match="TITLE">
		<FONT COLOR="#005E5E">
			<B>
				<xsl:value-of select="." disable-output-escaping="yes"/>
			</B>
		</FONT>
		<BR/>
		<BR/>
	</xsl:template>
	<xsl:template match="STRIP">
		<FONT class="nomodel" color="#800000">
			<xsl:value-of
				select="$translations//xslid[@id='sci_issuetoc']//text[@find='table_of_contents']"/>
		</FONT>
		<BR/>
		<font color="#800000">
			<xsl:call-template name="SHOWSTRIP">
				<xsl:with-param name="SHORTTITLE" select="SHORTTITLE"/>
				<xsl:with-param name="VOL" select="VOL"/>
				<xsl:with-param name="NUM" select="NUM"/>
				<xsl:with-param name="SUPPL" select="SUPPL"/>
				<xsl:with-param name="CITY" select="CITY"/>
				<xsl:with-param name="MONTH" select="MONTH"/>
				<xsl:with-param name="YEAR" select="YEAR"/>
				<xsl:with-param name="reviewType">
					<xsl:if test="contains(NUM,'review')">provisional</xsl:if>
				</xsl:with-param>
			</xsl:call-template>
		</font>
	</xsl:template>
	<xsl:template match="SECTION">
		<xsl:if test="NAME and not($num='AHEAD')">
			<tr>
				<td class="section" colspan="2">
					<IMG>
						<xsl:attribute name="src"><xsl:value-of
								select="//CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:value-of
								select="normalize-space(//CONTROLINFO/LANGUAGE)"
							/>/lead.gif</xsl:attribute>
					</IMG>
					<font size="-1">&#160;</font>
					<xsl:value-of select="NAME" disable-output-escaping="yes"/>
				</td>
			</tr>
			<tr>
				<td>&#160;</td>
				<xsl:if test="//ISSUE/SECTION/NAME">
					<td>&#160;</td>
				</xsl:if>
			</tr>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$num='AHEAD'">
				<xsl:apply-templates select="ARTICLE">
					<xsl:sort select="@ahpdate"/>
					<xsl:sort select="@DOI"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="ARTICLE"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<xsl:template match="ARTICLE">
		<tr>
			<!-- If there was a section name -->
			<xsl:if test="../NAME">
				<td>&#160;</td>
			</xsl:if>
			<td>
				<xsl:if test="//ISSUE/SECTION/NAME and not(../NAME)">
					<!-- This section has no name but there is another session with name inside the TOC -->
					<xsl:attribute name="colspan">2</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="TITLE and ../NAME">
						<FONT class="normal">
							<font face="Symbol">·</font> &#160;</FONT>
					</xsl:when>
				</xsl:choose>
				<xsl:if test="TITLE">
					<FONT class="normal">
						<B>
							<xsl:value-of select="TITLE" disable-output-escaping="yes"/>
						</B>
					</FONT>
					<br/>
				</xsl:if>
				<FONT class="normal">
					<xsl:apply-templates select="AUTHORS">
						<xsl:with-param name="NORM" select="//CONTROLINFO/STANDARD"/>
						<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
						<xsl:with-param name="AUTHLINK">1</xsl:with-param>
					</xsl:apply-templates>
				</FONT>
				<xsl:if test="TITLE">
					<br/>
					<br/>
				</xsl:if>
				<!-- CENTER -->
				<xsl:apply-templates select="LANGUAGES">
					<xsl:with-param name="LANG" select="//CONTROLINFO/LANGUAGE"/>
					<xsl:with-param name="PID" select="@PID"/>
					<xsl:with-param name="VERIFY" select="/SERIAL/DEBUG/@VERIFY"/>
				</xsl:apply-templates>
				<!-- /CENTER -->
				<tr>
					<td>&#160;</td>
					<xsl:if test="//ISSUE/SECTION/NAME">
						<td>&#160;</td>
					</xsl:if>
				</tr>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="PAGES">
		<div id="pagination">
			<span id="pageOf">
				<xsl:value-of select="$translations//xslid[@id='sci_issuetoc']//text[@find='page']"
				/>&#160; <xsl:value-of select="PAGE[@selected]/@number"/>&#160; <xsl:value-of
					select="$translations//xslid[@id='sci_issuetoc']//text[@find='of']"/>&#160;
					<xsl:value-of select="PAGE[position()=last()]/@number"/>
			</span>
			<span id="pageNav">
				<xsl:value-of
					select="$translations//xslid[@id='sci_issuetoc']//text[@find='gotopage']"
					/>&#160;<xsl:apply-templates select="PAGE" mode="look"/>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="PAGE" mode="look">
		<xsl:if test="@number != '1'"/>
		<span class="page">
			<xsl:apply-templates select="."/>
		</span>
	</xsl:template>
	<xsl:template match="PAGE/@number">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="PAGE[@selected]/@number">
		<strong> &#160;<xsl:value-of select="."/>&#160; </strong>
	</xsl:template>
	<xsl:template match="PAGE">
		<a>
			<xsl:attribute name="href"><xsl:call-template name="getScieloLink"><xsl:with-param
						name="seq" select="$issuetoc_controlInfo/PAGE_PID"/><xsl:with-param
						name="script" select="'sci_issuetoc'"
					/></xsl:call-template>&amp;page=<xsl:value-of select="@number"/></xsl:attribute>
			<xsl:apply-templates select="@number"/>
		</a>
	</xsl:template>
	<xsl:template match="PAGE[@selected='true']">
		<xsl:apply-templates select="@number"/>
	</xsl:template>
	<xsl:template match="PAGE/@selected"> </xsl:template>
</xsl:stylesheet>
