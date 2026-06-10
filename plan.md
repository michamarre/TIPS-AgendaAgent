# Umsetzungsplan: TIPS AgendaFlow

## Ziel des Umsetzungsplans
Dieser Plan beschreibt die schrittweise Umsetzung des im PRD definierten Systems „TIPS AgendaFlow“ auf Basis von Nextcloud Deck, n8n und einer dedizierten Agenda-Mailadresse. Die Umsetzung ist bewusst in aufeinander aufbauende Schritte gegliedert, damit zuerst die fachlichen und technischen Grundlagen geschaffen und danach schrittweise die Automatisierungen, Benachrichtigungen und Betriebsaspekte ergänzt werden.[cite:1][web:13][web:15]

Der Plan enthält noch keine Implementierung, sondern legt fest, welche Komponenten, Konfigurationen, Workflows und Artefakte in welcher Reihenfolge erstellt werden. Grundlage sind insbesondere die Anforderungen zu Mail-Eingang, Deck-basierter Agenda-Verwaltung, ToDo-Nachverfolgung, n8n-Orchestrierung, Datenschutz und Wartbarkeit aus dem PRD.[cite:1][cite:2][cite:5]

## Zielarchitektur
Die Zielarchitektur besteht aus drei operativen Kernkomponenten: einer dedizierten Agenda-Mailadresse als Eingangskanal, einem Nextcloud-Deck-Board als zentrale Arbeitsoberfläche und n8n als Automatisierungs- und Integrationsschicht. Eingehende E-Mails werden über das dedizierte Postfach erfasst, in strukturierte Agenda-Punkte überführt und anschließend im Deck-Board vorbereitet, im Termin bearbeitet und nach dem Termin weiterverfolgt.[cite:1][web:13][web:15]

Technisch wird dabei ein modularer Aufbau vorgesehen, damit einzelne Workflows unabhängig erweitert werden können. Diese Modularität unterstützt die im PRD geforderte Wartbarkeit und Anpassbarkeit bei neuen Statuswerten, zusätzlichen Feldern oder weiteren Benachrichtigungsregeln.[cite:5]

## Datei- und Ordnerstruktur
Für die spätere Umsetzung wird eine klar getrennte Projektstruktur vorgesehen. Sie dient der sauberen Ablage von Konfiguration, Dokumentation, Workflow-Exporten, Mapping-Definitionen und Betriebshinweisen.

```text
TIPS-AgendaFlow/
├── README.md
├── docs/
│   ├── prd.md
│   ├── plan.md
│   ├── fachkonzept/
│   │   ├── prozessmodell.md
│   │   ├── statusmodell.md
│   │   └── rollen-und-rechte.md
│   ├── betrieb/
│   │   ├── deployment.md
│   │   ├── backup-restore.md
│   │   └── datenschutz-und-berechtigungen.md
│   └── testfaelle/
│       ├── fachliche-tests.md
│       └── technische-tests.md
├── config/
│   ├── mail/
│   │   ├── mailbox-konzept.md
│   │   └── mail-routing-regeln.md
│   ├── nextcloud/
│   │   ├── deck-board-design.md
│   │   ├── deck-labels-und-stacks.md
│   │   └── nextcloud-zugriffsmodell.md
│   ├── n8n/
│   │   ├── credentials-template.md
│   │   ├── workflow-landkarte.md
│   │   └── env-konzept.md
│   └── mappings/
│       ├── email-zu-agenda-felder.json
│       ├── status-transitionen.json
│       └── benachrichtigungsregeln.json
├── workflows/
│   ├── 01_maileingang/
│   │   ├── workflow-mail-to-agenda.json
│   │   └── workflow-mail-validierung.json
│   ├── 02_vorbereitung/
│   │   ├── workflow-wochenagenda.json
│   │   └── workflow-erinnerungen-vorbereitung.json
│   ├── 03_sitzung-und_nachbereitung/
│   │   ├── workflow-todo-nachverfolgung.json
│   │   └── workflow-reagenda-offene-punkte.json
│   └── 99_shared/
│       ├── helper-feldmapping.json
│       └── helper-textbausteine.json
├── templates/
│   ├── email/
│   │   ├── eingangsbestaetigung.md
│   │   ├── agenda-digest.md
│   │   └── follow-up-todos.md
│   └── deck/
│       ├── agenda-karten-template.md
│       └── sitzungsdokumentation-template.md
└── operations/
    ├── exports/
    ├── logs/
    └── runbooks/
        ├── incident-maileingang.md
        ├── incident-deck-sync.md
        └── incident-benachrichtigungen.md
```

