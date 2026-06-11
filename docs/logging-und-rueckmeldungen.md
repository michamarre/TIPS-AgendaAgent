# Logging und Rueckmeldungen

## Ziel

Dieses Dokument legt fest, wie der MVP-Workflow `mail-to-agenda` Ergebnisse protokolliert und welche Rueckmeldungen bewusst **noch nicht** versendet werden.

## Grundsatz

Im MVP wird zwischen:

- technischem Logging
- fachlicher Sichtbarkeit im Board
- externen Rueckmeldungen per Mail

klar getrennt.

## MVP-Logging

### Primäre Log-Quelle

Im MVP reicht zunaechst:

- das n8n Execution Log

Jeder Lauf soll pro verarbeiteter Mail ein klares Ergebnisobjekt erzeugen.

### Pflichtfelder im Erfolgslog

- `result`
- `graph_message_id`
- `internet_message_id`
- `deck_card_id`
- `deck_stack_id`
- `deck_label_id`
- `imported_at`

### Pflichtfelder im Fehlerlog

- `result`
- `step_name`
- `error_message`
- `graph_message_id`, falls bekannt
- `internet_message_id`, falls bekannt
- `imported_at`

## Ergebniswerte

Folgende Resultatwerte sollen im MVP verwendet werden:

- `success_clean`
- `success_with_review_flag`
- `duplicate_skip`
- `error_source_read`
- `error_duplicate_check`
- `error_target_write`
- `error_invalid_message`

## Sichtbarkeit im Board

Fachliche Rueckmeldung erfolgt im MVP primaer ueber die erzeugte Karte selbst:

- Karte vorhanden -> Import erfolgreich
- Karte mit `Zu ueberpruefen` -> Import erfolgreich, aber fachlich nachpruefen

Es gibt im MVP noch keine separate technische Uebersichtsoberflaeche.

## Keine automatische Eingangsbestaetigung im MVP

Bewusste Entscheidung:

- es werden im MVP **keine** automatischen Eingangsbestätigungen versendet

Begruendung:

- es gibt noch keinen stabilen institutionellen Absenderkanal
- der Eingangskanal ist aktuell personenbezogen
- der MVP soll erst den Kernimport absichern

## Keine automatische Fehlermail im MVP

Im MVP werden auch bei Fehlern noch keine automatischen Hinweis- oder Alarmmails versendet.

Begruendung:

- Alarmierungskette ist fachlich noch nicht abgestimmt
- vermeidet Spam in einer fruehen Phase

## Empfohlene spaetere Ausbaupfade

Nach erfolgreichem MVP sind diese Rueckmeldungen sinnvoll:

1. Eingangsbestätigung an Einreicher
2. technische Fehlerbenachrichtigung an `n8n Operator`
3. Wochenreport ueber importierte, uebersprungene und fehlerhafte Mails

## Konsequenz fuer den Workflow

Der Workflow braucht im MVP:

1. ein standardisiertes Erfolgsobjekt
2. ein standardisiertes Fehlerobjekt
3. keine Outbound-Mail-Nodes

## Minimaler Betriebsblick

Fuer den MVP reicht als Betriebsroutine:

1. n8n Executions bei Bedarf pruefen
2. Board `TIPS AgendaFlow` auf neue Karten im Stack `Eingang` pruefen
3. Karten mit `Zu ueberpruefen` gezielt nachbearbeiten
