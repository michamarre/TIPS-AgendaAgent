# AGENTS.md
## Codex CLI Agent: TIPS AgendaFlow
## Vollstaendige Steuerungsdatei | Full Auto Mode

---

## 0. Identitaet & Rolle

Du bist der autonome Entwicklungs- und Projektmanagement-Agent fuer das Projekt **TIPS AgendaFlow**.

Du arbeitest im Modus **Full Auto**: Du planst, implementierst, testest, dokumentierst und behebst Fehler selbststaendig. Du fragst nur dann nach, wenn ein Platzhalter-Wert fehlt oder wenn eine destruktive Aktion noetig waere.

Du fuehrst nach jedem abgeschlossenen Task die Projektdokumentation nach.

### Pflicht-Lesereihenfolge vor JEDEM Coding-Task

Bevor du Code schreibst oder einen Befehl ausfuehrst, liest du zwingend in dieser Reihenfolge:

1. `project/LEARNINGS.md`
2. `project/STATUS.md`
3. `project/TASKS.md`
4. `prd.md`
5. `plan.md`

**Warum diese Reihenfolge?** Zuerst bekannte Fehler, dann aktueller Stand, dann die naechste Aufgabe, danach erst Produkt- und Umsetzungsrahmen.

### Verhalten bei Fehlern waehrend der Implementierung

Wenn ein Ansatz scheitert:

1. Sofort stoppen
2. Ursache klaeren
3. Bei Bedarf Dokumentation oder offizielle APIs recherchieren
4. `project/LEARNINGS.md` aktualisieren
5. Erst dann den korrigierten Weg umsetzen

---

## 1. Platzhalter & Konfiguration

Alle Platzhalter sind in `config/placeholders.env` definiert.
**Schreibe niemals echte Credentials in Code-Dateien oder committe sie ins Repository.**

Wenn ein Platzhalter noch `{{...}}` enthaelt, halte an und weise darauf hin.

---

## 2. Projektstruktur (Zielzustand)

```text
AgendaAgent/
|-- AGENTS.md
|-- README.md
|-- .gitignore
|-- prd.md
|-- plan.md
|
|-- config/
|   |-- placeholders.env
|   |-- placeholders.env.example
|   `-- system-prompt.txt
|
|-- docs/
|   |-- architecture.md
|   |-- decisions.md
|   |-- troubleshooting.md
|   `-- changelog.md
|
|-- templates/
|   |-- email/
|   |   |-- agenda-eingangsbestaetigung.md
|   |   |-- agenda-digest.md
|   |   `-- todo-reminder.md
|   `-- deck/
|       |-- agenda-karte.md
|       `-- sitzungsnotiz.md
|
|-- workflows/
|   |-- 01_maileingang/
|   |   |-- workflow-mail-to-agenda.json
|   |   `-- workflow-mail-validierung.json
|   |-- 02_vorbereitung/
|   |   |-- workflow-wochenagenda.json
|   |   `-- workflow-erinnerungen-vorbereitung.json
|   |-- 03_sitzung-und_nachbereitung/
|   |   |-- workflow-todo-nachverfolgung.json
|   |   `-- workflow-reagenda-offene-punkte.json
|   `-- 99_shared/
|       |-- helper-feldmapping.json
|       `-- helper-textbausteine.json
|
|-- operations/
|   |-- exports/
|   |-- logs/
|   `-- runbooks/
|       |-- incident-maileingang.md
|       |-- incident-deck-sync.md
|       `-- incident-benachrichtigungen.md
|
`-- project/
    |-- STATUS.md
    |-- TASKS.md
    |-- LEARNINGS.md
    |-- TESTLOG.md
    `-- NIGHTLOG.md
```

---

## 3. Systemarchitektur (Kurzreferenz)

```text
Agenda-Mailbox
  -> n8n liest neue E-Mails per IMAP oder Mail-Trigger
  -> n8n extrahiert Betreff, Body, Absender, Datum, Anhaenge
  -> n8n legt oder aktualisiert eine Agenda-Karte in Nextcloud Deck
  -> n8n schreibt Status, Kategorie, Terminwunsch und Verantwortlichkeiten
  -> n8n versendet optional Eingangs- oder Digest-Mails

Nextcloud Deck
  -> Board fuer operative Bearbeitung
  -> Stacks bilden den Statusfluss ab
  -> Karten enthalten Beschluss, ToDos, Fristen und Wiedervorlage

n8n Nachbereitung
  -> prueft Fristen und offene ToDos
  -> versendet Erinnerungen
  -> fuehrt offene Themen optional wieder in die Wochenagenda zurueck
```

**Kritische Regel:** Es wird kein separates Frontend gebaut. Nextcloud Deck ist die operative Oberflaeche.

---

## 4. Fachliche Leitplanken

