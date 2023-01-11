<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kiosek="urn:vse.cz:vanj23:kiosek"
    exclude-result-prefixes="xs kiosek" version="2.0">

    <xsl:output method="html" version="5"/>

    <xsl:output method="html" version="5" name="html5"/>
    
    <xsl:param name="nazevRestaurace"/>
    <xsl:param name="barvaZahlavi"/>
    

    <xsl:template match="/">
        <html lang="cs">
            <head>
                <title>Kiosek - vanj23</title>
                <link
                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
                    rel="stylesheet"
                    integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
                    crossorigin="anonymous"/>
                <link rel="stylesheet" href="kiosek.css"/>
                <style>
                    header {
                        background-color: <xsl:value-of select="$barvaZahlavi"/>;
                    }
                </style>
            </head>
            <body>
                <header>
                    <h1><xsl:value-of select="$nazevRestaurace"/> kiosek - vanj23</h1>
                </header>
                <div class="container pt-4">
                    <div class="row">
                        <aside class="col-3">
                            <xsl:apply-templates select="kiosek:kiosek/kiosek:kategorieJidel"
                                mode="sideMenu"> </xsl:apply-templates>
                        </aside>
                        <main class="col-9">
                            <h3>Celá nabídka:</h3>
                            <div class="row">
                                <xsl:apply-templates select="kiosek:kiosek/kiosek:polozky"/>
                            </div>
                        </main>
                    </div>
                </div>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="kiosek:kategorie" mode="sideMenu">
        <!-- Uděláme podmínku - pokud je kategorie prázdná, vypíše se šedě -->
        <div class="category-card">
            <a href="{generate-id()}.html" title="Kategorie {.}">
                <h2>
                    <xsl:apply-templates/>
                </h2>
            </a>
        </div>

        <!-- Stránka pro samostatnou kategorii -->
        <xsl:result-document href="{generate-id()}.html" format="html5">
            <html lang="cs">
                <head>
                    <title><xsl:value-of select="."/> - vanj23</title>
                    <link
                        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
                        rel="stylesheet"
                        integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
                        crossorigin="anonymous"/>
                    <link rel="stylesheet" href="kiosek.css"/>
                    <style>
                        header {
                        background-color: <xsl:value-of select="$barvaZahlavi"/>;
                        }
                    </style>
                </head>
                <body>
                    <header>
                        <h1><xsl:value-of select="$nazevRestaurace"/> kiosek - vanj23</h1>
                    </header>
                    <div class="container pt-4">
                        <div class="row">
                            <aside class="col-3">
                                <div class="category-card">
                                    <a href="kiosek.html" title="Zpět na hlavní stránku">
                                        <h2>
                                            Zpět
                                        </h2>
                                    </a>
                                </div>
                            </aside>
                            <main class="col-9">
                                <h3><xsl:value-of select="."/>:</h3>
                                <div class="row">
                                    <!-- Vybrat položky na základě hodnoty kategorie -->
                                    <xsl:variable name="aktualniKategorie" select="text()"/>
                                    
                                    <xsl:apply-templates select="/kiosek:kiosek/kiosek:polozky/kiosek:polozka/kiosek:kategorie[text() = $aktualniKategorie]/.."/>
                                </div>
                            </main>
                        </div>
                    </div>
                </body>
            </html>

        </xsl:result-document>
    </xsl:template>

    <xsl:template match="kiosek:polozky">
        <xsl:for-each select="kiosek:polozka">
            <xsl:sort select="kiosek:cena" data-type="number" order="descending"/>
            <xsl:apply-templates select="."/>            
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="kiosek:polozka">
        <div class="col-4">
            <div class="item-card">

                <xsl:choose>
                    <xsl:when test="kiosek:povoleneUpravy/kiosek:uprava">
                        <h4 style="color:#0b6623">
                            <xsl:apply-templates select="kiosek:nazev"/> - <xsl:apply-templates
                                select="kiosek:cena"/>&#160;Kč
                        </h4>
                    </xsl:when>
                    <xsl:otherwise>
                        <h4>
                            <xsl:apply-templates select="kiosek:nazev"/> - <xsl:apply-templates
                                select="kiosek:cena"/>&#160;Kč
                        </h4>
                    </xsl:otherwise>
                </xsl:choose>
                
                <img src="{kiosek:obrazek}" alt="Obrázek pro {kiosek:nazev}"/>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
