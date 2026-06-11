# Deck-Board-Design

## Ziel

Dieses Dokument definiert das konkrete MVP-Sollbild fuer das Deck-Board `1919`.

Es legt fest:

1. welche Stacks verwendet werden
2. welche Labels genutzt werden
3. wie eine Agenda-Karte strukturiert wird
4. welche Elemente n8n beim Import setzen soll

## Reeller Umsetzungsstand

Das Soll-Design wurde am `2026-06-10` bereits im realen Board umgesetzt.

Aktueller Ist-Stand des Boards:

- Board-ID: `1919`
- Board-Titel: `TIPS AgendaFlow`

Aktuelle Stacks:

- `5678` -> `Eingang`
- `5681` -> `Rueckfrage`
- `5684` -> `Vorbereitung`
- `5687` -> `Freitagsagenda`
- `5690` -> `Beschlossen`
- `5693` -> `ToDo laeuft`
- `5696` -> `Erledigt`

Aktuelle Labels:

- `7895` -> `Abgeschlossen`
- `7898` -> `Zu ueberpruefen`
- `7901` -> `Handlung erforderlich`
- `7904` -> `Spaeter`
- `7907` -> `Information`
- `7910` -> `Diskussion`
- `7913` -> `Beschluss`
- `7916` -> `Sonstiges`

## Grundentscheidung

Im MVP wird der **fachliche Status primär ueber Stacks** abgebildet, nicht ueber Labels.

Begruendung:

- Der Statusfluss ist das zentrale Navigations- und Arbeitsmodell.
- Deck-Stacks sind visuell klarer als reine Label-Logik.
- `Agenda Koordination` und `Sitzungsleitung` koennen so direkt am Board arbeiten, ohne Zusatzlogik lesen zu muessen.

Labels werden im MVP nur fuer **ergänzende Verdichtung** genutzt.

## Soll-Stacks

Die Zielstruktur des Boards soll direkt dem definierten Statusmodell entsprechen.

### 1. `Eingang`

- Startstack fuer neue Karten aus Outlook `__Agenda`
- ersetzt den bisherigen generischen Stack `Backlog`

### 2. `Rueckfrage`

- fuer unklare, unvollstaendige oder blockierte Punkte

### 3. `Vorbereitung`

- fuer inhaltlich valide Punkte in Bearbeitung

### 4. `Freitagsagenda`

- fuer Punkte, die konkret in die naechste Sitzung sollen

### 5. `Beschlossen`

- fuer Punkte mit dokumentierter Entscheidung ohne offene Folgearbeit

### 6. `ToDo laeuft`

- fuer Punkte mit laufender Nachverfolgung

### 7. `Erledigt`

- fuer abgeschlossene Punkte

## Umgang mit dem bisherigen Stack `Backlog`

Bereits umgesetzt:

1. `Backlog` wurde in `Eingang` umbenannt
2. die weiteren sechs Stacks wurden angelegt

## Label-Design

## Grundsatz

Labels sollen **nicht** den Status duplizieren.

Sie sollen nur Informationen tragen, die quer zum Status liegen.

## MVP-Labels fuer Kategorien

Die fachliche Kategorie soll im MVP als Label gefuehrt werden, weil sie dann im Board sofort sichtbar ist.

Empfohlene Kategorien-Labels:

- `Information`
- `Diskussion`
- `Beschluss`
- `Sonstiges`

## MVP-Labels fuer Bearbeitungshinweise

Die bereits im Board vorhandenen Labels sind dafuer brauchbar und koennen weiterverwendet werden.

- `Zu ueberpruefen`
  - fuer Punkte mit fachlicher Unsicherheit
- `Handlung erforderlich`
  - fuer Punkte mit aktiver Folgearbeit
- `Spaeter`
  - fuer bewusst zurueckgestellte Punkte
- `Abgeschlossen`
  - im MVP optional, weil `Erledigt` bereits als Stack existiert

Empfehlung:

- `Abgeschlossen` mittelfristig nicht aktiv nutzen, um Doppelabbildung zum Stack `Erledigt` zu vermeiden

## Kartenstruktur

## Titel

Der Kartentitel soll knapp und lesbar bleiben.

Regel:

- primaer Mail-Betreff
- bei Bedarf durch `Agenda Koordination` manuell verkuerzen

## Beschreibung

Die Kartenbeschreibung soll in einem festen Blockschema aufgebaut werden.

Empfohlenes Format:

```text
Kurzkontext
<hier Body-Preview oder manuelle Kurzbeschreibung>

Kategorie: <Information|Diskussion|Beschluss|Sonstiges>
Status: <Eingang|Rueckfrage|Vorbereitung|Freitagsagenda|Beschlossen|ToDo laeuft|Erledigt>
Einreicher: <Name>
E-Mail: <Adresse>
Eingang: <Datum>
Gewuenschter Termin: <optional>
Vorbereitung: <optional>
Wiedervorlage/Frist: <optional>

Technik
source_system: outlook_agenda_folder
source_message_id: <Graph Message ID>
source_folder_id: <Graph Folder ID>
imported_at: <Zeitstempel>
```

## Zweck des Beschreibungsblocks

Der Block dient drei Zielen:

- Pflichtfelder bleiben in Deck ohne Sonderentwicklung sichtbar
- Menschen und Workflow teilen dieselbe Referenz
- spaetere Updates durch n8n koennen gezielt auf feste Feldnamen schreiben

## Checklisten und Kommentare

Im MVP sollen Checklisten und Kommentare noch nicht Kernbestandteil des Imports sein.

Empfehlung:

- Kommentare nur manuell
- Checklisten erst in Phase 4 einfuehren, wenn ToDo-Ableitung stabil ist

## Mindestbelegung durch n8n beim Import

Beim Import einer Mail aus `__Agenda` soll n8n mindestens:

1. eine Karte im Stack `Eingang` anlegen
2. genau ein Kategorien-Label setzen
3. die Kartenbeschreibung im Standardblock befuellen
4. den technischen Referenzteil mit Graph-ID und Importzeitpunkt schreiben

## Manuelle Pflege nach dem Import

Nach dem Import pflegt die `Agenda Koordination` typischerweise:

- Kategorie, falls der Standardwert `Sonstiges` unpassend ist
- den fachlich passenden Zielstack
- `Gewuenschter Termin`
- `Vorbereitung`
- `Wiedervorlage/Frist`

Spaeter in Sitzung oder Nachverfolgung kommen hinzu:

- `decision_note`
- `todo_summary`

Diese Inhalte werden im MVP zunaechst ebenfalls im Beschreibungstext gepflegt.

## Nicht im MVP

Noch nicht Teil des MVP-Board-Designs sind:

- separates ToDo-Board
- automatische Anhangssynchronisation in Dateispeicher
- farbcodierte Prioritaetslogik
- komplexe Unteraufgabenmodelle
- automatische Kalender- oder Sitzungseinladungslogik

## Konkrete Folge fuer P2-05

Das Mail->Deck-Mapping muss auf diesem Board-Design aufsetzen.

Insbesondere zu klaeren sind als Naechstes:

- wie der Standard-Beschreibungsblock technisch erzeugt wird
- wie Kategorien sicher auf Labels gemappt werden
- wie spaetere Updates in den Beschreibungstext geschrieben werden, ohne manuelle Inhalte zu zerstoeren
