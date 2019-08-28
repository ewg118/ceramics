<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:void="http://rdfs.org/ns/void#" xmlns:pelagios="http://pelagios.github.io/vocab/terms#" xmlns:relations="http://pelagios.github.io/vocab/relations#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:edm="http://www.europeana.eu/schemas/edm/"
	xmlns:svcs="http://rdfs.org/sioc/services#" xmlns:doap="http://usefulinc.com/ns/doap#" xmlns:oa="http://www.w3.org/ns/oa#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" exclude-result-prefixes="#all" version="2.0">

	<xsl:variable name="url" select="/content/config/url"/>
	<xsl:param name="page" select="tokenize(tokenize(doc('input:request')/request/request-url, '/')[last()], '\.')[2]"/>

	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:oa="http://www.w3.org/ns/oa#"
			xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:void="http://rdfs.org/ns/void#"
			xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:svcs="http://rdfs.org/sioc/services#" xmlns:doap="http://usefulinc.com/ns/doap#">

			<!-- suppress agent from any page but the first -->
			<xsl:if test="xs:integer($page) = 0">
				<foaf:Organization rdf:about="{$url}pelagios-objects.rdf#agents/me">
					<foaf:name>
						<xsl:value-of select="/content/config/title"/>
					</foaf:name>
				</foaf:Organization>
			</xsl:if>

			<xsl:apply-templates select="descendant::res:result"/>
		</rdf:RDF>
	</xsl:template>

	<xsl:template match="res:result">
		<xsl:variable name="uri" select="res:binding[@name = 'object']/res:uri"/>

		<pelagios:AnnotatedThing rdf:about="{$url}pelagios-objects.rdf#{encode-for-uri($uri)}">
			<dcterms:title>
				<xsl:value-of select="res:binding[@name = 'title']/res:literal"/>
			</dcterms:title>
			<foaf:homepage rdf:resource="{$uri}"/>
			<xsl:if test="res:binding[@name = 'startDate'] and res:binding[@name = 'endDate']">
				<dcterms:temporal>
					<xsl:text>start=</xsl:text>
					<xsl:value-of select="number(res:binding[@name = 'startDate'])"/>
					<xsl:text>; end=</xsl:text>
					<xsl:value-of select="number(res:binding[@name = 'endDate'])"/>
				</dcterms:temporal>
			</xsl:if>
			<xsl:if test="res:binding[@name = 'model']">
				<edm:isShownBy rdf:resource="{res:binding[@name='model']/res:uri}"/>
			</xsl:if>
			<xsl:apply-templates select="res:binding[@name='thumb'] | res:binding[@name='ref']" mode="image"/>
			<void:inDataset rdf:resource="{res:binding[@name='dataset']/res:uri}"/>
		</pelagios:AnnotatedThing>

		<oa:Annotation rdf:about="{$url}pelagios-objects.rdf#{encode-for-uri($uri)}/annotations/01">
			<oa:hasBody rdf:resource="{res:binding[@name='match']/res:uri}#this"/>
			<oa:hasTarget rdf:resource="{$url}pelagios-objects.rdf#{encode-for-uri($uri)}"/>
			<pelagios:relation rdf:resource="http://pelagios.github.io/vocab/relations#attestsTo"/>
			<oa:annotatedBy rdf:resource="{$url}pelagios-objects.rdf#agents/me"/>
			<oa:annotatedAt rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
				<xsl:value-of select="current-dateTime()"/>
			</oa:annotatedAt>
		</oa:Annotation>


		<!-- edm:WebResource and svcs:Service for IIIF integration -->
		<xsl:for-each select="res:binding[@name='manifest']">
			<edm:WebResource rdf:about="{parent::node()/res:binding[@name='ref']/res:uri}">
				<dcterms:isReferencedBy rdf:resource="{res:uri}"/>
				<svcs:has_service rdf:resource="{parent::node()/res:binding[@name='service']/res:uri}"/>
			</edm:WebResource>

			<svcs:Service rdf:about="{parent::node()/res:binding[@name = 'service']/res:uri}">
				<dcterms:conformsTo rdf:resource="http://iiif.io/api/image"/>
				<doap:implements rdf:resource="http://iiif.io/api/image/2/level1.json"/>
			</svcs:Service>
		</xsl:for-each>

		<!-- include 3D model -->
		<xsl:if test="res:binding[@name = 'model']">
			<edm:WebResource rdf:about="{res:binding[@name='model']/res:uri}">
				<dcterms:format rdf:resource="{res:binding[@name='modelFormat']/res:uri}"/>
				<dcterms:publisher>
					<xsl:value-of select="res:binding[@name = 'modelPublisher']/res:literal"/>
				</dcterms:publisher>
			</edm:WebResource>
		</xsl:if>
	</xsl:template>

	<xsl:template match="res:binding" mode="image">
		<xsl:element name="{if (@name = 'thumb') then 'foaf:thumbnail' else 'foaf:depiction'}" namespace="http://xmlns.com/foaf/0.1/">
			<xsl:attribute name="rdf:resource" select="res:uri"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
