# PRD: TIPS Agenda Workflow auf Basis von Nextcloud Deck, n8n und dedizierter Agenda-Mailadresse

## Projektname
TIPS AgendaFlow

## Beschreibung
TIPS AgendaFlow ist ein internes Workflow-System zur nachhaltigen Pflege der wiederkehrenden Agenda des Institutsvorstandes TIPS. Das System kombiniert eine dedizierte Agenda-Mailadresse als Eingangskanal, Nextcloud Deck als zentrale Arbeitsoberfläche für Agenda-Punkte und n8n als Automatisierungs- und Orchestrierungsschicht.[cite:1][cite:2][cite:5]

Ziel ist es, eingehende Informationen strukturiert in bearbeitbare Agenda-Punkte zu überführen, diese vor der Freitagssitzung vorzubereiten, Entscheidungen im Termin nachvollziehbar festzuhalten und daraus resultierende ToDos mit Verantwortlichkeiten und Fristen weiterzuverfolgen. Nextcloud Groupware integriert Mail, Kalender und kollaborative Funktionen, während Deck als Kanban-orientiertes Planungswerkzeug für Team- und Projektorganisation dient.[cite:1][web:11][web:13]

Die Lösung soll in einer hochschulnahen, datenschutzsensiblen Umgebung funktionieren und sich an bestehende oder geplante Nextcloud-/Sciebo-nahe Infrastrukturen anlehnen. Durch n8n sollen eingehende E-Mails automatisiert verarbeitet und als strukturierte Einträge in Deck oder in nachgelagerte Aufgabenprozesse überführt werden können.[cite:2][cite:4][web:15]

## Zielsetzung
Das Produkt soll einen einheitlichen, transparenten und nachhaltigen Prozess für die Verwaltung von Themen, Beschlüssen und ToDos des Institutsvorstandes bereitstellen. Informationen sollen nicht mehr ausschließlich in persönlichen Postfächern oder isolierten Dokumenten verbleiben, sondern als nachvollziehbare Vorgänge in einem gemeinsamen System geführt werden.[cite:1][web:13][web:21]

## Funktionale Anforderungen

### 1. Eingang von Agenda-Punkten
- Das System muss eine dedizierte Agenda-Mailadresse bereitstellen, an die Themenvorschläge, Unterlagen und Hinweise gesendet werden können.
- Eingehende E-Mails sollen automatisiert erkannt und verarbeitet werden können, beispielsweise über IMAP-basierte Trigger in n8n.[web:15]
- Aus einer eingegangenen E-Mail muss automatisiert oder halbautomatisiert ein neuer Agenda-Punkt erzeugt werden können.[web:12][web:15]
- Anhänge aus E-Mails sollen dem Agenda-Punkt referenziert oder beigefügt werden können, soweit dies durch die Zielumgebung technisch unterstützt wird.

### 2. Strukturierung von Agenda-Punkten
- Jeder Agenda-Punkt muss als Karte oder Eintrag in Nextcloud Deck geführt werden können, da Deck als Kanban-basiertes Organisationswerkzeug innerhalb von Nextcloud vorgesehen ist.[web:13][web:21]
- Für jeden Agenda-Punkt müssen mindestens folgende Felder pflegbar sein:
  - Titel
  - Beschreibung / Kontext
  - Einreicher
  - Eingangsdatum
  - Kategorie (z. B. Information, Diskussion, Beschluss, Sonstiges)
  - gewünschter Sitzungstermin
  - verantwortliche Person für die Vorbereitung
  - Status
  - Frist / Wiedervorlage
- Das System soll Statuswerte für den Lebenszyklus eines Punkts unterstützen, etwa: Eingang, Rückfrage, Vorbereitung, Freitagsagenda, Beschlossen, ToDo läuft, Erledigt.[cite:1][web:13]

### 3. Vorbereitung der Sitzung
- Agenda-Punkte sollen vor der Sitzung gesichtet, ergänzt, kommentiert und einer Statusspalte zugeordnet werden können.[web:13][web:21]
- Das System soll eine Übersicht aller Punkte bereitstellen, die für die nächste Freitagssitzung vorgesehen sind.
- Es soll möglich sein, verantwortliche Personen zur Vorbereitung einzelner Punkte festzulegen.
- Vor dem Regeltermin soll automatisiert eine Agenda-Zusammenstellung versendet oder erzeugt werden können, basierend auf allen Punkten im Status „Freitagsagenda“.[cite:5]

### 4. Durchführung und Dokumentation
- Während der Sitzung soll das Board oder die Agenda-Liste als operative Arbeitsoberfläche verwendet werden können.[web:19]
- Für jeden Punkt soll das Ergebnis dokumentiert werden können, z. B. vertagt, beschlossen, zur Nachbearbeitung zurückgegeben oder in ToDos überführt.
- Aus einem Agenda-Punkt sollen ein oder mehrere ToDos mit Verantwortlichen und Fristen abgeleitet werden können.
- Entscheidungen und Folgeaktivitäten sollen am ursprünglichen Agenda-Punkt nachvollziehbar bleiben.

### 5. ToDo-Nachverfolgung
- ToDos aus der Sitzung sollen nach dem Termin systematisch weiterverfolgt werden können.
- Das System soll Fälligkeiten und Zuständigkeiten unterstützen.
- Wiedervorlagen und Erinnerungen sollen über n8n automatisiert ausgelöst werden können.[cite:5][cite:7]
- Offene ToDos sollen bei Bedarf automatisch wieder als Agenda-Punkt für eine Folgesitzung eingebracht werden können.

