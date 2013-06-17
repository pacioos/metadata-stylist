<!--

pacioos-gmx-html.xsl

Author: John Maurer (jmaurer@hawaii.edu)
Date: November 10, 2011

Geographic Metadata XML (GMX)
This Extensible Stylesheet Language for Transformations (XSLT) document takes
metadata in Extensible Markup Language (XML) for the ISO 19115's Geographic
Metadata XML (GMX) Code List and converts it into an HTML page. This format
is used to show the full list on PacIOOS's website. The ISO 19115 HTML output
links to these codes to provide users with further information.

For more information on XSLT see:

http://en.wikipedia.org/wiki/XSLT
http://www.w3.org/TR/xslt

-->

<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gmi="http://www.isotc211.org/2005/gmi"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:gsr="http://www.isotc211.org/2005/gsr"
  xmlns:gss="http://www.isotc211.org/2005/gss"
  xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gml="http://www.opengis.net/gml/3.2"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!-- Import another XSLT file for replacing newlines with HTML <br/>'s: -->

  <xsl:import href="utils/replace-newlines.xsl"/>

  <!-- Import another XSLT file for doing other string substitutions: -->

  <xsl:import href="utils/replace-string.xsl"/>

  <!-- 

  This HTML output method conforms to the following DOCTYPE statement:

    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
      "http://www.w3.org/TR/html4/loose.dtd">
  -->

  <xsl:output
    method="html"
    doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
    doctype-system="http://www.w3.org/TR/html4/loose.dtd"
    encoding="ISO-8859-1"
    indent="yes"/>

  <!-- The separator separates short names from long names. For example:
       DMSP > Defense Meteorological Satellite Program -->

  <xsl:variable name="separator">
     <xsl:text disable-output-escaping="yes"> &lt;img src="/images/right.gif" width="5" height="8"/&gt; </xsl:text>
  </xsl:variable>

  <!-- Define a variable for creating a newline: -->

  <xsl:variable name="newline">
<xsl:text>
</xsl:text>
  </xsl:variable>

  <!-- The top-level template; Define various features for the entire page and then
       call the "CT_CodelistCatalogue" template to fill in the remaining HTML: -->

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml"><xsl:value-of select="$newline"/>
    <head><xsl:value-of select="$newline"/>
    <title>Geographic Metadata in XML (GMX) Code Lists</title><xsl:value-of select="$newline"/>
    <link href="/pacioos/css/main_old.css" rel="stylesheet" type="text/css"/><xsl:value-of select="$newline"/>
    <style type="text/css">

  .callouthead {
    font-size: 85%;
    font-weight: bold;
    color: #003366;
    padding: 4px 4px 0 4px;
    margin: 0;
  }

  .callouttext {
    font-size: .88em;
    font-weight: normal;
    padding: 2px 4px 0 5px;
    margin: 0;
  }

