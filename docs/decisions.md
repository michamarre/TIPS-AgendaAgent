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

## D-004: MVP-Eingangskanal ist ein Outlook-Ordner `__Agenda`
**Status:** Aktiv
**Datum:** 2026-06-10
**Entscheidung:** Fuer den MVP wird kein eigenes Agenda-Postfach vorausgesetzt. Stattdessen werden Mails im persoenlichen Outlook-Postfach ueber eine Betreffkonvention wie `[Agenda]` und eine Outlook-Regel in den Ordner `__Agenda` verschoben. Nur dieser Ordner wird spaeter automatisiert ausgelesen.
**Begruendung:** Es existiert aktuell kein echtes Agenda-Postfach. Die `__Agenda`-Loesung ermoeglicht dennoch einen sofort nutzbaren, mailbasierten Eingangskanal ohne make.com-Zwischenschicht.

## D-005: Nicht-MVP-Mailboxwerte blockieren den Outlook-Ordner-MVP nicht
**Status:** Aktiv
**Datum:** 2026-06-11
**Entscheidung:** Solange AgendaFlow im MVP ueber Outlook `__Agenda` statt ueber eine eigene Agenda-Mailbox laeuft, duerfen IMAP-, SMTP- und institutionelle Mailboxwerte lokal als `MVP_DEFERRED` markiert werden.
**Begruendung:** Diese Werte werden fuer den derzeit real betriebenen Importpfad nicht benoetigt und sollen die Produktivhaertung nicht mit einem kuenstlichen Konfigurationsblocker stoppen.

## D-006: Reminder und Re-Agenda bleiben vorerst deployed, aber inaktiv
**Status:** Aktiv
**Datum:** 2026-06-11
**Entscheidung:** `workflow-erinnerungen-vorbereitung` und `workflow-reagenda-offene-punkte` bleiben in `agenda-n8n` vorerst vorhanden, werden aber bis zur Betriebsfreigabe nicht automatisch aktiviert.
**Begruendung:** Die Workflows sind technisch validiert, sollen aber erst nach bewusster Cron-, Empfaenger- und Betriebsentscheidung automatisch laufen.

## D-007: API-Key-Rotation wird im MVP-Testfenster bewusst nicht vorgezogen
**Status:** Aktiv
**Datum:** 2026-06-11
**Entscheidung:** Der bestehende `agenda-n8n`-API-Key und die aktuellen technischen Credentials werden fuer das laufende MVP-Testfenster vorerst nicht rotiert.
**Begruendung:** Im aktuellen Schritt hat Stabilitaet des Testpfads hoehere Prioritaet als sofortige Credential-Rotation. Die Haertung bleibt Folgearbeit vor einer breiteren Betriebsfreigabe.

## D-008: Re-Agenda-Standard ist eine Woche spaeter
**Status:** Aktiv
**Datum:** 2026-06-11
**Entscheidung:** Fuer `P6-05` gilt als Standardfall, dass offene Punkte nach Reminder oder Re-Agenda fuer den naechsten Wochenzyklus wieder eine Woche spaeter eingeplant werden.
**Begruendung:** Das entspricht dem regulaeren Sitzungsrhythmus und vermeidet zu aggressive Rueckfuehrung offener Punkte in denselben Wochenlauf.

## D-009: Proxy-Schutz fuer `agenda-n8n` erfolgt ueber idempotenten Reconcile-Job
**Status:** Aktiv
**Datum:** 2026-06-11
**Entscheidung:** Der funktionierende `agenda-n8n`-Subpath-Block wird nicht mehr nur manuell in `proxy_host/5.conf` gepflegt, sondern ueber ein idempotentes Reconcile-Skript plus Cron-Self-Heal abgesichert.
**Begruendung:** Nginx Proxy Manager kann generierte Host-Dateien neu schreiben. Ein versionierter Reconcile-Pfad ist in dieser Umgebung belastbarer als ein einmaliger Handedit.
