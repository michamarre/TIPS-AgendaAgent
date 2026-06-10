# Architecture

## Zielbild

TIPS AgendaFlow verbindet drei Kernsysteme:

1. Eine dedizierte Agenda-Mailbox fuer Eingaben
2. Nextcloud Deck als operative Arbeitsoberflaeche
3. n8n als Integrations- und Automatisierungsschicht

## Datenfluss

1. Eine E-Mail trifft in der Agenda-Mailbox ein.
2. n8n liest Betreff, Text, Absender, Datum und Anhaenge.
3. Das Mapping entscheidet ueber Titel, Kategorie, Zielstatus und Zusatzfelder.
4. n8n erzeugt oder aktualisiert eine Karte in Nextcloud Deck.
5. Vor der Freitagssitzung erstellt n8n optional einen Agenda-Digest.
6. Nach der Sitzung verfolgt n8n offene ToDos und Wiedervorlagen.

## System of Record

- Operative Sicht: Nextcloud Deck
- Integrationslogik: n8n
- Eingangsquelle: Agenda-Mailbox
- Fachliche Leitplanken: `prd.md` und `plan.md`

## Entwurfsprinzipien

- Keine eigene App, solange Deck ausreicht
- Modulare Workflows statt monolithischer Automatisierung
- Nachvollziehbare Statuswechsel
- DSGVO-sensible Verarbeitung
