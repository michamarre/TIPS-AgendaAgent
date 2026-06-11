# LEARNINGS.md
## Persistentes Fehlergedaechtnis: TIPS AgendaFlow

Dieses Dokument wird vom Agenten automatisch gepflegt.
VOR JEDEM CODING-TASK ZUERST LESEN.
Nach jedem Fehler sofort ergaenzen, nicht erst am Ende der Session.

Eintraege: 10
Letzte Aktualisierung: 2026-06-11

## L-001: Encoding-Probleme sofort mit UTF-8 normalisieren

**Status:** Achtung
**Aufgetreten in:** Initiale Projektmigration, 2026-06-10
**Technologie:** PowerShell / Markdown

**Gescheiterter Weg:**
Markdown-Dateien ohne explizite Encoding-Kontrolle weiterverwenden.

**Fehler / Symptom:**
Umlaute und typografische Zeichen erscheinen als Kauderwelsch.

**Ursache:**
Dateien wurden zuvor nicht durchgaengig UTF-8-konsistent gespeichert.

**Recherche:**
Ableitung aus dem Referenzprojekt `email-sync-agent`.

**Funktionierende Loesung:**
Markdown-Dateien bei Reparaturen explizit als UTF-8 neu schreiben und Encoding-Probleme frueh bereinigen.

**Merksatz:**
Encoding-Fehler nicht ignorieren; sie verunreinigen alle Folgeartefakte.

## L-002: Fuer JSON-POSTs gegen n8n unter Windows ist `Invoke-WebRequest` robuster als `curl.exe`

**Status:** Bewaehrt
**Aufgetreten in:** Task P1-03, 2026-06-10
**Technologie:** PowerShell / n8n REST API

**Gescheiterter Weg:**
Owner-Setup und API-Key-Requests mit `curl.exe` und inline oder dateibasierten JSON-Bodies absetzen.

**Fehler / Symptom:**
n8n meldet wiederholt `Failed to parse request body`, obwohl der Endpoint selbst korrekt existiert.

**Ursache:**
Windows-/PowerShell-Quoting und Body-Uebergabe an `curl.exe` waren in dieser Umgebung fehleranfaellig.

**Recherche:**
Direkter Vergleich mit `Invoke-WebRequest` gegen denselben Endpoint.

**Funktionierende Loesung:**
JSON-POSTs fuer n8n-Setup und authentifizierte REST-Operationen in PowerShell mit `Invoke-WebRequest` und explizitem `-ContentType 'application/json'` absetzen.

**Merksatz:**
Wenn n8n unter Windows scheinbar grundlos den Request-Body nicht parsen kann, zuerst `Invoke-WebRequest` statt `curl.exe` verwenden.

## L-003: n8n-Code-Nodes duerfen in dieser Laufzeit keine HTTP-Requests absetzen

**Status:** Bewaehrt
**Aufgetreten in:** Task P3-05, 2026-06-10
**Technologie:** n8n Code Node / HTTP Request Node

**Gescheiterter Weg:**
Graph- und Deck-Aufrufe direkt in Code-Nodes mit `fetch` oder `URLSearchParams` implementieren.

**Fehler / Symptom:**
Executions brechen mit `URLSearchParams is not defined` und danach mit `fetch is not defined` ab.

**Ursache:**
Die Code-Node-Umgebung in dieser n8n-Version erlaubt keine HTTP-Requests und stellt typische Web-APIs nicht bereit.

**Recherche:**
Execution-Analyse gegen `agenda-n8n` und Abgleich mit der offiziellen n8n-Code-Node-Dokumentation.

**Funktionierende Loesung:**
HTTP-Aufrufe konsequent in `HTTP Request`-Nodes auslagern und Code-Nodes nur fuer Transformation, Mapping und Statuslogik nutzen.

**Merksatz:**
In n8n erst Datenlogik in Code-Nodes, Netzwerkaction aber immer in `HTTP Request`-Nodes.

## L-004: Deck-Basic-Auth in n8n robuster ueber vorcodierten Env-Wert statt Inline-Berechnung

