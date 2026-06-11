# Rollen und Rechte

## Ziel

Dieses Dokument definiert fuer den MVP von TIPS AgendaFlow:

1. die beteiligten Rollen
2. ihre fachlichen Aufgaben
3. die minimal noetigen Systemrechte in Outlook, Microsoft Graph, Deck und n8n
4. die Trennung zwischen Bedienung, Betrieb und Administration

## Grundprinzipien

- Rechte werden im MVP so klein wie moeglich vergeben.
- Fachliche Verantwortung und technische Administration werden getrennt.
- Der persoenliche Outlook-Ordner `__Agenda` ist ein Uebergangskanal und erzeugt deshalb ein erhoehtes Personenrisiko.
- n8n soll auf produktive Systeme nur mit den Rechten zugreifen, die fuer Lesen, Import und spaetere Statuspflege wirklich noetig sind.

## Rollen im MVP

### 1. `Mailbox Owner`

**Bedeutung:**
Die Person, in deren Outlook-Postfach der Ordner `__Agenda` liegt.

**MVP-Zuschnitt:**
- aktuell die personengebundene Eingangsinstanz fuer Agenda-Mails
- Quelle fuer den technischen Import

**Fachliche Aufgaben:**
- sicherstellen, dass relevante Mails in `__Agenda` landen
- bei Bedarf fehlerhafte oder unklare Eingaenge manuell nachsortieren

**Noetige Systemrechte:**
- Vollzugriff auf das eigene Outlook-Postfach
- Berechtigung, den Ordner `__Agenda` anzulegen und zu pflegen

**Nicht zwingend noetig:**
- Admin-Rechte in n8n
- Admin-Rechte in Deck

### 2. `Agenda Koordination`

**Bedeutung:**
Die fachlich verantwortliche Rolle fuer Sichtung, Vorbereitung und Einplanung von Agenda-Punkten.

**Fachliche Aufgaben:**
- neue Karten im Status `Eingang` sichten
- Kategorie und fachliche Einordnung pflegen
- Punkte in `Rueckfrage`, `Vorbereitung` oder `Freitagsagenda` ueberfuehren
- Vorbereitungsverantwortliche benennen

**Noetige Systemrechte:**
- Schreibzugriff auf das relevante Deck-Board
- Leserechte auf Karteninhalte, Labels, Stacks und Aktivitaet im Board

**Optional hilfreich:**
- Lesender Zugriff auf die Ursprungsmail oder exportierte Mailreferenzen

### 3. `Sitzungsleitung`

**Bedeutung:**
Die Rolle, die Punkte fuer die konkrete Sitzung freigibt oder Entscheidungen nachhaelt.

**Fachliche Aufgaben:**
- Punkte fuer `Freitagsagenda` bestaetigen
- Beschlussstatus oder operative Folgearbeit nachvollziehen
- Abschluss oder Wiedervorlage ausloesen

**Noetige Systemrechte:**
- mindestens Schreibzugriff auf das Deck-Board

**Optional hilfreich:**
- Lesender Zugriff auf n8n-Ausgaben wie Agenda-Digests

### 4. `Bearbeitung / Vorbereitung`

**Bedeutung:**
Fachlich zustaendige Personen, die Inhalte vorbereiten oder Folgeaufgaben umsetzen.

**Fachliche Aufgaben:**
- Unterlagen pruefen
- Beschreibungen ergaenzen
- Rueckfragen beantworten
- ToDos fortschreiben

**Noetige Systemrechte:**
- mindestens Schreibzugriff auf Karten im Deck-Board

### 5. `n8n Operator`

**Bedeutung:**
Technische Betriebsrolle fuer Workflows, Credentials und Ausfuehrungsfehler.

**Technische Aufgaben:**
- Workflows deployen und aendern
- Credentials pflegen
- Fehleranalysen in Executions durchfuehren
- Logging und Betriebsnotizen pflegen

**Noetige Systemrechte:**
- Schreibzugriff in `agenda-n8n`
- Zugriff auf relevante Credentials in n8n
- API-Zugriff fuer Workflow-Deployment

**Nicht automatisch noetig:**
- fachliche Entscheidungsrechte im Board

### 6. `System Admin`

