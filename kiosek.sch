<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <sch:ns uri="urn:vse.cz:vanj23:kiosek" prefix="kiosek"/>

    <!-- Položka účtenky, co má typ kuponu musí odpovídat názvem kuponu -->
    <!-- Položka účtenky, co má typ samostaná musí odpovídat názvem položce -->
    <sch:pattern>
        <sch:title>Názvy položky účtenek odpovídají</sch:title>
        
        <sch:rule
            context="kiosek:uctenky/kiosek:uctenka/kiosek:polozkyUctenky/kiosek:polozkaUctenky[@kiosek:typ = 'Kupon']">
            <sch:let name="aktualniHodnotaTextu" value="./kiosek:nazev/text()"/>
            <sch:report
                test="count(/kiosek:kiosek/kiosek:kupony/kiosek:kupon/kiosek:nazev[text() = $aktualniHodnotaTextu]) &lt; 1"
                > Nepodařilo se najít kupon v nabídce s tímto názvem! </sch:report>
        </sch:rule>

        <sch:rule
            context="kiosek:uctenky/kiosek:uctenka/kiosek:polozkyUctenky/kiosek:polozkaUctenky[@kiosek:typ = 'Samostatná']">
            <sch:let name="aktualniHodnotaTextu" value="./kiosek:nazev/text()"/>
            <sch:report
                test="count(/kiosek:kiosek/kiosek:polozky/kiosek:polozka/kiosek:nazev[text() = $aktualniHodnotaTextu]) &lt; 1"
                > Nepodařilo se najít položku v nabídce s tímto názvem! </sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Součet jednotlivých položek se rovná celkové ceně na účtence -->
    <sch:pattern>
        <sch:title>Cena je správně vypočítána</sch:title>

        <sch:rule context="kiosek:uctenky/kiosek:uctenka">
            <sch:let name="celkovaCena" value="kiosek:celkem"/>
            <sch:let name="soucetCen"
                value="sum(kiosek:polozkyUctenky/kiosek:polozkaUctenky/(kiosek:pocet * kiosek:cena))"/>
            <sch:assert test="$celkovaCena = $soucetCen"> Součet cen a celková cena se musí rovnat!
                Celková cena: <sch:value-of select="$celkovaCena"/> Součet cen: <sch:value-of
                    select="$soucetCen"/>
            </sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- Položka účtenky obsahuje pouze povolené úpravy -->
    <sch:pattern>
        <sch:title>Položka účtenky obsahuje pouze povolené úpravy</sch:title>
        <sch:rule
            context="kiosek:uctenky/kiosek:uctenka/kiosek:polozkyUctenky/kiosek:polozkaUctenky/kiosek:upravaPolozky/kiosek:uprava">
            <sch:let name="nazevPolozky" value="../kiosek:upravovanaPolozka"/>
            <sch:let name="aktualniUprava" value="."/>
            <sch:assert
                test="count(/kiosek:kiosek/kiosek:polozky/kiosek:polozka/kiosek:nazev[text() = $nazevPolozky]/../kiosek:povoleneUpravy/kiosek:uprava[. = $aktualniUprava]) &gt; 0">
                <sch:value-of select="$aktualniUprava"/> Položka obsahuje pouze povolené úpravy!
            </sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- Element upravovanaPolozka musi byt soucasti kuponu (pokud je typ kupon), jinak se upravovanaPolozka musi rovnat nazvu na uctence -->
    <sch:pattern>
        <sch:title>Je upravováno pouze jídlo, které reálně bylo zakoupeno</sch:title>

        <!-- Pro samostatnou položku -->
        <sch:rule
            context="kiosek:uctenky/kiosek:uctenka/kiosek:polozkyUctenky/kiosek:polozkaUctenky[@kiosek:typ = 'Samostatná']/kiosek:upravaPolozky">
            <sch:let name="nazevPolozkyNaUctence" value="../kiosek:nazev"/>
            <sch:assert test="kiosek:upravovanaPolozka = $nazevPolozkyNaUctence"> Úprava se vztahuje
                k položce! </sch:assert>
        </sch:rule>

        <!-- Pro kupony -->
        <sch:rule
            context="kiosek:uctenky/kiosek:uctenka/kiosek:polozkyUctenky/kiosek:polozkaUctenky[@kiosek:typ = 'Kupon']/kiosek:upravaPolozky/kiosek:upravovanaPolozka">
            <sch:let name="nazevKuponu" value="../../kiosek:nazev"/>
            <sch:let name="polozkyKuponu"
                value="/kiosek:kiosek/kiosek:kupony/kiosek:kupon/kiosek:nazev[. = $nazevKuponu]/../kiosek:obsah"/>
            <sch:let name="aktualniUprava" value="."/>
            <sch:assert test="count($polozkyKuponu/kiosek:polozka[. = $aktualniUprava]) &gt; 0">
                Úpravy mohou být pouze pro položky z kuponu! </sch:assert>
        </sch:rule>
    </sch:pattern>

    <!-- Ceny sedí u kuponu i u samotnych polozek -->
    <sch:pattern>
        <sch:title>Ceny na účtence se rovnají ceníku</sch:title>
        
        <!-- Pro kupon -->
        <sch:rule context="kiosek:uctenky/kiosek:uctenka/kiosek:polozkyUctenky/kiosek:polozkaUctenky[@kiosek:typ='Kupon']">
            <sch:let name="nazevKuponu" value="kiosek:nazev"/>
            <sch:assert test="kiosek:cena = /kiosek:kiosek/kiosek:kupony/kiosek:kupon/kiosek:nazev[. = $nazevKuponu]/../kiosek:cena">
                Cena kuponu v nabídce a na účtence se musí rovnat!
            </sch:assert>
        </sch:rule>
        <!-- Pro samostatnou položku -->
        <sch:rule context="kiosek:uctenky/kiosek:uctenka/kiosek:polozkyUctenky/kiosek:polozkaUctenky[@kiosek:typ='Samostatná']">
            <sch:let name="nazevPolozky" value="kiosek:nazev"/>
            <sch:assert test="kiosek:cena = /kiosek:kiosek/kiosek:polozky/kiosek:polozka/kiosek:nazev[. = $nazevPolozky]/../kiosek:cena">
                Cena položky v nabídce a na účtence se musí rovnat!
            </sch:assert>
        </sch:rule>
    </sch:pattern>
    
</sch:schema>
