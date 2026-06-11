# Troubleshooting

## TR-001: Markdown-Dateien zeigen kaputtes Encoding
**Symptom:** Umlaute oder Anfuehrungszeichen erscheinen als Kauderwelsch.
**Cause:** Datei wurde mit falschem Encoding gespeichert.
**Fix:** Betroffene Markdown-Datei explizit als UTF-8 neu schreiben.

## TR-002: Agenda-Mail wird verarbeitet, aber keine Deck-Karte entsteht
**Symptom:** n8n meldet Mail-Eingang, im Deck-Board erscheint jedoch keine neue Karte.
**Cause:** Deck-Board-ID, API-Rechte oder Feldmapping sind unvollstaendig.
**Fix:** Nextcloud-Zugriff pruefen, Board-ID gegen `config/placeholders.env` abgleichen und Mapping-Log kontrollieren.

## TR-003: Wochenagenda-Digest ist leer trotz vorbereiteter Punkte
**Symptom:** Der Digest wird versendet, enthaelt aber keine Themen.
**Cause:** Filter fuer den Zielstatus oder den Sitzungstermin greift falsch.
**Fix:** Status `Freitagsagenda` und Terminlogik im Workflow pruefen.

## TR-004: `agenda-n8n` liefert unter `/agenda-n8n/rest/*` HTML statt JSON
**Symptom:** Aufrufe wie `/agenda-n8n/rest/settings` liefern die SPA-HTML-Seite statt einer REST-Antwort.
**Cause:** Die aktuelle Subpath-/Proxy-Konfiguration fuer `agenda-n8n` ist fuer REST-Routen nicht korrekt verdrahtet oder wird falsch rewritten.
**Fix:** Proxy- und n8n-Pfadkonfiguration gemeinsam pruefen. Referenztest: `http://127.0.0.1:5680/rest/settings` muss JSON liefern, und dieselbe Semantik muss anschliessend auch oeffentlich unter `/agenda-n8n/rest/settings` funktionieren. In `proxy_host/5.conf` mussten die `agenda-n8n`-Routen auf `proxy_pass .../;`, `.../webhook/;` und `.../webhook-test/;` umgestellt werden, damit der Prefix sauber entfernt wird.

## TR-005: Sciebo Deck liefert fuer erwartete `cards`-GET-Endpunkte `405 Method Not Allowed`
**Symptom:** `GET /boards/1919/stacks/5678/cards` und Varianten wie `/stacks/5678/cards` liefern `405`, obwohl Board und Stacks lesbar sind.
**Cause:** Entweder verwendet die eingesetzte Deck-Version in Sciebo einen abweichenden Karten-Endpunkt, oder der Endpunkt erwartet in dieser Umgebung einen anderen Zugriffspfad als die gaengige REST-Dokumentation.
**Fix:** Fuer diese Instanz den tatsaechlich unterstuetzten Card-Lese-/Schreibpfad separat ermitteln. Verifiziert wurde: `POST /boards/{boardId}/stacks/{stackId}/cards` funktioniert fuer die Anlage, `GET /boards/{boardId}/stacks/{stackId}/cards/{cardId}` funktioniert fuer das Ruecklesen, `DELETE /boards/{boardId}/stacks/{stackId}/cards/{cardId}` funktioniert fuer das Loeschen. Der Collection-GET-Endpunkt selbst bleibt in dieser Umgebung weiterhin `405`.

## TR-006: n8n-Code-Node bricht mit `URLSearchParams is not defined` oder `fetch is not defined` ab
**Symptom:** Ein Workflow scheitert in einer Code-Node sofort, obwohl die JavaScript-Logik ausserhalb von n8n plausibel ist.
**Cause:** Die Code-Node-Laufzeit in dieser n8n-Version stellt keine HTTP-Request-APIs fuer Netzwerkaction bereit.
**Fix:** Alle externen Aufrufe in `HTTP Request`-Nodes verschieben und Code-Nodes nur fuer Datenlogik verwenden.

## TR-007: Deck-Aufrufe aus n8n liefern `401 Current user is not logged in`
**Symptom:** `HTTP Request`-Nodes gegen Deck schlagen mit `401` fehl, obwohl dieselben Zugangsdaten in PowerShell oder `curl` funktionieren.
**Cause:** Die Inline-Bildung des Basic-Auth-Headers im Workflow ist in dieser Umgebung nicht belastbar genug.
**Fix:** `NEXTCLOUD_BASIC_AUTH` als vorcodierten Base64-Wert in der Server-`.env` pflegen und im Workflow direkt als `Authorization: Basic <wert>` verwenden.

## TR-008: Reminder- oder Re-Agenda-Workflow findet keine Karten, obwohl faellige Karten vorhanden sind
**Symptom:** Reminder-Ausgabe bleibt leer oder Re-Agenda verarbeitet keine Kandidaten.
**Cause:** Der Workflow erwartet faelschlich ein Array aus dem `HTTP Request`-Node, waehrend n8n die Stack-Antwort als mehrere Items weitergibt.
**Fix:** In Code-Nodes `const stacks = $input.all().map((item) => item.json || {})` verwenden und nicht nur `$input.first().json`.

## TR-009: Re-Agenda verliert `target_card_id` nach Label-Zuweisung
**Symptom:** Folgende HTTP-Requests laufen auf URLs mit `.../stacks/undefined/cards/undefined/...`.
**Cause:** `HTTP Request`-Nodes fuer Label-Zuweisung geben ihre API-Antwort weiter und verlieren damit den urspruenglichen Kartenkontext.
**Fix:** Nach Label- und Delete-Schritten den Originalkontext ueber kleine Code-Nodes wiederherstellen, bevor weitere Requests darauf aufbauen.

## TR-010: Deck-Reorder antwortet erfolgreich, verschiebt die Karte aber nicht
**Symptom:** `PUT .../reorder` liefert `200`, die Karte bleibt trotzdem im Ursprungsstack.
**Cause:** Die eingesetzte Sciebo-/Deck-Version ignoriert das Ziel-`stackId` beim Cross-Stack-Move.
**Fix:** Re-Agenda ueber `copy -> relabel -> delete` implementieren und die neue Herkunft im Beschreibungstext notieren.

## TR-011: Lokaler Deck-Smoke-Test scheitert trotz gueltiger Zugangsdaten mit `Current user is not logged in`
**Symptom:** Ein lokaler PowerShell-Test gegen Deck liefert `401 Current user is not logged in`, obwohl Benutzername und App-Passwort korrekt sind.
**Cause:** Der Basic-Auth-Header wurde lokal fehlerhaft gebaut, weil der PowerShell-Formatoperator nicht vor der Base64-Kodierung ausgewertet wurde.
**Fix:** Den Klartext immer zuerst mit `("{0}:{1}" -f $user, $password)` bilden und erst danach per `GetBytes()` und Base64 kodieren.
