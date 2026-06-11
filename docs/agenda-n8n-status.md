# Agenda n8n Status

## Bekannter Ist-Stand

Eine separate n8n-Instanz fuer TIPS AgendaFlow wurde auf dem Hetzner-Server innerhalb des bestehenden n8n-/Proxy-Setups angelegt.

Bekannte Zielpfade:

- Oeffentlich: `https://paperclip.178.104.156.69.sslip.io/agenda-n8n/`
- Lokal auf dem Server: `http://127.0.0.1:5680/agenda-n8n/`

Bekannte Host-Struktur:

- Compose-Basis: `/home/deploy/n8n`
- Eigene n8n-App: `agenda-n8n`
- Eigene Datenbank: `agenda-n8n-postgres`
- Eigener Home-/Datei-Storage fuer diese Instanz
- Geteilt mit bestehendem Setup:
  - Docker-/Proxy-Netz
  - Mailpit

## Was daran fachlich bedeutet

- TIPS AgendaFlow bekommt eine eigene n8n-Runtime und eine eigene Datenbank.
- Das ist gut, weil Workflows, Credentials und Ausfuehrungen von anderen Projekten getrennt bleiben.
- Gleichzeitig ist die Instanz nicht komplett isoliert, weil Proxy und Mailpit weiterhin gemeinsam genutzt werden.

## Was nach Aussage bereits verifiziert wurde

- Container `agenda-n8n` und `agenda-n8n-postgres` laufen
- Oeffentlicher GET liefert HTTP `200`
- Lokaler GET auf Port `5680` liefert HTTP `200`

## Konkrete Validierung vom 2026-06-10

Tatsaechlich nachgeprueft wurde:

- `docker ps` auf dem VPS zeigt `agenda-n8n` und `agenda-n8n-postgres` als laufend
- `curl http://127.0.0.1:5680/agenda-n8n/` auf dem VPS liefert `200` und die n8n-HTML-App
- `curl http://127.0.0.1:5680/rest/settings` auf dem VPS liefert gueltiges JSON
- diese JSON-Antwort enthaelt:
  - `authenticationMethod: "email"`
  - `showSetupOnFirstLoad: true`
  - `smtpSetup: true`

Das bedeutet:

- die Instanz ist noch im Erstsetup-Modus
- es gibt aus Projektsicht noch keinen abgeschlossenen Owner-/Login-Bootstrap
- API-Key, produktive Credentials und Workflow-Deployments sind noch nicht einsatzbereit

## Kritischer Befund: Subpath-API war fehlerhaft verdrahtet

Urspruenglich nachgewiesenes Verhalten:

- `http://127.0.0.1:5680/rest/settings` -> JSON, korrekt
- `http://127.0.0.1:5680/agenda-n8n/rest/settings` -> HTML statt JSON, falsch
- `https://paperclip.178.104.156.69.sslip.io/agenda-n8n/rest/settings` -> HTML statt JSON, falsch

Zusammen mit den Container-Umgebungswerten:

- `N8N_PATH=/agenda-n8n/`
- `N8N_EDITOR_BASE_URL=https://paperclip.178.104.156.69.sslip.io/agenda-n8n/`
- `WEBHOOK_URL=https://paperclip.178.104.156.69.sslip.io/agenda-n8n/`

war damit klar, dass die Proxy-/Pfadkonfiguration fuer REST- und Webhook-Routen noch nicht korrekt funktioniert.

## Durchgefuehrter Fix am 2026-06-10

Die manuell ergaenzten Proxy-Regeln in

- `/home/deploy/portfolio_V3/nginx-proxy/data/nginx/proxy_host/5.conf`

wurden so angepasst, dass der Prefix `/agenda-n8n/` vor dem Upstream-Request sauber entfernt wird:

- allgemeine App-Route: `proxy_pass http://agenda-n8n:5678/;`
- Webhook-Route: `proxy_pass http://agenda-n8n:5678/webhook/;`
- Webhook-Test-Route: `proxy_pass http://agenda-n8n:5678/webhook-test/;`

Danach wurde die Nginx-Konfiguration im Container `portfolio-proxy` erfolgreich mit `nginx -t` validiert und neu geladen.

## Validierung nach dem Fix

Oeffentliche Zielroute:

- `GET /agenda-n8n/rest/settings` -> `200` JSON
- `GET /agenda-n8n/rest/login` -> `401` JSON `Unauthorized`
- `POST /agenda-n8n/webhook-test/codex-probe` -> `404` JSON `webhook not registered`

Bewertung:

- REST-Routen laufen jetzt korrekt durch den Proxy
- Login-API wird korrekt erreicht
- Webhook-Test-Route wird korrekt an n8n durchgereicht
- der Proxy-/Pfadfehler fuer `/agenda-n8n/rest/*` ist damit behoben

Wichtig:

- Die Instanz bleibt trotzdem im Erstsetup-Modus (`showSetupOnFirstLoad: true`)
- API-Key, Owner-Setup und produktive Credentials fehlen weiterhin

## Was damit noch nicht bewiesen ist

Ein HTTP-`200` auf die Basis-URL beweist nur, dass die Instanz grundsaetzlich antwortet. Noch nicht nachgewiesen sind:

