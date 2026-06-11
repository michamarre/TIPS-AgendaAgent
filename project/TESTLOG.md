# Test-Log

## 2026-06-10 16:30 - Initiale Projektstruktur und Steuerungsdokumente
**Ergebnis:** PASS
**Output:** `AGENTS.md`, Konfiguration, Projektlogs, Doku-Basis, Templates und Workflow-Ordner fuer TIPS AgendaFlow angelegt. Keine Laufzeitintegration geprueft.

## 2026-06-10 17:25 - P1-02 agenda-n8n Basisvalidierung
**Ergebnis:** WARN
**Output:** `agenda-n8n` und `agenda-n8n-postgres` laufen auf dem VPS. `curl http://127.0.0.1:5680/agenda-n8n/` liefert die n8n-HTML-App. `curl http://127.0.0.1:5680/rest/settings` liefert gueltiges JSON und zeigt `showSetupOnFirstLoad: true`, die Instanz ist also noch im Erstsetup-Modus. Kritischer Befund: `https://paperclip.178.104.156.69.sslip.io/agenda-n8n/rest/settings` liefert HTML statt JSON; die Subpath-REST-Konfiguration ist damit noch nicht korrekt.

## 2026-06-10 17:30 - P1-02a agenda-n8n Proxy-/Pfadfix und Revalidierung
**Ergebnis:** PASS
**Output:** Die manuell ergaenzten `agenda-n8n`-Proxy-Routen in `proxy_host/5.conf` wurden so korrigiert, dass `/agenda-n8n/` vor dem Upstream-Request entfernt wird. `docker exec portfolio-proxy nginx -t` PASS, anschliessend Reload PASS. Revalidierung oeffentlich: `GET /agenda-n8n/rest/settings` -> `200` JSON, `GET /agenda-n8n/rest/login` -> `401` JSON, `POST /agenda-n8n/webhook-test/codex-probe` -> `404` JSON `webhook not registered`. Damit sind REST-, Login- und Webhook-Testpfade ueber den oeffentlichen Subpath korrekt verdrahtet. Die Instanz bleibt noch im Erstsetup-Modus.

## 2026-06-10 17:40 - P1-03 agenda-n8n Bootstrap, API-Key und Deploy-Pfad
**Ergebnis:** PASS
**Output:** Owner-Setup erfolgreich ueber `POST /agenda-n8n/rest/owner/setup` ausgefuehrt. Danach liefert `GET /agenda-n8n/rest/settings` den Wert `showSetupOnFirstLoad: false`. Login gegen `POST /agenda-n8n/rest/login` erfolgreich. Erlaubte API-Key-Scopes ueber `GET /agenda-n8n/rest/api-keys/scopes` ermittelt. Ein Public-API-Key `AgendaAgent CLI` mit Workflow-, Credential-, Project- und Execution-Scopes erzeugt. Revalidierung: `GET /agenda-n8n/api/v1/workflows` mit `X-N8N-API-KEY` liefert `200` und `{\"data\":[],\"nextCursor\":null}`. Lokale Konfiguration auf `N8N_WEBHOOK_BASE_URL=https://paperclip.178.104.156.69.sslip.io/agenda-n8n` und `N8N_API_BASE=https://paperclip.178.104.156.69.sslip.io/agenda-n8n/api/v1` umgestellt.

## 2026-06-10 19:20 - P1-04 Sciebo/Deck Basiszugriff
**Ergebnis:** PASS
**Output:** Zugriff auf `https://fh-swf.sciebo.de/index.php/apps/deck/api/v1.0` mit Basic Auth gegen das App-Passwort erfolgreich. `GET /boards/1919` liefert `200` und Board `Instiut` mit Owner `tips.pbox@fh-swf.de`, Labels und Stack `Backlog` (`id=5678`). `GET /boards/1919/stacks` liefert `200` und bestaetigt den Stack `Backlog`. Die erwarteten Card-Endpunkte `GET /boards/1919/stacks/5678/cards` und `GET /stacks/5678/cards` liefern in dieser Sciebo-/Deck-Version aktuell `405 Method Not Allowed`; das ist als Folgepunkt fuer P1-05 offen.

## 2026-06-10 19:22 - P1-05 Deck-Karten-Endpunkte Board 1919
**Ergebnis:** PASS
**Output:** Testkarte erfolgreich angelegt ueber `POST /boards/1919/stacks/5678/cards` mit Rueckgabe `id=8585`. Sammlungspfad `GET /boards/1919/stacks/5678/cards` liefert in dieser Instanz weiterhin `405`, ist also kein lesender Collection-Endpunkt. Ruecklese erfolgreich ueber `GET /boards/1919/stacks/5678/cards/8585`. Loeschen erfolgreich ueber `DELETE /boards/1919/stacks/5678/cards/8585`; anschliessende Verifikation liefert `403` mit `Card is deleted`. Damit ist der reale Kartenpfad fuer diese Deck-Version geklaert: Create und Read/Delete funktionieren ueber den Board+Stack+Card-ID-Pfad.