**Status:** Bewaehrt
**Aufgetreten in:** Task P3-05, 2026-06-10
**Technologie:** n8n HTTP Request / Nextcloud Deck

**Gescheiterter Weg:**
Basic-Auth-Header im Node-Ausdruck direkt mit `Buffer.from(user + ':' + pass).toString('base64')` erzeugen.

**Fehler / Symptom:**
Deck-Create liefert `401 Current user is not logged in`, obwohl dieselben Zugangsdaten ausserhalb von n8n funktionieren.

**Ursache:**
Die Header-Bildung im HTTP-Node war in dieser Konstellation nicht belastbar genug oder schwer verifizierbar.

**Recherche:**
Vergleich zwischen erfolgreichem PowerShell-Zugriff und fehlgeschlagenem n8n-Node-Aufruf.

**Funktionierende Loesung:**
`NEXTCLOUD_BASIC_AUTH` serverseitig als fertigen Base64-Wert in `.env` setzen und im Workflow nur noch als `Authorization: Basic <wert>` referenzieren.

**Merksatz:**
Wenn Basic-Auth in n8n merkwuerdig scheitert, die Kodierung aus dem Workflow herausziehen und als fertigen Env-Wert bereitstellen.

## L-005: In dieser Sciebo-Instanz kommen Karten lesbar ueber `GET /boards/{boardId}/stacks`, nicht ueber den Collection-Card-Endpunkt

**Status:** Bewaehrt
**Aufgetreten in:** Task P4-04, 2026-06-10
**Technologie:** Nextcloud Deck API / Sciebo

**Gescheiterter Weg:**
Reminder- und Re-Agenda-Workflows auf `GET /boards/{boardId}/stacks/{stackId}/cards` aufbauen.

**Fehler / Symptom:**
Der erwartete Collection-Endpunkt liefert `405 Method Not Allowed`.

**Ursache:**
Die eingesetzte Deck-Version in dieser Umgebung expose-t Karten nur indirekt ueber den Stack-Index.

**Recherche:**
Direkter API-Vergleich gegen Board-, Stack- und Card-ID-Endpunkte.

**Funktionierende Loesung:**
`GET /boards/1919/stacks` als primaren Lesepfad verwenden und die eingebetteten `cards` aus den Stack-Objekten auswerten.

**Merksatz:**
In dieser Sciebo-Instanz immer zuerst den Stack-Index lesen; nicht vom dokumentierten Karten-Collection-GET ausgehen.

## L-006: Deck-Reorder zwischen Stacks ist in dieser Sciebo-Instanz faktisch kaputt

**Status:** Achtung
**Aufgetreten in:** Task P4-05, 2026-06-10
**Technologie:** Nextcloud Deck API / Re-Agenda

**Gescheiterter Weg:**
Cards mit `PUT /boards/{boardId}/stacks/{stackId}/cards/{cardId}/reorder` in einen anderen Stack verschieben.

**Fehler / Symptom:**
Die API antwortet `200`, aber die Karte bleibt im Ursprungsstack.

**Ursache:**
Das Ziel-`stackId` wird in dieser Instanz beim Reorder-Aufruf effektiv ignoriert.

**Recherche:**
Live-Test mit Testkarte und Ruecklesen ueber Card-ID; Befund deckt sich mit aktuellen Upstream-Problemen.

**Funktionierende Loesung:**
Fuer Re-Agenda `copy -> labels setzen -> Quelle loeschen` statt echtem Stack-Move.

**Merksatz:**
Cross-Stack-Moves nicht vertrauen; fuer belastbare Automatisierung hier nur den Copy-Delete-Weg verwenden.

## L-007: PowerShell-Formatoperator bei Basic-Auth immer vor `GetBytes()` auswerten

**Status:** Bewaehrt
**Aufgetreten in:** Smoke-Test Produktivhaertung, 2026-06-11
**Technologie:** PowerShell / Nextcloud Deck API

**Gescheiterter Weg:**
Den Ausdruck `"{0}:{1}" -f user, password` direkt innerhalb von `GetBytes()` ohne Klammerung verwenden.

