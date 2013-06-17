<?xml version="1.0" encoding="UTF-8"?>


<!--
Source: www.ngdc.noaa.gov/nmmrview/xmls/xml-to-text.xsl
Obtained: November 10, 2011 (jmaurer@hawaii.edu)
********************************************************************
xml-to-text.xsl, version 1.0, 06/August/2002

This stylesheet transforms files from XML format to text format. It
was written with the idea of transforming FGDC metadata records, but
could be used for other types of XML files. The code could probably
stand to be cleaned up.

The stylesheet works as follows: The tags of the XML source document
are replaced by labels that are read from an external lookup table
(more about this below). Attributes associated with the tags are
ignored. If a tag appears in the source document and does not have a
translation, no tag label will be written. The element itself will
still be processed, however.

Handling of the content of the XML elements depends on type of
element. A compound element, which contains other elements, will
display those elements indented at a level that corresponds to the
nesting level. An element that contains text will display formatted
text. The look of the text depends on a global parameter. The default
is to display text with the same line wrapping as the original XML
file, but with indentation altered to fit the current indentation
level. This option would make sense if the XML source already had line
breaks that should be preserved. The other option is to fold lines so
they are no longer than a maximum specified length. Lines at broken at
some specified character (typically a space). If it is not possible to
break a line so that its length is less than the maximum length, then
it will be broken at the first possible place after the maximum
length. This option would make sense for documents with elements that
contain long blocks of text without line breaks. XML elements
containing mixed content (other XML elements as well as text) are
treated as compound elements, and the text is ignored. XML elements
such as comments and CDATA elements are ignored.

As an example, the following input:

<foo>
<bar>
        Text.
</bar>
<baz>
<quux>
        Even more text.
        On two or
        three lines.
</quux>
</baz>
</foo>

will be translated to:

Foo:
  Bar: Text
  Baz:
    Quux: Even more text.
      On two or
      three lines.

if using the default settings and assuming tag translations of the
nature of foo -> Foo.

This stylesheet relies on an external XML document to provide a
translation from the XML tag names to the words or phrases that
explain the tags. That document is accessed via the document call in
the match=* template. The document URI is contained in a global
parameter. Change the global parameter as appropriate. In particular
if delivering this stylesheet to a browser to apply the transform, be
sure that the URI refers to a network accessible resource. The format
of the external document should be:

<names>
  <name tagname="idinfo">Identification Information</name>
  <name tagname="citation">Citation</name>
...
</names>

The <name> elements should have the XML tag as a tagname attribute and
the translation as the content of the element.

This stylesheet has been tested with Xalan 2.4.D1 and Saxon 6.5.2.

This stylesheet was developed by Joseph Shirley of
Systems Engineering and Security Incorporated
Suite 700
Greenbelt, Maryland 20770

on behalf of

The National Oceanographic Data Center
1315 East West Highway
Silver Spring, MD 20910


 @version $Id$

 7/5/2006   Richard.Fozzard@noaa.gov
    Refactored to detect and preserve metadata author's formatting with whitespace 
    (as with indented lists or tables), and otherwise to word-wrap long lines 
    into paragraphs. Also, now handles tags without a translation (i.e. not in
    elements.xml.)
    
 10/20/2006   Richard.Fozzard@noaa.gov
    Workaround/performance enhancement: 
     - retrieve translation document just once, instead of for each element
     - resolves a possible memory leak using JSTL x:transform under Xalan 2.6
-->


<!-- Top level directives -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="utils/printFormatted.xsl" />
<xsl:import href="utils/printTextLines.xsl" />
<!-- xsl:import href="utils/printHtmlLines.xsl" / -->

<!-- xsl:output method="html" indent="no" / -->
<xsl:output method="text" indent="yes" />


<!-- Global parameters -->

<!-- 
  g-tag-translation-URI 
    This parameter specifies the URI of the external document
    containing the lookup table for the tag name translation. The
    default is the name of a file in the same directory as the
    stylesheet. Make sure this is a network accessible URI if
    delivering to a browser for translation.
-->
<xsl:param name="g-tag-translation-URI" select="'utils/elements-fgdc.xml'"/>

<!--
  g-indent-increment
    This parameter specifies the character string to be added before a
    label for each level of indentation. I.e. if you want each level
    indented by four spaces, then make this a four space character
    string. Set this to the empty string to forego indenting.
-->
<xsl:param name="g-indent-increment" select="'  '"/>

<!--
  g-fold-width
    This parameter specifies the maximum length of a line when
    word-wrapping lines. It must match the value specified in
    printTextLines.xsl.
-->
<xsl:param name="g-fold-width" select="'80'"/>

<!--
  g-text-field-handler
    This parameter specifies the handler to use for formatting text
    fields. The choices are 'fold' to fold lines at a maximum length
    and 'print-lines' to print lines with line breaks preserved as in
    the source XML document. If unspecified, or if an invalid choice
    is specified, 'print-lines' will be used.
  
  [OBSOLETE: replaced by printFormatted template]
-->
<xsl:param name="g-text-field-handler" select="'print-lines'"/>


<!-- Global variables -->

<xsl:variable name="newline">
<xsl:text>&#xA;</xsl:text>
</xsl:variable>