</style><xsl:value-of select="$newline"/>
    </head><xsl:value-of select="$newline"/>
    <body><xsl:value-of select="$newline"/>
    <xsl:comment>#include virtual="/pacioos/ssi/pacioos_header.ssi"</xsl:comment><xsl:value-of select="$newline"/>
    <xsl:comment>#include virtual="/pacioos/navigation/index.php"</xsl:comment><xsl:value-of select="$newline"/>
    <xsl:comment>#include virtual="/pacioos/ssi/pacioos_header_b.ssi"</xsl:comment><xsl:value-of select="$newline"/>
    <ul id="nav-breadcrumb">
      <li><a style="margin-top:-12px;" href="/pacioos">Home</a></li>
      <li><a href="/pacioos/data_access/">Data Access</a></li>
      <li class="last"><a href="/pacioos/metadata/">Metadata</a></li>
    </ul>
    <table width="99%" border="0" cellspacing="2" cellpadding="0">
      <tr>
        <td valign="top">
          <table width="98%" border="0" align="center" cellpadding="2" cellspacing="8" style="margin-top: -20px;">
            <tr>
              <td valign="top" >
                <h2 style="text-transform: none;">Geographic Metadata in XML (GMX) Code Lists</h2>
                <p><xsl:value-of select="codelistItem"/></p>
                <ul>
                  <xsl:for-each select="CT_CodelistCatalogue/codelistItem">
                    <xsl:variable name="codeID"><xsl:value-of select="CodeListDictionary/gml:identifier"/></xsl:variable>
                    <li><a href="#{$codeID}"><xsl:value-of select="$codeID"/></a></li>
                  </xsl:for-each>
                </ul>
                <xsl:apply-templates select="CT_CodelistCatalogue"/>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
    <table width="185" cellspacing="0" cellpadding="0" style="position: absolute; top: 10px; right: 10px; z-index: 2; background-color: #fff; padding-left: 10px;">
      <tr>
        <td style="font-size: 105%; font-weight: bold; color: #006699; padding: 6px 4px 4px 4px; margin: 17px 0 4px 0; border-left-width: 1px; border-left-style: solid; border-left-color: #006699;">Metadata Views</td>
      </tr>
      <tr>
        <td>
          <p class="callouthead"><a href="http://pacioos.org/metadata/gmxCodelists.txt">GMX Text-Only</a></p>
          <p class="callouttext">Geographic Metadata in XML (GMX) in plain text</p>
          <p class="callouthead"><a href="http://pacioos.org/metadata/gmxCodelists.xml">GMX XML</a></p>
          <p class="callouttext">Geographic Metadata in XML (GMX) in Extensible Markup Language (XML)</p>
        </td>
      </tr>
    </table>
    <xsl:comment> END MAIN CONTENT </xsl:comment><xsl:value-of select="$newline"/>
    <xsl:comment> footer include </xsl:comment><xsl:value-of select="$newline"/>
    <xsl:comment>#include virtual="/pacioos/ssi/pacioos_footer.ssi"</xsl:comment><xsl:value-of select="$newline"/>
    <xsl:comment> end footer include </xsl:comment><xsl:value-of select="$newline"/>
    </body><xsl:value-of select="$newline"/>
    </html>
  </xsl:template>

  <!-- The second-level template: match all the main elements of the GMX and
       process them separately. The order of these elements is maintained in
       the resulting document: -->

  <!-- ROOT: ****************************************************************-->

  <xsl:template name="CT_CodelistCatalogue">
    <xsl:apply-templates select="name"/>
    <xsl:apply-templates select="scope"/>
    <xsl:apply-templates select="fieldOfApplication"/>
    <xsl:apply-templates select="versionNumber"/>
    <xsl:apply-templates select="versionDate"/>
    <xsl:apply-templates select="codelistItem/CodeListDictionary"/>
  </xsl:template>

  <xsl:template match="name">
    <h3 style="display: inline">Name:</h3>
    <p style="display: inline"><xsl:value-of select="."/></p>
    <p></p>
  </xsl:template>

  <xsl:template match="scope">
    <h3 style="display: inline">Scope:</h3>
    <p style="display: inline"><xsl:value-of select="."/></p>
    <p></p>
  </xsl:template>

  <xsl:template match="fieldOfApplication">
    <h3 style="display: inline">Field Of Application:</h3>
    <p style="display: inline"><xsl:value-of select="."/></p>
    <p></p>
  </xsl:template>

  <xsl:template match="versionNumber">
    <h3 style="display: inline">Version Number:</h3>
    <p style="display: inline"><xsl:value-of select="."/></p>
    <p></p>
  </xsl:template>

  <xsl:template match="versionDate">
    <h3 style="display: inline">Version Date:</h3>
    <p style="display: inline">
      <xsl:call-template name="date">
        <xsl:with-param name="element" select="./gco:Date"/>
      </xsl:call-template>
    </p>
    <p></p>
  </xsl:template>

  <xsl:template match="codelistItem/CodeListDictionary">
    <hr/>
    <h3><a name="{gml:identifier}"></a><xsl:value-of select="gml:identifier"/>:</h3>
    <h4>Description:</h4>
    <p><xsl:value-of select="gml:description"/></p>
    <h4>Code Definitions:</h4>
    <xsl:for-each select="codeEntry/CodeDefinition">
      <xsl:sort select="gml:identifier"/>
      <p><b><i><xsl:value-of select="gml:identifier"/>:</i></b></p> 
      <p><xsl:value-of select="gml:description"/></p>
    </xsl:for-each>
    <p><a href="javascript:void(0)" onClick="window.scrollTo( 0, 0 ); this.blur(); return false;">Back to Top</a></p>
  </xsl:template>

  <!-- template: date *******************************************************-->
  
  <xsl:template name="date">
    <xsl:param name="element"/>
    <xsl:choose>
      <xsl:when test="contains( $element, 'known' )">
        <xsl:value-of select="$element"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="year" select="substring($element, 1, 4)"/>
        <xsl:variable name="month" select="substring($element, 6, 2)"/>
        <xsl:variable name="day" select="substring($element, 9, 2)"/>
        <xsl:if test="$month = '01'">
          <xsl:text>January </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '02'">
          <xsl:text>February </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '03'">
          <xsl:text>March </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '04'">
          <xsl:text>April </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '05'">
          <xsl:text>May </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '06'">
          <xsl:text>June </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '07'">
          <xsl:text>July </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '08'">
          <xsl:text>August </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '09'">
          <xsl:text>September </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '10'">
          <xsl:text>October </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '11'">
          <xsl:text>November </xsl:text>
        </xsl:if>
        <xsl:if test="$month = '12'">
          <xsl:text>December </xsl:text>
        </xsl:if>
        <xsl:if test="string-length( $day )">
          <xsl:choose>
            <xsl:when test="$day = '01'">
              <xsl:variable name="daydisplay" select="'1'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '02'">
              <xsl:variable name="daydisplay" select="'2'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '03'">
              <xsl:variable name="daydisplay" select="'3'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '04'">
              <xsl:variable name="daydisplay" select="'4'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '05'">
              <xsl:variable name="daydisplay" select="'5'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '06'">
              <xsl:variable name="daydisplay" select="'6'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '07'">
              <xsl:variable name="daydisplay" select="'7'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '08'">
              <xsl:variable name="daydisplay" select="'8'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:when test="$day = '09'">
              <xsl:variable name="daydisplay" select="'9'"/>
              <xsl:value-of select="$daydisplay"/><xsl:text>, </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$day"/><xsl:text>, </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:value-of select="$year"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
