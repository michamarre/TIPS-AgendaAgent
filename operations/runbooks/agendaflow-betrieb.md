# AgendaFlow Betrieb

## Zweck

Dieses Runbook beschreibt den operativen Einstieg fuer TIPS AgendaFlow.

## Systeme

- Outlook `__Agenda`
- Microsoft Graph
- Nextcloud Deck Board `1919`
- `agenda-n8n`

## Kern-Workflows

- `workflow-mail-to-agenda`
- `workflow-erinnerungen-vorbereitung`
- `workflow-reagenda-offene-punkte`

## Regelmaessige Kontrollen

### 1. n8n-Instanz

- `GET /rest/settings` bzw. `GET /api/v1/workflows`
- letzte Executions auf Fehler pruefen

### 2. Outlook-Eingang

- liegen neue Mails in `__Agenda`
- wurden sie in Deck zu `Eingang`-Karten

### 3. Deck-Board

- Karten liegen in den erwarteten Stacks
- Reminder- und Re-Agenda-Workflows erzeugen keine unerwarteten Duplikate

## Stoerungsbilder

### Mail kommt nicht in Deck an

- `workflow-mail-to-agenda` Execution pruefen
- Graph-Zugriff und Folder-ID pruefen
- Deck-Auth pruefen

### Reminder bleibt leer

- pruefen, ob `Wiedervorlage/Frist` oder ToDo-`Frist` wirklich gesetzt und faellig ist
- beachten, dass der Workflow ueber `GET /boards/1919/stacks` liest

### Re-Agenda verschiebt nicht

- Deck-Reorder zwischen Stacks funktioniert in dieser Instanz nicht
- nur der Copy-Delete-Workflow ist belastbar

## Aenderungen am Proxy

`agenda-n8n` haengt an einer manuell ergaenzten Proxy-Route. Nach Proxy-Neugenerierung oder manuellen Aenderungen die REST-Pfade erneut pruefen:

- `/agenda-n8n/rest/settings`
- `/agenda-n8n/rest/login`
- `/agenda-n8n/webhook-test/...`

## Geheimnisse

- keine Secrets im Repo
- nur lokal ignorierte `config/placeholders.env`
- Serverwerte in `/home/deploy/n8n/.env`