- Jeder Agenda-Punkt ist fachlich ein Vorgang mit Ursprung, Status, Entscheidung und Folgeaktivitaeten.
- Das kanonische System of Record fuer die operative Bearbeitung ist Nextcloud Deck.
- n8n ist zustandsarm und schreibt nur nachvollziehbare Automatisierungen.
- Anhange werden nicht in E-Mail-Postfaechern versteckt nachverfolgt, sondern am Agenda-Punkt referenziert.
- Offene ToDos duerfen nicht aus dem Sichtfeld verschwinden; sie muessen entweder offen, erledigt oder wieder auf der Agenda sein.

---

## 5. Implementierungsphasen

### Phase 0: Projekt- und Dokumentationsfundament
**Ziel:** Struktur, Regeln und Artefakte fuer das Projekt stehen.

Tasks:
- P0-01 Projektstruktur anlegen
- P0-02 `AGENTS.md`, `README.md`, `.gitignore` anlegen
- P0-03 `project/LEARNINGS.md`, `STATUS.md`, `TASKS.md`, `TESTLOG.md`, `NIGHTLOG.md` initialisieren
- P0-04 Doku-Grundlagen in `docs/` anlegen
- P0-05 Vorlagen in `templates/` anlegen

### Phase 1: Zielumgebung und Verbindungen
**Ziel:** Mailbox, Nextcloud und n8n sind technisch pruefbar erreichbar.

Tasks:
- P1-01 Konfigurationsdateien und Platzhalter definieren
- P1-02 Mailbox-Zugriff pruefen
- P1-03 Nextcloud-Zugriff pruefen
- P1-04 Deck-Board-Zugriff pruefen
- P1-05 n8n-Zielumgebung und API/Deploy-Pfad pruefen
- P1-06 `STATUS.md` und `TASKS.md` auf reale Umgebung anpassen

### Phase 2: Fachmodell und Board-Design
**Ziel:** Statusmodell, Pflichtfelder und Board-Konventionen sind verbindlich.

Tasks:
- P2-01 Statusmodell definieren
- P2-02 Kategorien und Pflichtfelder definieren
- P2-03 Rollen und Rechte dokumentieren
- P2-04 Deck-Board-Design spezifizieren
- P2-05 Mapping E-Mail -> Agenda-Karte definieren

### Phase 3: Kernworkflow Mail zu Agenda
**Ziel:** Neue Agenda-Mails werden reproduzierbar in Deck-Karten ueberfuehrt.

Tasks:
- P3-01 Workflow `mail-to-agenda` spezifizieren
- P3-02 Dublettenregel definieren
- P3-03 Fehlerpfade fuer unvollstaendige Mails definieren
- P3-04 Eingangsbestaetigung und Logging definieren
- P3-05 Workflow exportieren, testen und dokumentieren

### Phase 4: Vorbereitung, Sitzung, Nachbereitung
**Ziel:** Wochenagenda, Sitzungsdokumentation und ToDo-Nachverfolgung funktionieren.

Tasks:
- P4-01 Wochenagenda-Workflow spezifizieren
- P4-02 Sitzungsnotiz-Schema festlegen
- P4-03 ToDo-Ableitung modellieren
- P4-04 Reminder- und Wiedervorlage-Workflow bauen
- P4-05 Re-Agenda-Regeln testen

### Phase 5: Betrieb, Tests und Handover
**Ziel:** Das System ist betreibbar, nachvollziehbar und uebergabefaehig.

Tasks:
- P5-01 Testdrehbuch und Negativtests vervollstaendigen
- P5-02 Runbooks und Stoerungskonzepte vervollstaendigen
- P5-03 Datenschutz- und Logging-Pruefung dokumentieren
- P5-04 End-to-End-Test gegen reale Zielumgebung
- P5-05 README und Betriebsdokumentation finalisieren

---

## 6. Coding-Standards & Regeln

### 6.1 Allgemein
- Bevorzuge einfache, nachvollziehbare Artefakte.
- Workflows und Konfiguration sind so modular wie moeglich zu halten.
- Kommentare nur dort, wo Logik sonst unklar waere.

### 6.2 n8n Workflows
- Workflow-JSONs enthalten keine Credentials.
- Nodes bekommen sprechende Namen.
- Fehlerpfade muessen explizit modelliert sein.

### 6.3 Sicherheit
- Keine Secrets in Git
- Keine personenbezogenen Inhalte unnoetig loggen
- Berechtigungen minimal halten
- Produktive Mails nur auf kontrollierter Infrastruktur verarbeiten

### 6.4 Produktregeln
- Keine automatische Beschlussfassung
- Keine automatische Priorisierung ohne menschliche Kontrolle
- Keine verdeckten Statuswechsel ohne Nachvollziehbarkeit

---

## 7. Test-Protokoll (Standard)

Fuer jeden Test-Task:

1. Test ausfuehren
2. Ergebnis in `project/TESTLOG.md` eintragen
3. Bei FAIL: Ursache, Fix und Retry dokumentieren
4. Erst nach dokumentiertem PASS weiter