### 6. Kommunikation und Transparenz
- Das System soll optional Eingangsbestätigungen an Einreicher versenden können, wenn ein Agenda-Punkt übernommen wurde.
- Es soll möglich sein, vor oder nach der Sitzung automatisierte Informationsmails an definierte Verteiler zu versenden, etwa als Agenda-Digest oder Ergebnisübersicht.[cite:5]
- Die Bearbeitungshistorie eines Punktes soll im Rahmen der Möglichkeiten von Deck und den begleitenden Prozessen nachvollziehbar sein.[web:13][web:21]

## Technische Anforderungen

### 1. Plattform und Komponenten
- Die Lösung soll auf einer Nextcloud-Umgebung mit verfügbarer Deck-Funktionalität aufsetzen, wie sie auch in Sciebo-nahen oder Nextcloud-basierten Umgebungen eingesetzt wird.[cite:2][web:13][web:21]
- n8n soll als Workflow-Engine zur Orchestrierung von Mailverarbeitung, Statusautomatisierung, Benachrichtigungen und Folgeaktionen eingesetzt werden.[cite:5][web:15]
- Als Eingangskanal soll eine dedizierte Mailadresse verwendet werden, die per IMAP oder vergleichbarer Schnittstelle automatisiert ausgelesen werden kann.[web:15]

### 2. Integration
- Die Lösung muss Mails aus einem dedizierten Postfach lesen können.
- Die Lösung muss neue Einträge in Nextcloud Deck anlegen oder aktualisieren können.
- Die Lösung soll Metadaten aus E-Mails extrahieren können, insbesondere Betreff, Textinhalt, Absender, Datum und ggf. Anhänge.[web:15]
- Die Lösung soll regelbasiert Betreffpräfixe oder Inhaltsmuster verarbeiten können, um Kategorien oder Prioritäten vorzubelegen.
- Die Lösung soll in bestehende hochschulische Infrastruktur integrierbar sein und vorhandene REST-, IMAP-, WebDAV- oder ähnliche Schnittstellen nutzen können, soweit verfügbar.[cite:2]

### 3. Datenschutz und Betrieb
- Die Lösung muss DSGVO-sensibel ausgelegt sein und möglichst innerhalb kontrollierter institutioneller Infrastruktur betrieben werden, da Datenschutz und Systemkontrolle im Nutzungskontext eine hohe Priorität haben.[cite:4][cite:5]
- Externe SaaS-Abhängigkeiten sollen minimiert werden.
- Zugriffe auf Agenda-Daten sollen rollen- und berechtigungsbasiert abgesichert werden.
- Protokollierung und Nachvollziehbarkeit von Automatisierungen sollen im Rahmen der Plattformmöglichkeiten gewährleistet sein.

### 4. Verfügbarkeit und Wartbarkeit
- Die Lösung soll für einen wiederkehrenden wöchentlichen Einsatz mit geringer administrativer Last geeignet sein.
- Fachliche Änderungen, etwa neue Statuswerte, zusätzliche Felder oder neue Benachrichtigungsregeln, sollen mit vertretbarem Aufwand anpassbar sein.
- Die Automatisierungen sollen modular aufgebaut sein, damit einzelne Workflows unabhängig erweitert oder angepasst werden können.[cite:5]

### 5. Benutzbarkeit
- Die Oberfläche für die operative Arbeit soll für nichttechnische Beteiligte verständlich und ohne Spezialschulung nutzbar sein.
- Die Pflege von Agenda-Punkten soll primär in einer sichtbaren, kollaborativen Oberfläche erfolgen und nicht nur in Automatisierungs- oder Administrationswerkzeugen.
- Die Anzahl manueller Zwischenschritte zwischen E-Mail-Eingang, Agenda-Vorbereitung und ToDo-Nachverfolgung soll minimiert werden.

## Nicht im Scope
- Vollständiger Ersatz einer gesamten Groupware- oder Kollaborationsplattform.
- Entwicklung eines eigenständigen, von Nextcloud losgelösten Agenda-Frontends.
- Vollautomatische KI-gestützte Beschlussfassung oder autonome Priorisierung ohne menschliche Prüfung.
- Tiefgehende Sitzungsprotokollierung mit Audio-/Videoaufzeichnung oder Transkriptionssystemen.
- Umfassendes Dokumentenmanagement mit revisionssicherer Aktenführung.
- Mobile Native App-Entwicklung.
- Mandantenfähigkeit für mehrere organisatorische Einheiten außerhalb des primären Anwendungsfalls des Institutsvorstandes TIPS.
- Vollständige Ablösung bestehender Mail-, Kalender- oder Aufgabenlösungen der Hochschule.[cite:2][web:20]

## Abnahmekriterien
- Eine an die Agenda-Mailadresse gesendete E-Mail kann als neuer Agenda-Punkt im vorgesehenen Board erfasst werden.[web:12][web:15]
- Agenda-Punkte können einem definierten Statusmodell zugeordnet und im Board sichtbar verschoben werden.[web:13][web:21]
- Vor der Freitagssitzung kann eine Liste aller vorbereiteten Punkte bereitgestellt oder versendet werden.[cite:1][cite:5]
- Im Termin können Ergebnisse und Folge-ToDos pro Punkt dokumentiert werden.
- Offene ToDos bleiben nach dem Termin sichtbar und nachverfolgbar.

## Annahmen und Randbedingungen
- Eine geeignete Nextcloud-/Sciebo-nahe Umgebung mit Deck-Unterstützung ist verfügbar oder kann bereitgestellt werden.[web:13][web:21]
- Für die dedizierte Agenda-Mailadresse bestehen technische und organisatorische Voraussetzungen.
- n8n darf auf die relevanten Systeme zugreifen und kann mit den erforderlichen Credentials betrieben werden.[cite:5]
- Die beteiligten Nutzer akzeptieren einen standardisierten Prozess für Einreichung, Vorbereitung und Nachverfolgung von Agenda-Punkten.
