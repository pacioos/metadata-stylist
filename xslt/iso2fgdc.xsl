<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="gco gmi gml gmx gsr gss gts gmd srv xlink xs xsi xsl">
  <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Feb 03, 2010</xd:p>
      <xd:p><xd:b>Revised on:</xd:b> Mar 04, 2010</xd:p>
      <xd:p><xd:b>Revised on:</xd:b> Mar 08, 2010</xd:p>
      <xd:p><xd:b>Revised on:</xd:b> Mar 25, 2010</xd:p>
      <xd:p>Provides URL back to original ISO XML, uses the namespace2UrlMapping.xml file<xd:b>Revised on:</xd:b> June 3, 2010</xd:p>
      <xd:p>Changed gml namespace to 3.2, fixed online and offline in distinfo, fixed platinfo short/long name options.<xd:b>Revised on:</xd:b> Mar 25, 2010</xd:p>
      <xd:p>Added mapping of gmd:identificationInfo/srv:SV_ServiceIdentification to additional digform distribution URL's. Added point of conact (ptcontac) section mapped from gmd:contact. Added mapping of gmd:verticalExtent to boundalt. (jmaurer@hawaii.edu) <xd:b>Revised on:</xd:b> Nov 16, 2011</xd:p>
      <xd:p>Modified Distribution Information, Standard Order Process. Rather than add gmd:MD_DigitalTransferOptions beneath gmd:distributorFormat, I ignore gmd:distributorFormat and use gmd:MD_DigitalTransferOptions (pulling name for formname, and adding description). (jmaurer@hawaii.edu) <xd:b>Revised on:</xd:b> Mar 07, 2013</xd:p>

      <xd:p><xd:b>Author:</xd:b> Anna Milan anna.milan@noaa.gov</xd:p>
      <xd:p><xd:b>Modified By:</xd:b> John Maurer jmaurer@hawaii.edu</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:variable name="isoDateDash">-</xsl:variable>
  <xsl:variable name="nothing"/>
  <xsl:template match="/">
    <metadata>

      <xsl:attribute name="xsi:noNamespaceSchemaLocation">http://ngdc.noaa.gov/metadata/published/xsd/ngdcSchema/schema.xsd</xsl:attribute>
      <idinfo>
        <datsetid>
          <xsl:for-each select=".//gmd:fileIdentifier">
            <xsl:value-of select="@gco:nilReason|gco:CharacterString"/>
          </xsl:for-each>
        </datsetid>
        <xsl:for-each select=".//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation">

          <citation>
            <xsl:call-template name="citeinfoTemplate"/>
          </citation>
        </xsl:for-each>
        <xsl:for-each select="//gmd:identificationInfo/gmd:MD_DataIdentification">
          <descript>
            <xsl:for-each select="./gmd:abstract">
              <abstract>
                <xsl:value-of select="@gco:nilReason|gco:CharacterString"/>

              </abstract>
            </xsl:for-each>
            <xsl:for-each select="./gmd:purpose">
              <purpose>
                <xsl:value-of select="@gco:nilReason|gco:CharacterString"/>
              </purpose>
            </xsl:for-each>
          </descript>
        </xsl:for-each>

        <xsl:for-each select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent">
          <xsl:choose>
            <!-- use temporalExent with boundingExtent @id value -->
            <xsl:when test="@id='boundingExtent'">
              <xsl:choose>
                <xsl:when test=".//gml:TimePeriod">
                  <timeperd>
                    <timeinfo>
                      <rngdates>

                        <xsl:if test=".//gml:end">
                          <xsl:for-each select=".//gml:begin/gml:TimeInstant/gml:timePosition">
                            <begdate>
                              <xsl:call-template name="gml2fgdcDate"/>
                            </begdate>
                          </xsl:for-each>
                          <xsl:for-each select=".//gml:end/gml:TimeInstant/gml:timePosition">
                            <enddate>
                              <xsl:call-template name="gml2fgdcDate"/>

                            </enddate>
                          </xsl:for-each>
                        </xsl:if>
                        <xsl:if test=".//gml:beginPosition">
                          <xsl:for-each select=".//gml:beginPosition">
                            <begdate>
                              <xsl:call-template name="gml2fgdcDate"/>
                            </begdate>
                          </xsl:for-each>

                          <xsl:for-each select=".//gml:endPosition">
                            <enddate>
                              <xsl:call-template name="gml2fgdcDate"/>
                            </enddate>
                          </xsl:for-each>
                        </xsl:if>
                      </rngdates>
                    </timeinfo>
                    <current>Unknown</current>

                  </timeperd>
                </xsl:when>
                <xsl:when test="count(.//gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant)&gt;1">
                  <timeperd>
                    <timeinfo>
                      <mdattim>
                        <xsl:for-each select=".//gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition">
                          <sngdate>
                            <caldate>

                              <xsl:call-template name="gml2fgdcDate"/>
                            </caldate>
                          </sngdate>
                        </xsl:for-each>
                      </mdattim>
                    </timeinfo>
                    <current>Unknown</current>
                  </timeperd>

                </xsl:when>
                <xsl:when test="count(.//gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant)=1">
                  <xsl:for-each select=".//gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition">
                    <timeperd>
                      <timeinfo>
                        <sngdate>
                          <caldate>
                            <xsl:call-template name="gml2fgdcDate"/>
                          </caldate>

                        </sngdate>
                      </timeinfo>
                      <current>Unknown</current>
                    </timeperd>
                  </xsl:for-each>
                </xsl:when>
              </xsl:choose>
            </xsl:when>

            <!-- if @id does not ='boundingExtent' then use the first time period-->
            <xsl:when test="@id!='boundingExtent'">
              <xsl:choose>
                <xsl:when test=".//gml:TimePeriod[1]">
                  <timeperd>
                    <timeinfo>
                      <rngdates>
                        <xsl:choose>
                          <xsl:when test=".//gml:begin">

                            <!-- BEGIN/TIMEINSTANT -->
                            <xsl:for-each select=".//gml:begin/gml:TimeInstant/gml:timePosition">
                              <begdate>
                                <xsl:call-template name="gml2fgdcDate"/>
                              </begdate>
                            </xsl:for-each>
                            <xsl:for-each select=".//gml:end/gml:TimeInstant/gml:timePosition">
                              <enddate>
                                <xsl:call-template name="gml2fgdcDate"/>

                              </enddate>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>
                            <!-- BEGINPOSITION and END POSITION-->
                            <xsl:for-each select=".//gml:beginPosition">
                              <begdate>
                                <xsl:call-template name="gml2fgdcDate"/>
                              </begdate>

                            </xsl:for-each>
                            <xsl:for-each select=".//gml:endPosition">
                              <enddate>
                                <xsl:call-template name="gml2fgdcDate"/>
                              </enddate>
                            </xsl:for-each>
                          </xsl:otherwise>
                        </xsl:choose>
                      </rngdates>

                    </timeinfo>
                    <current>Unknown</current>
                  </timeperd>
                </xsl:when>
                <xsl:when test="count(.//gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant)&gt;1">
                  <timeperd>
                    <timeinfo>
                      <mdattim>

                        <xsl:for-each select=".//gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition">
                          <sngdate>
                            <caldate>
                              <xsl:call-template name="gml2fgdcDate"/>
                            </caldate>
                          </sngdate>
                        </xsl:for-each>
                      </mdattim>
                    </timeinfo>

                    <current>Unknown</current>
                  </timeperd>
                </xsl:when>
                <xsl:when test="count(.//gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant)=1">
                  <xsl:for-each select=".//gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant/gml:timePosition">
                    <timeperd>
                      <timeinfo>
                        <sngdate>

                          <caldate>
                            <xsl:call-template name="gml2fgdcDate"/>
                          </caldate>
                        </sngdate>
                      </timeinfo>
                      <current>Unknown</current>
                    </timeperd>
                  </xsl:for-each>

                </xsl:when>
              </xsl:choose>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
        <status>
          <xsl:for-each select=".//gmd:status/gmd:MD_ProgressCode">
            <progress>
              <xsl:choose>

                <xsl:when test="normalize-space(@codeListValue)='completed'">
                  <xsl:value-of select="'Complete'"/>
                </xsl:when>
                <xsl:when test="normalize-space(@codeListValue)='underDevelopment'">
                  <xsl:value-of select="'In work'"/>
                </xsl:when>
                <xsl:when test="normalize-space(@codeListValue)='historicalArchive'">
                  <xsl:value-of select="'Complete'"/>
                </xsl:when>

                <xsl:when test="normalize-space(@codeListValue)='obsolete'">
                  <xsl:value-of select="'Complete'"/>
                </xsl:when>
                <xsl:when test="normalize-space(@codeListValue)='onGoing'">
                  <xsl:value-of select="'In work'"/>
                </xsl:when>
                <xsl:when test="normalize-space(@codeListValue)='planned'">
                  <xsl:value-of select="'Planned'"/>
                </xsl:when>

                <xsl:when test="normalize-space(@codeListValue)='required'">
                  <xsl:value-of select="'In work'"/>
                </xsl:when>
                <xsl:when test="normalize-space(@codeListValue)='underDevelopment'">
                  <xsl:value-of select="'Planned'"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="'In work'"/>
                </xsl:otherwise>

              </xsl:choose>
            </progress>
          </xsl:for-each>
          <xsl:for-each select="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency">
            <update>
              <xsl:value-of select="./@gco:nilReason|gmd:MD_MaintenanceFrequencyCode/@codeListValue"/>
            </update>
          </xsl:for-each>
        </status>

        <spdom>
          <xsl:choose>
            <!-- select BoundingBox from EX_Extent w/ boundingExtent id -->
            <xsl:when test="//gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/@id='boundingExtent'">
              <bounding>
                <westbc>
                  <xsl:value-of select=".//gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal"/>
                </westbc>
                <eastbc>

                  <xsl:value-of select=".//gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal"/>
                </eastbc>
                <northbc>
                  <xsl:value-of select=".//gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal"/>
                </northbc>
                <southbc>
                  <xsl:value-of select=".//gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal"/>
                </southbc>
              </bounding>
            </xsl:when>
            <xsl:otherwise>
              <!-- otherwise select the first bounding box, To Do: calculate the max and min of each bbox in ISO...  -->
              <bounding>
                <westbc>
                  <xsl:value-of select=".//gmd:geographicElement/gmd:EX_GeographicBoundingBox[1]/gmd:westBoundLongitude/gco:Decimal"/>
                </westbc>
                <eastbc>
                  <xsl:value-of select=".//gmd:geographicElement/gmd:EX_GeographicBoundingBox[1]/gmd:eastBoundLongitude/gco:Decimal"/>

                </eastbc>
                <northbc>
                  <xsl:value-of select=".//gmd:geographicElement/gmd:EX_GeographicBoundingBox[1]/gmd:northBoundLatitude/gco:Decimal"/>
                </northbc>
                <southbc>
                  <xsl:value-of select=".//gmd:geographicElement/gmd:EX_GeographicBoundingBox[1]/gmd:southBoundLatitude/gco:Decimal"/>
                </southbc>
              </bounding>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="string-length( .//gmd:verticalElement/gmd:EX_VerticalExtent )">
            <boundalt>
              <xsl:choose>
                <xsl:when test="string-length( .//gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue )">
                  <altmin>
                    <xsl:value-of select=".//gmd:verticalElement/gmd:EX_VerticalExtent/gmd:minimumValue/gco:Real"/>
                  </altmin>
                </xsl:when>
                <xsl:otherwise>
                  <altmin>Unknown</altmin>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="string-length( .//gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue )">
                  <altmax>
                    <xsl:value-of select=".//gmd:verticalElement/gmd:EX_VerticalExtent/gmd:maximumValue/gco:Real"/>
                  </altmax>
                </xsl:when>
                <xsl:otherwise>
                  <altmax>Unknown</altmax>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="string-length( .//gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS )">
                  <altunits>
                    <xsl:value-of select=".//gmd:verticalElement/gmd:EX_VerticalExtent/gmd:verticalCRS"/>
                  </altunits>
                </xsl:when>
                <xsl:otherwise>
                  <altunits>Unknown</altunits>
                </xsl:otherwise>
              </xsl:choose>
            </boundalt>
          </xsl:if>
        </spdom>
        <keywords>
          <xsl:for-each select=".//gmd:descriptiveKeywords">
            <xsl:if test=".//gmd:MD_KeywordTypeCode/@codeListValue='theme'">
              <theme>
                <xsl:for-each select=".//gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title">
                  <themekt>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>

                  </themekt>
                </xsl:for-each>
                <xsl:for-each select=".//gmd:MD_Keywords/gmd:keyword">
                  <themekey>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </themekey>
                </xsl:for-each>
              </theme>
            </xsl:if>

          </xsl:for-each>
          <xsl:for-each select=".//gmd:descriptiveKeywords">
            <xsl:if test=".//gmd:MD_KeywordTypeCode/@codeListValue='discipline'">
              <theme>
                <xsl:for-each select=".//gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title">
                  <themekt>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </themekt>
                </xsl:for-each>

                <xsl:for-each select=".//gmd:MD_Keywords/gmd:keyword">
                  <themekey>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </themekey>
                </xsl:for-each>
              </theme>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select=".//gmd:descriptiveKeywords">

            <xsl:if test=".//gmd:MD_KeywordTypeCode/@codeListValue='place'">
              <place>
                <xsl:for-each select=".//gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title">
                  <placekt>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </placekt>
                </xsl:for-each>
                <xsl:for-each select=".//gmd:MD_Keywords/gmd:keyword">
                  <placekey>

                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </placekey>
                </xsl:for-each>
              </place>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select=".//gmd:descriptiveKeywords">
            <xsl:if test=".//gmd:MD_KeywordTypeCode/@codeListValue='stratum'">
              <stratum>

                <xsl:for-each select=".//gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title">
                  <stratkt>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </stratkt>
                </xsl:for-each>
                <xsl:for-each select=".//gmd:MD_Keywords/gmd:keyword">
                  <stratkey>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </stratkey>

                </xsl:for-each>
              </stratum>
            </xsl:if>
          </xsl:for-each>
          <xsl:for-each select=".//gmd:descriptiveKeywords">
            <xsl:if test=".//gmd:MD_KeywordTypeCode/@codeListValue='temporal'">
              <temporal>
                <xsl:for-each select=".//gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title">
                  <tempkt>

                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </tempkt>
                </xsl:for-each>
                <xsl:for-each select=".//gmd:MD_Keywords/gmd:keyword">
                  <tempkey>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </tempkey>
                </xsl:for-each>
              </temporal>

            </xsl:if>
          </xsl:for-each>
        </keywords>
        <xsl:if test="//gmi:acquisitionInformation">
          <xsl:for-each select="//gmi:MI_AcquisitionInformation">
            <plainsid>
              <xsl:if test="./gmi:operation/gmi:MI_Operation/gmi:identifier">
                <missname>
                  <xsl:for-each select="//gmi:operation/gmi:MI_Operation/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">

                    <xsl:choose>
                      <xsl:when test="contains(., '&gt; ')">
                        <xsl:value-of select="substring-after(., '&gt; ')"/>
                        <xsl:if test="position()!=last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>

                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="position()!=last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </missname>

              </xsl:if>
              <xsl:if test="gmi:platform">
                <platflnm>
                  <xsl:for-each select="gmi:platform/gmi:MI_Platform/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
                    <xsl:choose>
                      <xsl:when test="contains(., '&gt; ')">
                        <xsl:value-of select="substring-after(., '&gt; ')"/>
                        <xsl:if test="position()!=last()">
                          <xsl:text>, </xsl:text>

                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="position()!=last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:otherwise>

                    </xsl:choose>
                  </xsl:for-each>
                </platflnm>
                <platfsnm>
                  <xsl:for-each select="gmi:platform/gmi:MI_Platform/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
                    <xsl:choose>
                      <xsl:when test="contains(., '&gt; ')">
                        <xsl:value-of select="substring-after(., '&gt; ')"/>
                        <xsl:if test="position()!=last()">

                          <xsl:text>, </xsl:text>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="position()!=last()">
                          <xsl:text>, </xsl:text>
                        </xsl:if>

                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </platfsnm>
              </xsl:if>
              <xsl:if test="gmi:instrument">
                <instflnm>
                  <xsl:for-each select="gmi:instrument/gmi:MI_Instrument/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
                    <xsl:value-of select="substring-after(., '&gt; ')"/>

                    <xsl:if test="position()!=last()">
                      <xsl:text>, </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </instflnm>
                <instshnm>
                  <xsl:for-each select="gmi:instrument/gmi:MI_Instrument/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString">
                    <xsl:value-of select="substring-before(.,' &gt;')"/>

                    <xsl:if test="position()!=last()">
                      <xsl:text>, </xsl:text>
                    </xsl:if>
                  </xsl:for-each>
                </instshnm>
              </xsl:if>
            </plainsid>
          </xsl:for-each>

        </xsl:if>
        <xsl:choose>
          <xsl:when test="//gmd:resourceConstraints//gmd:accessConstraints">
            <accconst>
              <xsl:for-each select="//gmd:resourceConstraints//gmd:accessConstraints">
                <xsl:text>Restriction Code: </xsl:text>
                <xsl:value-of select="./@gco:nilReason|./gmd:MD_RestrictionCode/@codeListValue"/>
                <xsl:text>;  </xsl:text>

              </xsl:for-each>
            </accconst>
          </xsl:when>
          <xsl:otherwise>
            <accconst>None</accconst>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="//gmd:resourceConstraints//gmd:useLimitation">

          <useconst>
            <xsl:for-each select="//gmd:resourceConstraints//gmd:useLimitation">
              <xsl:text>Use Limitation: </xsl:text>
              <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
              <xsl:text>;   </xsl:text>
            </xsl:for-each>
            <xsl:for-each select="//gmd:resourceConstraints//gmd:otherConstraints">
              <xsl:text>Other: </xsl:text>

              <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
              <xsl:text>;   </xsl:text>
            </xsl:for-each>
          </useconst>
        </xsl:if>
        <xsl:if test="//gmd:contact">
          <xsl:for-each select="//gmd:contact/gmd:CI_ResponsibleParty">
            <ptcontac>
              <cntinfo>
                <cntorgp>
                  <xsl:if test="gmd:organisationName">
                    <cntorg>
                      <xsl:value-of select="normalize-space(gmd:organisationName)"/>
                    </cntorg>

                  </xsl:if>
                  <xsl:if test="gmd:individualName">
                    <cntper>
                      <xsl:value-of select="normalize-space(gmd:individualName)"/>
                    </cntper>
                  </xsl:if>
                </cntorgp>
                <xsl:choose>
                  <xsl:when test="./gmd:positionName">

                    <cntpos>
                      <xsl:value-of select="normalize-space(.)"/>
                    </cntpos>
                  </xsl:when>
                </xsl:choose>
                <xsl:if test="./gmd:contactInfo/gmd:CI_Contact">
                  <xsl:choose>
                    <xsl:when test=".//gmd:address/gmd:CI_Address">
                      <cntaddr>

                        <addrtype>physical and mailing</addrtype>
                        <address><xsl:value-of select="normalize-space(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint[1])"/></address>
                        <city>
                          <xsl:value-of select="normalize-space(.//gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city)"/>
                        </city>
                        <state>
                          <xsl:value-of select="normalize-space(./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea)"/>
                        </state>

                        <postal>
                          <xsl:value-of select="normalize-space(./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode)"/>
                        </postal>
                      </cntaddr>
                    </xsl:when>
                    <xsl:otherwise>
                      <cntaddr>
                        <addrtype>physical and mailing</addrtype>

                        <address>Unknown</address>
                        <city>Unknown</city>
                        <state>Unknown</state>
                        <postal>Unknown</postal>
                      </cntaddr>
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:choose>
                    <xsl:when test="gmd:contactInfo/gmd:CI_Contact/gmd:phone">
                      <xsl:for-each select=".//gmd:voice/gco:CharacterString">
                        <cntvoice>
                          <xsl:value-of select="normalize-space(.)"/>
                        </cntvoice>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>

                      <cntvoice>Unknown</cntvoice>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:for-each select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                    <cntemail>
                      <xsl:value-of select="normalize-space(.)"/>
                    </cntemail>
                  </xsl:for-each>

                </xsl:if>
              </cntinfo>
            </ptcontac>
          </xsl:for-each>
        </xsl:if>
        <!--<crossref>
                    <citeinfo>
                        <origin>DOC/NOAA/NESDIS/NGDC > National Geophysical Data Center, NESDIS, NOAA, U.S. Department of Commerce</origin>
                        <xsl:for-each select=".//gmd:dateStamp">
                            <pubdate>
                                <xsl:call-template name="iso2fgdcDate"/>
                            </pubdate>
                        </xsl:for-each>
                        <title>View complete metadata record </title>
                        <xsl:variable name="id" select="substring-after(//gmd:fileIdentifier, ':')"/>
                        <xsl:variable name="idNS" select="substring-before(//gmd:fileIdentifier, ':')"/>
                        <xsl:for-each select="document('../namespace2UrlMapping.xml')//directory">
                            <xsl:variable name="ns" select="@ns"/>
                            <xsl:variable name="iso" select="@iso"/>
                            <xsl:choose>
                                <xsl:when test="$ns=$idNS">
                                    <onlink>
                                        <xsl:value-of select="concat('http:www.ngdc.noaa.gov/metadata/published/',$iso,'/',$id,'.xml')"/>
                                    </onlink>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </citeinfo>
                </crossref>-->
      </idinfo>
      <xsl:for-each select="//gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor">

        <distinfo>
          <distrib>
            <xsl:for-each select="gmd:distributorContact/gmd:CI_ResponsibleParty">
              <cntinfo>
                <cntorgp>
                  <xsl:if test="gmd:organisationName">
                    <cntorg>
                      <xsl:value-of select="normalize-space(gmd:organisationName)"/>
                    </cntorg>

                  </xsl:if>
                  <xsl:if test="gmd:individualName">
                    <cntper>
                      <xsl:value-of select="normalize-space(gmd:individualName)"/>
                    </cntper>
                  </xsl:if>
                </cntorgp>
                <xsl:choose>
                  <xsl:when test="./gmd:positionName">

                    <cntpos>
                      <xsl:value-of select="normalize-space(.)"/>
                    </cntpos>
                  </xsl:when>
                </xsl:choose>
                <xsl:if test="./gmd:contactInfo/gmd:CI_Contact">
                  <xsl:choose>
                    <xsl:when test=".//gmd:address/gmd:CI_Address">
                      <cntaddr>

                        <addrtype>physical and mailing</addrtype>
                        <address><xsl:value-of select="normalize-space(gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint[1])"/></address>
                        <city>
                          <xsl:value-of select="normalize-space(.//gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city)"/>
                        </city>
                        <state>
                          <xsl:value-of select="normalize-space(./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:administrativeArea)"/>
                        </state>

                        <postal>
                          <xsl:value-of select="normalize-space(./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode)"/>
                        </postal>
                      </cntaddr>
                    </xsl:when>
                    <xsl:otherwise>
                      <cntaddr>
                        <addrtype>physical and mailing</addrtype>

                        <address>Unknown</address>
                        <city>Unknown</city>
                        <state>Unknown</state>
                        <postal>Unknown</postal>
                      </cntaddr>
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:choose>
                    <xsl:when test="gmd:contactInfo/gmd:CI_Contact/gmd:phone">
                      <xsl:for-each select=".//gmd:voice/gco:CharacterString">
                        <cntvoice>
                          <xsl:value-of select="normalize-space(.)"/>
                        </cntvoice>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>

                      <cntvoice>Unknown</cntvoice>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:for-each select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                    <cntemail>
                      <xsl:value-of select="normalize-space(.)"/>
                    </cntemail>
                  </xsl:for-each>

                </xsl:if>
              </cntinfo>
            </xsl:for-each>
          </distrib>
          <distliab>Unknown</distliab>
          <xsl:if test=".//gmd:onLine or //gmd:identificationInfo/srv:SV_ServiceIdentification">
            <stdorder>
              <xsl:for-each select="//gmd:identificationInfo/srv:SV_ServiceIdentification">
                <digform>
                  <digtinfo>
                    <formname>
                      <xsl:value-of select="normalize-space(srv:serviceType/gco:LocalName)"/>
                    </formname>
                  </digtinfo>
                  <xsl:if test="srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint">
                    <digtopt>
                      <xsl:for-each select="srv:containsOperations/srv:SV_OperationMetadata/srv:connectPoint">

                        <onlinopt>
                          <computer>
                            <networka>
                              <networkr>
                                <xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:linkage/gmd:URL)"/>
                              </networkr>
                            </networka>
                          </computer>
                        </onlinopt>

                      </xsl:for-each>
                    </digtopt>
                  </xsl:if>
                </digform>
              </xsl:for-each>
              <!-- amilan's original method:
              <xsl:for-each select=".//gmd:distributorFormat">

                <digform>
                  <digtinfo>
                    <formname>
                      <xsl:value-of select="normalize-space(gmd:MD_Format/gmd:name)"/>
                    </formname>
                  </digtinfo>
                  <xsl:if test="../gmd:distributorTransferOptions">
                    <digtopt>
                      <xsl:for-each select="..//gmd:MD_DigitalTransferOptions/gmd:onLine">

                        <onlinopt>
                          <computer>
                            <networka>
                              <networkr>
                                <xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:linkage/gmd:URL)"/>
                              </networkr>
                            </networka>
                          </computer>
                        </onlinopt>

                      </xsl:for-each>
                    </digtopt>
                  </xsl:if>
                </digform>
              </xsl:for-each>
              -->
              <!-- jmaurer's new method: -->
              <xsl:for-each select="..//gmd:MD_DigitalTransferOptions/gmd:onLine">
                <digform>       
                  <digtinfo>  
                    <formname>
                      <xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:name)"/>
                    </formname>
                    <xsl:if test="gmd:CI_OnlineResource/gmd:description">
                      <formcont>
                        <xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:description)"/>     
                      </formcont>                        
                    </xsl:if>
                  </digtinfo> 
                  <digtopt>
                      <onlinopt>
                        <computer>
                          <networka>
                            <networkr>
                              <xsl:value-of select="normalize-space(gmd:CI_OnlineResource/gmd:linkage/gmd:URL)"/>
                            </networkr>
                          </networka>
                        </computer>
                      </onlinopt>
                  </digtopt>
                </digform>
              </xsl:for-each> 
              <!-- end jmaurer -->
              <xsl:choose>
                <xsl:when test="gmd:distributionOrderProcess/gmd:MD_StandardOrderProcess/gmd:fees">
                  <fees>
                    <xsl:value-of select="gmd:distributionOrderProcess/gmd:MD_StandardOrderProcess//gmd:fees"/>

                  </fees>
                </xsl:when>
                <xsl:otherwise>
                  <fees>None specified</fees>
                </xsl:otherwise>
              </xsl:choose>
            </stdorder>
            <xsl:if test="//gmd:offLine">

              <!-- /gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:offLine -->
              <xsl:for-each select=".//gmd:MD_DigitalTransferOptions/gmd:offLine">
                <stdorder>
                  <nondig>
                    <xsl:value-of select="normalize-space(.)"/>
                  </nondig>
                  <!-- /gmi:MI_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributionOrderProcess/gmd:MD_StandardOrderProcess/gmd:fees -->
                  <xsl:choose>
                    <xsl:when test="//gmd:distributionOrderProcess/gmd:MD_StandardOrderProcess/gmd:fees">

                      <fees>
                        <xsl:value-of select="normalize-space(../../../gmd:distributionOrderProcess/gmd:MD_StandardOrderProcess/gmd:fees)"/>
                      </fees>
                    </xsl:when>
                    <xsl:otherwise>
                      <fees>None specified</fees>
                    </xsl:otherwise>
                  </xsl:choose>

                  <!--<ordering/>
                  <turnarnd/>-->
                </stdorder>
              </xsl:for-each>
            </xsl:if>
          </xsl:if>
        </distinfo>
      </xsl:for-each>
      <metainfo>
        <xsl:for-each select=".//gmd:dateStamp">

          <metd>
            <xsl:call-template name="iso2fgdcDate"/>
          </metd>
        </xsl:for-each>
        <xsl:for-each select="gmi:MI_Metadata/gmd:contact">
          <metc>
            <xsl:for-each select="gmd:CI_ResponsibleParty">
              <cntinfo>
                <cntperp>

                  <xsl:for-each select="./gmd:individualName">
                    <cntper>
                      <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                    </cntper>
                  </xsl:for-each>
                  <xsl:for-each select="./gmd:organisationName">
                    <cntorg>
                      <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                    </cntorg>

                  </xsl:for-each>
                </cntperp>
                <xsl:choose>
                  <xsl:when test=".//gmd:CI_Contact/gmd:address/@gco:nilReason">
                    <cntaddr>
                      <addrtype>mailing</addrtype>
                      <city>Unknown</city>
                      <state>Unknown</state>

                      <postal>Unknown</postal>
                    </cntaddr>
                  </xsl:when>
                  <xsl:when test=".//gmd:CI_Contact/gmd:address">
                    <cntaddr>
                      <addrtype>mailing and physical</addrtype>
                      <xsl:for-each select=".//gmd:address/gmd:CI_Address/gmd:deliveryPoint">
                        <address>

                                                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                                                </address>
                      </xsl:for-each>
                      <xsl:for-each select=".//gmd:address/gmd:CI_Address/gmd:city">
                        <city>
                          <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                        </city>
                      </xsl:for-each>
                      <xsl:for-each select=".//gmd:address/gmd:CI_Address/gmd:administrativeArea">

                        <state>
                          <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                        </state>
                      </xsl:for-each>
                      <xsl:for-each select=".//gmd:address/gmd:CI_Address/gmd:postalCode">
                        <postal>
                          <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                        </postal>
                      </xsl:for-each>

                    </cntaddr>
                  </xsl:when>
                  <xsl:otherwise>
                    <cntaddr>
                      <addrtype>mailing</addrtype>
                      <city>Unknown</city>
                      <state>Unknown</state>

                      <postal>Unknown</postal>
                    </cntaddr>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="gmd:contactInfo/gmd:CI_Contact/gmd:phone/@gco:nilReason">
                    <cntvoice>
                      <xsl:value-of select="."/>

                    </cntvoice>
                  </xsl:when>
                  <xsl:when test="gmd:contactInfo/gmd:CI_Contact/gmd:phone">
                    <xsl:for-each select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice">
                      <cntvoice>
                        <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                      </cntvoice>
                    </xsl:for-each>
                  </xsl:when>

                  <xsl:otherwise>
                    <cntvoice>Unknown</cntvoice>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:for-each select=".//gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress">
                  <cntemail>
                    <xsl:value-of select="./@gco:nilReason|gco:CharacterString"/>
                  </cntemail>

                </xsl:for-each>
              </cntinfo>
            </xsl:for-each>
          </metc>
        </xsl:for-each>
        <metstdn>Content Standard for Digital Geospatial Metadata: Extensions for Remote Sensing Metadata</metstdn>
        <metstdv>FGDC-STD-012-2002</metstdv>
      </metainfo>

    </metadata>
  </xsl:template>
  <xsl:template name="citeinfoTemplate">
    <citeinfo>
      <xsl:for-each select=".//gmd:citedResponsibleParty/gmd:CI_ResponsibleParty">
        <xsl:if test="./gmd:role/gmd:CI_RoleCode/@codeListValue='originator'">
          <xsl:for-each select="gmd:individualName">
            <origin>
              <xsl:value-of select="@gco:nilReason|gco:CharacterString"/>

            </origin>
          </xsl:for-each>
          <xsl:for-each select="gmd:organisationName">
            <origin>
              <xsl:value-of select="@gco:nilReason|gco:CharacterString"/>
            </origin>
          </xsl:for-each>
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select=".//gmd:date/gmd:CI_Date">
        <xsl:if test="./gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='publication' or ./gmd:dateType/gmd:CI_DateTypeCode/@codeListValue='creation'">
          <pubdate>
            <xsl:for-each select="./gmd:date">
              <xsl:call-template name="iso2fgdcDate"/>
            </xsl:for-each>
          </pubdate>
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select="./gmd:title">
        <title>
          <xsl:value-of select="@gco:nilReason|gco:CharacterString"/>
        </title>
      </xsl:for-each>
    </citeinfo>
  </xsl:template>
  <xsl:template name="iso2fgdcDate">
    <xsl:variable name="gcoDate">

      <xsl:choose>
        <xsl:when test="gco:DateTime">
          <xsl:value-of select="substring-before(normalize-space(gco:DateTime), 'T')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="gco:Date"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="./@gco:nilReason">
        <xsl:if test="./@gco:nilReason='unknown'">Unknown</xsl:if>
        <xsl:if test="./@gco:nilReason='missing'">Unknown</xsl:if>
        <xsl:if test="./@gco:nilReason='inapplicable'">Unpublished material</xsl:if>
        <xsl:if test="./@gco:nilReason='withheld'">Unknown</xsl:if>
        <xsl:if test="./@gco:nilReason='template'">Unpublished material</xsl:if>

      </xsl:when>
      <xsl:when test="contains($gcoDate,$isoDateDash)">
        <xsl:value-of select="translate($gcoDate, $isoDateDash,$nothing)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="gco:Date"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="gml2fgdcDate">
    <xsl:choose>
      <xsl:when test="./@indeterminatePosition">Unknown</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="translate(node(), $isoDateDash,$nothing)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
