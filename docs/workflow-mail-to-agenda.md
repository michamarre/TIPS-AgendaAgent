# Workflow `mail-to-agenda`

## Ziel

Dieser Workflow bildet den MVP-Kern von TIPS AgendaFlow ab.

Er soll:

1. neue oder relevante Mails aus Outlook `__Agenda` lesen
2. die benoetigten Felder extrahieren und transformieren
3. eine Karte im Deck-Board `1919` erzeugen
4. das Ergebnis nachvollziehbar protokollieren

## Nicht-Ziele des ersten Workflows

Der erste Workflow soll noch **nicht**:

- Mails verschieben oder markieren
- Eingangsbestätigungen versenden
- Anhänge nach Nextcloud hochladen
- ToDos oder Wiedervorlagen erzeugen
- komplexe Dublettenentscheidungen treffen

## Trigger-Modell

## Empfohlener MVP-Trigger

Der Workflow soll zunaechst **zeitgesteuert** laufen, nicht webhook- oder eventbasiert.

Empfehlung:

- Cron alle `5` Minuten

Begruendung:

- robust fuer den MVP
- kein zusaetzlicher Outlook-Push-Mechanismus noetig
- gut mit lesendem Graph-Zugriff vereinbar

## Arbeitsmodus

Pro Lauf:

1. die letzten Mails aus `__Agenda` lesen
2. Kandidaten filtern
3. pro Mail eine Importentscheidung treffen

## Benoetigte Credentials

Der Workflow braucht in n8n mindestens:

### 1. Microsoft Graph Credential

Verwendung:

- Zugriff auf das Postfach `marre.michael@lfm-fh-swf.de`
- Lesen aus dem Ordner `__Agenda`

### 2. Nextcloud / Deck Credential

Verwendung:

- Karte im Board `1919` anlegen
- Kategorien-Label zuweisen

## Workflow-Uebersicht

## Eingaben

- Graph-Postfach `marre.michael@lfm-fh-swf.de`
- Folder-ID `__Agenda`
- Mapping-Regeln aus `mail-to-deck-mapping.md`

## Ausgaben

Pro erfolgreich importierter Mail mindestens:

- Deck-Card-ID
- verwendete Stack-ID
- verwendete Label-ID
- referenzierte Graph-Message-ID

## Node-Folge

### 1. `Cron`

**Zweck:**
Startet den Workflow regelmaessig.

**Output:**
ein Trigger-Item

### 2. `Set Config`

**Zweck:**
Stellt feste MVP-Konstanten bereit.

**Mindestwerte:**

- `mailbox_user`
- `agenda_folder_id`
- `board_id = 1919`
- `stack_id_eingang = 5678`
- `label_information = 7907`
- `label_diskussion = 7910`
- `label_beschluss = 7913`
- `label_sonstiges = 7916`

### 3. `Microsoft Graph - List Messages`

**Zweck:**
Liest Mails aus `__Agenda`.

**Empfohlene Query:**

- Ordner: `__Agenda`
- Sortierung: `receivedDateTime desc`
- Limit im MVP z. B. `10` oder `20`
- Felder:
  - `id`
  - `internetMessageId`
  - `subject`
  - `from`
  - `receivedDateTime`
  - `bodyPreview`
  - `body`
  - `hasAttachments`
  - `isRead`

### 4. `Filter Candidate Messages`

**Zweck:**
Entfernt technisch unbrauchbare oder offensichtliche Leerfaelle.

**MVP-Regeln:**

- Mail braucht eine Graph-`id`
- Mail braucht `receivedDateTime`
- Mail darf nicht leer sein in `subject` **und** `bodyPreview`, sonst Fallback `Ohne Betreff` plus leerer Kontext ist noch erlaubt

### 5. `Normalize Fields`

**Zweck:**
Bereitet alle Zielwerte fuer Deck vor.

**Logik:**

- `title` aus `subject`, sonst `Ohne Betreff`
- `category` per Betreffregel
- `label_id` per Kategorie
- `submitter_name` aus `from.emailAddress.name`, sonst E-Mail
- `submitter_email` aus `from.emailAddress.address`
- `received_date` aus `receivedDateTime`
- `attachments_flag` = `ja` oder `nein`
- `imported_at` = aktueller Zeitstempel

