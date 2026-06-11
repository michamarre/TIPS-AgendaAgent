# Testdrehbuch

## Ziel

Dieses Dokument fasst die wiederholbaren MVP-Tests fuer TIPS AgendaFlow zusammen.

## Kern-Tests

### T-01 Mailimport Outlook -> Deck

- Mail liegt in Outlook-Ordner `__Agenda`
- `workflow-mail-to-agenda` liest die Mail
- Deck-Karte entsteht im Stack `Eingang`
- Kategorie-Label und ggf. `Zu ueberpruefen` werden gesetzt

### T-02 Reminder fuer faellige Wiedervorlage

- Testkarte in `Vorbereitung` mit `Wiedervorlage/Frist <= heute`
- `workflow-erinnerungen-vorbereitung` erzeugt Reminder-Markdown
- Ausgabe enthaelt Titel, Stack, Frist und Card-ID

### T-03 Reminder fuer faelliges ToDo

- Testkarte in `ToDo laeuft`
- `ToDos`-Block enthaelt offenes ToDo mit `Frist <= heute`
- Reminder-Ausgabe enthaelt ToDo-Grund und Verantwortliche

### T-04 Re-Agenda nach `Freitagsagenda`

- Testkarte in `ToDo laeuft`
- `Naechster Zielstatus: Freitagsagenda`
- offenes ToDo oder `Wiedervorlage/Frist <= heute`
- Workflow erzeugt Zielkarte in `Freitagsagenda`
- Ursprungskarte wird geloescht
- Zielkarte enthaelt `Automation`-Block mit `reagenda_from_card_id`

## Negativtests

### N-01 Graph-Mail ohne Pflichtdaten

- fehlende `source_message_id` oder `receivedDateTime`
- erwartetes Ergebnis: Import wird nicht fortgesetzt

### N-02 Deck-Collection-GET

- `GET /boards/{boardId}/stacks/{stackId}/cards`
- erwartetes Ergebnis in dieser Sciebo-Instanz: `405`
- Folgerung: nur `GET /boards/{boardId}/stacks` als Lesepfad verwenden

### N-03 Deck-Reorder zwischen Stacks

- `PUT /boards/{boardId}/stacks/{stackId}/cards/{cardId}/reorder` mit anderem `stackId`
- erwartetes Ergebnis in dieser Sciebo-Instanz: Antwort `200`, Karte bleibt im Ursprungsstack
- Folgerung: fuer Re-Agenda `copy -> relabel -> delete`

### N-04 n8n-Code-Node fuer HTTP

- HTTP-Aufruf in Code-Node
- erwartetes Ergebnis: Fehler (`fetch is not defined` oder aehnlich)
- Folgerung: Netzwerkaction nur in `HTTP Request`-Nodes

## Nachweisstand vom 2026-06-10

- T-01: PASS
- T-02: PASS
- T-03: PASS
- T-04: PASS
- N-02: bestaetigt
- N-03: bestaetigt
- N-04: bestaetigt