## 2026-06-10 19:35 - P1-06 Outlook-Ordner `__Agenda` als MVP-Eingangskanal
**Ergebnis:** PASS
**Output:** Der Outlook-Ordner `__Agenda` ist angelegt und als temporaerer Eingangskanal fuer den MVP festgelegt. Die konkrete Einsortierlogik per Outlook-Regel oder manuell ist aktuell nachrangig. Naechster technischer Fokus ist ausschliesslich der lesende Zugriff auf genau diesen Ordner per Microsoft Graph.

## 2026-06-10 19:45 - P1-07 Graph-Zugriff auf `__Agenda`
**Ergebnis:** PASS
**Output:** Microsoft Graph Zugriff auf das reale Outlook-Postfach `marre.michael@lfm-fh-swf.de` erfolgreich verifiziert. `GET /users/{user}/mailFolders?$top=50` und `GET /users/{user}/mailFolders/inbox/childFolders?$top=100` liefern die Ordnerstruktur. Der Ordner `__Agenda` wurde unter `Posteingang` gefunden mit `id=AAMkADM3ZDhmZDc1LTIwYmQtNDlmZS1hMWE2LWI5OTAxYTlkZWIxMAAuAAAAAAAkH0jcZmphQ4D6jBE3b4iQAQA4d7TUfWQcRJjaCy_7yagjAAX0HNZOAAA=` und `totalItemCount=1`. Eine Beispielmail wurde erfolgreich gelesen: Betreff `Re: Austausch WI/ FHSWF`, Absender `Manuel Bickel <manuel.bickel@wupperinst.org>`, Eingang `2026-06-10T14:24:19Z`, `hasAttachments=true`.

## 2026-06-10 19:55 - P2-01 MVP-Statusmodell
**Ergebnis:** PASS
**Output:** Ein umsetzbares MVP-Statusmodell fuer AgendaFlow wurde definiert und dokumentiert. Die Statuskette lautet `Eingang -> Rueckfrage -> Vorbereitung -> Freitagsagenda -> Beschlossen -> ToDo laeuft -> Erledigt`. Der Outlook-Ordner `__Agenda` ist dabei nur Eingangskanal; der fachliche Status wird in Deck gefuehrt.

## 2026-06-10 20:05 - P2-02 Kategorien und Pflichtfelder
**Ergebnis:** PASS
**Output:** Vier MVP-Kategorien (`Information`, `Diskussion`, `Beschluss`, `Sonstiges`) sowie technische und fachliche Pflichtfelder fuer Agenda-Karten definiert. Der Mindestimport aus Outlook `__Agenda` setzt technische Referenzen, Einreicherdaten, Eingangsdatum, Titel, Beschreibung, Kategorie und Startstatus `Eingang`.

## 2026-06-10 20:20 - P2-03 Rollen und Rechte
**Ergebnis:** PASS
**Output:** Rollenmodell fuer den MVP festgelegt und entlang von Outlook `__Agenda`, Microsoft Graph, Nextcloud Deck und `agenda-n8n` abgegrenzt. Dokumentiert wurden `Mailbox Owner`, `Agenda Koordination`, `Sitzungsleitung`, `Bearbeitung / Vorbereitung`, `n8n Operator` und `System Admin` sowie der minimale Rechtezuschnitt und die bewussten Personen- und Betriebsrisiken der Uebergangsloesung.

## 2026-06-10 20:35 - P2-04 Deck-Board-Design
**Ergebnis:** PASS
**Output:** Das Soll-Design fuer Board `1919` wurde aus Statusmodell, Kategorien und Pflichtfeldern abgeleitet. Definiert wurden sieben Ziel-Stacks entsprechend dem MVP-Statusmodell, die empfohlene Umbenennung von `Backlog` nach `Eingang`, ein schlankes Label-Modell fuer Kategorien und Bearbeitungshinweise sowie ein standardisierter Kartenbeschreibungsblock fuer Fach- und Technikfelder.