### 6. `Build Description`

**Zweck:**
Erzeugt den standardisierten Beschreibungstext fuer die Karte.

**Input:**
- normalisierte Felder
- `bodyPreview`
- optional spaeter bereinigter Body

**Output:**
- `card_description`

### 7. `Create Deck Card`

**Zweck:**
Legt die Karte im Stack `Eingang` an.

**API-Ziel:**

- `POST /boards/1919/stacks/5678/cards`

**Pflichtdaten:**

- `title`
- `description`

### 8. `Assign Category Label`

**Zweck:**
Weist der neu erzeugten Karte genau ein Kategorien-Label zu.

**API-Ziel:**

- `PUT /boards/{boardId}/stacks/{stackId}/cards/{cardId}/assignLabel`

**Pflichtdaten:**

- `labelId`

### 9. `Write Success Log`

**Zweck:**
Erzeugt ein standardisiertes Erfolgsobjekt fuer Execution-Logs oder spaetere Persistenz.

**Mindestausgabe:**

- `graph_message_id`
- `internet_message_id`
- `deck_card_id`
- `deck_stack_id`
- `deck_label_id`
- `imported_at`
- `result = success`

### 10. `Write Error Log`

**Zweck:**
Faengt API- oder Mappingfehler ab.

**Mindestausgabe:**

- `graph_message_id`, falls bekannt
- `step_name`
- `error_message`
- `imported_at`
- `result = error`

## Datenvertrag pro Mail

Der Workflow soll spaetestens vor `Create Deck Card` dieses Objekt erzeugen:

```json
{
  "source_system": "outlook_agenda_folder",
  "source_message_id": "<graph message id>",
  "source_folder_id": "<agenda folder id>",
  "internet_message_id": "<internetMessageId>",
  "title": "<card title>",
  "description": "<rendered description>",
  "submitter_name": "<name>",
  "submitter_email": "<email>",
  "received_date": "<iso datetime>",
  "category": "<Information|Diskussion|Beschluss|Sonstiges>",
  "label_id": 7916,
  "stack_id": 5678,
  "imported_at": "<iso datetime>",
  "has_attachments": true
}
```

## Fehlerpfade im MVP

### Graph nicht erreichbar

Verhalten:

- Workflow beendet mit Fehlerlog
- keine teilweise Deck-Erzeugung

### Deck-Create fehlschlaegt

Verhalten:

- Fehlerlog mit Message-ID
- kein Label-Assign-Versuch

### Label-Assign fehlschlaegt

Verhalten:

- Karte existiert bereits
- Fehlerlog soll Card-ID enthalten
- manuelle Nacharbeit ist moeglich

### Leere oder unklare Mail

Verhalten:

- Import weiterhin erlaubt
- Titel-Fallback `Ohne Betreff`
- Kategorie-Fallback `Sonstiges`

## MVP-Protokollierung

Im ersten Schritt reicht die Protokollierung in:

- n8n Execution Log
- optional spaeter zusaetzliche technische Log-Tabelle oder Datei

Noch nicht erforderlich:

- dedizierte Persistenzschicht nur fuer Importlogs

## Erfolgsdefinition fuer P3-01

Die Workflow-Spezifikation ist ausreichend, wenn sie den spaeteren Bau erlaubt ohne weitere Grundsatzentscheidungen zu brauchen.

Dazu muessen klar sein:

- Trigger
- gelesene Graph-Felder
- Zielstack und Label-IDs
- Kartenbeschreibung
- API-Reihenfolge
- Fehlerverhalten

## Folge fuer P3-02 bis P3-04

Die naechsten Tasks bauen direkt darauf auf:

- P3-02 verfeinert die Dublettenregel
- P3-03 haertet unvollstaendige oder problematische Mails
- P3-04 legt Logging und optionale Rueckmeldungen fest

Siehe dazu:

- [dublettenregel.md](dublettenregel.md)
- [fehlerpfade-mailimport.md](fehlerpfade-mailimport.md)
- [logging-und-rueckmeldungen.md](logging-und-rueckmeldungen.md)
