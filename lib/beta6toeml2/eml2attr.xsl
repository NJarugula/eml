<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" indent="yes"/>
<xsl:output encoding="ISO-8859-1"/>
<xsl:strip-space elements="*"/>


	<!-- assign variables for input doc i.e. beta6 attribute module -->
	<xsl:variable name="attb6" select="document('att1.atb6')"/>

  <xsl:template name="attrTransform">

  
    <attributeList>
      <xsl:for-each select="$attb6/eml-attribute/attribute">
        <xsl:element name="attribute">
        
          <xsl:element name="attributeName">
            <xsl:value-of select="./attributeName"/>
          </xsl:element>
          
          <xsl:if test="$attb6/eml-attribute/attribute/attributeLabel!=''">
            <xsl:for-each select="./attributeLabel">
              <xsl:element name="attributeLabel">
                <xsl:value-of select="."/>
              </xsl:element>
            </xsl:for-each>  
          </xsl:if>
          
          <xsl:element name="attributeDefinition">
            <xsl:value-of select="./attributeDefinition"/>
          </xsl:element>
          
          <xsl:if test="$attb6/eml-attribute/attribute/dataType!=''">
            <xsl:element name="storageType">
              <xsl:value-of select="./dataType"/>
            </xsl:element>
          </xsl:if>
          
          <xsl:element name="measurementScale">
     <!-- must determine which of 5 measurementScales to create -->     
            <xsl:if test="((./attributeDomain/enumeratedDomain!='')or(./attributeDomain/textDomain!=''))">
              <xsl:if test="./dataType='Date'"> <!-- need other string checks for time, etc here -->
                <xsl:element name="datetime">
                  <xsl:element name="formatString">
                    <xsl:value-of select="'YYY-MM-DD'"/><!-- this is an arbitrary choice -->  
                  </xsl:element>
                  <xsl:element name="dateTimePrecision">
                    <xsl:value-of select="'unknown'"/><!-- this is an arbitrary choice -->  
                  </xsl:element>
                  <xsl:element name="dateTimeDomain">
                    <xsl:element name="bounds">
                      <minimum exclusive="false">unknown</minimum>
                      <maximum exclusive="false">unknown</maximum>
                     </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
              <xsl:if test="./dataType!='Date'"> <!-- need other string checks for time, etc here -->
                <xsl:element name="nominal">
                  <xsl:element name="nonNumericDomain">
                     <xsl:if test="./attributeDomain/enumeratedDomain!=''">
                        <xsl:element name="enumeratedDomain">
                          <xsl:for-each select="./attributeDomain/enumeratedDomain"> 
                            <xsl:element name="codeDefinition">
                              <xsl:element name="code">
                                <xsl:value-of select="./code"/>
                              </xsl:element>
                              <xsl:element name="definition">
                                <xsl:value-of select="./definition"/>
                              </xsl:element>
                              <xsl:if test="./source!=''">
                                <xsl:element name="source">
                                  <xsl:value-of select="./source"/>
                                </xsl:element>
                              </xsl:if>  
                           </xsl:element>
                          </xsl:for-each>  
                        </xsl:element>
                     </xsl:if>
                     <xsl:if test="./attributeDomain/textDomain!=''">
                        <xsl:element name="textDomain">
                          <xsl:for-each select="./attributeDomain/textDomain"> 
                            <xsl:element name="definition">
                              <xsl:value-of select="./definition"/>
                            </xsl:element>
                            <xsl:if test="./pattern!=''">
                              <xsl:element name="pattern">
                                <xsl:value-of select="./pattern"/>
                              </xsl:element>
                            </xsl:if>  
                            <xsl:if test="./source!=''">
                              <xsl:element name="source">
                                <xsl:value-of select="./source"/>
                              </xsl:element>
                            </xsl:if>  
                          </xsl:for-each>
                       </xsl:element>
                     </xsl:if>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
              <!-- don't see how to determine if data is ordinal !! -->
            </xsl:if>
            
            <xsl:if test="./attributeDomain/numericDomain!=''">
            <!-- must be ratio or interval -->
              <xsl:if test="((./attributeDomain/numericDomain/minimum!='')and((./attributeDomain/numericDomain/minimum)&gt;=0.0))">
                <xsl:element name="ratio">
                  <xsl:element name="unit">
                    <xsl:element name="customUnit"> <!-- maybe a standard unit? -->
                      <xsl:value-of select="./unit"/>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="precision">
                  <!-- Note: 'precision' sometimes is filled out in beta6 for nonnumeric data! -->
                    <xsl:choose>
                      <xsl:when test="./precision!=''">
                        <xsl:value-of select="./precision"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'0.0'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                  <xsl:element name="numericDomain">
                    <xsl:element name="numberType">real</xsl:element>
                    <!--should really check data type + bounds to see if integer?-->
                    <xsl:element name="bounds">
                      <xsl:element name="minimum">
                        <xsl:value-of select="./attributeDomain/numericDomain/minimum"/>
                      </xsl:element>
                      <xsl:element name="maximum">
                        <xsl:value-of select="./attributeDomain/numericDomain/maximum"/>
                      </xsl:element>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
              <xsl:if test="((./attributeDomain/numericDomain/minimum!='')and((./attributeDomain/numericDomain/minimum)&lt;0.0))">
                <xsl:element name="interval">
                  <xsl:element name="unit">
                    <xsl:element name="customUnit"> <!-- maybe a standard unit? -->
                      <xsl:value-of select="./unit"/>
                    </xsl:element>
                  </xsl:element>
                  <xsl:element name="precision">
                  <!-- Note: 'precision' sometimes is filled out in beta6 for nonnumeric data! -->
                    <xsl:choose>
                      <xsl:when test="./precision!=''">
                        <xsl:value-of select="./precision"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="'0.0'"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:element>
                  <xsl:element name="numericDomain">
                    <xsl:element name="numberType">real</xsl:element>
                    <xsl:element name="bounds">
                      <minimum exclusive='false'>
                        <xsl:value-of select="./attributeDomain/numericDomain/minimum"/>
                      </minimum>
                      <maximum exclusive='false'>
                        <xsl:value-of select="./attributeDomain/numericDomain/maximum"/>
                      </maximum>
                    </xsl:element>
                  </xsl:element>
                </xsl:element>
              </xsl:if>
            </xsl:if>
          </xsl:element>
          <xsl:if test="$attb6/eml-attribute/attribute/missingValueCode!=''">
            <xsl:for-each select="./missingValueCode">
              <xsl:element name="missingValueCode">
                <xsl:element name="code">
                  <xsl:value-of select="."/>
                </xsl:element>
                <xsl:element name="codeExplanation">not available</xsl:element>
              </xsl:element>
            </xsl:for-each>  
          </xsl:if>
          
        </xsl:element><!-- end of attribute element-->
      </xsl:for-each>
    </attributeList>
  
  </xsl:template>
  
</xsl:stylesheet>  
