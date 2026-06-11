# MVP-Abgrenzung

## Ziel

Dieses Dokument schaerft den realen MVP von TIPS AgendaFlow gegenueber dem urspruenglichen PRD und dem allgemeinen Umsetzungsplan.

Es beantwortet:

1. was im MVP wirklich umgesetzt werden soll
2. welche Betriebsannahmen dafuer gelten
3. was bewusst erst spaeter kommt

## Reale MVP-Zielsetzung

Der MVP soll einen belastbaren End-to-End-Kern herstellen:

1. Eine Mail liegt im Outlook-Ordner `__Agenda`
2. n8n liest die Mail per Microsoft Graph
3. n8n erzeugt daraus eine Karte im Deck-Board `1919`
4. Die Karte ist im Stack `Eingang` sichtbar und traegt Kategorie, Beschreibung und technische Referenzen
5. Fachliche Bearbeitung erfolgt danach manuell im Board

Damit ist der MVP erfolgreich, wenn der **Eingang von Mail zu sichtbarer Agenda-Karte** stabil funktioniert.

## Im MVP enthalten

### Eingang und Import

- Outlook-Ordner `__Agenda` als temporärer Eingangskanal
- Lesen von Mails per Microsoft Graph
- Import relevanter Mail-Metadaten
- Erzeugung neuer Karten im Deck-Board `1919`

### Board-Nutzung

- reales Statusboard in Deck mit sieben Stacks
- Kategorien als Labels
- standardisierter Beschreibungstext mit Fach- und Technikfeldern

### Betriebsbasis

- eigene `agenda-n8n`-Instanz
- dokumentierter API-Key-Zugriff
- validierter Deck-Zugriff
- dokumentierte Rollen und Rechte fuer den MVP

## Bewusst nicht im MVP enthalten

### Mailarchitektur Zielbild

Noch nicht im MVP:

- dedizierte institutionelle Agenda-Mailadresse
- eigenes Agenda-Postfach
- IMAP-basierter Mailzugang

Stattdessen gilt aktuell:

- persoenliches Outlook-Postfach mit Unterordner `__Agenda`

### Mail-Rueckkanal

Noch nicht im MVP:

- automatische Eingangsbestätigung
- automatische Ergebnis- oder Follow-up-Mails
- automatisches Markieren, Verschieben oder Aufräumen verarbeiteter Outlook-Mails

### Anhaenge und Dateien

Noch nicht im MVP:

- Upload von Mailanhaengen nach Nextcloud
- Ablage von Dokumenten in definierter Dateistruktur
- Verknuepfung von Anhaengen als Deck-Attachments

### Sitzungs- und ToDo-Automation

Noch nicht im MVP:

- automatischer Agenda-Digest
- automatische Wiedervorlagen
- automatische ToDo-Erinnerungen
- automatische Re-Agenda offener Punkte

### Erweiterte Datenlogik

Noch nicht im MVP:

- ausgereifte Dublettenbehandlung
- automatische Betreff-Normalisierung
- regelbasierte Priorisierung
- strukturierte Unteraufgaben oder separates ToDo-Board

## Reale Betriebsannahmen

### 1. Personenabhaengiger Eingang

Der MVP haengt aktuell an einem persoenlichen Outlook-Postfach.

Folge:

- die Loesung ist fachlich brauchbar, aber organisatorisch noch kein finales Zielbild

### 2. Lesender Zugriff auf Outlook

Der MVP geht davon aus, dass n8n bzw. die technische Integration Mails nur liest, nicht veraendert.

Folge:

- geringeres Risiko im Postfach
- aber keine automatische Mailhygiene

### 3. Deck als operative Hauptoberflaeche

Alle fachlichen Folgearbeiten passieren im MVP in Deck, nicht in Outlook und nicht in n8n.

### 4. Manuelle Nachpflege bleibt Teil des Prozesses

Der MVP automatisiert den Eingang, aber nicht die gesamte Agenda-Arbeit.

Manuell bleiben zunaechst insbesondere:

- Kategoriekorrektur
- Verschieben in den passenden fachlichen Stack
- Vorbereitungsverantwortung
- Entscheidungseintrag
- ToDo-Nachverfolgung

## Konkrete MVP-Abnahmekriterien

Der MVP gilt als erreicht, wenn alle folgenden Punkte erfuellt sind:

1. Eine reale Mail aus `__Agenda` kann per Graph gelesen werden.
2. n8n kann daraus eine Karte im Board `1919` anlegen.
3. Die Karte landet im Stack `Eingang` (`5678`).
4. Die Karte enthaelt Titel, Kurzkontext, Einreicher, E-Mail, Eingangsdatum, Kategorie und technische Referenzen.
5. Genau ein Kategorien-Label wird gesetzt.
6. Die Karte ist anschliessend manuell im Board weiterbearbeitbar.

## Konsequenz fuer Phase 3

Phase 3 soll daher zuerst nur den Kernworkflow liefern:

- Mail lesen
- Felder mappen
- Karte anlegen
- Ergebnis pruefen

Nicht Teil des ersten Workflows sind:

- Outbound-Mail
- Anhangssync
- Wiedervorlage
- ToDo-Automation

## Spaetere Ausbaupfade

Nach dem MVP sind die naechsten sinnvollen Ausbaupfade:

1. Dublettenpruefung
2. Mail-Markierung oder Verschiebung nach erfolgreichem Import
3. Agenda-Digest vor der Freitagssitzung
4. ToDo- und Wiedervorlage-Workflows
5. Umstieg von persoenlichem Postfach auf institutionelle Eingangslösung
