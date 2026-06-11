# Fehlerpfade Mailimport

## Ziel

Dieses Dokument definiert die MVP-Behandlung fuer unvollstaendige, problematische oder technisch fehlerhafte Mails im Workflow `mail-to-agenda`.

## Grundprinzip

Im MVP gilt:

- technische Fehler blockieren den Import
- fachlich unklare, aber lesbare Mails duerfen trotzdem importiert werden

Damit wird zwischen **nicht importierbar** und **importierbar, aber schwach strukturiert** unterschieden.

## Fehlerklassen

### 1. Technischer Quellfehler

Beispiele:

- Graph nicht erreichbar
- Authentifizierung fehlgeschlagen
- Ordner `__Agenda` nicht lesbar

Verhalten:

- Workflow-Lauf endet mit Fehlerstatus
- keine Deck-Karte wird erzeugt

### 2. Technischer Zielfehler

Beispiele:

- Deck nicht erreichbar
- Card-Create fehlgeschlagen
- Label-Assign fehlgeschlagen

Verhalten:

- bei fehlgeschlagenem Card-Create: kein Teilimport, nur Fehlerlog
- bei fehlgeschlagenem Label-Assign: Karte bleibt bestehen, Fehlerlog mit Card-ID

### 3. Unvollstaendige, aber lesbare Mail

Beispiele:

- leerer Betreff
- kein sichtbarer Anzeigename
- nur kurzer oder kryptischer Body
- kein `internetMessageId`

Verhalten:

- Import bleibt erlaubt
- definierte Fallbacks greifen

### 4. Unerwartete Inhaltsform

Beispiele:

- HTML-lastiger Body
- Signaturen dominieren den Preview-Text
- nur Weiterleitungsketten

Verhalten:

- Import bleibt erlaubt
- `bodyPreview` oder gekuerzter Body wird als Kurzkontext verwendet
- manuelle Nachpflege in Deck ist eingeplant

## Feld-Fallbacks

### Betreff fehlt

Regel:

- `title = Ohne Betreff`

### Anzeigename fehlt

Regel:

- `submitter_name = submitter_email`

### E-Mail-Adresse fehlt

Regel:

- wenn keine Absenderadresse lesbar ist, Import weiterhin moeglich
- `submitter_email = unbekannt`
- zusaetzlich Hinweis in der Beschreibung

### BodyPreview und Body fehlen

Regel:

- Import weiterhin moeglich
- Kurzkontext leer oder Platzhalter `Kein Textinhalt verfuegbar`

### `internetMessageId` fehlt

Regel:

- Import weiterhin moeglich
- Feld bleibt leer
- Dublettenanker bleibt `source_message_id`

## Eskalationsregel fuer problematische, aber importierte Mails

Wenn eine Mail lesbar ist, aber wesentliche Fachinformationen fehlen, soll der Workflow zusaetzlich das Hinweis-Label setzen:

- `Zu ueberpruefen` (`7898`)

Empfohlene MVP-Ausloeser:

- leerer Betreff
- fehlende Absenderadresse
- leerer Kurzkontext

## Harte Abbruchregeln

Der Workflow darf **keine** Karte erzeugen, wenn mindestens eine dieser Bedingungen gilt:

1. keine `source_message_id` vorhanden
2. kein `receivedDateTime` vorhanden
3. Graph-Objekt ist strukturell nicht lesbar
4. Dublettenpruefung liefert keinen verwertbaren Entscheid

## Ergebniscodes

Der Workflow soll fuer problematische Mails diese Resultate unterscheiden:

- `success_clean`
- `success_with_review_flag`
- `error_source_read`
- `error_target_write`
- `error_invalid_message`

## Konsequenz fuer den Workflow

Vor dem Card-Create braucht der Workflow daher zusaetzlich:

1. `Validate Required Source Fields`
2. `Apply Fallbacks`
3. optional `Mark Review Required`

Damit bleibt der MVP robust, ohne fachlich unklare Eingaben einfach zu verlieren.
