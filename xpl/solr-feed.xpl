<?xml version="1.0" encoding="UTF-8"?>
<!--
	Copyright (C) 2010 Ethan Gruber
	EADitor: http://code.google.com/p/eaditor/
	Apache License 2.0: http://code.google.com/p/eaditor/
	
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors">

	<p:param type="input" name="data"/>
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
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
				<!-- url params -->
				<xsl:param name="q" select="doc('input:request')/request/parameters/parameter[name='q']/value"/>
				<xsl:param name="sort" select="doc('input:request')/request/parameters/parameter[name='sort']/value"/>
				<xsl:param name="start" select="doc('input:request')/request/parameters/parameter[name='start']/value"/>
				<xsl:variable name="start_var" as="xs:integer">
					<xsl:choose>
						<xsl:when test="number($start)">
							<xsl:value-of select="$start"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:param name="rows" as="xs:integer">100</xsl:param>
				
				<!-- config variables -->
				<xsl:variable name="solr-url" select="concat(/config/solr_published, 'select/')"/>
				
				<xsl:variable name="service">
					<xsl:choose>
						<xsl:when test="string($q)">
							<xsl:choose>
								<xsl:when test="string($sort)">
									<xsl:value-of select="concat($solr-url, '?q=', encode-for-uri($q), '&amp;sort=', encode-for-uri($sort), '&amp;start=',$start, '&amp;rows=100')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($solr-url, '?q=', encode-for-uri($q), '&amp;sort=timestamp%20desc&amp;start=',$start, '&amp;rows=100')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="string($sort)">
									<xsl:value-of select="concat($solr-url, '?q=*:*&amp;sort=', encode-for-uri($sort), '&amp;start=',$start, '&amp;rows=100')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="concat($solr-url, '?q=*:*&amp;sort=timestamp%20desc&amp;start=',$start, '&amp;rows=100')"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:template match="/">
					<xsl:copy-of select="document($service)/response"/>
				</xsl:template>				
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
