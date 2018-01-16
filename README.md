# 00_Installation und Konfiguration von Asymptote in LaTeX

Hier ein bisschen Erfahrung über die Installation sowie Anwendung von dem Modul der Asymptote zum Erstellen von Zeichnungen in LaTeX. Vielen Dank an unserer HiWi Hendrik, der das Modul schreibt. 

  *	Vorbereitung
  1.	TeX Live  https://www.tug.org/texlive/ 
  2.	TeX Studio http://www.texstudio.org/ 
  3.	Ghostscript (ggf. nicht erf.) https://www.ghostscript.com/download/gsdnld.html
  4.	Das Packagemodul (5 *.asy-Dateien)

  *	Installation
  1. Installation von TeX Live (dauert stundenlang, da alle Pakete installiert werden)
  2. Installation von TeX Studio
  3. Installation von Ghostscript
  4. Verschieben der 5 *.asy-Dateien in Asymptote-Ordner (bei mir: C:\texlive\2017\texmf-dist\asymptote)
  5. Im Asymptote-Ordner eine neue config.asy Datei erstellen und füge das folgende Code ein (gs das Installationspfad von Ghostscript ): 

  import settings;
  gs="C:\Program Files\gs\gs9.21\bin\gswin64c.exe";

  *	Konfiguration
  1.	Option - TeXstudio konfiguieren - Befehle - Asymptote: "C:\texlive\2017\tlpkg\asymptote\asy.exe" ?m*.asy
  2.	Option - TeXstudio konfiguieren - Erzeugung - Benutzerbefehle - user0: txs:///pdflatex | txs:///asy | txs:///pdflatex | txs:///view-pdf

  *	Anwendung 
  1.	Grammatik siehe die Anleitungsdokument des Moduls. 
  2.	Kompilieren der *.tex-Datei mit Tastatur-Kürzel "Umschalt-Alt-F1" (für user0: definiert)

  *	Reference
  1.	Anleitung.pdf im Modulordner
  2.	http://asymptote.sourceforge.net/
