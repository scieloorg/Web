<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:include href="sci_common.xsl"/>
    <xsl:variable name="analytics_code" select="//ANALYTICS_CODE"/>
    <xsl:template match="STATISTICS">
        <html>
            <head>
                <link rel="STYLESHEET" type="text/css" href="/css/scielo.css"/>
                <title>
                    <xsl:call-template name="PrintPageTitle"/>
                </title>
                <meta http-equiv="Pragma" content="no-cache"/>
                <meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
            </head>
            <body bgcolor="#FFFFFF">
                <table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                        <td>
                            <p align="center">
                                <a>
                                    <xsl:attribute name="href">http://<xsl:value-of select="CONTROLINFO/SCIELO_INFO/SERVER"/><xsl:value-of select="CONTROLINFO/SCIELO_INFO/PATH_DATA"/>scielo.php?lng=<xsl:value-of select="CONTROLINFO/LANGUAGE"/></xsl:attribute>
                                    <img>
                                        <xsl:attribute name="src"><xsl:value-of select="CONTROLINFO/SCIELO_INFO/PATH_GENIMG"/><xsl:value-of select="CONTROLINFO/LANGUAGE"/>/fbpelogp.gif</xsl:attribute>
                                        <xsl:attribute name="border">0</xsl:attribute>
                                        <xsl:attribute name="align">bottom</xsl:attribute>
                                    </img>
                                </a>
                            </p>
                        </td>
                        <td align="center" width="80%">
                            <blockquote>
                                <p align="left">
                                    <font face="Verdana" size="4" color="#000080">
                                        <xsl:value-of select="$translations/xslid[@id='sci_stat']/text[@find='library_collection']"/>
                                    </font>
                                </p>
                            </blockquote>
                        </td>
                    </tr>
                    <tr>
                        <td/>
                        <td>
                            <br/>
                            <blockquote>
                                <p>
                                    <font size="2" color="#800000">
                                        <xsl:call-template name="PrintPageTitle"/>
                                    </font>
                                </p>
                            </blockquote>
                        </td>
                    </tr>
                    <tr>
                        <td/>
                        <td>
                            <blockquote>
                                <ul>
                                <xsl:apply-templates select="document(concat('../xml/',//CONTROLINFO/LANGUAGE,'/sci_stat.xml'))//text"/>
                                    <li>
                                        <a href="http://analytics.scielo.org/w/accesses/list/journals?collection={$analytics_code}" target="_blank">
                                            <xsl:value-of select="$translations/xslid[@id='sci_stat']/text[@find='journal_requests']"/>
                                        </a>
                                    </li>                                                                
                                    <li>
                                        <a href="http://analytics.scielo.org/w/accesses/list/issues?collection={$analytics_code}" target="_blank">
                                            <xsl:value-of select="$translations/xslid[@id='sci_stat']/text[@find='issue_requests']"/>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="http://analytics.scielo.org/w/accesses/list/articles?collection={$analytics_code}" target="_blank">
                                            <xsl:value-of select="$translations/xslid[@id='sci_stat']/text[@find='article_requests']"/>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="http://analytics.scielo.org/w/accesses?collection={$analytics_code}" target="_blank">
                                            <xsl:value-of select="$translations/xslid[@id='sci_stat']/text[@find='charts_requests']"/>
                                        </a>
                                    </li>
                                </ul>
                            </blockquote>
                        </td>
                    </tr>
                </table>
                <p>&#160;</p>
                <xsl:apply-templates select="COPYRIGHT"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="PrintPageTitle">
        <xsl:value-of select="$translations/xslid[@id='sci_stat']/text[@find='library_site_usage_reports']"/>
    </xsl:template>
    <xsl:template match="COPYRIGHT">
        <xsl:call-template name="COPYRIGHTSCIELO"/>
    </xsl:template>
    <xsl:template match="text[@type='html']">
    <xsl:value-of select="." disable-output-escaping="yes"/>
    </xsl:template>
</xsl:stylesheet>
