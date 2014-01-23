<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2005/Atom" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	
	<!-- config variable -->
	<xsl:variable name="url" select="substring-before(doc('input:request')/request/request-url, 'feed/')"/>
	
	<!-- request params -->
	<xsl:param name="q" select="doc('input:request')/request/parameters/parameter[name='q']/value"/>	
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

	<xsl:template match="/">
		<xsl:variable name="numFound">
			<xsl:value-of select="number(//result[@name='response']/@numFound)"/>
		</xsl:variable>
		<xsl:variable name="last" select="floor($numFound div 100) * 100"/>
		<xsl:variable name="next" select="$start_var + 100"/>


		<feed xmlns="http://www.w3.org/2005/Atom">
			<title>
				<xsl:value-of select="/content/config/title"/>
			</title>
			<link href="{$url}"/>
			<link href="{$url}feed/{if (string($q)) then concat('?q=', $q) else ''}" rel="self"/>
			<id>Feed ID</id>

			<xsl:if test="$next &lt; $last">
				<link rel="next" href="{$url}feed/{if (string($q)) then concat('?q=', $q, '&amp;') else '?'}start={$next}"/>
			</xsl:if>
			<link rel="last" href="{$url}feed/{if (string($q)) then concat('?q=', $q, '&amp;') else '?'}start={$last}"/>
			<author>
				<name>Title</name>
			</author>
			<xsl:apply-templates select="descendant::doc"/>
		</feed>

	</xsl:template>

	<xsl:template match="doc">
		<!--<xsl:variable name="objectUri">
			<xsl:choose>
				<xsl:when test="//config/ark[@enabled='true']">
					<xsl:choose>
						<xsl:when test="string(str[@name='cid'])">
							<xsl:value-of select="concat($url, 'ark:/', //config/ark/naan, '/', str[@name='recordId'], '/', str[@name='cid'])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($url, 'ark:/', //config/ark/naan, '/', str[@name='recordId'])"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="string(str[@name='cid'])">
							<xsl:value-of select="concat($url, 'id/', str[@name='recordId'], '/', str[@name='cid'])"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($url, 'id/', str[@name='recordId'])"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>-->
		<entry>
			<title>
				<xsl:value-of select="str[@name='unittitle_display']"/>
			</title>
			<link href="{str[@name='id']}"/>
			<link rel="alternate xml" type="text/xml" href="{str[@name='id']}.xml"/>
			<link rel="alternate rdf" type="application/rdf+xml" href="{str[@name='id']}.rdf"/>
			<id>
				<xsl:value-of select="str[@name='id']"/>
			</id>
			<updated>
				<xsl:value-of select="date[@name='timestamp']"/>
			</updated>
		</entry>
	</xsl:template>
</xsl:stylesheet>