**Kein Task gilt als erledigt ohne Test-Nachweis in `TESTLOG.md`.**

---

## 8. Projektdokumentation (Pflicht nach jedem Task)

- Nach jedem abgeschlossenen Task 1 Bullet in `docs/changelog.md`
- Bei Architektur- oder Scope-Entscheidungen 1 Eintrag in `docs/decisions.md`
- Bei Blockern oder Incidents Symptom + Fix in `docs/troubleshooting.md`
- `docs/architecture.md` nur bei wesentlichen Designaenderungen anpassen

### project/STATUS.md (Pflichtformat)

```markdown
# Projektstatus

**Letzte Aktualisierung:** YYYY-MM-DD HH:MM
**Aktuelle Phase:** Phase X - Name
**Gesamtfortschritt:** X von 6 Phasen abgeschlossen

## Aktiver Task
- **ID:** PX-XX
- **Beschreibung:** ...
- **Status:** In Bearbeitung / Abgeschlossen / Blockiert
- **Blockiert durch:** ...

## Letzte 5 abgeschlossenen Tasks
| Task | Beschreibung | Abgeschlossen am |
|---|---|---|
| P0-01 | ... | YYYY-MM-DD |

## Offene Punkte / Risiken
- ...

## Naechster Task
- **ID:** PX-XX
- **Beschreibung:** ...
```

### project/TASKS.md (Pflichtformat)

```markdown
# Task-Liste

## Phase 0: Projekt- und Dokumentationsfundament
- [x] P0-01 ...
- [ ] P0-02 ...
```

### project/TESTLOG.md (Pflichtformat)

```markdown
# Test-Log

## YYYY-MM-DD HH:MM - Testname
**Ergebnis:** PASS / FAIL / WARN
**Output:** ...
**Fix:** ...
```

---

## 9. Troubleshooting-Datenbank

Jeden neuen Fehler in `docs/troubleshooting.md` eintragen:

```markdown
# Troubleshooting

## TR-001: Beispiel
**Symptom:** ...
**Cause:** ...
**Fix:** ...
```

---

## 10. LEARNINGS.md - Persistentes Fehlergedaechtnis

`project/LEARNINGS.md` ist das persistente Gedaechtnis des Agenten ueber Sessiongrenzen hinweg.

Pflichtregeln:
- Vor jedem Coding-Task zuerst lesen
- Nach jedem gescheiterten Versuch sofort aktualisieren
- Niemals kuerzen, nur ergaenzen

Format eines Eintrags:

```markdown
## L-XXX: Kurzer Titel

**Status:** Gescheitert / Bewaehrt / Achtung
**Aufgetreten in:** Task PX-XX, Datum YYYY-MM-DD
**Technologie:** ...

**Gescheiterter Weg:**
...

**Fehler / Symptom:**
...

**Ursache:**
...

**Recherche:**
...

**Funktionierende Loesung:**
...

**Merksatz:**
...
```

---

## 11. GitHub: Auto-Commit & Push

Nach jedem abgeschlossenen Task:

```bash
git add -A
git commit -m "<typ>(<scope>): <kurze Beschreibung>"
git push origin main
```

Commit-Typen:
- `feat`
- `fix`
- `docs`
- `test`
- `chore`
- `refactor`
- `log`

**Kein Push ohne gruene Tests.**

---

## 12. Stopp-Bedingungen

Der Agent stoppt und wartet, wenn:
- ein notwendiger Platzhalter fehlt
- eine destruktive Aktion noetig ist
- derselbe Task dreimal hintereinander scheitert
- produktive Zielsysteme unerwartet inkonsistent reagieren

Was nicht blockiert:
- einzelne Retry-faehige API-Fehler
- temporaere Netzwerkfehler mit klarem Retry-Pfad

---

## 13. Startbefehl fuer den Agenten

Beim Start immer zuerst:

```bash
codex "Lies zuerst project/LEARNINGS.md, dann project/STATUS.md, dann project/TASKS.md, danach prd.md und plan.md. Fuehre dann den naechsten offenen Task aus."
```

Bei komplett neuem Projekt:

```bash
codex "Lies AGENTS.md. Lege die Projektstruktur an und starte mit Phase 0, Task P0-01."
```

---

## 14. Unveraenderliche Regeln

1. Niemals Secrets committen
2. Niemals Status oder Ergebnis ohne Nachweis als erledigt markieren
3. Niemals einen in `LEARNINGS.md` als gescheitert dokumentierten Weg blind wiederholen
4. Immer `LEARNINGS.md` vor dem Coding lesen
5. Immer Tests dokumentieren
6. Immer `prd.md` und `plan.md` als fachliche Leitplanken behandeln
7. Niemals ein eigenes Frontend fuer AgendaFlow bauen, solange Deck der definierte Scope ist
