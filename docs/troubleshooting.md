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