Diese Struktur trennt fachliche Beschreibung, technische Konfiguration, n8n-Workflows und operative Dokumentation. Dadurch bleibt das System nachvollziehbar, testbar und später leichter anpassbar, was den Anforderungen aus dem PRD an Transparenz, Wartbarkeit und geringe Betriebslast entspricht.[cite:5]

## Umsetzungsschritte

## Schritt 1: Projektbasis und Dokumentationsstruktur anlegen
In diesem Schritt wird die grundlegende Projektstruktur angelegt. Dazu gehören das zentrale Projektverzeichnis, die Dokumentationsordner, die Konfigurationsverzeichnisse sowie Platzhalter für Workflow-Exporte und betriebliche Runbooks.

Implementiert wird hier noch keine Fachlogik, sondern die organisatorische und technische Grundlage für die spätere Umsetzung. Ergebnis dieses Schritts ist ein sauberes Arbeitsgerüst, in dem PRD, Plan, Fachkonzept, Betriebsdokumentation und Workflow-Dateien getrennt und versionierbar abgelegt werden.

## Schritt 2: Fachliches Prozessmodell konkretisieren
In diesem Schritt wird das fachliche Zielbild aus dem PRD in ein ausführbares Prozessmodell übersetzt. Es wird definiert, wie ein Agenda-Punkt vom Mail-Eingang über die Vorbereitung und Sitzung bis zur ToDo-Nachverfolgung und möglichen Wiedervorlage durch das System läuft.[cite:1]

Zu implementieren ist hier zunächst die fachliche Beschreibung, nicht die technische Automation. Konkret entstehen das Prozessmodell, das Statusmodell, die Definition der Pflichtfelder eines Agenda-Punkts sowie eine Regelbeschreibung, wann ein Punkt in welchem Status sein darf und welche Folgeaktionen daran geknüpft werden.[cite:1][web:13]

## Schritt 3: Rollen- und Berechtigungskonzept festlegen
In diesem Schritt wird geklärt, wer das Postfach verwaltet, wer Karten anlegen oder verändern darf, wer die Freitagssitzung vorbereitet und wer ToDos bearbeiten oder schließen darf. Zusätzlich wird beschrieben, wie Lese- und Schreibrechte in der Nextcloud-/Deck-Umgebung sowie für die n8n-Anbindung organisiert werden sollen.[cite:4][cite:5]

Implementiert wird ein dokumentiertes Rollenmodell mit mindestens den Rollen Administrator, Sitzungskoordination, Vorbereitungsverantwortliche und Board-Mitglied. Dieser Schritt ist notwendig, bevor produktive Zugriffe auf Postfach, Nextcloud und Workflows eingerichtet werden.

## Schritt 4: Agenda-Mailadresse und Mailfluss spezifizieren
Hier wird die dedizierte Agenda-Mailadresse fachlich und technisch vorbereitet. Es wird beschrieben, wie Mails in das Postfach gelangen, welche Betreffkonventionen optional verwendet werden, wie mit Anhängen umzugehen ist und wie n8n das Postfach per IMAP oder vergleichbarer Schnittstelle ausliest.[web:15]

Zu implementieren ist in diesem Schritt die Mailbox-Konzeption mit Routing-Regeln, Zugriffspfaden, Namenskonventionen und Fehlerfällen. Außerdem wird festgelegt, welche E-Mail-Metadaten zwingend extrahiert werden: Betreff, Text, Absender, Eingangsdatum und Anhänge, soweit im Zielsystem sinnvoll nutzbar.[web:15]

## Schritt 5: Nextcloud-Deck-Board fachlich entwerfen
In diesem Schritt wird das zentrale Board inhaltlich designt. Definiert werden Board-Name, Stacks/Spalten, optionale Labels, Benennungsregeln, Karteninhalt und die Abbildung der Pflichtfelder aus dem PRD auf konkrete Deck-Nutzungskonventionen.[cite:1][web:13][web:21]

Implementiert wird ein Board-Design-Dokument mit einem verbindlichen Statusmodell, beispielsweise „Eingang“, „Rückfrage“, „Vorbereitung“, „Freitagsagenda“, „Beschlossen“, „ToDo läuft“ und „Erledigt“. Zusätzlich wird festgelegt, wie Beschlüsse, Wiedervorlagen, Verantwortlichkeiten und Fristen innerhalb von Deck sichtbar gemacht werden.[cite:1][web:13]

