# Felder und Kategorien

## Ziel

Dieses Dokument definiert fuer den MVP:

1. die fachlichen Kategorien eines Agenda-Punkts
2. die Pflichtfelder einer Agenda-Karte
3. welche Felder aus einer Mail direkt befuellt werden koennen
4. welche Felder spaeter manuell oder halbautomatisch gepflegt werden muessen

## Kategorien

Fuer den MVP werden vier Kategorien verwendet.

### 1. `Information`

**Bedeutung:**
Ein Punkt dient primaer der Kenntnisnahme oder Einordnung.

**Typische Beispiele:**
- Statusbericht
- Hinweis auf externen Termin
- Kurzinfo zu laufendem Vorgang

### 2. `Diskussion`

**Bedeutung:**
Ein Punkt soll in der Sitzung besprochen, eingeordnet oder fachlich geklaert werden.

**Typische Beispiele:**
- Abstimmung zu Vorgehen
- inhaltliche Rueckfrage
- Bewertung einer Entwicklung

### 3. `Beschluss`

**Bedeutung:**
Ein Punkt zielt auf eine konkrete Entscheidung des Gremiums.

**Typische Beispiele:**
- Freigabe
- Priorisierung
- Ressourcenentscheidung

### 4. `Sonstiges`

**Bedeutung:**
Ein Punkt ist noch nicht eindeutig klassifizierbar oder passt nicht sauber in die drei Hauptkategorien.

**Typische Beispiele:**
- unvollstaendige Einreichung
- gemischter Inhalt
- technischer Sammelpunkt

## Pflichtfelder einer Agenda-Karte

### A. Technische Pflichtfelder

Diese Felder muessen fuer Import, Nachvollziehbarkeit und spaetere Automatisierung immer vorhanden sein.

1. `source_system`
   - Erwarteter Wert im MVP: `outlook_agenda_folder`

2. `source_message_id`
   - Die eindeutige Message-ID aus Microsoft Graph

3. `source_folder_id`
   - Die Graph-Folder-ID von `__Agenda`

4. `imported_at`
   - Zeitpunkt des technischen Imports

### B. Fachliche Pflichtfelder

Diese Felder muessen fuer jede Karte im MVP sichtbar und pflegbar sein.

1. `title`
   - Kurzbezeichnung des Agenda-Punkts
   - Standardquelle: Mail-Betreff

2. `description`
   - Kurzkontext oder Inhalt des Punkts
   - Standardquelle: Mail-Text bzw. Body-Preview plus spaetere Ergaenzung

3. `submitter_name`
   - Einreicher oder Absendername

4. `submitter_email`
   - Einreicher- oder Absenderadresse

5. `received_date`
   - Eingangsdatum der Mail

6. `category`
   - Einer der vier MVP-Werte: `Information`, `Diskussion`, `Beschluss`, `Sonstiges`

7. `status`
   - Einer der definierten MVP-Status aus `statusmodell.md`

### C. Fachlich notwendige, aber anfangs optional befuellte Felder

Diese Felder sind fuer den Prozess wichtig, koennen aber beim ersten Import leer bleiben.

1. `desired_meeting_date`
   - gewuenschter Sitzungstermin

2. `preparation_owner`
   - verantwortliche Person fuer die Vorbereitung

3. `due_or_followup_date`
   - Frist oder Wiedervorlage

4. `decision_note`
   - Beschluss- oder Ergebnisnotiz

5. `todo_summary`
   - Kurzbeschreibung offener Folgeaufgaben

## Mindestbelegung beim Mail-Import

Beim initialen Import aus Outlook `__Agenda` muss n8n mindestens diese Felder setzen:

- `source_system = outlook_agenda_folder`
- `source_message_id`
- `source_folder_id`
- `imported_at`
- `title`
- `description`
- `submitter_name`
- `submitter_email`
- `received_date`
- `category`
- `status = Eingang`

## Standardregeln fuer automatische Vorbelegung

### Kategorie

Wenn keine explizite Regel greift:

- Standardwert: `Sonstiges`

Spaeter moegliche einfache Regeln:

- Betreff enthaelt `Beschluss` -> `Beschluss`
- Betreff enthaelt `Info` oder `Information` -> `Information`
- Betreff enthaelt `Diskussion` -> `Diskussion`

### Titel

- primaer aus dem Mail-Betreff
- falls leer: `Ohne Betreff`

### Beschreibung

- primaer aus dem Mail-Body
- falls zu lang: zunaechst Body-Preview oder gekuerzter Text

### Status

- immer Startwert `Eingang`

## Empfohlene Darstellung in Deck

Weil Deck nicht beliebige strukturierte Felder wie ein eigenes Datenmodell bietet, sollten die Pflichtfelder sichtbar und konsistent in der Karte landen, z. B. als:

- Kartentitel fuer `title`
- standardisierter Beschreibungsblock fuer Fach- und Technikfelder
- Labels nur fuer das, was wirklich visuell verdichtet werden soll

## Offene Entscheidungen fuer P2-04 / P2-05

Noch nicht final entschieden sind:

- welche Felder direkt im Kartentext stehen
- welche Felder ueber Labels abgebildet werden
- ob `category` als Label oder Textfeld gefuehrt wird
- wie `decision_note` und `todo_summary` in Deck konkret modelliert werden
