<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../templates.xsl"/>
	<xsl:variable name="display_path">./</xsl:variable>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
				<script type="text/javascript" src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>
			</head>
			<body>
				<xsl:call-template name="header"/>
				<xsl:call-template name="body"/>
				<xsl:call-template name="footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<div class="container-fluid content">
			<div class="row">
				<div class="col-md-8">
					<xsl:copy-of select="//index/*"/>
				</div>
				<div class="col-md-4">
					<div>
						<h3>Data Export</h3>
						<h4>Kerameikos Linked Data</h4>
						<ul>
							<li>
								<a href="kerameikos.org.rdf">RDF/XML</a>
							</li>
							<li>
								<a href="kerameikos.org.ttl">Turtle</a>
							</li>
							<li>
								<a href="kerameikos.org.jsonld">JSON-LD</a>
							</li>
						</ul>
					</div>
					<div>
						<h3>Atom Feed</h3>
						<a href="feed/">
							<img src="{$display_path}ui/images/atom-large.png"/>
						</a>
					</div>

				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