**Fehler / Symptom:**
Der Testlauf bricht mit `FormatError` ab; der erzeugte Authorization-Header ist ungueltig und Deck antwortet danach mit `Current user is not logged in`.

**Ursache:**
Die String-Formatierung wurde nicht vor der Byte-Konvertierung ausgewertet.

**Recherche:**
Direkte Reproduktion im lokalen Smoke-Test gegen die Deck-API.

**Funktionierende Loesung:**
Den Formatoperator immer geklammert auswerten, also `("{0}:{1}" -f $user, $password)`, und erst danach per Base64 kodieren.

**Merksatz:**
Bei Basic-Auth in PowerShell erst den Klartextstring bauen, dann kodieren.

## L-008: PowerShell-Kommandos fuer `rg`-Regex und Objektpipelines parserfest halten

**Status:** Bewaehrt
**Aufgetreten in:** Smoke-Test Produktivhaertung, 2026-06-11
**Technologie:** PowerShell / `rg`

**Gescheiterter Weg:**
Komplexe Regex-Alternativen und Objektpipelines in einer Zeile mit unklarer Quote- und Pipe-Bindung an PowerShell uebergeben.

**Fehler / Symptom:**
PowerShell interpretiert Teile des Musters als eigene Befehle oder meldet `Ein leeres Pipeelement ist nicht zulaessig`.

**Ursache:**
Die PowerShell-Parserregeln greifen vor `rg` und vor der JSON-Ausgabe, wenn Regexe oder Pipelines nicht eindeutig gekapselt sind.

**Recherche:**
Direkte Reproduktion in lokalen Validierungskommandos.

**Funktionierende Loesung:**
Regex-Muster in einfachen Quotes an `rg` uebergeben und Objektlisten zuerst in Variablen sammeln oder je Datei getrennt ausgeben.

**Merksatz:**
Bei PowerShell lieber zwei einfache Pruefkommandos als eine clever verkettete Einzeile.

## L-009: Fuer groessere Zeichenersetzungen in PowerShell Here-Strings statt Inline-Quoting verwenden

**Status:** Bewaehrt
**Aufgetreten in:** Encoding-Bereinigung Leitdokumente, 2026-06-11
**Technologie:** PowerShell / Textnormalisierung

**Gescheiterter Weg:**
Viele Zeichenersetzungen mit gemischten einfachen und doppelten Quotes in einer einzigen Inline-Command-Zeile formulieren.

**Fehler / Symptom:**
PowerShell bricht mit `Die Zeichenfolge hat kein Abschlusszeichen` ab.

**Ursache:**
Mehrere verschachtelte Quote-Arten und Escape-Faelle machen die Einzeile parserinstabil.

**Recherche:**
Direkter Fehlversuch bei der UTF-8-/ASCII-Normalisierung von `prd.md` und `plan.md`.

**Funktionierende Loesung:**
Laengere Transformationsskripte als Here-String an PowerShell uebergeben und die Ersetzungstabelle darin klar strukturieren.

**Merksatz:**
Sobald Texttransformationen mehr als wenige Escape-Faelle haben, keine Einzeile mehr erzwingen.

## L-010: In dieser PowerShell-Umgebung keine Bash-Trenner wie `&&` verwenden

**Status:** Bewaehrt
**Aufgetreten in:** Git-Konsolidierung Morgenstand, 2026-06-11
**Technologie:** PowerShell / Git

**Gescheiterter Weg:**
Mehrere Git-Befehle mit `&&` wie in Bash verketten.

**Fehler / Symptom:**
PowerShell bricht mit `Das Token "&&" ist in dieser Version kein gueltiges Anweisungstrennzeichen` ab.

**Ursache:**
Die verwendete PowerShell-Version unterstuetzt `&&` nicht als Befehlstrenner.

**Recherche:**
Direkte Reproduktion beim Versuch, `git add`, `git commit` und `git push` in einer Zeile auszufuehren.

**Funktionierende Loesung:**
Git-Befehle in PowerShell mit `;` sequenziell ausfuehren oder als getrennte Kommandos senden.

**Merksatz:**
In dieser Umgebung Bash-Gewohnheiten ablegen und PowerShell-Syntax erzwingen.
