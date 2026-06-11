# Mail-to-Deck-Mapping

## Ziel

Dieses Dokument definiert das konkrete MVP-Mapping von Outlook-Mails aus `__Agenda` auf Karten im Deck-Board `1919`.

Es ist die direkte Grundlage fuer den spaeteren n8n-Workflow `mail-to-agenda`.

## Quelle

## Eingangskanal

- Microsoft Graph
- Postfach: `marre.michael@lfm-fh-swf.de`
- Ordner: `__Agenda`
- Folder-ID:
  `AAMkADM3ZDhmZDc1LTIwYmQtNDlmZS1hMWE2LWI5OTAxYTlkZWIxMAAuAAAAAAAkH0jcZmphQ4D6jBE3b4iQAQA4d7TUfWQcRJjaCy_7yagjAAX0HNZOAAA=`

## Primär gelesene Mailfelder

Das MVP soll mindestens diese Graph-Felder lesen:

- `id`
- `internetMessageId`
- `subject`
- `from`
- `receivedDateTime`
- `bodyPreview`
- `body`
- `hasAttachments`
- `isRead`

## Ziel in Deck

## Board und Startstatus

- Board-ID: `1919`
- Zielstack fuer neue Karten: `Eingang`
- Zielstack-ID: `5678`

## Kategorien-Labels

Das Mapping nutzt genau ein Kategorien-Label pro Karte:

- `Information` -> Label `7907`
- `Diskussion` -> Label `7910`
- `Beschluss` -> Label `7913`
- `Sonstiges` -> Label `7916`

## Hinweis-Labels

Diese Labels werden im MVP nicht pauschal gesetzt, sondern nur regelbasiert oder manuell:

- `Zu ueberpruefen` -> `7898`
- `Handlung erforderlich` -> `7901`
- `Spaeter` -> `7904`
- `Abgeschlossen` -> `7895`

## Feldmapping

### Kartentitel

`Deck.title` wird wie folgt gesetzt:

1. `subject`, wenn vorhanden
2. sonst `Ohne Betreff`

Zusatzregel:

- Fuehrende Prefixe wie `RE:` oder `FW:` werden im MVP **nicht automatisch entfernt**
- eine spaetere Bereinigung kann manuell erfolgen

### Kategorie

`Deck.category label` wird wie folgt bestimmt:

1. wenn `subject` das Wort `Beschluss` enthaelt -> `Beschluss`
2. wenn `subject` das Wort `Diskussion` enthaelt -> `Diskussion`
3. wenn `subject` `Info` oder `Information` enthaelt -> `Information`
4. sonst -> `Sonstiges`

Wichtig:

- im MVP wird immer genau ein Kategorien-Label gesetzt

### Status

Neue Karten starten immer mit:

- fachlicher Status `Eingang`
- technischer Zielstack `5678`

### Einreicher

Die Felder werden aus `from` befuellt:

- `submitter_name` -> `from.emailAddress.name`
- `submitter_email` -> `from.emailAddress.address`

Falls kein Anzeigename vorliegt:

- `submitter_name = submitter_email`

### Eingangsdatum

- `received_date` -> `receivedDateTime`

### Beschreibung

Die Kartenbeschreibung wird aus einem festen Template aufgebaut.

## Beschreibungsformat

```text
Kurzkontext
<bodyPreview oder gekuerzter Body-Text>

Kategorie: <ermittelter Kategorienwert>
Status: Eingang
Einreicher: <Name>
E-Mail: <Adresse>
Eingang: <receivedDateTime>
Gewuenschter Termin:
Vorbereitung:
Wiedervorlage/Frist:
Anhaenge vorhanden: <ja|nein>
Internet-Message-ID: <internetMessageId oder leer>

Technik
source_system: outlook_agenda_folder
source_message_id: <Graph message id>
source_folder_id: <Graph folder id>
imported_at: <aktueller Importzeitpunkt>
```

## Regel fuer Kurzkontext

Fuer den MVP gilt:

1. wenn `bodyPreview` vorhanden ist, wird `bodyPreview` verwendet
2. falls spaeter im Workflow ein bereinigter Plain-Text-Body vorliegt, kann dieser den Preview-Text ersetzen
3. sehr lange Inhalte werden zunaechst nicht vollstaendig in Deck gespiegelt

## Anhänge

Im MVP gilt fuer Anhänge zunaechst nur:

- `hasAttachments=true` wird sichtbar in die Beschreibung geschrieben
- Dateien werden noch **nicht** automatisch nach Nextcloud uebertragen
- kein automatischer Upload als Deck-Attachment in Phase 2

## Dublettenanker

Damit spaetere Dublettenerkennung moeglich ist, schreibt der Import in jedem Fall:

- `source_message_id`
- `internetMessageId`

Pragmatische MVP-Regel:

- `source_message_id` aus Graph ist der primaere technische Schluessel

## Nicht automatisch gepflegte Felder beim Erstimport

Diese Felder bleiben beim ersten Import leer und werden spaeter manuell oder halbautomatisch gepflegt:

- `desired_meeting_date`
- `preparation_owner`
- `due_or_followup_date`
- `decision_note`
- `todo_summary`

## Mapping-Tabelle

| Quelle Outlook/Graph | Ziel Deck | Regel |
|---|---|---|
| `subject` | `card.title` | Betreff oder `Ohne Betreff` |
| `bodyPreview` / `body` | Beschreibung `Kurzkontext` | Preview bevorzugt |
| `from.emailAddress.name` | `submitter_name` | Fallback auf E-Mail |
| `from.emailAddress.address` | `submitter_email` | direkt |
| `receivedDateTime` | `received_date` | direkt |
| `id` | `source_message_id` | direkt |
| `internetMessageId` | Beschreibung | direkt |
| `hasAttachments` | Beschreibung | `ja` oder `nein` |
| feste Regel | `stackId` | immer `5678` |
| Betreffregel | Kategorien-Label | `7907` / `7910` / `7913` / `7916` |

## Verhalten nach erfolgreichem Import

Im MVP wird nach erfolgreichem Import noch **keine** automatische Rueckverschiebung, Loeschung oder Markierung der Outlook-Mail ausgefuehrt.

Begruendung:

- minimiert das Risiko im personenabhaengigen Postfach
- trennt technischen Import von spaeterer Mailhygiene

## Offene Punkte fuer Phase 3

Dieses Mapping setzt fuer die Umsetzung in Workflows noch folgende Detailentscheidungen voraus:

- wie der Plain-Text-Body aus HTML bereinigt wird
- wie Dubletten technisch geprueft werden
- ob verarbeitete Mails spaeter markiert oder verschoben werden
- ob `RE:` / `FW:`-Praefixe spaeter normalisiert werden sollen