## Schritt 6: Datenmapping zwischen E-Mail und Agenda-Karte definieren
Hier wird festgelegt, wie Informationen aus einer eingehenden E-Mail in ein standardisiertes Kartenformat überführt werden. Das umfasst Feldzuordnungen, Normalisierung von Betreffzeilen, Vorbelegung von Kategorien, Behandlung leerer Informationen und Regeln für unvollständige Eingänge.[web:12][web:15]

Implementiert werden Mapping-Dateien, die z. B. den Betreff auf den Kartentitel, den Mailtext auf Beschreibung/Kontext, den Absender auf Einreicher und das Eingangsdatum auf ein Metadatenfeld oder standardisierte Kartenstruktur abbilden. Ebenso werden Status-Transitionen und Benachrichtigungsregeln als getrennte Konfigurationsartefakte beschrieben.

## Schritt 7: n8n-Workflow-Landkarte entwerfen
In diesem Schritt wird noch kein Workflow gebaut, sondern die Gesamtheit der nötigen Workflows als Architekturkarte beschrieben. Diese Landkarte zerlegt die spätere Umsetzung in einzelne Workflow-Module für Maileingang, Validierung, Agenda-Versand, Erinnerungen, ToDo-Nachverfolgung und Re-Agenda offener Punkte.[cite:5]

Implementiert wird ein Dokument, das pro Workflow Zweck, Trigger, Eingaben, Verarbeitungsschritte, Ausgaben, Fehlerfälle und Abhängigkeiten beschreibt. Das schafft die Grundlage für eine modulare n8n-Umsetzung und verhindert, dass ein großer monolithischer Workflow entsteht.[cite:5]

## Schritt 8: Workflow „Mail zu Agenda-Punkt“ detailliert spezifizieren
Dieser Schritt beschreibt den wichtigsten Kernworkflow des Systems. Er legt fest, wie eine neue E-Mail erkannt, validiert, geparst und in einen neuen oder aktualisierten Agenda-Punkt überführt wird.[web:12][web:15]

Zu beschreiben sind im Detail: Trigger auf neue Mail, Extraktion relevanter Felder, Anwendung des Mappings, Prüfung auf Dubletten, Anlegen der Karte im passenden Stack, optionales Anhängen von Referenzen sowie Versand einer Eingangsbestätigung. Auch Fehlerpfade, etwa bei unlesbaren Mails oder fehlenden Pflichtinformationen, werden hier konkret festgelegt.[web:15]

## Schritt 9: Workflow für Vorbereitung und Wochenagenda spezifizieren
In diesem Schritt wird der Vorbereitungsprozess vor dem Freitagstermin formalisiert. Das umfasst die automatische Zusammenstellung aller Punkte im Status „Freitagsagenda“ sowie optionale Erinnerungen an vorbereitende Personen oder an die Sitzungskoordination.[cite:1][cite:5]

Implementiert wird die fachliche und technische Beschreibung eines Zeitplan-Workflows, der zu einem definierten Wochentag oder Zeitpunkt eine Agenda-Zusammenstellung erzeugt. Zusätzlich wird beschrieben, in welchem Format diese Übersicht erzeugt wird, welche Karten einbezogen werden und an welche Verteiler die Information versendet werden soll.[cite:5]

## Schritt 10: Sitzungsdokumentation und ToDo-Erfassung spezifizieren
Dieser Schritt beschreibt, wie im Termin selbst gearbeitet wird. Es wird festgelegt, wie Entscheidungen direkt an Karten dokumentiert werden, wie ToDos aus Beschlüssen hervorgehen und in welcher Struktur Verantwortliche, Fristen und Status erfasst werden.[web:19]

Implementiert wird ein einheitliches Sitzungsdokumentationsschema, etwa als Kartenkommentar, standardisierter Textblock oder ergänzende Metadatenkonvention. Außerdem wird festgelegt, wie aus einem Agenda-Punkt mehrere Folge-ToDos abgeleitet und für die Nachverfolgung kenntlich gemacht werden.

## Schritt 11: Workflow für ToDo-Nachverfolgung und Wiedervorlage spezifizieren
Hier wird beschrieben, wie offene Aufgaben nach der Sitzung kontrolliert weitergeführt werden. Dazu gehören Erinnerungen bei Fristen, Kennzeichnung überfälliger Punkte, Eskalationspfade und die Regel, wann ein offenes ToDo erneut auf die Agenda einer Folgesitzung gesetzt werden soll.[cite:5][cite:7]

