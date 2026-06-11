# Statusmodell

## Ziel

Dieses Statusmodell definiert den fachlichen Lebenszyklus eines Agenda-Punkts im MVP von TIPS AgendaFlow.

Es verbindet drei Ebenen:

1. Eingang im Outlook-Ordner `__Agenda`
2. operative Bearbeitung in Nextcloud Deck
3. Nachverfolgung von Beschluessen und ToDos

## Grundprinzip

- Outlook `__Agenda` ist nur der **Eingangskanal**
- der fachliche Status wird in **Deck** gefuehrt
- n8n ueberfuehrt Eingangsmails in Karten und aktualisiert spaeter definierte Felder
- der Status einer Karte beschreibt immer den **fachlichen Bearbeitungsstand**, nicht nur den technischen Import

## MVP-Statuswerte

### 1. `Eingang`

**Bedeutung:**
Die Mail liegt im Eingangskanal oder wurde frisch als Agenda-Karte angelegt, aber noch nicht fachlich gesichtet.

**Typische Ausloeser:**
- Mail liegt in Outlook `__Agenda`
- n8n erzeugt eine neue Karte aus einer Mail

**Erlaubte Folge-Status:**
- `Rueckfrage`
- `Vorbereitung`
- `Erledigt`

### 2. `Rueckfrage`

**Bedeutung:**
Der Punkt ist noch nicht ausreichend klar oder unvollstaendig und braucht menschliche Klaerung.

**Typische Ausloeser:**
- fehlende Unterlagen
- unklarer Beschlussbedarf
- unklarer Terminwunsch

**Erlaubte Folge-Status:**
- `Vorbereitung`
- `Erledigt`

### 3. `Vorbereitung`

**Bedeutung:**
Der Punkt ist fachlich in Arbeit und wird fuer eine Sitzung vorbereitet.

**Typische Ausloeser:**
- Thema ist valide
- Vorbereitungsperson ist benannt
- Unterlagen werden gesammelt oder gesichtet

**Erlaubte Folge-Status:**
- `Freitagsagenda`
- `Rueckfrage`
- `Erledigt`

### 4. `Freitagsagenda`

**Bedeutung:**
Der Punkt ist fuer die naechste Sitzung vorgesehen.

**Typische Ausloeser:**
- Thema ist ausreichend vorbereitet
- Aufnahme in die konkrete Sitzung ist gewollt

**Erlaubte Folge-Status:**
- `Beschlossen`
- `ToDo laeuft`
- `Vorbereitung`
- `Erledigt`

### 5. `Beschlossen`

**Bedeutung:**
Zum Punkt wurde eine Entscheidung getroffen, ohne dass offene operative Folgearbeit im System verbleibt.

**Typische Ausloeser:**
- Beschluss gefasst
- Thema abgeschlossen

**Erlaubte Folge-Status:**
- `Erledigt`
- `ToDo laeuft`

### 6. `ToDo laeuft`

**Bedeutung:**
Aus dem Agenda-Punkt sind operative Folgeaufgaben entstanden, die noch nachverfolgt werden.

**Typische Ausloeser:**
- Verantwortliche und Fristen sind definiert
- Wiedervorlage ist noetig

**Erlaubte Folge-Status:**
- `Freitagsagenda`
- `Erledigt`

### 7. `Erledigt`

**Bedeutung:**
Der Punkt ist fachlich und operativ abgeschlossen.

**Typische Ausloeser:**
- Thema abgeschlossen
- ToDos erledigt
- kein weiterer Sitzungsbedarf

**Erlaubte Folge-Status:**
- keine regulären Folge-Status im MVP

## Empfohlene Deck-Abbildung

Die MVP-Stacks in Deck sollten direkt diesen Statusen entsprechen:

1. `Eingang`
2. `Rueckfrage`
3. `Vorbereitung`
4. `Freitagsagenda`
5. `Beschlossen`
6. `ToDo laeuft`
7. `Erledigt`

## Outlook- zu Deck-Regel

Wichtig:

- Der Outlook-Ordner `__Agenda` ist **kein eigener fachlicher Status**
- Eine Mail im Ordner `__Agenda` wird nach Import in Deck zunaechst als Karte mit Status `Eingang` behandelt

## Mindestregeln fuer n8n

Beim Import aus Outlook `__Agenda` soll n8n mindestens:

1. eine Karte im Board `1919` anlegen
2. den Startstatus `Eingang` setzen
3. Absender, Betreff, Eingangsdatum und Mail-ID referenzieren
4. die urspruengliche Mail eindeutig mit der Deck-Karte verknuepfbar halten

## Offene Entscheidungen fuer spaeter

Dieses MVP-Statusmodell laesst bewusst noch offen:

- ob `Beschlossen` und `Erledigt` spaeter zusammengelegt werden
- ob `Rueckfrage` ein eigener Stack oder nur ein Label sein soll
- ob `ToDo laeuft` spaeter in ein separates Nachverfolgungsboard auslagert
- wie verarbeitete Mails in Outlook nach dem Import weiter markiert oder verschoben werden