1. Login in die Editor-Oberflaeche funktioniert wirklich
2. `N8N_EDITOR_BASE_URL`, `WEBHOOK_URL` und eventuelle Pfadpraefixe passen zur Subpath-Route `/agenda-n8n/`
3. POST-Requests auf Webhooks funktionieren ueber den Proxy wirklich
4. Static Assets, Redirects und API-Pfade funktionieren sauber hinter dem Subpath
5. API-Key-Zugriff fuer spaeteres Deployment funktioniert
6. Credentials koennen gespeichert und wiederverwendet werden

## Wichtiger Betriebs-Risiko-Hinweis

Die Proxy-Route fuer `/agenda-n8n` wurde laut Vorabinformation direkt in die generierte Nginx-Proxy-Konfiguration eingetragen.

Das ist funktional, aber fragil:

- Sobald der betreffende Proxy-Host im Nginx Proxy Manager neu gespeichert oder neu generiert wird, kann die manuelle Aenderung verloren gehen.
- Dann kann die Instanz ploetzlich wieder unerreichbar sein, obwohl die Container weiterlaufen.

## Bewertung

Die technische Richtung ist sinnvoll:

- eigene n8n-Instanz
- eigene Datenbank
- gemeinsame Proxy-Infrastruktur

Der kritischste Punkt ist nicht die Containerisierung, sondern die **Subpath-Proxy-Loesung** mit manueller Nginx-Ergaenzung. n8n ist hinter Pfadpraefixen deutlich fehleranfaelliger als auf einer eigenen Subdomain.

## Empfohlene Naechste Pruefungen

Vor dem ersten Workflow-Deploy sollten wir diese Reihenfolge einhalten:

1. Editor-Login gegen `https://paperclip.178.104.156.69.sslip.io/agenda-n8n/` pruefen
2. API-Zugriff pruefen
3. Einen Minimal-Webhook anlegen und per POST gegen die oeffentliche URL testen
4. Erst danach produktive Credentials anlegen
5. Erst danach erste AgendaFlow-Workflows deployen

## Ziel fuer den Bootstrap

Ein belastbarer Bootstrap ist erst erreicht, wenn folgende Punkte gruen sind:

- Login erfolgreich
- API-Key erfolgreich erzeugt und verwendbar
- Minimal-Webhook ueber die oeffentliche URL erfolgreich
- Outlook-/Mailbox-/Nextcloud-Credentials angelegt
- mindestens ein einfacher Test-Workflow erfolgreich deployed

## Neuer Ist-Stand vom 2026-06-10 spaetabends

Der erste produktive MVP-Workflow fuer AgendaFlow wurde inzwischen wirklich gebaut, in `agenda-n8n` importiert, aktiviert und gegen die reale Zielumgebung ausgefuehrt.

Bekannter Workflow:

- Name: `workflow-mail-to-agenda`
- n8n-Workflow-ID: `fztRuTcSTAwP2BmA`
- Repo-Artefakt: `workflows/01_maileingang/workflow-mail-to-agenda.json`

Ergaenzte Runtime-Variablen auf dem Server:

- `AGENDA_OUTLOOK_USER`
- `AGENDA_OUTLOOK_FOLDER_ID`
- `AGENDA_POLL_TOP`
- `NEXTCLOUD_BASE_URL`
- `NEXTCLOUD_USERNAME`
- `NEXTCLOUD_APP_PASSWORD`
- `NEXTCLOUD_BASIC_AUTH`

Technische Testruns:

- Execution `1`: Fehler wegen `URLSearchParams is not defined`
- Execution `2`: Fehler wegen `fetch is not defined`
- Execution `3`: Fehler wegen Deck-Authentifizierung
- Execution `4`: erfolgreich

Verifizierter Erfolgslauf:

- Aus Outlook `__Agenda` wurde eine reale Mail gelesen
- daraus wurde in Deck eine Karte erzeugt
- Zielstack: `Eingang` (`5678`)
- erzeugte Karte: `8588`
- gesetzte Labels: `Sonstiges` (`7916`) und `Zu ueberpruefen` (`7898`)

Damit ist der technische MVP-Kern jetzt wirklich nachgewiesen:

- `Outlook __Agenda -> Graph -> agenda-n8n -> Deck`

## Offene Konfigurationswerte fuer AgendaAgent

Sobald der Bootstrap verifiziert ist, muessen in `config/placeholders.env` mindestens diese Werte fuer die neue Instanz konkretisiert werden:

- `N8N_WEBHOOK_BASE_URL`
- `N8N_API_BASE`
- `N8N_API_KEY`
- optional abweichende SSH-/Host-Informationen, falls nicht identisch mit dem bestehenden VPS-Setup

## Empfehlung

Wenn die Instanz dauerhaft fuer AgendaFlow bleiben soll, ist mittelfristig eine saubere Proxy-Verwaltung besser als eine manuelle Subpath-Ergaenzung.

Bevor wir Workflows bauen, brauchen wir zuerst einen reproduzierbaren Nachweis fuer:

- funktionierenden Login
- funktionierende Webhooks
- funktionierende API

In der aktuellen Lage ist der naechste sinnvolle Schritt:

1. Erstsetup/Owner-Login abschliessen
2. API-Key erzeugen
3. Minimal-Workflow anlegen
4. echten Test-Webhook pruefen
