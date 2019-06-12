<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" version="2.0">
    <xsl:strip-space elements="*" />
    <xsl:output method="text"/>
    <xsl:param name="FILENAME">unknown</xsl:param>
    <xsl:param name="FILEDIR">unknown</xsl:param>
    <xsl:param name="OUTPUTDIR">unknown</xsl:param>
    
    <xsl:template match="/">
        <xsl:variable name="QUOTE">"</xsl:variable>
        <xsl:if test="not(contains($FILENAME, 'notes.dita')) and not(contains($FILENAME, 'PortalUI')) and not(contains($FILENAME, 'ditamap'))">
            <xsl:variable name="newstring">
                <xsl:apply-templates select="//conbody/*"/>
                <xsl:apply-templates select="//taskbody/*"/>
                <xsl:apply-templates select="//refbody/*"/>
            </xsl:variable>
            <xsl:variable name="topicType">
                <xsl:choose>
                    <xsl:when test="concept">
                        <xsl:value-of select="'concept'"/>
                    </xsl:when>
                    <xsl:when test="task">
                        <xsl:value-of select="'task'"/>
                    </xsl:when>
                    <xsl:when test="reference">
                        <xsl:value-of select="'reference'"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="topictitle">
                <xsl:value-of select="normalize-space(/concept/title)"/>
                <xsl:value-of select="normalize-space(/task/title)"/>
                <xsl:value-of select="normalize-space(/reference/title)"/>
            </xsl:variable>
            {
            "title": "<xsl:value-of select="replace($topictitle, $QUOTE, '&amp;quot;')"/>",
            "text": "<xsl:value-of select="$newstring"/>",
            "type": "<xsl:value-of select="$topicType"/>",
            "href": "<xsl:value-of select="replace($FILENAME, '.dita', '.htm')"/>"
            },</xsl:if></xsl:template>
    
    <!-- double-escape quote to avoid breaking the generated javascript files. -->
    <xsl:variable name="QUOTE">"</xsl:variable>
    <xsl:template name="do-clean-string">
        <xsl:param name="str"/>
        <xsl:value-of select="normalize-space(replace($str, $QUOTE, '&amp;quot;'))"/>
    </xsl:template>
    
    <xsl:template match="text()"><xsl:value-of select="normalize-space(replace(., $QUOTE, '&amp;quot;'))"/></xsl:template>
    
    <xsl:template match="*[contains(@class, 'p')]"><xsl:choose><xsl:when test="parent::li"><xsl:apply-templates/></xsl:when><xsl:otherwise>&lt;p><xsl:apply-templates/>&lt;/p></xsl:otherwise></xsl:choose></xsl:template>
    
    <xsl:template match="*[contains(@class, 'dl')]">&lt;dl><xsl:apply-templates/>&lt;/dl></xsl:template>
    
    <xsl:template match="*[contains(@class, 'dlentry')]"><xsl:apply-templates/></xsl:template>
    
    <xsl:template match="*[contains(@class, 'dt')]">&lt;dt><xsl:apply-templates/>&lt;/dt></xsl:template>
    
    <xsl:template match="*[contains(@class, 'dd')]">&lt;dd><xsl:apply-templates/>&lt;/dd></xsl:template>
    
    <xsl:template match="*[contains(@class, 'uicontrol')]" priority="5"><xsl:text> </xsl:text>&lt;span class='uicontrol'><xsl:apply-templates/>&lt;/span><xsl:if test="not(starts-with(following-sibling::text()[1], '.')) and not(starts-with(following-sibling::text()[1], ',')) and not(starts-with(following-sibling::text()[1], ':'))"><xsl:text> </xsl:text></xsl:if></xsl:template>
    
    <xsl:template match="*[contains(@class, 'title')]"><xsl:choose><xsl:when test="parent::*[contains(@class, ' topic/section ')]">&lt;h3><xsl:apply-templates/>&lt;/h3></xsl:when><xsl:when test="parent::*[contains(@class, ' topic/table ')]">&lt;caption><xsl:apply-templates/>&lt;/caption></xsl:when><xsl:when test="parent::*[contains(@class, ' topic/fig ')]">&lt;figcaption><xsl:apply-templates/>&lt;/figcaption></xsl:when><xsl:otherwise>&lt;title><xsl:apply-templates/>&lt;/title></xsl:otherwise></xsl:choose></xsl:template>
    
    <xsl:template match="*[contains(@class, ' task/step ')]" priority="5">&lt;li class='step'><xsl:apply-templates/>&lt;/li></xsl:template>
    
    <xsl:template match="*[contains(@class, 'li')]">&lt;li><xsl:apply-templates/>&lt;/li></xsl:template>
    
    <xsl:template match="*[contains(@class, 'steps')]">&lt;ol><xsl:apply-templates/>&lt;/ol></xsl:template>
    
    <xsl:template match="*[contains(@class, 'topic/ul')]">&lt;ul><xsl:apply-templates/>&lt;/ul></xsl:template>
    
    <!-- Increate priority. Otherwise topic/ph always wins. -->
    <xsl:template match="*[contains(@class, ' task/cmd ')]" priority="5"><xsl:apply-templates/></xsl:template>
    
    <xsl:template match="*[contains(@class, 'section')]">&lt;section><xsl:apply-templates/>&lt;/section></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/fig ')]">&lt;figure><xsl:apply-templates/>&lt;/figure></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/note ')][contains(@type, 'note')]">&lt;div class='note-container'>&lt;div class='note-note'>&lt;i class='material-icons'>error_outline&lt;/i>&lt;/div>&lt;div class='note-content'><xsl:apply-templates/>&lt;/div>&lt;/div></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/note ')]">&lt;div class='note-container'>&lt;div class='note-note'>&lt;i class='material-icons'>error_outline&lt;/i>&lt;/div>&lt;div class='note-content'><xsl:apply-templates/>&lt;/div>&lt;/div></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/note ')][contains(@type, 'warning')]">&lt;div class='note-container'>&lt;div class='note-note'>&lt;i class='material-icons'>warning&lt;/i>&lt;/div>&lt;div class='note-content'><xsl:apply-templates/>&lt;/div>&lt;/div></xsl:template>
    
    <xsl:template match="*[contains(@class, 'context')]">&lt;div class='context'><xsl:apply-templates/>&lt;/div></xsl:template>
    
    <xsl:template match="*[contains(@class, ' task/info')]">&lt;div class='info'><xsl:apply-templates/>&lt;/div></xsl:template>
    
    <xsl:template match="*[contains(@class, 'postreq')]">&lt;div class='postreq'><xsl:apply-templates/>&lt;/div></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/desc ')]"></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/ph ')]"><xsl:text> </xsl:text>&lt;span><xsl:apply-templates/>&lt;/span><xsl:if test="not(starts-with(following-sibling::text()[1], '.')) and not(starts-with(following-sibling::text()[1], ',')) and not(starts-with(following-sibling::text()[1], ':'))"><xsl:text> </xsl:text></xsl:if></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/image ')]"><xsl:choose><xsl:when test="parent::*[contains(@class, ' topic/fig ')]">&lt;img class='topic-fig-image' src='<xsl:value-of select="replace(@href, 'Images/', 'assets/images/')"/>'><xsl:apply-templates/>&lt;/img></xsl:when><xsl:otherwise><xsl:text> </xsl:text>&lt;img class='topic-inline-image' src='<xsl:value-of select="replace(@href, 'Images/', 'assets/images/')"/>'><xsl:apply-templates/>&lt;/img><xsl:if test="not(starts-with(following-sibling::text()[1], '.')) and not(starts-with(following-sibling::text()[1], ',')) and not(starts-with(following-sibling::text()[1], ':'))"><xsl:text> </xsl:text></xsl:if></xsl:otherwise></xsl:choose></xsl:template>
    
    <xsl:template match="*[contains(@class, 'xref')]"><xsl:text> </xsl:text>&lt;a href='<xsl:value-of select="replace(@href, '.dita', '.htm')"/>' title='<xsl:value-of select="desc"/>'><xsl:apply-templates/>&lt;/a><xsl:if test="not(starts-with(following-sibling::text()[1], '.')) and not(starts-with(following-sibling::text()[1], ',')) and not(starts-with(following-sibling::text()[1], ':'))"><xsl:text> </xsl:text></xsl:if></xsl:template>
    
    <!-- Table handling -->
    <xsl:template match="*[contains(@class, ' topic/table ')]">&lt;table><xsl:apply-templates/>&lt;/table></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/thead ')]">&lt;thead><xsl:apply-templates/>&lt;/thead></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/row ')]">&lt;tr><xsl:apply-templates/>&lt;/tr></xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/entry ')]"><xsl:choose><xsl:when test="parent::*[contains(@class, ' topic/thead ')]"><xsl:choose><xsl:when test="@dita-ot:morecols">&lt;th colspan='<xsl:value-of select="@dita-ot:morecols + 1"/>'><xsl:apply-templates/>&lt;/th></xsl:when><xsl:otherwise>&lt;th><xsl:apply-templates/>&lt;/th></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise><xsl:choose><xsl:when test="@dita-ot:morecols">&lt;td colspan='<xsl:value-of select="@dita-ot:morecols + 1"/>'><xsl:apply-templates/>&lt;/td></xsl:when><xsl:otherwise>&lt;td><xsl:apply-templates/>&lt;/td></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose></xsl:template> 
    
    <!-- try to capture everything else as well. -->
    <xsl:template match="*[child::text()[normalize-space()]]" priority="-10">
        <xsl:call-template name="insert-element">
            <xsl:with-param name="str" select="string()"/>
        </xsl:call-template>        
    </xsl:template>
    
    <xsl:template name="insert-element">
        <xsl:param name="str"/>
        <xsl:call-template name="do-clean-string">
            <xsl:with-param name="str" select="$str"/>
        </xsl:call-template>
    </xsl:template>
    
</xsl:stylesheet>