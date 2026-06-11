# Workflow `wochenagenda`

## Ziel

Dieser Workflow beschreibt die MVP-Logik fuer die Vorbereitung der Freitagssitzung.

Er soll:

1. alle relevanten Karten fuer die naechste Sitzung sammeln
2. daraus eine klare Wochenagenda erzeugen
3. die Sitzungskoordination bei der Vorbereitung unterstuetzen

## Grundsatz

Im ersten Ausbauschritt ist `wochenagenda` noch **ein Lese- und Zusammenstellungsworkflow**, kein vollautomatischer Versandworkflow.

Das bedeutet:

- Karten werden gelesen
- eine strukturierte Agenda-Zusammenstellung wird erzeugt
- automatische Mailzustellung ist noch optional und nicht zwingender MVP-Bestandteil

## Fachlicher Ausloeser

Die Wochenagenda basiert auf dem Status `Freitagsagenda`.

Relevanter Zielstack:

- `Freitagsagenda`
- Stack-ID `5687`

## Zweck fuer die Praxis

Der Workflow soll der `Agenda Koordination` und `Sitzungsleitung` kurz vor der Freitagssitzung einen sauberen Arbeitsstand liefern:

- welche Punkte sind wirklich fuer die Sitzung vorgesehen
- in welcher Reihenfolge oder Gruppierung koennen sie gelesen werden
- wo fehlen noch Informationen

## Trigger-Modell

## MVP-Empfehlung

Zeitgesteuerter Lauf einmal pro Woche.

Empfohlener Zeitpunkt:

- Donnerstagmorgen
- Standard-Cron aus lokaler Konfiguration:
  - `WEEKLY_DIGEST_CRON`

## Optionaler Zusatztrigger

Spaeter moeglich:

- manueller Lauf vor der Sitzung

Das ist sinnvoll, falls sich am Donnerstag oder Freitag noch Karten aendern.

## Eingangsmenge

Der Workflow liest Karten aus Board `1919`.

Relevante Quelle:

- Board `1919`
- Stack `Freitagsagenda` (`5687`)

## Fachliche Auswahlregel

Im MVP gehoeren in die Wochenagenda:

1. alle Karten im Stack `Freitagsagenda`

Nicht automatisch enthalten:

- Karten aus `Vorbereitung`
- Karten aus `Rueckfrage`
- Karten aus `ToDo laeuft`

Begruendung:

- die Wochenagenda soll nur den bereits bewusst freigegebenen Sitzungsbestand abbilden

## Ausgabeform

## MVP-Hauptausgabe

Eine strukturierte Markdown-Agenda.

Diese soll mindestens enthalten:

1. Erzeugungszeitpunkt
2. Anzahl der Punkte
3. Liste aller Karten im Stack `Freitagsagenda`
4. pro Punkt die wichtigsten Sichtfelder

## Empfohlenes Format pro Punkt

```text
1. <Kartentitel>
   Kategorie: <Label>
   Einreicher: <Name>
   Eingang: <Datum>
   Kurzkontext: <kurzer Beschreibungsauszug>
   Vorbereitung: <falls gepflegt>
   Wiedervorlage/Frist: <falls gepflegt>
   Deck-Karte: <Card-ID oder Link, falls spaeter verfuegbar>
```

## Datenquelle pro Punkt

Die Wochenagenda soll aus der Deck-Karte selbst lesen:

- Titel
- Beschreibung
- Labels
- Card-ID

## Sortierung

Im MVP gilt eine einfache, nachvollziehbare Sortierung:

1. Reihenfolge im Stack `Freitagsagenda`
2. falls die API diese Reihenfolge nicht stabil liefert: nach `lastModified` oder `createdAt`

Die wichtigste Regel ist nicht Perfektion, sondern Wiederholbarkeit.

## Inhaltliche Verdichtung

Im MVP wird kein KI-Summary erzeugt.

Stattdessen:

- Kurzkontext aus dem vorhandenen Beschreibungsblock
- wenn noetig gekuerzt auf wenige Zeilen

## Warnregeln

Der Workflow soll fachliche Luecken sichtbar machen.

Empfohlene Warnfaelle:

- Karte traegt Label `Zu ueberpruefen`
- Feld `Vorbereitung` leer
- Kurzkontext faktisch leer oder sehr schwach

## MVP-Verhalten bei Warnfaellen

Warnfaelle bleiben in der Wochenagenda enthalten, werden aber markiert.

Empfohlene Kennzeichnung:

- `WARNUNG: Nachpruefen`

Begruendung:

- ein Punkt kann fuer die Sitzung relevant sein, auch wenn er noch unvollstaendig ist
- die Koordination soll vor dem Termin entscheiden koennen, ob er bleibt oder wieder herausgenommen wird

## Nicht-Ziele des ersten Wochenagenda-Workflows

Noch nicht Teil von `wochenagenda`:

- automatischer Mailversand an einen Verteiler
- automatische PDF-Erzeugung
- Kalenderintegration
- automatische Priorisierung
- automatische Umhaengung von Karten zwischen `Vorbereitung` und `Freitagsagenda`

## Node-Folge fuer spaetere Umsetzung

### 1. `Schedule Trigger`

Startet den Workflow nach `WEEKLY_DIGEST_CRON`.

### 2. `Set Config`

Stellt mindestens bereit:

- `board_id = 1919`
- `stack_id_freitagsagenda = 5687`

### 3. `Read Friday Agenda Cards`

Liest die Karten aus `Freitagsagenda`.

### 4. `Normalize Agenda Items`

Extrahiert aus Titel, Beschreibung und Labels die sichtbaren Sitzungsfelder.

### 5. `Build Agenda Markdown`

Erzeugt die strukturierte Wochenagenda als Markdown-Dokument.

### 6. `Store or Return Agenda`

Gibt die Agenda fuer manuelle Nutzung, spaetere Ablage oder spaeteren Mailversand aus.

## Erfolgsdefinition fuer P4-01

Die Spezifikation ist ausreichend, wenn klar definiert ist:

- welche Karten einbezogen werden
- welcher Trigger laeuft
- welche Ausgabe entsteht
- wie Warnfaelle behandelt werden
- was bewusst noch nicht automatisiert wird

## Folge fuer P4-02 bis P4-04

Die naechsten Tasks bauen direkt darauf auf:

- P4-02 legt das Sitzungsnotiz-Schema fest
- P4-03 beschreibt die Ableitung von ToDos aus Sitzungsentscheidungen
- P4-04 baut spaetere Reminder- und Wiedervorlage-Logik auf diesen Sitzungsdaten auf
