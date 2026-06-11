# Projektstatus

**Letzte Aktualisierung:** 2026-06-11 09:00
**Aktuelle Phase:** Phase 6 - Produktivhaertung
**Gesamtfortschritt:** 6 von 6 Phasen abgeschlossen

## Aktiver Task
- **ID:** P6-05
- **Beschreibung:** Aktivierungs- und Betriebsstrategie fuer Reminder und Re-Agenda festlegen
- **Status:** Abgeschlossen
- **Blockiert durch:** -

## Letzte 5 abgeschlossenen Tasks
| Task | Beschreibung | Abgeschlossen am |
|---|---|---|
| P5-05 | README und Betriebsdokumentation finalisiert | 2026-06-10 |
| P5-04 | End-to-End-Tests gegen die reale Zielumgebung dokumentiert und mit Reminder/Re-Agenda ergaenzt | 2026-06-10 |
| P5-03 | Datenschutz- und Logging-Linie fuer den MVP dokumentiert | 2026-06-10 |
| P5-02 | Runbook und Stoerungskonzept vervollstaendigt | 2026-06-10 |
| P5-01 | Testdrehbuch und Negativtests vervollstaendigt | 2026-06-10 |
| P6-05 | Aktivierungs- und Betriebsstrategie fuer Reminder und Re-Agenda festgelegt | 2026-06-11 |
| P6-01 | Nachtstand konsolidiert, lokale MVP-Konfiguration entblockt und Re-Smoke dokumentiert | 2026-06-11 |
| P4-05 | Re-Agenda-Regeln real gegen Deck validiert und Workaround fuer kaputtes Reorder dokumentiert | 2026-06-10 |
| P4-04 | Reminder- und Wiedervorlage-Workflow gebaut, deployed und validiert | 2026-06-10 |
| P4-03 | ToDo-Ableitung aus Sitzungsentscheidungen modelliert | 2026-06-10 |
| P4-02 | Sitzungsnotiz-Schema fuer Agenda-Karten festgelegt | 2026-06-10 |
| P4-01 | Wochenagenda-Workflow fuer Stack `Freitagsagenda` spezifiziert | 2026-06-10 |
| P3-05 | Workflow `mail-to-agenda` gebaut, in n8n deployed und erfolgreich getestet | 2026-06-10 |
| P3-04 | Logging und bewusste Nicht-Nutzung von Eingangsbestaetigungen im MVP definiert | 2026-06-10 |
| P3-03 | Fehlerpfade fuer unvollstaendige und problematische Mails definiert | 2026-06-10 |
| P3-02 | Dublettenregel fuer Mailimporte definiert | 2026-06-10 |
| P3-01 | Kernworkflow `mail-to-agenda` spezifiziert | 2026-06-10 |
| P2-06 | MVP-Abgrenzung und reale Betriebsannahmen geschaerft | 2026-06-10 |
| P2-05 | Mapping Outlook `__Agenda` -> Deck-Karte definiert | 2026-06-10 |
| P2-04 | Deck-Board-Design fuer Board `1919` spezifiziert | 2026-06-10 |
| P2-03 | Rollen und Rechte fuer Outlook, Deck und n8n dokumentiert | 2026-06-10 |
| P2-02 | Kategorien und Pflichtfelder fuer Agenda-Punkte definiert | 2026-06-10 |
| P2-01 | MVP-Statusmodell fuer AgendaFlow definiert | 2026-06-10 |
| P1-07 | Graph-Zugriff auf Outlook-Ordner `__Agenda` erfolgreich validiert | 2026-06-10 |
| P1-06 | Outlook-Ordner `__Agenda` als MVP-Eingangskanal festgelegt | 2026-06-10 |
| P1-05 | Deck-Karten-Endpunkte fuer Board `1919` erfolgreich verifiziert | 2026-06-10 |
| P1-04 | Nextcloud-/Sciebo-Zugriff erfolgreich validiert | 2026-06-10 |
| P1-03 | `agenda-n8n` API-Key, Basis-Credentials und Deploy-Pfad dokumentiert | 2026-06-10 |
| P1-02 | `agenda-n8n` Login, API und Webhook-Basisfunktion validiert | 2026-06-10 |
| P0-05 | Vorlagen in `templates/` angelegt | 2026-06-10 |
| P0-04 | Doku-Grundlagen in `docs/` angelegt | 2026-06-10 |
| P0-03 | Projektlogs initialisiert | 2026-06-10 |

## Offene Punkte / Risiken
- Es gibt aktuell keine echte Agenda-Mailadresse mit eigenem Postfach; der Eingangskanal laeuft weiter ueber Outlook `__Agenda`.
- `workflow-mail-to-agenda` ist in `agenda-n8n` aktiv und laut Re-Smoke am 2026-06-11 mehrfach erfolgreich gelaufen.
- `workflow-erinnerungen-vorbereitung` und `workflow-reagenda-offene-punkte` sind deployed und validiert, bleiben aber derzeit bewusst `inactive`.
- Die `agenda-n8n`-Instanz haengt weiterhin an einer manuell ergaenzten Proxy-Route; diese Loesung kann bei Proxy-Neugenerierung ueberschrieben werden.
- Die Instanz nutzt weiter technische Bootstrap-Credentials bzw. den bestehenden API-Key; eine Rotation wurde fuer das laufende MVP-Testfenster bewusst vertagt.
- Sciebo/Deck-Zugriff auf Board `1919` wurde im Re-Smoke erneut bestaetigt; belastbarer Lesepfad fuer Karten bleibt `GET /boards/{boardId}/stacks`.
- Cross-Stack-Moves per Deck-`reorder` bleiben in dieser Instanz unzuverlaessig; produktiv ist weiterhin nur `copy -> relabel -> delete` belastbar.
- `prd.md` und `plan.md` sind als Leitdokumente neu nach UTF-8 geschrieben, bilden aber weiterhin eher das Zielbild als den heutigen Betriebs-MVP ab.
- Fuer Reminder und Re-Agenda gilt jetzt als dokumentierter Standard die Wiedereinplanung in den naechsten regulaeren Wochenlauf, also wieder eine Woche spaeter.

## Naechster Task
- **ID:** P6-03
- **Beschreibung:** Proxy-Route fuer `agenda-n8n` reproduzierbar absichern.
