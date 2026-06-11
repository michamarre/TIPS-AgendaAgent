# Task-Liste

## Phase 0: Projekt- und Dokumentationsfundament
- [x] P0-01 Projektstruktur anlegen
- [x] P0-02 `AGENTS.md`, `README.md`, `.gitignore` anlegen
- [x] P0-03 `project/LEARNINGS.md`, `STATUS.md`, `TASKS.md`, `TESTLOG.md`, `NIGHTLOG.md` initialisieren
- [x] P0-04 Doku-Grundlagen in `docs/` anlegen
- [x] P0-05 Vorlagen in `templates/` anlegen

## Phase 1: Zielumgebung und Verbindungen
- [x] P1-01 Konfigurationsdateien und Platzhalter definieren
- [x] P1-02 `agenda-n8n` Login, API und Webhook-Basisfunktion validieren
- [x] P1-03 `agenda-n8n` API-Key, Basis-Credentials und Deploy-Pfad dokumentieren
- [x] P1-04 Nextcloud-Zugriff iterativ klaeren und pruefen
- [x] P1-05 Deck-Board-Zugriff und Board-ID iterativ klaeren und pruefen
- [x] P1-06 Outlook-Ordner `__Agenda` als temporaeren Eingangskanal festlegen und pruefen
- [x] P1-07 Graph-Zugriff auf Outlook-Ordner `__Agenda` planen und pruefen

## Phase 2: Fachmodell und Board-Design
- [x] P2-01 Statusmodell definieren
- [x] P2-02 Kategorien und Pflichtfelder definieren
- [x] P2-03 Rollen und Rechte dokumentieren
- [x] P2-04 Deck-Board-Design spezifizieren
- [x] P2-05 Mapping E-Mail -> Agenda-Karte definieren
- [x] P2-06 MVP-Abgrenzung und reale Betriebsannahmen nach Infrastrukturklaerung schaerfen

## Phase 3: Kernworkflow Mail zu Agenda
- [x] P3-01 Workflow `mail-to-agenda` spezifizieren
- [x] P3-02 Dublettenregel definieren
- [x] P3-03 Fehlerpfade fuer unvollstaendige Mails definieren
- [x] P3-04 Eingangsbestaetigung und Logging definieren
- [x] P3-05 Workflow exportieren, testen und dokumentieren

## Phase 4: Vorbereitung, Sitzung, Nachbereitung
- [x] P4-01 Wochenagenda-Workflow spezifizieren
- [x] P4-02 Sitzungsnotiz-Schema festlegen
- [x] P4-03 ToDo-Ableitung modellieren
- [x] P4-04 Reminder- und Wiedervorlage-Workflow bauen
- [x] P4-05 Re-Agenda-Regeln testen

## Phase 5: Betrieb, Tests und Handover
- [x] P5-01 Testdrehbuch und Negativtests vervollstaendigen
- [x] P5-02 Runbooks und Stoerungskonzepte vervollstaendigen
- [x] P5-03 Datenschutz- und Logging-Pruefung dokumentieren
- [x] P5-04 End-to-End-Test gegen reale Zielumgebung
- [x] P5-05 README und Betriebsdokumentation finalisieren

## Phase 6: Produktivhaertung
- [x] P6-01 Nachtstand konsolidieren, lokale MVP-Konfiguration entblocken und Re-Smoke dokumentieren
- [ ] P6-02 `agenda-n8n`-Credentials und API-Key haerten oder rotieren (bewusst nach MVP-Testfenster)
- [x] P6-03 Proxy-Route fuer `agenda-n8n` reproduzierbar absichern
- [ ] P6-04 Institutionelle Agenda-Mailbox statt Outlook `__Agenda` vorbereiten
- [x] P6-05 Aktivierungs- und Betriebsstrategie fuer Reminder und Re-Agenda festlegen