<!-- Get the g-tag-translation-URI (elements.xml) node-set just once.
    This should improve performance on large XML files.
    This also works around a memory-leak problem using JSTL \<x:transform xsltSystemId
    (the memory-leak may also be present in direct Transformer calls from Java).
    /// We see this in Xalan 2.6.0; is it fixed in 2.7.0 ?
-->
<xsl:variable name="g-tag-translations" select="document($g-tag-translation-URI)"/>


<!-- Templates -->

<xsl:template match="/">
  <!-- xsl:text>&lt;/pRe&gt;</xsl:text--><!-- close useless PRE tag that wraps us -->
  <xsl:apply-templates select="*"/>
  <!-- xsl:text>&lt;PrE&gt;</xsl:text--><!-- reopen useless PRE tag that wraps us -->
</xsl:template>


<!--
  Apply to all elements. Determine whether it's a compound or text element
  and call the appropriate template.
-->

<xsl:template match="*">
  <xsl:param name="indent" select="''"/>
  <xsl:param name="indent-increment" select="$g-indent-increment"/>
  <xsl:variable name="tagname" select="name()"/>
  <!-- xsl:variable name="tag-longname" select="document($g-tag-translation-URI)/*/name[@tagname=$tagname]"/-->
     <xsl:variable name="tag-longname" select="$g-tag-translations/*/name[@tagname=$tagname]"/>
  <xsl:variable name="tag-translation">
    <!-- Display long name if we can translate the tag, else just display the tag name itself -->
    <xsl:choose>
        <xsl:when test="$tag-longname">
            <xsl:value-of select="$tag-longname"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$tagname"/>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="output" select="concat($indent, $tag-translation, ': ')"/>
  <xsl:if test="string-length(normalize-space($tag-translation)) &gt; 0">
    <xsl:value-of select="$output"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="*">
      <!-- This is a compound element (i.e., it has children) -->
      <xsl:choose>
        <xsl:when test="string-length(normalize-space($tag-translation)) &gt; 0">
          <!-- There is a tag translation -->
          <xsl:value-of select="$newline"/><!-- move into $output ?? -->
          <xsl:apply-templates select="*">
            <xsl:with-param name="indent" select="concat($indent, $indent-increment)"/>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <!-- No tag translation -->
            <xsl:apply-templates select="*">
               <xsl:with-param name="indent" select="concat($indent, $indent-increment)"/>
            </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    
    <!-- else a content element: display the text -->
    
    <xsl:otherwise>
        <xsl:value-of select="$newline"/><!-- move into $output ?? -->
        <!-- Call the imported printFormatted template to print both
            preformatted text and word-wrapped paragraphs. 
            This will parse each line, and call back to the
            printFormattedLine and printParagraphLine templates
            in this file. -->
        <xsl:call-template name="printFormatted">
            <xsl:with-param name="elementContent">
                <!-- strip leading whitespace only from first line of text -->
                <xsl:call-template name="strip-leading-whitespace">
                    <xsl:with-param name="content" select="."/>
                </xsl:call-template>
            </xsl:with-param>
            <xsl:with-param name="startFormattedSectionString" select="''"/><!-- nothing needed -->
            <xsl:with-param name="endFormattedSectionString" select="''"/><!-- nothing needed -->
            <xsl:with-param name="optional-param-1" select="concat($indent, $indent-increment)"/>
            <xsl:with-param name="optional-param-2" select="number($g-fold-width) - string-length($indent)"/>
        </xsl:call-template>
    </xsl:otherwise>    
  </xsl:choose>
</xsl:template>



<!--
  Text formatting template. Use existing line breaks. Indent each line
  to the current indent level. Return the next line each time the template
  is called.
  
  [OBSOLETE: replaced by printFormatted template]
-->

<xsl:template name="print-lines">
  <xsl:param name="original-string"/>
  <xsl:param name="indent"/>
  <xsl:param name="print-indent" select="0"/>
  <xsl:variable name="str1" select="substring-before($original-string,$newline)"/>
  <xsl:variable name="str2" select="substring-after($original-string,$newline)"/>
  <xsl:variable name="printstring">
    <xsl:choose>
      <xsl:when test="$print-indent">
	<xsl:call-template name="strip-leading-whitespace">
	  <xsl:with-param name="content" select="$str1"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$str1" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- Print next line, unless it's a blank line after final text line. -->
  <xsl:choose>
    <xsl:when test="(string-length($printstring) &gt; 0) or (string-length(normalize-space($str2)) &gt; 0)">
      <xsl:if test="$print-indent">
        <!-- 
          The first line may not be indented, because it's on the same line as
          the label.
         -->
        <xsl:value-of select="$indent"/>
      </xsl:if>
      <xsl:value-of select="$printstring"/>
      <xsl:value-of select="$newline"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="normalize-space($original-string)">
        <!-- There's only one line. -->
        <xsl:if test="$print-indent">
          <!-- 
            The first line may not be indented, because it's on the same line as
            the label.
           -->
          <xsl:value-of select="$indent"/>
        </xsl:if>
        <xsl:value-of select="$original-string"/>
        <xsl:value-of select="$newline"/>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$str2">
    <!-- There is more text to break, call recursively. -->
    <xsl:call-template name="print-lines">
      <xsl:with-param name="original-string" select="$str2"/>
      <xsl:with-param name="indent" select="$indent"/>
      <xsl:with-param name="print-indent" select="1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


</xsl:stylesheet>

