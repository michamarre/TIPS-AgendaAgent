# Outlook Ordner `__Agenda`

## Zweck

Fuer den MVP dient nicht ein separates Agenda-Postfach als Eingangskanal, sondern der Outlook-Unterordner `__Agenda` im persoenlichen Posteingang.

## Verifizierter Mailpfad

- Mailbox: `marre.michael@lfm-fh-swf.de`
- Parent Folder: `Posteingang`
- Child Folder: `__Agenda`

## Verifizierte Graph-Ordner-ID

`AAMkADM3ZDhmZDc1LTIwYmQtNDlmZS1hMWE2LWI5OTAxYTlkZWIxMAAuAAAAAAAkH0jcZmphQ4D6jBE3b4iQAQA4d7TUfWQcRJjaCy_7yagjAAX0HNZOAAA=`

## Verifizierte Graph-Aufrufe

Ordnerstruktur:

- `GET /users/{user}/mailFolders?$top=50`
- `GET /users/{user}/mailFolders/inbox/childFolders?$top=100`

Mails aus `__Agenda`:

- `GET /users/{user}/mailFolders/{agendaFolderId}/messages?$top=5&$orderby=receivedDateTime desc&$select=id,subject,from,receivedDateTime,hasAttachments,isRead,bodyPreview,internetMessageId`

## Verifizierter Beispielinhalt

Zum Zeitpunkt der Pruefung lag genau eine Beispielmail im Ordner:

- Betreff: `Re: Austausch WI/ FHSWF`
- Absender: `Manuel Bickel <manuel.bickel@wupperinst.org>`
- Eingangszeitpunkt: `2026-06-10T14:24:19Z`
- `hasAttachments=true`

## Bedeutung fuer die Umsetzung

Damit ist der komplette MVP-Eingangskanal technisch verifiziert:

1. Mail landet in Outlook
2. Mail liegt im Ordner `__Agenda`
3. Microsoft Graph kann den Ordner eindeutig finden
4. Microsoft Graph kann die Mail daraus lesen

## Offene Punkte

- Regel oder manueller Verschiebeprozess nach `__Agenda`
- spaetere Strategie fuer verarbeitete Mails, z. B. weiterer Ordner oder Markierung
- Abbildung des Maileingangs auf das fachliche Statusmodell in Deck
