<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../json/json-metamodel.xsl"/>
	<xsl:include href="../../functions.xsl"/>

	<xsl:template match="/rdf:RDF">
		<xsl:variable name="model" as="element()*">
			<_object>
				<html>
					<xsl:text>&lt;p&gt;</xsl:text>
					<xsl:value-of select="descendant::skos:definition[@xml:lang = 'en']"/>
					<xsl:text>&lt;/p&gt;</xsl:text>
				</html>
				<id>
					<xsl:value-of select="tokenize(*[1]/@rdf:about, '/')[last()]"/>
				</id>
			</_object>
		</xsl:variable>

		<xsl:apply-templates select="$model"/>
	</xsl:template>
</xsl:stylesheet>
