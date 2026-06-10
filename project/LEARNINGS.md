# LEARNINGS.md
## Persistentes Fehlergedaechtnis: TIPS AgendaFlow

Dieses Dokument wird vom Agenten automatisch gepflegt.
VOR JEDEM CODING-TASK ZUERST LESEN.
Nach jedem Fehler sofort ergaenzen, nicht erst am Ende der Session.

Eintraege: 1
Letzte Aktualisierung: 2026-06-10

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
