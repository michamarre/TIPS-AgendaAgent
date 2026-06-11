# TIPS AgendaFlow

Workflow-System fuer die Pflege der Agenda des Institutsvorstands TIPS auf Basis von Outlook `__Agenda`, Nextcloud Deck und n8n.

## Kernkomponenten
- Outlook-Ordner `__Agenda` als aktueller MVP-Eingangskanal
- Nextcloud Deck als operative Arbeitsoberflaeche fuer Agenda-Punkte
- n8n als Automatisierungs- und Integrationsschicht

## Reeller MVP-Stand
- Kernworkflow `mail-to-agenda` ist gebaut, in `agenda-n8n` deployed und gegen Outlook/Deck erfolgreich getestet.
- Reminder-Workflow fuer faellige Wiedervorlagen und ToDos ist gebaut und in `agenda-n8n` validiert; aktuell noch nicht automatisch aktiviert.
- Re-Agenda-Workflow ist gebaut und gegen das reale Sciebo-Board validiert; aktuell noch nicht automatisch aktiviert.
- Board `1919` ist real als `TIPS AgendaFlow` mit produktiver Stack-Struktur angelegt.

## Projektsteuerung
- [AGENTS.md](AGENTS.md)
- [prd.md](prd.md)
- [plan.md](plan.md)
- [project/STATUS.md](project/STATUS.md)
- [project/TASKS.md](project/TASKS.md)
- [project/LEARNINGS.md](project/LEARNINGS.md)

## Struktur
- `config/` Konfiguration, Platzhalter und Prompt-Dateien
- `docs/` Architektur, Entscheidungen, Stoerungen, Aenderungen
- `templates/` Mail-, Deck- und Sitzungs-Templates
- `workflows/` n8n-Exporte und modulare Workflow-Dateien
- `operations/` Runbooks und Betriebsnotizen
- `project/` laufende Projektsteuerung

## Einstieg
1. [AGENTS.md](AGENTS.md) lesen.
2. [project/LEARNINGS.md](project/LEARNINGS.md), [project/STATUS.md](project/STATUS.md) und [project/TASKS.md](project/TASKS.md) pruefen.
3. Fuer Architektur und Betriebsgrenzen [docs/architecture.md](docs/architecture.md), [docs/workflow-erinnerungen-und-wiedervorlage.md](docs/workflow-erinnerungen-und-wiedervorlage.md) und [docs/workflow-reagenda-regeln.md](docs/workflow-reagenda-regeln.md) lesen.
4. Fuer Stoerungen und Betrieb [docs/troubleshooting.md](docs/troubleshooting.md), [docs/testdrehbuch.md](docs/testdrehbuch.md) und [operations/runbooks/agendaflow-betrieb.md](operations/runbooks/agendaflow-betrieb.md) verwenden.