Zu implementieren ist die Workflow-Spezifikation für Fälligkeitsprüfungen, Reminder-Mails, Statusaktualisierung und die automatische oder halbautomatische Rückführung offener Themen in den Status „Freitagsagenda“ oder „Vorbereitung“.

## Schritt 12: E-Mail-Templates und Textbausteine definieren
In diesem Schritt werden die standardisierten Nachrichten vorbereitet, die später durch n8n genutzt werden. Dazu gehören Eingangsbestätigung, Agenda-Digest, Erinnerungsnachrichten und optionale Follow-up-Mails nach der Sitzung.[cite:5]

Implementiert werden Markdown- oder Textvorlagen mit Platzhaltern für Betreff, Einreicher, Sitzungstermin, Verantwortliche, Fristen und Kartentitel. Dieser Schritt sorgt für ein konsistentes Kommunikationsbild und reduziert spätere Pflegeaufwände.

## Schritt 13: Testkonzept und Abnahmeszenarien formulieren
Hier wird beschrieben, wie die spätere Implementierung geprüft werden soll. Das Testkonzept orientiert sich an den Abnahmekriterien des PRD, insbesondere an der erfolgreichen Überführung von Mails in Agenda-Punkte, der Board-Nutzung, der Agenda-Erzeugung und der Nachverfolgbarkeit offener ToDos.[web:12][web:13][web:15]

Implementiert werden fachliche Testfälle, technische Testfälle und Negativtests. Dazu gehören etwa Tests für leere Betreffzeilen, nicht lesbare Anhänge, doppelte Einreichungen, fehlende Berechtigungen, fehlerhafte Mailzugriffe oder fehlgeschlagene Benachrichtigungen.

## Schritt 14: Betriebs-, Backup- und Störungskonzept dokumentieren
In diesem Schritt werden die Anforderungen an den laufenden Betrieb definiert. Dazu zählen Sicherung von Konfiguration und Workflow-Exporten, Wiederherstellbarkeit, Monitoring, Protokollierung und Vorgehensweisen bei typischen Störungen im Mailfluss, in Deck oder in n8n.[cite:4][cite:5]

Implementiert werden Runbooks für Standardstörungen, ein Backup-/Restore-Konzept für Konfigurationen und Workflow-Definitionen sowie eine Liste betrieblicher Prüfpunkte für den wiederkehrenden Wochenbetrieb. Dieser Schritt ist besonders wichtig, weil das PRD eine geringe administrative Last bei gleichzeitiger Nachvollziehbarkeit verlangt.[cite:5]

## Schritt 15: Umsetzungsreihenfolge für die spätere Implementierung freigeben
Im letzten Planungsschritt werden alle zuvor erstellten Artefakte in eine verbindliche Realisierungsreihenfolge überführt. Es wird festgelegt, welche Komponenten in der tatsächlichen Umsetzung zuerst gebaut werden und welche voneinander abhängen.

Die empfohlene spätere Implementierungsreihenfolge lautet: zuerst Mailzugang und Board-Struktur, danach Datenmapping, anschließend der Kernworkflow „Mail zu Agenda-Punkt“, danach Wochenagenda, dann Sitzungsdokumentation, ToDo-Nachverfolgung, Benachrichtigungen und zuletzt Betriebshärtung. So wird zuerst ein minimal nutzbarer End-to-End-Kern hergestellt und danach schrittweise erweitert.[web:12][web:13][web:15]

## Ergebnis des Planungsstands
Nach Abschluss dieses Planungsdokuments liegt ein vollständiger Umsetzungsrahmen vor, aber noch keine technische Implementierung. Vorhanden sind dann eine definierte Projektstruktur, ein fachliches Prozessmodell, ein Berechtigungskonzept, ein Board-Design, Workflow-Spezifikationen, Mapping-Dateien, Nachrichtenvorlagen sowie Test- und Betriebskonzepte.[cite:1][cite:5]

Damit kann die spätere Umsetzung kontrolliert, modular und mit geringem Risiko gestartet werden. Gleichzeitig bleibt der Ansatz kompatibel mit dem im PRD beschriebenen Scope: zentrale Agenda-Verwaltung in Nextcloud Deck, Automatisierung über n8n und Nutzung einer dedizierten Agenda-Mailadresse ohne Aufbau eines eigenständigen Frontends.[cite:1][web:13][web:15]
