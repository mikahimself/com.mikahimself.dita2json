<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    version="2.0"
    exclude-result-prefixes="xs dita-ot ditamsg">
    <xsl:output method="text"/>
    
    <!-- Use tabs to indent entries -->
    <xsl:variable name="TABS" select="'&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;'" />
    
    <xsl:template match="/">
        <xsl:apply-templates mode="toc"></xsl:apply-templates>
    </xsl:template>
    
    
    <!-- Go through TOC -->
    <xsl:template match="*[contains(@class, ' map/map ')]" mode="toc">
        <xsl:param name="pathFromMaplist"/>
        <xsl:if test="descendant::*[contains(@class, ' map/topicref ')][not(@toc = 'no')][not(@processing-role = 'resource-only')]">[<xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc"></xsl:apply-templates>
]</xsl:if>
    </xsl:template>
    
    <!-- Pick up title -->
    <xsl:template match="*" mode="get-navtitle">
        <xsl:choose>
            <!-- If navtitle is specified -->
            <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]">
                <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]"
                    mode="dita-ot:text-only"/>
            </xsl:when>
            <xsl:when test="@navtitle">
                <xsl:value-of select="@navtitle"/>
            </xsl:when>
            <!-- If there is no title and none can be retrieved, check for <linktext> -->
            <xsl:when test="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]">
                <xsl:apply-templates select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/linktext ')]"
                    mode="dita-ot:text-only"/>
            </xsl:when>
            <!-- No local title, and not targeting a DITA file. Could be just a container setting
           metadata, or a file reference with no title. Issue message for the second case. -->
            <xsl:otherwise>
                <xsl:if test="normalize-space(@href)">
                    <xsl:apply-templates select="." mode="ditamsg:could-not-retrieve-navtitle-using-fallback">
                        <xsl:with-param name="target" select="@href"/>
                        <xsl:with-param name="fallback" select="@href"/>
                    </xsl:apply-templates>
                    <xsl:value-of select="@href"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--  Generate TOC JSON-->
    <xsl:template match="*[contains(@class, ' map/topicref ')]
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]"
        mode="toc" priority="10">
        <xsl:param name="children" select="*[contains(@class, ' map/topicref ')]"/>
        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="normalize-space($title)">               
                <xsl:choose>
                    <!-- When topicref/chapter contains a href -->
                    <xsl:when test="normalize-space(@href)">
                        <xsl:variable name="level">
                            <xsl:value-of select="count(ancestor::*) * 4"/>"
                        </xsl:variable>
                        <xsl:text>&#xa;</xsl:text>
                        <xsl:value-of select="substring($TABS, 0, count(ancestor::*) + count(ancestor::*) )"/><xsl:text>{&#xa;</xsl:text>
                        <xsl:value-of select="substring($TABS, 0, count(ancestor::*) + count(ancestor::*) + 1)"/><xsl:text>"name": "</xsl:text><xsl:value-of select="$title"></xsl:value-of><xsl:text>", &#xa;</xsl:text>
                        <xsl:value-of select="substring($TABS, 0, count(ancestor::*) + count(ancestor::*) + 1)"/><xsl:text>"href": "</xsl:text><xsl:value-of select="replace(@href, '.dita', '.htm')"/><xsl:text>"</xsl:text><xsl:if test="not(exists($children))"><xsl:text>&#xa;</xsl:text><xsl:value-of select="substring($TABS, 1, count(ancestor::*)  + count(ancestor::*) - 1)"/><xsl:text>}</xsl:text><xsl:if test="following-sibling::*">,</xsl:if><xsl:if test="not(following-sibling::*)"></xsl:if></xsl:if><xsl:if test="(exists($children))"><xsl:text>,&#xa;</xsl:text></xsl:if>
                        <xsl:if test="exists($children)">
                            <xsl:value-of select="substring($TABS, 1, count(ancestor::*) + count(ancestor::*))"/><xsl:text>"children": [</xsl:text>
                            <xsl:apply-templates select="$children" mode="#current"></xsl:apply-templates>
                            <xsl:text>&#xa;</xsl:text>
                            <xsl:value-of select="substring($TABS, 1, count(ancestor::*) + count(ancestor::*))"/><xsl:text>]</xsl:text><xsl:text>&#xa;</xsl:text><xsl:value-of select="substring($TABS, 1, count(ancestor::*) * 2 - 1)"/><xsl:text>}</xsl:text><xsl:if test="following-sibling::*">,&#xa;</xsl:if><xsl:if test="not(following-sibling::*)">&#xa;</xsl:if>
                        </xsl:if>
                    </xsl:when>
                    <!-- When topicref/chapter only contains a navtitle -->
                    <xsl:otherwise>
                        <xsl:variable name="level">
                            <xsl:value-of select="count(ancestor::*) * 4"/>"
                        </xsl:variable>
                        <xsl:text>&#xa;</xsl:text>
                        <xsl:value-of select="substring($TABS, 0, count(ancestor::*) + count(ancestor::*) )"/><xsl:text>{&#xa;</xsl:text>
                        <xsl:value-of select="substring($TABS, 0, count(ancestor::*) + count(ancestor::*) + 1)"/><xsl:text>"name": "</xsl:text><xsl:value-of select="$title"></xsl:value-of><xsl:text>", &#xa;</xsl:text>
                        <xsl:value-of select="substring($TABS, 0, count(ancestor::*) + count(ancestor::*) + 1)"/><xsl:text>"href": "</xsl:text><xsl:value-of select="'#'"/><xsl:text>"</xsl:text><xsl:if test="not(exists($children))"><xsl:text>&#xa;</xsl:text><xsl:value-of select="substring($TABS, 1, count(ancestor::*)  + count(ancestor::*) - 1)"/><xsl:text>}</xsl:text><xsl:if test="following-sibling::*">,</xsl:if><xsl:if test="not(following-sibling::*)"></xsl:if></xsl:if><xsl:if test="(exists($children))"><xsl:text>,&#xa;</xsl:text></xsl:if>
                        <xsl:if test="exists($children)">
                            <xsl:value-of select="substring($TABS, 1, count(ancestor::*) + count(ancestor::*))"/><xsl:text>"children": [</xsl:text>
                            <xsl:apply-templates select="$children" mode="#current"></xsl:apply-templates>
                            <xsl:text>&#xa;</xsl:text>
                            <xsl:value-of select="substring($TABS, 1, count(ancestor::*) + count(ancestor::*))"/><xsl:text>]</xsl:text><xsl:text>&#xa;</xsl:text><xsl:value-of select="substring($TABS, 1, count(ancestor::*) * 2 - 1)"/><xsl:text>}</xsl:text><xsl:if test="following-sibling::*">,&#xa;</xsl:if><xsl:if test="not(following-sibling::*)">&#xa;</xsl:if>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
