<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs tei jc"
    xmlns:jc="http://james.blushingbunny.net/ns.html"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <!-- 
  File to output information about notes in SRO Entries, for each note that isn't a status note in an SRO volume. 
  For each note it outputs the SRO ID, the value of any @type attribute, the value of any @resp attribute, and the 
  string content of the note.
  
  This is best run on the commandline with something like:
  
  saxon -o:OutputFileName.csv -s:Arber1.xml -xsl:find-notes.xsl
  
  Then import the CSV into something like libreoffice or excel
  -->
    
    <!-- We set the output method for text because we are producing CSV -->
    <xsl:output method="text"/>
    
    <!-- We are matching the top-level document node since we're ignoring most of it. -->
    <xsl:template match="/">
        <!-- We output the column headings with a linebreak by having xsl:text end on next line -->  
        <xsl:text>"SRO ID", "choice", "sic", "corr"
</xsl:text>
        <!-- For each entry with a choice... -->  
        <xsl:for-each select="//div[@type='entry']//choice">
            <!-- We make a variable named 'output' which has all the columns we want. It is fine to 
  have them on separate lines and such because we will normalize-space it afterwards. -->
            <xsl:variable name="output">
                <!-- get the SRO ID -->
                "<xsl:value-of select="ancestor::div[@type='entry']/@xml:id"/>",
               
                <!-- get the normalized-space string of the current note, and then escape any double quotes in it. -->
                "<xsl:value-of select="jc:csvEscapeDoubleQuotes(normalize-space(.))"/>"
            </xsl:variable>
            <!-- the actual output, normalize-space the output variable -->  
            <xsl:value-of select="normalize-space($output)"/><xsl:text>
</xsl:text>    
        </xsl:for-each>    
    </xsl:template>   
    
    
    <!-- CSV doesn't like spare double quotes lying around. So you escape them by putting two double quotes instead --> 
    <xsl:function name="jc:csvEscapeDoubleQuotes" as="xs:string">
        <xsl:param name="string" as="xs:string"/>
        <xsl:value-of select="replace($string, '&quot;', '&quot;&quot;')"/>
    </xsl:function>
    
    
</xsl:stylesheet>
