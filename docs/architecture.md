# Architecture

## Zielbild

TIPS AgendaFlow verbindet drei Kernsysteme:

1. Einen Mail-Eingangskanal fuer Agenda-Themen
2. Nextcloud Deck als operative Arbeitsoberflaeche
3. n8n als Integrations- und Automatisierungsschicht

## Datenfluss

1. Eine E-Mail trifft im persoenlichen Outlook-Postfach des Verantwortlichen ein.
2. Eine Outlook-Regel verschiebt Mails mit einer klaren Kennzeichnung, z. B. `[Agenda]`, in den Ordner `__Agenda`.
3. n8n liest vorerst nur diesen Ordner als operativen Eingangskanal.
4. n8n extrahiert Betreff, Text, Absender, Datum und Anhaenge.
5. Das Mapping entscheidet ueber Titel, Kategorie, Zielstatus und Zusatzfelder.
6. n8n erzeugt oder aktualisiert eine Karte in Nextcloud Deck.
7. Vor der Freitagssitzung erstellt n8n optional einen Agenda-Digest.
8. Nach der Sitzung verfolgt n8n offene ToDos und Wiedervorlagen.

## System of Record

- Operative Sicht: Nextcloud Deck
- Integrationslogik: n8n
- Eingangsquelle im aktuellen MVP: Outlook-Ordner `__Agenda`
- Fachliche Leitplanken: `prd.md` und `plan.md`

## Entwurfsprinzipien

- Keine eigene App, solange Deck ausreicht
- Modulare Workflows statt monolithischer Automatisierung
- Nachvollziehbare Statuswechsel
- DSGVO-sensible Verarbeitung
- Der Eingangskanal darf fuer den MVP uebergangsweise persoenlich sein, muss aber spaeter auf eine institutionell tragfaehige Loesung ueberfuehrt werden

## MVP-Statusfluss

Der fachliche MVP-Statusfluss lautet:

`Eingang -> Rueckfrage -> Vorbereitung -> Freitagsagenda -> Beschlossen -> ToDo laeuft -> Erledigt`

Siehe auch:

- [statusmodell.md](statusmodell.md)

## MVP-Kategorien und Pflichtfelder

Der MVP verwendet vier Kategorien:

- `Information`
- `Diskussion`
- `Beschluss`
- `Sonstiges`

Die Mindestfelder fuer den Import aus Outlook `__Agenda` sind in

- [felder-und-kategorien.md](felder-und-kategorien.md)

definiert.

## MVP-Rollen und Rechte

Die Rollen- und Rechteabgrenzung fuer Outlook `__Agenda`, Deck und `agenda-n8n` ist in

- [rollen-und-rechte.md](rollen-und-rechte.md)

festgelegt.

## Deck-Board-Design

Die konkrete Soll-Abbildung auf Stacks, Labels und Kartenstruktur fuer Board `1919` ist in

- [deck-board-design.md](deck-board-design.md)

definiert.

## Mail-to-Deck-Mapping

Das konkrete Mapping von Outlook-Mails aus `__Agenda` auf Deck-Karten ist in

- [mail-to-deck-mapping.md](mail-to-deck-mapping.md)

festgelegt.

## MVP-Abgrenzung

Die reale MVP-Abgrenzung gegenueber dem urspruenglichen PRD ist in

- [mvp-abgrenzung.md](mvp-abgrenzung.md)

festgelegt.

## Workflow-Spezifikation

Die Spezifikation des Kernworkflows `mail-to-agenda` ist in

- [workflow-mail-to-agenda.md](workflow-mail-to-agenda.md)

festgelegt.

Die dazugehoerigen Betriebsregeln fuer Dubletten, problematische Mails und Logging sind in

- [dublettenregel.md](dublettenregel.md)
- [fehlerpfade-mailimport.md](fehlerpfade-mailimport.md)
- [logging-und-rueckmeldungen.md](logging-und-rueckmeldungen.md)

dokumentiert.

## Wochenagenda

Die Spezifikation fuer die Zusammenstellung der Freitagssitzung ist in

- [workflow-wochenagenda.md](workflow-wochenagenda.md)

festgelegt.

## Sitzung und ToDos

Das Sitzungsnotiz-Schema und die ToDo-Ableitung sind in

- [sitzungsnotiz-schema.md](sitzungsnotiz-schema.md)
- [todo-ableitung.md](todo-ableitung.md)

festgelegt.
