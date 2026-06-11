# Dublettenregel

## Ziel

Dieses Dokument definiert die MVP-Regel, wann eine Outlook-Mail aus `__Agenda` als bereits verarbeitet gilt und deshalb **keine neue Deck-Karte** erzeugt werden darf.

## Grundsatz

Im MVP gilt:

- **pro Graph-Message-ID maximal eine Deck-Karte**

Der primaere technische Schluessel ist damit:

- `source_message_id`

## Begruendung

Fuer den aktuellen MVP ist `source_message_id` die belastbarste und einfachste Importreferenz:

- sie ist pro Graph-Nachricht eindeutig
- sie steht direkt im Importobjekt zur Verfuegung
- sie wird bereits in der Kartenbeschreibung persistiert

`internetMessageId` wird zusaetzlich gespeichert, ist im MVP aber nur ein sekundaerer Referenzwert.

## MVP-Entscheidungsregel

Vor dem Anlegen einer neuen Karte prueft der Workflow:

1. existiert bereits eine Karte, die `source_message_id: <Graph ID>` in ihrer Beschreibung traegt
2. wenn ja -> **kein neuer Import**
3. wenn nein -> Karte anlegen

## Suchstrategie im MVP

Weil die Deck-API in dieser Umgebung kein einfaches Collection-GET fuer Karten liefert, wird die Dublettenpruefung im MVP nicht ueber einen vollstaendigen API-Suchlauf auf Board-Ebene geloest.

Stattdessen gilt fuer den ersten realen Workflow:

### Stufe 1

- n8n fuehrt eine eigene technische Importliste innerhalb des Workflows oder als lokale Workflow-Datenhaltung

### Stufe 2

- zusaetzlich wird `source_message_id` immer in die Kartenbeschreibung geschrieben

Das bedeutet:

- die Kartenbeschreibung bleibt die menschlich sichtbare Referenz
- die technische Dublettenpruefung darf fuer den MVP ueber n8n-internen Speicher oder eine kleine technische Liste erfolgen

## Praktische MVP-Varianten

Fuer den Workflow-Bau sind zwei Varianten zulaessig.

### Variante A: Workflow Static Data

n8n speichert verarbeitete `source_message_id`-Werte in statischen Workflow-Daten.

Vorteile:

- schnell
- kein externer Speicher zusaetzlich noetig

Nachteile:

- weniger transparent
- bei Workflow-Reset oder Rebuild mit Risiko auf erneute Imports

### Variante B: Technische JSON-Liste / Data Store

n8n speichert verarbeitete IDs in einem kleinen technischen Store.

Vorteile:

- robuster und besser nachvollziehbar

Nachteile:

- etwas mehr Implementierungsaufwand

## MVP-Empfehlung

Fuer den ersten End-to-End-Bau:

- **Variante A** ist ausreichend

Fuer eine kurzfristige Haertung direkt danach:

- auf **Variante B** wechseln

## Sonderfaelle

### Dieselbe Mail wird erneut gelesen

Wenn dieselbe Graph-Message-ID erneut im Polling auftaucht:

- kein neuer Import
- Ergebnisstatus `duplicate_skip`

### Weitergeleitete oder neu eingegangene aehnliche Mail

Wenn Betreff und Inhalt aehnlich sind, aber eine andere Graph-Message-ID vorliegt:

- im MVP **neuer Import**

Begruendung:

- inhaltliche Dublettenanalyse ist noch nicht Teil des MVP

### Manuell geloeschte Deck-Karte

Wenn eine bereits importierte Karte spaeter manuell in Deck geloescht wurde, aber die Message-ID technisch als verarbeitet gilt:

- im MVP **kein automatischer Reimport**

Begruendung:

- Loeschen soll nicht unbemerkt durch Polling rueckgaengig gemacht werden

## Ergebniscodes

Der Workflow soll fuer die Dublettenentscheidung diese technischen Resultate unterscheiden:

- `import_new`
- `duplicate_skip`
- `error_duplicate_check`

## Konsequenz fuer den Workflow

Vor `Create Deck Card` braucht der Workflow einen klaren Schritt:

1. `Check Duplicate`
2. nur bei `import_new` weiter zu Deck
3. bei `duplicate_skip` sauber beenden und protokollieren
