# tbc65 - Mega65 Tiny Basic Compiler

TBC65 ist ein Compiler für ein einfaches Subset von Basic-Befehlen.
Das Programm benötigt einen Mega65 im Original oder Emulator.

Basis des Programms ist der Micro Compiler von Vic Cortes, der in der deutschen RUN (Juli 1986) erschien. (US Ausgabe #20 Aug 85)

Der Compiler tbc65 erzeugt ein ablauffähiges Programm auf Disk.

## Wichtiger Hinweis

Das Programm ist Work-in-Progress. Es sind noch nicht alle Funktionen umgesetzt und getestet.
Außerdem können vorhandene Programmierfehler zum Abbruch führen.
Ich habe damit begonnen, dem Code des Originals eine neue und übersichtlichere Struktur zu geben.

## Doku zum Original

Ich empfehle https://github.com/EgonOlsen71/microcompiler
bzw die US Ausgabe: https://archive.org/details/run-magazine-20

## Erweiterungen
Da die Ausgabe nicht mehr als Assembler Code erfolgt, fallen die Optionen weg.

    REM$A <assembler befehle>
fügt zusätzliche Assembler Befehl in den übersetzten Code ein

    REM$L
die MULDIV Library Routinen werden in jedem Fall eingebunden

    REM$V
    REM$NV
die Variablendefinitionen werden ausgegeben (Default) bzw nicht (NV)

    REM$Q
Beendet den Compiler, falls es bisher Übersetzungsfehler gab.

Dateiausgabe wird unterstützt mit
OPEN, CLOSE, GET#, PRINT#

Der BANK Befehl funktioniert ebenfalls.

    SYS, PEEK, POKE
Die Befehle waren auf dem C64 einfacher umgesetzt. Der Mega65 benötigt dank mehr Memory auch mehr Aufwand bei der Umsetzung. Mit lda_far und sta_far Routinen funktioniert das auch leidlich.

    PRINT INT
Integer Zahlen wurden beim C64 mit Hilfe einer ROM Routine ausgegeben. Das entsprechende Gegenstück im Mega65 ROM habe ich mangels ROM Listing nicht gefunden, also blieb nur eine eigene Funktion. Die gibt negative Zahlen korrekt aus. Eine -1 wird als -1 auf den Bildschirm geschrieben. Das Original kannte nur 0..65535.

## Ideen
Natürlich schweben mir für eine Folgeversion schon Erweiterungen vor. Das aber erst nachdem alle korrekt läuft.

 - Die Ausgabe von Zahlen sollte umschaltbar zwischen signed und unsigned int möglich sein.
 - Grafik wäre auch schön.
 - Ordentliche Auswertung von Termen. Es sollte "4 + 2 * 3" = 10 und nicht 18 sein.
 - Weitere Variabletypen: Array, String
 - aufgeräumte Programmstruktur