## 2026-06-10 20:45 - Deck-Board 1919 auf MVP-Struktur umgestellt
**Ergebnis:** PASS
**Output:** Board `1919` wurde real angepasst: Board-Titel auf `TIPS AgendaFlow` gesetzt, `Backlog` in `Eingang` umbenannt und die Stacks `Rueckfrage`, `Vorbereitung`, `Freitagsagenda`, `Beschlossen`, `ToDo laeuft` und `Erledigt` angelegt. Zusaetzlich wurden die Kategorien-Labels `Information`, `Diskussion`, `Beschluss` und `Sonstiges` erstellt. Die finalen Stack-IDs sind `5678`, `5681`, `5684`, `5687`, `5690`, `5693`, `5696`.

## 2026-06-10 20:55 - P2-05 Mail-to-Deck-Mapping
**Ergebnis:** PASS
**Output:** Das konkrete MVP-Mapping von Outlook-Mails aus `__Agenda` auf Deck-Karten im Board `1919` wurde festgelegt. Dokumentiert sind Quellfelder aus Microsoft Graph, Zielstack `Eingang` (`5678`), Kategorien-Label-IDs, Titel- und Beschreibungsregeln, Sichtbarkeit von Anhaengen sowie die technischen Referenzen fuer spaetere Dublettenerkennung.

## 2026-06-10 21:10 - P2-06 MVP-Abgrenzung und Betriebsannahmen
**Ergebnis:** PASS
**Output:** Die reale MVP-Abgrenzung gegenueber PRD und Zielbild wurde dokumentiert. Festgelegt ist jetzt, dass der MVP nur den End-to-End-Kern `Outlook __Agenda -> Graph -> n8n -> Deck Karte im Stack Eingang` liefern muss. Nicht Teil des MVP sind derzeit dedizierte Agenda-Mailadresse, IMAP, Outbound-Mails, Anhangssync, Wiedervorlage- und ToDo-Automation.

## 2026-06-10 21:25 - P3-01 Workflow `mail-to-agenda`
**Ergebnis:** PASS
**Output:** Der MVP-Kernworkflow wurde als baubare n8n-Spezifikation dokumentiert. Festgelegt sind Cron-Trigger, benoetigte Graph- und Deck-Credentials, Node-Folge vom Lesen der Mails ueber Feldnormalisierung und Beschreibungsaufbau bis zu Deck-Create und Label-Zuweisung sowie das minimale Fehler- und Erfolgslogging.

## 2026-06-10 21:45 - P3-02 bis P3-04 Importregeln gehaertet
**Ergebnis:** PASS
**Output:** Die offene Workflow-Spezifikation wurde entlang der drei verbleibenden Regelbereiche geschaerft: Dubletten werden im MVP primaer ueber `source_message_id` behandelt, problematische aber lesbare Mails mit Fallbacks und optionalem Label `Zu ueberpruefen` importiert, und technisches Logging erfolgt vorerst ausschliesslich ueber standardisierte n8n-Execution-Daten ohne automatische Eingangs- oder Fehlermails.

## 2026-06-10 22:10 - P3-05 Workflow gebaut, deployed und erfolgreich getestet
**Ergebnis:** PASS
**Output:** `workflow-mail-to-agenda` als reales n8n-Workflow-JSON gebaut, per Public API in `agenda-n8n` importiert und aktiviert. Serverseitig wurden die benoetigten Agenda-/Deck-Umgebungsvariablen in `/home/deploy/n8n/.env` ergaenzt und `agenda-n8n` neu erstellt. Nach drei gezielten Runtime-Fixes liefen die Executions `1` bis `3` noch in Fehlerbilder (`URLSearchParams`, `fetch`, Deck-Auth), Execution `4` war erfolgreich. Verifizierter Endzustand: Mail aus Outlook `__Agenda` importiert, Deck-Karte `8588` im Stack `Eingang` (`5678`) erzeugt, Labels `Sonstiges` (`7916`) und `Zu ueberpruefen` (`7898`) gesetzt.

## 2026-06-10 22:20 - P4-01 Wochenagenda-Workflow
**Ergebnis:** PASS
**Output:** Der Workflow `wochenagenda` wurde als fachlich belastbare Spezifikation definiert. Grundlage ist ausschliesslich der Stack `Freitagsagenda` (`5687`) im Board `1919`. Festgelegt sind Trigger, Auswahlregel, Sortierung, Warnfaelle und die Markdown-Ausgabe fuer die Sitzungskoordination. Automatischer Versand bleibt bewusst noch ausserhalb dieses Schritts.

## 2026-06-10 22:35 - P4-02 und P4-03 Sitzungsschema und ToDo-Ableitung
**Ergebnis:** PASS
**Output:** Ein textbasiertes Sitzungsnotiz-Schema fuer Entscheidungen direkt an der Agenda-Karte wurde festgelegt. Darauf aufbauend ist die MVP-ToDo-Ableitung modelliert: Folgeaufgaben bleiben an derselben Karte, nutzen einen standardisierten `ToDos`-Block mit Verantwortlichen, Frist und Status und fuehren in der Regel zum Status `ToDo laeuft`.

