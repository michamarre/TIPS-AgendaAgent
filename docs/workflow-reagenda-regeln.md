# Workflow `reagenda-regeln`

## Ziel

Dieser Workflow setzt die MVP-Regeln fuer offene Punkte nach der Sitzung um.

Er soll Karten aus `ToDo laeuft` wieder in den fachlichen Bearbeitungsfluss bringen, wenn Fristen oder Wiedervorlagen faellig sind.

## Ausgangslage

Quelle ist ausschliesslich:

- Stack `ToDo laeuft` (`5693`)

## Re-Agenda-Regeln

Eine Karte ist Re-Agenda-Kandidat, wenn mindestens eine Bedingung gilt:

1. ein offenes ToDo hat `Frist <= heute`
2. `Wiedervorlage/Frist <= heute`

## Zielstack-Regel

Der Zielstack wird aus `Naechster Zielstatus` abgeleitet:

- `Freitagsagenda` -> Zielstack `5687`
- sonst -> Zielstack `5684` (`Vorbereitung`)

## Wichtige API-Grenze

Die reale Sciebo-/Deck-Version ignoriert beim offiziellen Reorder-Endpunkt das Ziel-`stackId`.

Nachgewiesener Befund:

- `PUT /boards/{boardId}/stacks/{stackId}/cards/{cardId}/reorder`
- Antwort `200`
- Karte bleibt trotzdem im Ursprungsstack

Deshalb nutzt der Workflow im MVP bewusst einen Workaround:

1. Zielkarte im Zielstack neu erzeugen
2. Kategorie-Label erneut setzen
3. `Zu ueberpruefen` bei Bedarf uebernehmen
4. `Handlung erforderlich` setzen
5. Ursprungskarte loeschen

## Konsequenz des Workarounds

Die Deck-Card-ID aendert sich bei Re-Agenda.

Das ist nicht ideal, aber derzeit die stabilste nachgewiesene Betriebsvariante fuer diese Instanz.

Zur Nachvollziehbarkeit schreibt der Workflow in die neue Kartenbeschreibung:

- `reagenda_from_card_id`
- `reagenda_at`
- `reagenda_reason`

## Trigger

- manuell
- sowie werktags `08:30` per Cron

## MVP-Risiko

Der Copy-Delete-Weg bewahrt Titel, Beschreibung und die wichtigsten Labels, aber nicht jede denkbare Card-Metadatenbeziehung.

Fuer den aktuellen MVP ist das akzeptabel, weil:

- keine Unteraufgabenstruktur existiert
- keine externen Deep-Links auf Card-IDs verwendet werden
- die Fachfuehrung ohnehin ueber Board-Status und Beschreibungstext laeuft
