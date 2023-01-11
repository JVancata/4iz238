<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:kiosek="urn:vse.cz:vanj23:kiosek" exclude-result-prefixes="xs kiosek" version="2.0">

    <xsl:output method="xml"/>

    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4" page-height="297mm" page-width="210mm"
                    margin="1in">


                    <fo:region-body margin-bottom="15mm"/>
                    <fo:region-after extent="10mm"/>

                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="A4" font-family="Calibri" font-size="11pt"
                line-height="1.15">

                <fo:static-content flow-name="xsl-region-after">

                    <fo:block text-align-last="justify">
                        <fo:page-number/> vanj23 </fo:block>

                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <xsl:variable name="totalSum"
                            select="sum(kiosek:kiosek/kiosek:uctenky/kiosek:uctenka/kiosek:celkem)"/>
                        <xsl:variable name="totalCount"
                            select="count(kiosek:kiosek/kiosek:uctenky/kiosek:uctenka)"/>
                        <xsl:variable name="averageCost" select="$totalSum div $totalCount"/>
                        <fo:block font-size="28pt" font-weight="600"> Seznam účtenek: </fo:block>
                        <fo:block> Celkový počet: <xsl:value-of select="$totalCount"/> účtenky </fo:block>
                        <fo:block> Celková částka: <xsl:value-of select="$totalSum"/> Kč </fo:block>
                        <fo:block> Průměrná objednávka: <xsl:value-of select="round($averageCost)"/>
                            Kč </fo:block>
                        <fo:block margin-top="10mm">
                            <xsl:apply-templates select="kiosek:kiosek/kiosek:uctenky"/>
                        </fo:block>
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="kiosek:uctenky">
        <xsl:for-each select="kiosek:uctenka">
            <fo:block text-align="justify" text-align-last="justify">

                <fo:page-number-citation ref-id="{generate-id()}"/>
                <fo:leader/>
                <fo:inline color="blue">
                    <fo:basic-link internal-destination="{generate-id()}">
                        <xsl:value-of select="kiosek:id"/>
                    </fo:basic-link>
                </fo:inline>

            </fo:block>
        </xsl:for-each>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="kiosek:uctenka">
        <fo:block id="{generate-id()}" font-size="28pt" page-break-before="always"> Účtenka: </fo:block>

        <!-- Detaily účtenky -->
        <fo:table>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell width="30mm">
                        <fo:block>ID</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:value-of select="kiosek:id"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell width="30mm">
                        <fo:block>Datum vystavení</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:value-of
                                select="format-dateTime(kiosek:vystaveno, '[D01]. [M01]. [Y0001] [H01]:[m01]:[s01]')"
                            />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell width="30mm">
                        <fo:block>Čas vystavení</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:value-of
                                select="format-dateTime(kiosek:vystaveno, '[H01]:[m01]:[s01]')"/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <fo:table-row>
                    <fo:table-cell width="30mm">
                        <fo:block>Cena</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block>
                            <xsl:value-of select="kiosek:celkem"/> Kč </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
        <fo:block font-size="18pt" margin-top="10mm"> Položky: </fo:block>
        <fo:block>
            <xsl:apply-templates select="kiosek:polozkyUctenky"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="kiosek:polozkaUctenky">
        <fo:leader leader-pattern="rule" leader-length="100%" rule-style="solid"
            rule-thickness="1pt"/>

        <xsl:variable name="nazevPolozky" select="kiosek:nazev"/>

        <fo:table>
            <fo:table-body>
                <!-- Data + Obrázek -->
                <fo:table-row>
                    <!-- Data -->
                    <fo:table-cell>
                        <fo:table>
                            <fo:table-body>
                                <fo:table-row>
                                    <fo:table-cell width="30mm">
                                        <fo:block>Typ</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block>
                                            <xsl:value-of select="./@kiosek:typ"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell width="30mm">
                                        <fo:block>Název</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block>
                                            <xsl:value-of select="kiosek:nazev"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell width="30mm">
                                        <fo:block>Cena</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block>
                                            <xsl:value-of select="kiosek:cena"/> Kč </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                                <fo:table-row>
                                    <fo:table-cell width="30mm">
                                        <fo:block>Počet</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block>
                                            <xsl:value-of select="kiosek:pocet"/> ks</fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:table-cell>
                    <!-- Pokud je to samostatná položka, zobraz obrázek -->
                    <xsl:if test="./@kiosek:typ = 'Samostatná'">
                        <xsl:variable name="imageSrc"
                            select="/kiosek:kiosek/kiosek:polozky/kiosek:polozka[kiosek:nazev = $nazevPolozky]/kiosek:obrazek"/>
                        <fo:table-cell width="30mm">
                            <fo:block>
                                <fo:external-graphic src="{$imageSrc}" content-height="scale-to-fit"
                                    height="20mm" content-width="40mm"/>
                            </fo:block>
                        </fo:table-cell>
                    </xsl:if>
                </fo:table-row>
                <!-- Pokud má položka úpravy, zobraz je -->
                <xsl:if test="count(kiosek:upravaPolozky) &gt; 0">
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block margin-top="5mm" font-weight="600"> Úpravy: </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell width="30mm">
                            <fo:block> Pro 
                                <fo:inline font-weight="600"><xsl:value-of select="kiosek:upravaPolozky/kiosek:upravovanaPolozka"/></fo:inline>: </fo:block>
                        </fo:table-cell>
                        <!--<fo:table-cell>
                            <fo:block> <xsl:value-of select="kiosek:upravaPolozky/kiosek:upravovanaPolozka"/> </fo:block>
                        </fo:table-cell>-->
                    </fo:table-row>
                    <xsl:apply-templates select="kiosek:upravaPolozky/kiosek:uprava"/>
                </xsl:if>
            </fo:table-body>
        </fo:table>

    </xsl:template>
    
    <xsl:template match="kiosek:uprava">
        <fo:table-row>
            <fo:table-cell>
                <fo:block>
                    <xsl:value-of select="."/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
</xsl:stylesheet>
