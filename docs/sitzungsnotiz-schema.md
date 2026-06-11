# Sitzungsnotiz-Schema

## Ziel

Dieses Dokument legt fest, wie Ergebnisse einer Freitagssitzung direkt an einer Deck-Karte dokumentiert werden.

Das Schema soll:

1. schnell im Termin nutzbar sein
2. Entscheidungen nachvollziehbar halten
3. die Basis fuer spaetere ToDo-Ableitung und Wiedervorlage bilden

## Grundsatz

Im MVP bleibt die **Deck-Karte der zentrale Ort** fuer die Sitzungsdokumentation.

Das bedeutet:

- keine separate Protokoll-App
- keine komplexe Unterdatenstruktur
- stattdessen ein standardisierter Sitzungsnotiz-Block im Beschreibungstext

## Zeitpunkt der Nutzung

Das Sitzungsnotiz-Schema wird verwendet, wenn eine Karte im oder nach dem Status:

- `Freitagsagenda`

bearbeitet wird.

## Dokumentationsziel pro Punkt

Fuer jeden besprochenen Agenda-Punkt sollen nach der Sitzung mindestens folgende Fragen beantwortbar sein:

1. Wurde der Punkt besprochen?
2. Was ist das Ergebnis?
3. Gab es einen Beschluss?
4. Sind Folgeaufgaben entstanden?
5. Welcher Zielstatus gilt danach?

## MVP-Ergebnisarten

Im MVP werden vier Ergebnisarten verwendet:

### 1. `beschlossen`

Bedeutung:

- zum Punkt wurde eine klare Entscheidung getroffen

Typischer Folgestatus:

- `Beschlossen`
- oder `ToDo laeuft`, falls Folgearbeit entsteht

### 2. `vertagt`

Bedeutung:

- der Punkt bleibt offen und soll spaeter erneut behandelt werden

Typischer Folgestatus:

- `Vorbereitung`
- oder `Freitagsagenda`, falls direkte Wiedervorlage gewollt ist

### 3. `rueckfrage`

Bedeutung:

- der Punkt ist noch nicht entscheidungsreif
- weitere Klaerung ist noetig

Typischer Folgestatus:

- `Rueckfrage`

### 4. `erledigt_ohne_folge`

Bedeutung:

- Thema ist abgeschlossen
- keine operative Nachverfolgung noetig

Typischer Folgestatus:

- `Erledigt`

## Standardblock fuer die Sitzungsnotiz

Der Sitzungsnotiz-Teil soll in die Kartenbeschreibung unterhalb des bestehenden Importblocks eingefuegt oder gepflegt werden.

Empfohlenes Format:

```text
Sitzungsnotiz
Sitzungsdatum: <YYYY-MM-DD>
Besprochen: <ja|nein>
Ergebnisart: <beschlossen|vertagt|rueckfrage|erledigt_ohne_folge>
Beschluss: <kurze Entscheidung oder leer>
Ergebnisnotiz: <freie Kurznotiz>
Folgeaufgaben entstanden: <ja|nein>
Naechster Zielstatus: <Beschlossen|Rueckfrage|Vorbereitung|Freitagsagenda|ToDo laeuft|Erledigt>
```

## Pflichtfelder im Sitzungsnotiz-Block

Nach einer realen Besprechung muessen mindestens gepflegt sein:

- `Sitzungsdatum`
- `Besprochen`
- `Ergebnisart`
- `Naechster Zielstatus`

## Optionale, aber wichtige Felder

- `Beschluss`
- `Ergebnisnotiz`
- `Folgeaufgaben entstanden`

## Regeln fuer den Naechsten Zielstatus

### Wenn `Ergebnisart = beschlossen`

- ohne Folgeaufgaben -> `Beschlossen`
- mit Folgeaufgaben -> `ToDo laeuft`

### Wenn `Ergebnisart = vertagt`

- Standard -> `Vorbereitung`
- bei sofortiger Wiederaufnahme moeglich -> `Freitagsagenda`

### Wenn `Ergebnisart = rueckfrage`

- Zielstatus -> `Rueckfrage`

### Wenn `Ergebnisart = erledigt_ohne_folge`

- Zielstatus -> `Erledigt`

## Bedienbarkeit im Termin

Das Schema ist absichtlich textbasiert und kompakt gehalten.

Vorteile:

- direkt in Deck bearbeitbar
- keine Zusatzmaske noetig
- spaetere Automatisierung kann feste Feldnamen lesen

## Nicht im MVP

Noch nicht Teil des Sitzungsnotiz-Schemas:

- Mehrfachbeschluesse pro Karte als eigene Struktur
- formale Abstimmungsergebnisse mit Ja/Nein/Enthaltung
- Teilnehmerliste
- Langprotokoll oder Wortbeitraege

## Folge fuer P4-03

Die ToDo-Ableitung soll direkt auf zwei Feldern aufsetzen:

- `Folgeaufgaben entstanden`
- `Naechster Zielstatus`

Sobald `Folgeaufgaben entstanden: ja` gesetzt wird, muss die Modellierung fuer Verantwortliche, Fristen und Wiedervorlage greifen.
