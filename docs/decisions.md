# Decisions

## Decision Log
- Status: laufend
- Zweck: Architektur- und Scope-Entscheidungen kurz und nachvollziehbar festhalten.

## D-001: Nextcloud Deck bleibt die operative Oberflaeche
**Status:** Aktiv
**Datum:** 2026-06-10
**Entscheidung:** TIPS AgendaFlow baut kein separates Frontend. Die Bearbeitung der Agenda-Punkte erfolgt in Nextcloud Deck.
**Begruendung:** Das PRD schliesst ein eigenstaendiges Frontend explizit aus. So bleibt der Scope klein und der Betrieb einfacher.

## D-002: Agenda-Mailbox ist der primaere Eingangskanal
**Status:** Aktiv
**Datum:** 2026-06-10
**Entscheidung:** Neue Themen werden primaer ueber die dedizierte Agenda-Mailadresse in das System ueberfuehrt.
**Begruendung:** Das reduziert verteilte Einreichungswege und ermoeglicht eine nachvollziehbare Automatisierung.

## D-003: n8n orchestriert, Deck fuehrt
**Status:** Aktiv
**Datum:** 2026-06-10
**Entscheidung:** n8n uebernimmt Trigger, Parsing, Benachrichtigungen und Nachverfolgung; Deck bleibt das kanonische Arbeitsboard.
**Begruendung:** Damit bleiben Automatisierung und operative Bearbeitung sauber getrennt.
