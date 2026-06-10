# TIPS AgendaFlow

Workflow-System fuer die Pflege der Agenda des Institutsvorstands TIPS auf Basis von Agenda-Mailadresse, Nextcloud Deck und n8n.

## Kernkomponenten
- Agenda-Mailadresse als Eingangskanal fuer Themen, Unterlagen und Hinweise
- Nextcloud Deck als operative Arbeitsoberflaeche fuer Agenda-Punkte
- n8n als Automatisierungs- und Integrationsschicht

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
- `operations/` Exporte, Logs und Runbooks
- `project/` laufende Projektsteuerung

## Start
1. `config/placeholders.env.example` nach `config/placeholders.env` kopieren oder die bereits angelegte Datei pruefen.
2. `AGENTS.md` lesen.
3. Danach immer mit `project/LEARNINGS.md`, `project/STATUS.md` und `project/TASKS.md` starten.