## 2026-06-10 22:33 - P4-04 Reminder- und Wiedervorlage-Workflow
**Ergebnis:** PASS
**Output:** `workflow-erinnerungen-vorbereitung` gebaut, per Public API in `agenda-n8n` importiert und ueber einen temporaeren Minutentakt gegen das reale Board getestet. Zunaechst wurde ein Datenmodellierungsfehler sichtbar, weil der `HTTP Request`-Node die Stackliste als mehrere Items weitergab; nach Fix auf `$input.all()` lieferte der Workflow korrekt `due_items_found` mit zwei Testkarten. Die Reminder-Ausgabe erkannte sowohl `Wiedervorlage/Frist` in `Vorbereitung` als auch offenes ToDo plus Wiedervorlage in `ToDo laeuft`.

## 2026-06-10 22:38 - P4-05 Re-Agenda-Regeln
**Ergebnis:** PASS
**Output:** `workflow-reagenda-offene-punkte` gebaut, in `agenda-n8n` deployed und gegen eine echte Testkarte in `ToDo laeuft` validiert. Vorher wurde live nachgewiesen, dass Deck-`reorder` in dieser Sciebo-Instanz zwar `200` liefert, Karten aber nicht in den Zielstack bewegt. Deshalb nutzt der Workflow einen Workaround: Zielkarte erzeugen, Kategorie- und Hinweislabels setzen, Quelle loeschen. Der erfolgreiche Test erzeugte eine neue Karte in `Freitagsagenda` mit `Status: Freitagsagenda`, `Automation`-Block und Labels `Diskussion`, `Zu ueberpruefen` und `Handlung erforderlich`; die Ursprungskarte wurde entfernt.

## 2026-06-10 22:42 - P5-01 bis P5-05 Test-, Betriebs- und Handover-Dokumentation
**Ergebnis:** PASS
**Output:** Testdrehbuch, Runbook, Datenschutz-/Logging-Dokumentation, README und Troubleshooting wurden auf den realen MVP-Stand gebracht. Negativtests fuer Deck-Collection-GET, Deck-Reorder und n8n-Code-Node-HTTP sind jetzt explizit dokumentiert; der End-to-End-Nachweis umfasst Mailimport, Reminder und Re-Agenda in der Zielumgebung.

## 2026-06-11 08:20 - P6-01 Lokaler Deck-Smoke-Test Basic-Auth-Bildung
**Ergebnis:** FAIL
**Output:** Der erste lokale Re-Smoke gegen `GET /boards/1919/stacks` lieferte `Current user is not logged in`, obwohl die Zugangsdaten selbst korrekt waren.
**Fix:** Basic-Auth-Header lokal neu gebaut, wobei der PowerShell-Formatoperator zuerst ausgewertet und erst danach Base64-kodiert wurde.

## 2026-06-11 08:32 - P6-01 Re-Smoke Graph, Deck und agenda-n8n
**Ergebnis:** PASS
**Output:** Graph-Lesezugriff auf Outlook `__Agenda` erneut erfolgreich; letzte Mail `Re: Austausch WI/ FHSWF` vom `2026-06-10T14:24:19Z` lesbar. Deck-Zugriff auf Board `1919` erfolgreich; sieben Ziel-Stacks `Eingang`, `Rueckfrage`, `Vorbereitung`, `Freitagsagenda`, `Beschlossen`, `ToDo laeuft`, `Erledigt` bestaetigt. `agenda-n8n` Public API erfolgreich; drei AgendaFlow-Workflows vorhanden. `workflow-mail-to-agenda` ist `active=true` und zeigte zuletzt wiederholte Success-Executions am `2026-06-11` zwischen `05:45:00Z` und `06:30:02Z`. Reminder und Re-Agenda sind weiterhin deployed, aber `active=false`.

## 2026-06-11 09:00 - P6-05 Aktivierungs- und Betriebsstrategie
**Ergebnis:** PASS
**Output:** Die Betriebsstrategie fuer die Folgeworkflows wurde dokumentarisch festgelegt. `workflow-mail-to-agenda` bleibt aktiv. Reminder und Re-Agenda bleiben vorerst deployed, aber nicht automatisch aktiviert. Fuer offene Punkte gilt als Standardfall die Wiedereinplanung in den naechsten regulaeren Wochenlauf, also wieder eine Woche spaeter. Die Rotation des bestehenden `agenda-n8n`-API-Keys wurde fuer das laufende MVP-Testfenster bewusst vertagt.
