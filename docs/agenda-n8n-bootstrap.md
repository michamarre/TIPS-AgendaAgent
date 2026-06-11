# Agenda n8n Bootstrap

## Erreichbare Zielpfade

- Editor/UI: `https://paperclip.178.104.156.69.sslip.io/agenda-n8n/`
- REST-Settings: `https://paperclip.178.104.156.69.sslip.io/agenda-n8n/rest/settings`
- Public API Base: `https://paperclip.178.104.156.69.sslip.io/agenda-n8n/api/v1`
- Webhook Base: `https://paperclip.178.104.156.69.sslip.io/agenda-n8n`

## Verifizierter Status

- Owner-Setup abgeschlossen
- Login-Route funktioniert
- Public API funktioniert
- Webhook-Testpfad funktioniert
- `showSetupOnFirstLoad` steht auf `false`

## API-Key

Es wurde ein erster API-Key fuer den technischen Bootstrap erzeugt:

- Label: `AgendaAgent CLI`
- Audience: `public-api`

Die geheimen Werte liegen ausschliesslich lokal in:

- `config/placeholders.env`

Sie sind nicht fuer die versionierte Dokumentation bestimmt.

## Erlaubte Scope-Quelle

Die Instanz liefert die erlaubten API-Key-Scopes ueber:

- `GET /agenda-n8n/rest/api-keys/scopes`

## Aktuell verwendete Scope-Gruppe

Der Bootstrap-Key deckt aktuell diese technischen Aufgaben ab:

- Workflow anlegen, lesen, aendern, loeschen, listen, aktivieren, deaktivieren
- Credentials anlegen, aendern, loeschen, listen
- Projekte anlegen, aendern, listen
- Executions lesen und listen

## Wichtiger Betriebs-Hinweis

Die `agenda-n8n`-Route im Proxy war urspruenglich ein manueller Eingriff in `proxy_host/5.conf`. Seit `2026-06-11` gibt es dafuer einen reproduzierbaren Self-Heal-Pfad:

- Repo-Skript: `operations/runbooks/ensure-agenda-n8n-proxy.sh`
- Server-Skript: `/home/deploy/portfolio_V3/scripts/ensure-agenda-n8n-proxy.sh`
- Cron: `*/5 * * * * QUIET=1 /home/deploy/portfolio_V3/scripts/ensure-agenda-n8n-proxy.sh >> /var/log/ensure-agenda-n8n-proxy.log 2>&1`

Damit wird der funktionierende `agenda-n8n`-Block nach Proxy-Neugenerierungen automatisch wiederhergestellt. Unabhaengig davon muessen diese Pfade bei Aenderungen weiterhin geprueft werden:

- `/agenda-n8n/rest/settings`
- `/agenda-n8n/rest/login`
- `/agenda-n8n/webhook-test/<pfad>`
- `/agenda-n8n/api/v1/workflows`

## Offene Haertung

Vor produktivem Einsatz sollten bewusst geprueft oder geaendert werden:

- finaler Owner-Account statt rein technischem Bootstrap-Owner
- Passwort-Rotation
- API-Key-Rotation
- produktive Credentials fuer Nextcloud und den spaeteren Outlook-/Mailbox-Zugriff
