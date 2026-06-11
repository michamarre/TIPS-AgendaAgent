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

## Aktueller Betriebsstandard

- `workflow-mail-to-agenda` bleibt aktiv
- `workflow-erinnerungen-vorbereitung` und `workflow-reagenda-offene-punkte` bleiben vorerst deployed, aber nicht automatisch aktiviert
- offene Punkte werden im Standardfall fuer den naechsten Wochenlauf, also wieder eine Woche spaeter, eingeplant
- API-Key-Rotation fuer `agenda-n8n` ist fuer das aktuelle MVP-Testfenster bewusst vertagt

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

Fuer die Reproduktion und Selbstheilung des Proxy-Fix ist das versionierte Skript vorgesehen:

- `operations/runbooks/ensure-agenda-n8n-proxy.sh`

Serverseitiger Sollpfad:

- `/home/deploy/portfolio_V3/scripts/ensure-agenda-n8n-proxy.sh`

Es setzt den `agenda-n8n`-Block in `proxy_host/5.conf` idempotent neu, validiert `nginx -t` im Container `portfolio-proxy` und fuehrt danach ein Reload aus. Fuer den aktuellen Betrieb ist zusaetzlich ein Cron-Self-Heal vorgesehen, damit Proxy-Host-Regenerierungen den Subpath-Fix nicht dauerhaft verlieren.

Aktuell installiert:

- Server-Skript: `/home/deploy/portfolio_V3/scripts/ensure-agenda-n8n-proxy.sh`
- Cron: `*/5 * * * * QUIET=1 /home/deploy/portfolio_V3/scripts/ensure-agenda-n8n-proxy.sh >> /var/log/ensure-agenda-n8n-proxy.log 2>&1`

## Geheimnisse

- keine Secrets im Repo
- nur lokal ignorierte `config/placeholders.env`
- Serverwerte in `/home/deploy/n8n/.env`
