<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline xmlns:p="http://www.orbeon.com/oxf/pipeline"
	xmlns:oxf="http://www.orbeon.com/oxf/processors">
	
	<p:param type="input" name="file"/>
	<p:param type="output" name="data"/>	
	
	<p:processor name="oxf:request">
		<p:input name="config">
			<config>
				<include>/request</include>
			</config>
		</p:input>
		<p:output name="data" id="request"/>
	</p:processor>	
	
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="request" href="#request"/>
		<p:input name="data" href="../config.xml"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
				<xsl:output indent="yes"/>
				<xsl:template match="/">					
					<xsl:variable name="path" select="substring-after(doc('input:request')/request/request-url, 'id/')"/>
					
					<xsl:variable name="doc">
						<xsl:choose>
							<xsl:when test="string(doc('input:request')/request/parameters/parameter[name='id']/value)">
								<xsl:value-of select="doc('input:request')/request/parameters/parameter[name='id']/value"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="contains($path, '.')">
										<xsl:variable name="pieces" select="tokenize($path, '\.')"/>
										
										<xsl:for-each select="$pieces[not(position()=last())]">
											<xsl:value-of select="."/>
											<xsl:if test="not(position()=last())">
												<xsl:text>.</xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$path"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:copy-of select="document(concat('file:///usr/local/projects/ceramic-ids/id/', $doc, '.xml'))/*"/>					
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:pipeline>

