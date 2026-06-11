# Datenschutz und Logging

## Ziel

Dieses Dokument beschreibt die aktuelle MVP-Linie fuer datensensible Verarbeitung und technische Protokollierung.

## Aktuelle Datenfluesse

- Outlook `__Agenda` als persoenlicher Eingangskanal
- Microsoft Graph liest Mail-Metadaten und Mail-Inhalte
- `agenda-n8n` verarbeitet die Daten
- Nextcloud Deck speichert die operative Kartenbeschreibung

## MVP-Minimierung

- kein automatischer Versand von Eingangs- oder Fehlermails
- kein automatischer Dateiupload von Mail-Anhaengen
- kein separates Logsystem ausserhalb von n8n-Execution-Daten
- keine zusaetzliche Schattenkopie kompletter Mails im Repo

## Sichtbare Inhaltsdaten

In Deck werden aktuell bewusst gespeichert:

- Betreff als Kartentitel
- Kurzkontext aus Mailtext
- Einreichername und E-Mail
- Eingangsdatum
- technische Referenzen wie `source_message_id`

## Logging

Der MVP nutzt primaer:

- n8n Execution Logs
- Projektlog in [project/TESTLOG.md](../project/TESTLOG.md)
- Stoerungswissen in [docs/troubleshooting.md](troubleshooting.md)

## Risiken

- persoenlicher Outlook-Eingang ist keine dauerhafte institutionelle Zielarchitektur
- Deck-Karten koennen personenbezogene Informationen enthalten
- n8n Execution Logs koennen Inhaltsdaten transportieren

## Betriebsregel

Vor einem echten Produktivbetrieb sollten mindestens geprueft werden:

1. wer Zugriff auf `agenda-n8n` und Execution Logs hat
2. welche Aufbewahrungsdauer fuer Logs gelten soll
3. ob Mailinhalte in Deck in dieser Form institutionell freigegeben sind
4. wann der persoenliche Outlook-Eingang durch eine tragfaehige Loesung ersetzt wird

## Aktueller Status

Fuer den MVP ist die Verarbeitung technisch begrenzt und dokumentiert, aber noch keine formale Datenschutzfreigabe ersetzt.
