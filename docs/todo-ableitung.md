# ToDo-Ableitung

## Ziel

Dieses Dokument legt fest, wie aus einem besprochenen Agenda-Punkt operative Folgeaufgaben entstehen.

Es definiert:

1. wann ToDos ausgeloest werden
2. welche Mindestfelder ein ToDo braucht
3. wie ToDos im MVP an der Ursprungs-Karte sichtbar bleiben

## Grundsatz

Im MVP entstehen ToDos **nicht als eigenes Systemobjekt**, sondern als strukturierter Block an derselben Deck-Karte.

Das bedeutet:

- keine separate ToDo-App
- kein separates Board im ersten Schritt
- die Agenda-Karte bleibt der gemeinsame Ursprung fuer Thema, Entscheidung und Folgearbeit

## Ausloeser fuer ToDo-Ableitung

Ein ToDo entsteht, wenn in der Sitzungsnotiz gilt:

- `Folgeaufgaben entstanden: ja`

und typischerweise:

- `Naechster Zielstatus: ToDo laeuft`

## Mindestfelder pro ToDo

Jedes Folge-ToDo soll im MVP mindestens diese Informationen haben:

1. `todo_summary`
2. `todo_owner`
3. `todo_due_date`
4. `todo_status`

## MVP-Werte fuer `todo_status`

- `offen`
- `in_bearbeitung`
- `erledigt`

## Darstellungsform im Kartentext

Die Folgeaufgaben sollen als eigener Block in der Kartenbeschreibung stehen.

Empfohlenes Format:

```text
ToDos
1. Aufgabe: <Kurzbeschreibung>
   Verantwortlich: <Name>
   Frist: <YYYY-MM-DD oder leer>
   Status: <offen|in_bearbeitung|erledigt>

2. Aufgabe: <Kurzbeschreibung>
   Verantwortlich: <Name>
   Frist: <YYYY-MM-DD oder leer>
   Status: <offen|in_bearbeitung|erledigt>
```

## Mindestregel bei der Erfassung

Wenn `Folgeaufgaben entstanden: ja`, dann muss mindestens ein ToDo mit diesen Angaben existieren:

- Aufgabe
- Verantwortlich

`Frist` darf im MVP notfalls leer sein, ist aber fachlich unerwuenscht.

## Zielstatus nach ToDo-Ableitung

Sobald mindestens ein offenes Folge-ToDo existiert, soll die Karte in der Regel auf:

- `ToDo laeuft`

gesetzt werden.

## Wann bleibt ein Punkt trotzdem `Beschlossen`

Wenn zwar ein Beschluss dokumentiert wurde, aber keine operative Nachverfolgung im System erforderlich ist:

- kein ToDo-Block
- Status `Beschlossen`

## Sichtbarkeit im Board

Fuer Karten mit laufender Folgearbeit ist im MVP zusaetzlich das vorhandene Label sinnvoll:

- `Handlung erforderlich` (`7901`)

Empfehlung:

- setzen, wenn `Naechster Zielstatus = ToDo laeuft`

## Wiedervorlagebezug

Die ToDo-Ableitung muss einen Platz fuer spaetere Wiedervorlage offenhalten.

Mindestens relevant:

- Frist im ToDo
- optional zusaetzlich `Wiedervorlage/Frist` im Hauptblock der Karte

## Mehrere ToDos aus einem Punkt

Mehrere Folgeaufgaben sind im MVP ausdruecklich erlaubt.

Regel:

- jede Aufgabe als eigener nummerierter Eintrag
- gemeinsame Herkunft bleibt dieselbe Agenda-Karte

## Nicht im MVP

Noch nicht Teil der ToDo-Ableitung:

- automatische Unteraufgaben in Deck
- separates Nachverfolgungsboard
- automatische Personenzuweisung an Deck-Mitglieder
- automatische Eskalation

## Konsequenz fuer P4-04

Der spaetere Reminder-Workflow soll auf diesen Feldern aufbauen:

- `Status: ToDo laeuft`
- ToDo-Block mit `Frist`
- optional Label `Handlung erforderlich`

## Konsequenz fuer P4-05

Re-Agenda-Regeln sollen spaeter pruefen:

- gibt es offene ToDos
- ist die Frist erreicht oder ueberschritten
- soll die Karte wieder in `Freitagsagenda` oder zunaechst in `Vorbereitung`
