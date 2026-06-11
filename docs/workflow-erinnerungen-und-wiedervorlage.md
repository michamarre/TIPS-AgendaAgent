# Workflow `erinnerungen-und-wiedervorlage`

## Ziel

Dieser Workflow deckt den operativen Nacht- und Tagesbedarf fuer faellige Nachverfolgung ab.

Er soll:

1. faellige Wiedervorlagen erkennen
2. offene ToDos mit faelliger Frist sichtbar machen
3. einen kompakten Reminder-Output fuer die manuelle Nacharbeit erzeugen

## Reale API-Grundlage

In der produktiven Sciebo-/Deck-Instanz ist der lesende Collection-Endpunkt fuer Karten nicht nutzbar:

- `GET /boards/{boardId}/stacks/{stackId}/cards` -> `405`

Der stabile Lesepfad fuer Reminder ist deshalb:

- `GET /boards/1919/stacks`

Diese Antwort liefert die Karten bereits eingebettet pro Stack.

## Quelle

Der Workflow liest Board `1919` und bewertet Karten aus:

- `Rueckfrage` (`5681`)
- `Vorbereitung` (`5684`)
- `Freitagsagenda` (`5687`)
- `ToDo laeuft` (`5693`)

## Faelligkeitsregeln

Eine Karte wird in den Reminder aufgenommen, wenn mindestens eine der folgenden Bedingungen gilt:

1. `Wiedervorlage/Frist` ist gesetzt und `<= heute`
2. im `ToDos`-Block existiert mindestens ein Eintrag mit
   - `Status != erledigt`
   - `Frist <= heute`

## Ausgabe

Der Workflow erzeugt Markdown in der Execution-Ausgabe.

Pro Karte werden mindestens ausgegeben:

- Titel
- Stack
- Kategorie
- Einreicher
- Wiedervorlage/Frist
- ToDo-Remindergrund
- Deck-Card-ID

## MVP-Grenze

Im aktuellen Ausbauschritt erfolgt noch kein automatischer Mailversand.

Der Workflow ist bewusst:

- lesend
- nachvollziehbar
- fuer manuelle Nacharbeit geeignet

## Trigger

- manuell
- sowie werktags `08:00` per Cron

## Folge

Der Reminder-Workflow erzeugt noch keine Statusaenderung.

Die eigentliche Re-Agenda-Entscheidung wird im separaten Workflow

- [workflow-reagenda-regeln.md](workflow-reagenda-regeln.md)

umgesetzt.