**Bedeutung:**
Technische Rolle fuer Infrastruktur, Proxy, Docker, Datenbank und Grundbetrieb.

**Technische Aufgaben:**
- VPS-, Container- und Proxy-Betrieb
- Datenbank- und Storage-Sicherung
- Erreichbarkeit und technische Stoerungen beheben

**Noetige Systemrechte:**
- Server-/Containerzugriff
- Proxy- und Netzwerkzugriff
- n8n-Infrastrukturzugriff

**Wichtig:**
- Diese Rolle ist nicht automatisch Owner des fachlichen Prozesses.

## Systemrechte nach Plattform

### Outlook / Microsoft 365 / Graph

Fuer den MVP ist fachlich nur ein lesender Zugriff auf den Ordner `__Agenda` notwendig.

**n8n bzw. die technische Integration braucht mindestens:**
- `Mail.Read` auf das betroffene Benutzerpostfach

**Spaeter optional:**
- `Mail.ReadWrite`, falls verarbeitete Mails verschoben, markiert oder kategorisiert werden sollen

**MVP-Empfehlung:**
- zunaechst nur lesen
- keine automatische Verschiebung oder Loeschung in Outlook

### Nextcloud Deck

Fuer das Board `1919` gelten im MVP diese Mindestannahmen:

- `Agenda Koordination`, `Sitzungsleitung` und `Bearbeitung / Vorbereitung` brauchen Schreibzugriff
- `n8n` braucht die technischen Rechte, um Karten anzulegen und spaeter gezielt zu lesen, zu aendern oder zu loeschen

**MVP-Empfehlung:**
- kein globaler Nextcloud-Admin-Zugriff fuer den Workflow
- eigener technischer Zugriff nur auf das benoetigte Board

### n8n

In `agenda-n8n` muessen Rechte sauber getrennt werden:

- `n8n Operator` verwaltet Workflows und Credentials
- fachliche Nutzer brauchen nicht automatisch Editor-Zugriff auf n8n
- `System Admin` braucht nur dann direkten n8n-Zugriff, wenn Betriebs- oder Stoerungsaufgaben es erfordern

**MVP-Empfehlung:**
- produktive Credentials nur in n8n speichern
- keine Secrets in Workflow-JSON, README oder frei zugreifbaren Docs

## Minimaler Rechtezuschnitt fuer den MVP

Der MVP kann mit folgendem Zuschnitt betrieben werden:

1. Ein persoenlicher `Mailbox Owner` mit Outlook-Ordner `__Agenda`
2. Eine `Agenda Koordination` mit Schreibzugriff auf das Deck-Board
3. Ein `n8n Operator`, der Graph-, Deck- und spaeter optionale Mail-Credentials in `agenda-n8n` pflegt
4. Ein `System Admin` fuer VPS, Docker und Proxy

## Bewusste Risiken im MVP

### 1. Personenabhaengigkeit

Der Eingangskanal haengt aktuell an einem persoenlichen Postfach.

Folgen:
- Vertretung ist organisatorisch zu klaeren
- die Loesung ist nicht institutionell stabil

### 2. Rechtebuendelung

Wenn dieselbe Person `Mailbox Owner`, `Agenda Koordination` und `n8n Operator` ist, wird der MVP zwar einfacher, aber auch stoeranfaelliger und revisionsschwaecher.

### 3. Bootstrap-Zugaenge

Die neue `agenda-n8n`-Instanz wurde technisch initialisiert. Produktive Rollen, Passwoerter und API-Keys muessen vor echtem Betrieb bewusst gehaertet und spaeter sauber uebergeben werden.

## Konsequenz fuer die naechsten Tasks

Aus diesem Rollenmodell folgen fuer die weitere Spezifikation:

- P2-04 muss Deck-Stacks, Labels und Beschreibungsstruktur so definieren, dass `Agenda Koordination` und `Sitzungsleitung` damit praktikabel arbeiten koennen.
- P2-05 muss im Mail->Deck-Mapping sauber trennen, welche Felder automatisch kommen und welche fachlich gepflegt werden.
- P5-03 muss die Datenschutz- und Logging-Sicht besonders auf den persoenlichen Outlook-Eingangskanal anwenden.
