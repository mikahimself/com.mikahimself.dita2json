<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    version="2.0"
    exclude-result-prefixes="xs dita-ot ditamsg">
    
    <xsl:template match="*" mode="gen-user-sidetoc">
        <xsl:if test="$nav-toc = ('partial', 'full')">
            <div class="col-xs-6 col-sm-4 sidebar-offcanvas one-third-right-column pad-top15" id="sidebar">
                <div class="list-group" id="dita-menu">
                    <xsl:choose>
                        <xsl:when test="$nav-toc = 'partial'">
                            <xsl:apply-templates select="$current-topicrefs[1]" mode="toc-pull">
                                <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                                <xsl:with-param name="children" as="element()*">
                                    <xsl:apply-templates select="$current-topicrefs[1]/*[contains(@class, ' map/topicref ')]" mode="toc">
                                        <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                                    </xsl:apply-templates>
                                </xsl:with-param>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:when test="$nav-toc = 'full'">
                            <xsl:apply-templates select="$input.map" mode="toc">
                                <xsl:with-param name="pathFromMaplist" select="$PATH2PROJ" as="xs:string"/>
                            </xsl:apply-templates>
                        </xsl:when>
                    </xsl:choose>
                </div>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- Testing. -->
    <!-- This place start the processing of index.html file. -->
    <xsl:template match="*[contains(@class, ' map/map ')]" mode="toc">
        <xsl:param name="pathFromMaplist"/>
        <xsl:if test="descendant::*[contains(@class, ' map/topicref ')]
            [not(@toc = 'no')]
            [not(@processing-role = 'resource-only')]">
            <nav>
                <div>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
                        <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                    </xsl:apply-templates>
                </div>
            </nav>
            
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="gen-user-head">
        <xsl:apply-templates select="." mode="gen-user-head"/>
    </xsl:template>
    <xsl:template match="/|node()|@*" mode="gen-user-head">
        <!-- to customize: copy this to your override transform, add the content you want. -->
        <!-- it will be placed in the HEAD section of the XHTML. -->
    </xsl:template>
    
    <xsl:template name="gen-user-header">
        <xsl:apply-templates select="." mode="gen-user-header"/>
    </xsl:template>
    <xsl:template match="/|node()|@*" mode="gen-user-header">
        <!-- to customize: copy this to your override transform, add the content you want. -->
        <!-- it will be placed in the running heading section of the XHTML. -->
    </xsl:template>
    
    <xsl:template name="gen-user-footer">
        <!--<xsl:apply-templates select="." mode="gen-user-footer"/>-->
    </xsl:template>
    <xsl:template match="/|node()|@*" mode="gen-user-footer">
        <!-- to customize: copy this to your override transform, add the content you want. -->
        <!-- it will be placed in the running footing section of the XHTML. -->
    </xsl:template>
    
    
    
    <!-- end testing -->
    
    <!-- testing -->
    <xsl:template match="*[contains(@class, ' map/topicref ')]
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]"
        mode="toc">
        <xsl:param name="pathFromMaplist"/>
        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space($title)">
                <div class="porksu">
                    <!--<xsl:call-template name="commonattributes"/>-->
                    <xsl:choose>
                        <!-- If there is a reference to a DITA or HTML file, and it is not external: -->
                        <xsl:when test="normalize-space(@href)">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:choose>
                                        <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and 
                                            (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                                            <xsl:if test="not(@scope = 'external')">
                                                <xsl:value-of select="$pathFromMaplist"/>
                                            </xsl:if>
                                            <xsl:call-template name="replace-extension">
                                                <xsl:with-param name="filename" select="@copy-to"/>
                                                <xsl:with-param name="extension" select="$OUTEXT"/>
                                            </xsl:call-template>
                                            <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                                <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                                            <xsl:if test="not(@scope = 'external')">
                                                <xsl:value-of select="$pathFromMaplist"/>
                                            </xsl:if>
                                            <xsl:call-template name="replace-extension">
                                                <xsl:with-param name="filename" select="@href"/>
                                                <xsl:with-param name="extension" select="$OUTEXT"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise><!-- If non-DITA, keep the href as-is -->
                                            <xsl:if test="not(@scope = 'external')">
                                                <xsl:value-of select="$pathFromMaplist"/>
                                            </xsl:if>
                                            <xsl:value-of select="@href"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:if test="@scope = 'external' or not(not(@format) or @format = 'dita' or @format = 'ditamap')">
                                    <xsl:attribute name="target">_blank</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="$title"/>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$title"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- If there are any children that should be in the TOC, process them -->
                    <xsl:if test="descendant::*[contains(@class, ' map/topicref ')]
                        [not(@toc = 'no')]
                        [not(@processing-role = 'resource-only')]">
                        <ul>
                            <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
                                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                            </xsl:apply-templates>
                        </ul>
                    </xsl:if>
                </div>
            </xsl:when>
            <xsl:otherwise><!-- if it is an empty topicref -->
                <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
                    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- end testing -->
    
    <xsl:template match="*[contains(@class, ' map/topicref ')]
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]"
        mode="toc-pull" priority="10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <xsl:param name="children" select="()" as="element()*"/>
        <xsl:param name="parent" select="parent::*" as="element()?"/>
        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>
        <xsl:apply-templates select="$parent" mode="toc-pull">
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            <xsl:with-param name="children" as="element()*">
                <xsl:apply-templates select="preceding-sibling::*[contains(@class, ' map/topicref ')]" mode="toc">
                    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                </xsl:apply-templates>
                <xsl:choose>
                    <xsl:when test="normalize-space($title)">
                        <li class="nav-menu_item">
                            <!--<xsl:if test=". is $current-topicref">
                                <xsl:attribute name="class">active</xsl:attribute>
                            </xsl:if>-->
                            <xsl:choose>
                                <xsl:when test="normalize-space(@href)">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:if test="not(@scope = 'external')">
                                                <xsl:value-of select="$pathFromMaplist"/>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and 
                                                    (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                                                    <xsl:call-template name="replace-extension">
                                                        <xsl:with-param name="filename" select="@copy-to"/>
                                                        <xsl:with-param name="extension" select="$OUTEXT"/>
                                                    </xsl:call-template>
                                                    <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                                        <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                                                    <xsl:call-template name="replace-extension">
                                                        <xsl:with-param name="filename" select="@href"/>
                                                        <xsl:with-param name="extension" select="$OUTEXT"/>
                                                    </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="@href"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:attribute>
                                        <xsl:value-of select="$title"/>
                                    </a>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$title"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="exists($children)">
                                <ul class="nav nav-sidebar collapse" id="{concat('drilldown', position())}">
                                    <xsl:copy-of select="$children"/>
                                </ul>
                            </xsl:if>
                        </li>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
                            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates select="following-sibling::*[contains(@class, ' map/topicref ')]" mode="toc">
                    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                </xsl:apply-templates>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    
    
    <!-- THIS IS THE PROPER TEMPLATE TO BUILD NAVIGATION CURRENTLY 2019-05-23 -->
    <!--<xsl:template match="*[contains(@class, ' map/topicref ')]
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]"
        mode="toc" priority="10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <!-\- Commented out for testing 2019-05-23 -\->
        <!-\-<xsl:param name="children" select="if ($nav-toc = 'full') then *[contains(@class, ' map/topicref ')] else ()" as="element()*"/>-\->
        <xsl:param name="children" select="*[contains(@class, ' map/topicref ')]"/>
        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space($title)">
                <!-\-<li>-\->
                    <xsl:variable name="collapseID">
                        <xsl:value-of select="generate-id()"></xsl:value-of>
                    </xsl:variable>
                    <xsl:variable name="parentID">
                        <xsl:value-of select="concat('parent-', generate-id())"/>
                    </xsl:variable> 
                    <xsl:choose>
                        <xsl:when test="normalize-space(@href)">
                            <!-\-<xsl:if test="exists($children)">
                                <span class="nav-arrow pull-left collapsed" aria-expanded="true">
                                <xsl:attribute name="data-toggle">
                                    <xsl:value-of select="'collapse'"/>
                                </xsl:attribute>
                                <xsl:attribute name="data-target">
                                    <xsl:value-of select="concat('#', $collapseID)"/>
                                </xsl:attribute>
                                 </span>
                            </xsl:if>-\->
                            <!-\-<xsl:if test="not(exists($children))">
                                <span class="glyphicon glyphicon-chevron-right nav-arrow pull-left" aria-expanded="true" style="visibility:hidden"/>
                            </xsl:if>-\->
                            <a class="list-group-item" data-parent="#dita-menu">
                                <!-\- <xsl:if test=". is $current-topicref">
                                    <xsl:attribute name="class">active</xsl:attribute>
                                </xsl:if> -\->
                                <xsl:if test="exists($children)">
                                    <xsl:attribute name="data-target">
                                        <xsl:value-of select="concat('#', $collapseID)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="data-toggle">
                                        <xsl:value-of select="'collapse'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'list-group-item collapsed'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="aria-expanded" select="'false'"/>
                                </xsl:if>
                                <xsl:attribute name="href">
                                    <xsl:if test="not(@scope = 'external')">
                                        <xsl:value-of select="$pathFromMaplist"/>
                                    </xsl:if>
                                    <!-\-<xsl:value-of select="concat('#', $collapseID)"/>-\->
                                    <xsl:choose>
                                        <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and 
                                            (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                                            <xsl:call-template name="replace-extension">
                                                <xsl:with-param name="filename" select="@copy-to"/>
                                                <xsl:with-param name="extension" select="$OUTEXT"/>
                                            </xsl:call-template>
                                            <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                                <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                                            <xsl:call-template name="replace-extension">
                                                <xsl:with-param name="filename" select="@href"/>
                                                <xsl:with-param name="extension" select="$OUTEXT"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@href"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:if test="exists($children)">
                                    <span class="glyphicon glyphicon-chevron-right">
                                        <xsl:text> </xsl:text>
                                    </span>
                                </xsl:if>
                                <xsl:if test="not(exists($children))">
                                    <span class="glyphicon glyphicon-chevron-right hidden-glyph">
                                        <xsl:text> </xsl:text>
                                    </span>
                                </xsl:if>
                                <span class="list-group-item-title">
                                    <xsl:value-of select="$title"/>
                                </span>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="list-group-item">
                                <xsl:if test="exists($children)">
                                    <xsl:attribute name="data-target">
                                        <xsl:value-of select="concat('#', $collapseID)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="data-toggle">
                                        <xsl:value-of select="'collapse'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'list-group-item collapsed'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="aria-expanded" select="'false'"/>
                                </xsl:if>
                                <span class="glyphicon glyphicon-chevron-right">
                                    <xsl:text> </xsl:text>
                                </span>
                                <span class="list-group-item-title">
                                    <xsl:value-of select="$title"/>
                                </span>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="exists($children)">
                        <div id="{$collapseID}" class="sublinks collapse" data-parent="#dita-menu">
                        <!-\-<ul class="nav nav-sidebar collapse collapsed" ">-\->
                            <xsl:apply-templates select="$children" mode="#current">
                                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                            </xsl:apply-templates>
                        <!-\-</ul>-\->
                        </div>
                    </xsl:if>
                <!-\-</li>-\->
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->
    
    
    <!-- Testing different navigation. -->
    <xsl:template match="*[contains(@class, ' map/topicref ')]
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]"
        mode="toc" priority="10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <!-- Commented out for testing 2019-05-23 -->
        <!--<xsl:param name="children" select="if ($nav-toc = 'full') then *[contains(@class, ' map/topicref ')] else ()" as="element()*"/>-->
        <xsl:param name="children" select="*[contains(@class, ' map/topicref ')]"/>
        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space($title)">
                <!--<li>-->
                    <xsl:variable name="collapseID">
                        <xsl:value-of select="generate-id()"></xsl:value-of>
                    </xsl:variable>
                    <xsl:variable name="parentID">
                        <xsl:value-of select="concat('parent-', generate-id())"/>
                    </xsl:variable> 
                    <xsl:choose>
                        <xsl:when test="normalize-space(@href)">
                            <!--<xsl:if test="exists($children)">
                                <span class="nav-arrow pull-left collapsed" aria-expanded="true">
                                <xsl:attribute name="data-toggle">
                                    <xsl:value-of select="'collapse'"/>
                                </xsl:attribute>
                                <xsl:attribute name="data-target">
                                    <xsl:value-of select="concat('#', $collapseID)"/>
                                </xsl:attribute>
                                 </span>
                            </xsl:if>-->
                            <!--<xsl:if test="not(exists($children))">
                                <span class="glyphicon glyphicon-chevron-right nav-arrow pull-left" aria-expanded="true" style="visibility:hidden"/>
                            </xsl:if>-->
                            <a class="list-group-item" data-parent="#dita-menu">
                                <!-- <xsl:if test=". is $current-topicref">
                                    <xsl:attribute name="class">active</xsl:attribute>
                                </xsl:if> -->
                                <xsl:if test="exists($children)">
                                    <xsl:attribute name="data-target">
                                        <xsl:value-of select="concat('#', $collapseID)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="data-toggle">
                                        <xsl:value-of select="'collapse'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'list-group-item collapsed'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="aria-expanded" select="'false'"/>
                                </xsl:if>
                                <xsl:attribute name="href">
                                    <xsl:if test="not(@scope = 'external')">
                                        <xsl:value-of select="$pathFromMaplist"/>
                                    </xsl:if>
                                    <!--<xsl:value-of select="concat('#', $collapseID)"/>-->
                                    <xsl:choose>
                                        <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and 
                                            (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                                            <xsl:call-template name="replace-extension">
                                                <xsl:with-param name="filename" select="@copy-to"/>
                                                <xsl:with-param name="extension" select="$OUTEXT"/>
                                            </xsl:call-template>
                                            <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                                                <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                                            <xsl:call-template name="replace-extension">
                                                <xsl:with-param name="filename" select="@href"/>
                                                <xsl:with-param name="extension" select="$OUTEXT"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@href"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <xsl:if test="exists($children)">
                                    <span class="glyphicon glyphicon-chevron-right">
                                        <xsl:text> </xsl:text>
                                    </span>
                                </xsl:if>
                                <xsl:if test="not(exists($children))">
                                    <span class="glyphicon glyphicon-chevron-right hidden-glyph">
                                        <xsl:text> </xsl:text>
                                    </span>
                                </xsl:if>
                                <span class="list-group-item-title">
                                    <xsl:value-of select="$title"/>
                                </span>
                            </a>
                        </xsl:when>
                        <xsl:otherwise>
                            <span class="list-group-item">
                                <xsl:if test="exists($children)">
                                    <xsl:attribute name="data-target">
                                        <xsl:value-of select="concat('#', $collapseID)"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="data-toggle">
                                        <xsl:value-of select="'collapse'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="class">
                                        <xsl:value-of select="'list-group-item collapsed'"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="aria-expanded" select="'false'"/>
                                </xsl:if>
                                <span class="glyphicon glyphicon-chevron-right">
                                    <xsl:text> </xsl:text>
                                </span>
                                <span class="list-group-item-title">
                                    <xsl:value-of select="$title"/>
                                </span>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="exists($children)">
                        <div id="{$collapseID}" class="sublinks collapse" data-parent="#dita-menu">
                        <!--<ul class="nav nav-sidebar collapse collapsed" ">-->
                            <xsl:apply-templates select="$children" mode="#current">
                                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                            </xsl:apply-templates>
                        <!--</ul>-->
                        </div>
                    </xsl:if>
                <!--</li>-->
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    
    
    
    <!--main template for setting up all links after the body - applied to the related-links container-->
    <xsl:template match="*[contains(@class, ' topic/related-links ')]" name="topic.related-links">
        <!--<nav role="navigation">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="$include.roles = ('child', 'descendant')">
                <xsl:call-template name="ul-child-links"/>
                <!-\-handle child/descendants outside of linklists in collection-type=unordered or choice-\->
                <xsl:call-template name="ol-child-links"/>
                <!-\-handle child/descendants outside of linklists in collection-type=ordered/sequence-\->
            </xsl:if>
            <xsl:if test="$include.roles = ('next', 'previous', 'parent')">
                <xsl:call-template name="next-prev-parent-links"/>
                <!-\-handle next and previous links-\->
            </xsl:if>
            <!-\- Group all unordered links (which have not already been handled by prior sections). Skip duplicate links. -\->
            <!-\- NOTE: The actual grouping code for related-links:group-unordered-links is common between
             transform types, and is located in ../common/related-links.xsl. Actual code for
             creating group titles and formatting links is located in XSL files specific to each type. -\->
            <xsl:variable name="unordered-links" as="element()*">
                <xsl:apply-templates select="." mode="related-links:group-unordered-links">
                    <xsl:with-param name="nodes"
                        select="descendant::*[contains(@class, ' topic/link ')]
                        [not(related-links:omit-from-unordered-links(.))]
                        [generate-id(.) = generate-id(key('hideduplicates', related-links:hideduplicates(.))[1])]"/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:apply-templates select="$unordered-links"/>
            <!-\-linklists - last but not least, create all the linklists and their links, with no sorting or re-ordering-\->
            <xsl:apply-templates select="*[contains(@class, ' topic/linklist ')]"/>
        </nav>-->
    </xsl:template>
    
    <!-- THIS IS A TEST TEMPLATE TO BUILD NAVIGATION TREE IN JSON. -->
    <!--<xsl:template match="*[contains(@class, ' map/topicref ')]
        [not(@toc = 'no')]
        [not(@processing-role = 'resource-only')]"
        mode="toc" priority="10">
        <xsl:param name="pathFromMaplist" as="xs:string"/>
        <!-\- Commented out for testing 2019-05-23 -\->
        <!-\-<xsl:param name="children" select="if ($nav-toc = 'full') then *[contains(@class, ' map/topicref ')] else ()" as="element()*"/>-\->
        <xsl:param name="children" select="*[contains(@class, ' map/topicref ')]"/>
        <xsl:variable name="title">
            <xsl:apply-templates select="." mode="get-navtitle"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space($title)">
                <!-\-<li>-\->
                <xsl:variable name="collapseID">
                    <xsl:value-of select="generate-id()"></xsl:value-of>
                </xsl:variable>
                <xsl:variable name="parentID">
                    <xsl:value-of select="concat('parent-', generate-id())"/>
                </xsl:variable> 
                <xsl:choose>
                    <xsl:when test="normalize-space(@href)">
<xsl:text>{ </xsl:text>
  <xsl:text>"name": "</xsl:text><xsl:value-of select="$title"></xsl:value-of><xsl:text>", &#xa;</xsl:text>
  <xsl:text>"href": "</xsl:text><xsl:value-of select="@href"/><xsl:text>"</xsl:text><xsl:if test="not(exists($children))"><xsl:text>}</xsl:text><xsl:if test="following-sibling::*">,&#xa;</xsl:if><xsl:if test="not(following-sibling::*)">&#xa;</xsl:if></xsl:if><xsl:if test="(exists($children))"><xsl:text>,&#xa;</xsl:text></xsl:if>
  <xsl:if test="exists($children)">
  <xsl:text>  "children": [</xsl:text>
  <xsl:apply-templates select="$children" mode="#current">
    <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
  </xsl:apply-templates>
  <xsl:text>]}</xsl:text><xsl:if test="following-sibling::*">,&#xa;</xsl:if><xsl:if test="not(following-sibling::*)">&#xa;</xsl:if>
  </xsl:if>
                         
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>"name": "</xsl:text><xsl:value-of select="$title"></xsl:value-of><xsl:text>" }</xsl:text><xsl:if test="following-sibling::*">,&#xa;</xsl:if><xsl:if test="not(following-sibling::*)">&#xa;</xsl:if>
                        <xsl:text></xsl:text>

                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->
    
    
    
</xsl:stylesheet>
