#DEFINE PR_FORMICON  "wwrite.ico"

#DEFINE PR_ENGLISH
* #DEFINE PR_PORTUGUES
* #DEFINE PR_ESPANIOL
* #DEFINE PR_GERMAN
* #DEFINE PR_TURKISH 
* #DEFINE PR_ITALIANO
* #DEFINE PR_CZECH
* #DEFINE PR_PERSIAN
* #DEFINE PR_GREEK 


#IFDEF  PR_ENGLISH

	#DEFINE PR_PRINT          "Print"

	#DEFINE PR_MENUTOP        'First page'
	#DEFINE PR_MENUPREV       'Previous'
	#DEFINE PR_MENUNEXT       'Next'
	#DEFINE PR_MENULAST       'Last Page'
	#DEFINE PR_MENUGOTO       'Go to page'
	#DEFINE PR_MENUSHOWPAGES  'Show pages'
	#DEFINE PR_MENUPRINT      'Print report'
	#DEFINE PR_MENUCLOSE      'Close preview'
	#DEFINE PR_MENUTOOLB      "Toolbar"

	#DEFINE PR_CBOZOOMWHOLEPG "Whole Page"
	#DEFINE PR_CBOZOOMPGWIDTH "Page Width"
	#DEFINE PR_CMDGOTOPGTTIP  "Go to page"

	#DEFINE PR_ONEPGTTIP      "One page"
	#DEFINE PR_TWOPGTTIP      "Two pages"
	#DEFINE PR_FOURPGTTIP     "Four pages"

	#DEFINE PR_REPORTTITLE    "Previewing Report..."
	#DEFINE PR_ERR_CREATINGFILE "Failed creating file !" + CHR(13) + "Please try again later."
	#DEFINE PR_ERROR          "Error"
	#DEFINE PR_ERRNOPRINTER   "No Printers found." + CHR(13) + "Please install a printer and try running the report again."

	#DEFINE PR_MENUPROOF      "\<Miniatures..."

	#DEFINE PR_COPIES         "Copies"
	#DEFINE PR_SAVEREPORT     "Save Report"

	#DEFINE PR_SAVEASIMAGE    "Save as image file..."
	#DEFINE PR_SAVEASPDF      "Save as PDF"
	#DEFINE PR_SAVEASHTML     "Save as HTML"
	#DEFINE PR_SAVEASRTF      "Save as RTF"
	#DEFINE PR_SAVEASXLS      "Save as XLS"

	#DEFINE PR_SENDTOEMAIL    "Send report by e-mail"
	#DEFINE PR_CLOSEREPORT    "Close Report"
	#DEFINE PR_PRINTREPORT    "Print Report"
	#DEFINE PR_MINIATURES     "Show Miniatures"
	#DEFINE PR_GLOBALPREVIEW  "Global Preview"

	#DEFINE PR_AVAILABLEPRINT "Available Printers"

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO
	#DEFINE PR_GOTOPG_OK      "Ok"
	#DEFINE PR_CANCEL  "Cancel"

	#DEFINE PR_PRINTINGPREF   "Printing Preferences"

	#DEFINE PR_PREFCAPTION    "Customize Printing"
	#DEFINE PR_PREFTAB        "General"
	#DEFINE PR_PREFBUTTON     "Preferences"
	#DEFINE PR_PREFPGINTERVAL "Page Range"
	#DEFINE PR_PREFALLPG      "All Pages"
	#DEFINE PR_PREFCURRPG     "Current Page"
	#DEFINE PR_PREFPAGES      "Pages"

#ELSE

	#DEFINE PR_NONENGLISH

#ENDIF


#IFDEF  PR_PORTUGUES

	#DEFINE PR_PRINT      'Imprimir'

	#DEFINE PR_MENUTOP        'In�cio'
	#DEFINE PR_MENUPREV       'P�g. Anterior'
	#DEFINE PR_MENUNEXT       'P�g. Seguinte'
	#DEFINE PR_MENULAST       '�ltima p�gina'
	#DEFINE PR_MENUGOTO       'Ir para p�gina'
	#DEFINE PR_MENUSHOWPAGES  'Mostrar p�ginas'
	#DEFINE PR_MENUPRINT      'Imprimir'
	#DEFINE PR_MENUCLOSE      'Fechar'
	#DEFINE PR_MENUTOOLB      "Barra de Ferramentas"

	#DEFINE PR_CBOZOOMWHOLEPG "P�gina Inteira"
	#DEFINE PR_CBOZOOMPGWIDTH "Largura da P�gina"
	#DEFINE PR_CMDGOTOPGTTIP  "Ir para a p�gina"

	#DEFINE PR_ONEPGTTIP      "Uma p�gina"
	#DEFINE PR_TWOPGTTIP      "Duas p�ginas"
	#DEFINE PR_FOURPGTTIP     "Quatro p�ginas"

	#DEFINE PR_ONEPGMENU	  "1 p�gina"
	#DEFINE PR_TWOPGMENU	  "2 p�ginas"
	#DEFINE PR_FOURPGMENU	  "4 p�ginas"

	#DEFINE PR_REPORTTITLE    "Previsualizando relat�rio..."
	#DEFINE PR_ERR_CREATINGFILE "Falha na cria��o do arquivo !" + CHR(13) + "Tente novamente."
	#DEFINE PR_ERROR          "Erro"
	#DEFINE PR_ERRNOPRINTER   "Impressora n�o encontrada." + CHR(13) + "Instale uma impressora e execute o relat�rio novamente."

	#DEFINE PR_MENUPROOF      "\<Miniaturas..."

	#DEFINE PR_COPIES         "C�pias"
	#DEFINE PR_SAVEREPORT     "Salvar relat�rio"

	#DEFINE PR_SAVEASIMAGE    "Salvar em arquivo de imagem..."
	#DEFINE PR_SAVEASPDF      "Salvar em PDF"
	#DEFINE PR_SAVEASHTML     "Salvar em HTML"
	#DEFINE PR_SAVEASRTF      "Salvar em RTF"
	#DEFINE PR_SAVEASXLS      "Salvar em XLS"

	#DEFINE PR_SENDTOEMAIL    "Enviar relat�rio por email"
	#DEFINE PR_CLOSEREPORT    "Fechar relat�rio"
	#DEFINE PR_PRINTREPORT    "Imprimir"
	#DEFINE PR_MINIATURES     "Mostrar Miniaturas"
	#DEFINE PR_GLOBALPREVIEW  "Previsualiza��o geral"

	#DEFINE PR_AVAILABLEPRINT "Impressoras dispon�veis"

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO
	#DEFINE PR_GOTOPG_OK      "Ok"
	#DEFINE PR_CANCEL  "Cancelar"

	#DEFINE PR_PRINTINGPREF   "Prefer�ncias de Impress�o"

	#DEFINE PR_PREFCAPTION    "Customizar Impress�o"
	#DEFINE PR_PREFTAB        "Geral"
	#DEFINE PR_PREFBUTTON     "Prefer�ncias"
	#DEFINE PR_PREFPGINTERVAL "Intervalo de P�ginas"
	#DEFINE PR_PREFALLPG      "Tudo"
	#DEFINE PR_PREFCURRPG     "P�gina Atual"
	#DEFINE PR_PREFPAGES      "P�ginas :"

#ENDIF


* Spanish translation
#IFDEF	PR_ESPANIOL

	#DEFINE PR_PRINT 		'Imprimir'

	#DEFINE PR_MENUTOP		'Inicio'
	#DEFINE PR_MENUPREV		'P�gina anterior'
	#DEFINE PR_MENUNEXT 		'P�gina siguiente'
	#DEFINE PR_MENULAST 		'�ltima p�gina'
	#DEFINE PR_MENUGOTO 		'Ir a p�gina'
	#DEFINE PR_MENUSHOWPAGES 	'Mostrar p�ginas'
	#DEFINE PR_MENUPRINT 		'Imprimir'
	#DEFINE PR_MENUCLOSE 		'Cerrar'

	#DEFINE PR_MENUTOOLB 		"Barra de herramientas"

	#DEFINE PR_CBOZOOMWHOLEPG 	"P�gina entera"
	#DEFINE PR_CBOZOOMPGWIDTH 	"Ancho de p�gina"
	#DEFINE PR_CMDGOTOPGTTIP 	"Ir a p�gina"

	#DEFINE PR_ONEPGTTIP 		"Una p�gina"
	#DEFINE PR_TWOPGTTIP 		"Dos p�ginas"
	#DEFINE PR_FOURPGTTIP 		"Cuatro p�ginas"
	
	#DEFINE PR_ONEPGMENU		"1 p�gina"
	#DEFINE PR_TWOPGMENU		"2 p�ginas"
	#DEFINE PR_FOURPGMENU		"4 p�ginas"
	
	#DEFINE PR_REPORTTITLE 		"Vista previa del informe..."
	#DEFINE PR_ERR_CREATINGFILE "No se pudo crear el archivo!" + CHR(13) + "Por favor int�ntelo nuevamente."
	#DEFINE PR_ERROR 			"Error"
	#DEFINE PR_ERRNOPRINTER     "No hay impresoras encontradas." + CHR(13) + "Instale una impresora e intente ejecutar de nuevo el informe."

	#DEFINE PR_MENUPROOF 		"\<Miniaturas..."
	#DEFINE PR_COPIES 			"Copias"
	#DEFINE PR_SAVEREPORT 		"Guardar informe"

	#DEFINE PR_SAVEASIMAGE 		"Guardar como archivo de imagen ..."
	#DEFINE PR_SAVEASPDF 		"Guardar como PDF"
	#DEFINE PR_SAVEASHTML 		"Guardar como HTML"
	#DEFINE PR_SAVEASRTF 		"Guardar como RTF"
	#DEFINE PR_SAVEASXLS 		"Guardar como XLS"

	#DEFINE PR_SENDTOEMAIL 		"Enviar informe por correo electr�nico"
	#DEFINE PR_CLOSEREPORT 		"Cerrar informe"
	#DEFINE PR_PRINTREPORT 		"Imprimir informe"
	#DEFINE PR_MINIATURES 		"Mostrar miniaturas"
	#DEFINE PR_GLOBALPREVIEW 	"Vista previa global"
	#DEFINE PR_AVAILABLEPRINT 	"Impresoras disponibles"

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO
	#DEFINE PR_GOTOPG_OK		"Ok"
	#DEFINE PR_CANCEL	"Cancelar"

	#DEFINE PR_PRINTINGPREF   "Preferencias de impresi�n"

	#DEFINE PR_PREFCAPTION    "Personalizar Impresi�n"
	#DEFINE PR_PREFTAB        "General"
	#DEFINE PR_PREFBUTTON     "Preferencias"
	#DEFINE PR_PREFPGINTERVAL "Rango de P�ginas"
	#DEFINE PR_PREFALLPG      "Todas las P�ginas"
	#DEFINE PR_PREFCURRPG     "P�gina Actual"
	#DEFINE PR_PREFPAGES      "P�ginas :"

#ENDIF

* German translation
#IFDEF PR_GERMAN
	#DEFINE PR_PRINT 'Drucken'

	#DEFINE PR_MENUTOP 'Erste Seite'
	#DEFINE PR_MENUPREV 'Zur�ck'
	#DEFINE PR_MENUNEXT 'Vor'
	#DEFINE PR_MENULAST 'Letzte Seite'
	#DEFINE PR_MENUGOTO 'Gehe zu Seite'
	#DEFINE PR_MENUSHOWPAGES 'Anzahl Seiten'
	#DEFINE PR_MENUPRINT 'Drucken'
	#DEFINE PR_MENUCLOSE 'Ende'
	#DEFINE PR_MENUTOOLB "Toolbar"

	#DEFINE PR_CBOZOOMWHOLEPG "Ganze Seite"
	#DEFINE PR_CBOZOOMPGWIDTH "Seitenbreite"
	#DEFINE PR_CMDGOTOPGTTIP "Gehe zu Seite"

	#DEFINE PR_ONEPGTTIP "1 Seite"
	#DEFINE PR_TWOPGTTIP "2 Seiten"
	#DEFINE PR_FOURPGTTIP "4 Seiten"

	#DEFINE PR_REPORTTITLE "Vorschau f�r ..."
	#DEFINE PR_ERR_CREATINGFILE "Dateifehler" + CHR(13) + "Bitte versuchen Sie es noch einmal"
	#DEFINE PR_ERROR "Fehler"
	#DEFINE PR_ERRNOPRINTER   "Keine Drucker gefunden. Bitte installieren Sie einen Drucker ein und versuchen Sie den Bericht erneut."


	#DEFINE PR_ONEPGMENU	"1 Seite"
	#DEFINE PR_TWOPGMENU	"2 Seiten"
	#DEFINE PR_FOURPGMENU	"4 Seiten"

	#DEFINE PR_MENUPROOF 	"\<Miniaturbilder.."

	#DEFINE PR_COPIES 		"Kopien"
	#DEFINE PR_SAVEREPORT 	"Speichern"

	#DEFINE PR_SAVEASIMAGE 	"Speichern als Bild"
	#DEFINE PR_SAVEASPDF 	"Speichern als PDF "
	#DEFINE PR_SAVEASHTML 	"Speichern als HTML"
	#DEFINE PR_SAVEASRTF 	"Speichern als RTF "
	#DEFINE PR_SAVEASXLS 	"Speichern als XLS "

	#DEFINE PR_SENDTOEMAIL 	"Als Email versenden"
	#DEFINE PR_CLOSEREPORT 	"Ende"
	#DEFINE PR_PRINTREPORT 	"Drucken"
	#DEFINE PR_MINIATURES 	"Zeige Miniaturbilder"
	#DEFINE PR_GLOBALPREVIEW "�bersicht"

	#DEFINE PR_AVAILABLEPRINT "Vorhandene Drucker"

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO
	#DEFINE PR_GOTOPG_OK      "Ok"
	#DEFINE PR_CANCEL  "Abbrechen"

	#DEFINE PR_PRINTINGPREF   "Druckoptionen"

	#DEFINE PR_PREFCAPTION    "Drucken" && as opposed to the literal "Druckeinstellungen"
	#DEFINE PR_PREFTAB        "Allgemein"
	#DEFINE PR_PREFBUTTON     "Einstellungen"
	#DEFINE PR_PREFPGINTERVAL "Seitenbereich"
	#DEFINE PR_PREFALLPG      "Alles" && as opposed to literally "Alle Seiten"
	#DEFINE PR_PREFCURRPG     "Aktuelle Seite"
	#DEFINE PR_PREFPAGES      "Seiten :"

#ENDIF


* Turkish translation
#IFDEF  PR_TURKISH 
	#DEFINE PR_PRINT      'Yazdir' 

	#DEFINE PR_MENUTOP        'Ilk Sayfa' 
	#DEFINE PR_MENUPREV       '�nceki Sayfa' 
	#DEFINE PR_MENUNEXT       'Sonraki Sayfa' 
	#DEFINE PR_MENULAST       'Son Sayfa' 
	#DEFINE PR_MENUGOTO       'Sayfaya Git' 
	#DEFINE PR_MENUSHOWPAGES  'Sayfalari G�ster' 
	#DEFINE PR_MENUPRINT      'Raporu Yazdir' 
	#DEFINE PR_MENUCLOSE      '�nizlemeyi Kapat' 
	#DEFINE PR_MENUTOOLB      "Ara� �ubugu" 

	#DEFINE PR_CBOZOOMWHOLEPG "T�m Sayfa" 
	#DEFINE PR_CBOZOOMPGWIDTH "Sayfa Genisligi" 
	#DEFINE PR_CMDGOTOPGTTIP  "Sayfaya Git" 

	#DEFINE PR_ONEPGTTIP      "Tek Sayfa" 
	#DEFINE PR_TWOPGTTIP      "Iki Sayfa" 
	#DEFINE PR_FOURPGTTIP     "D�rt Sayfa" 

	#DEFINE PR_ONEPGMENU	  PR_ONEPGTTIP
	#DEFINE PR_TWOPGMENU	  PR_TWOPGTTIP
	#DEFINE PR_FOURPGMENU	  PR_FOURPGTTIP

	#DEFINE PR_REPORTTITLE    "Rapor �nizleme..." 	
	#DEFINE PR_ERR_CREATINGFILE "Dosya Olusturma Hatasi !" + CHR(13) + "Tekrar Deneyin.." 
	#DEFINE PR_ERROR          "Hata" 
	#DEFINE PR_ERRNOPRINTER   "Hayir yazicilar bulundu. L�tfen bir yazici y�klemek ve raporu tekrar �alistirmayi deneyin."

	#DEFINE PR_MENUPROOF      "\<Minyat�rler..." 

	#DEFINE PR_COPIES         "Kopya Sayisi" 
	#DEFINE PR_SAVEREPORT     "Raporu Kaydet" 

	#DEFINE PR_SAVEASIMAGE    "Image Dosyasi Olarak Kaydet..." 	
	#DEFINE PR_SAVEASPDF      "PDF Olarak Kaydet" 
	#DEFINE PR_SAVEASHTML     "HTML Olarak Kaydet" 
	#DEFINE PR_SAVEASRTF      "RTF Olarak Kaydet" 
	#DEFINE PR_SAVEASXLS      "XLS Olarak Kaydet" 

	#DEFINE PR_SENDTOEMAIL    "Raporu e-mail olarak g�nder" 
	#DEFINE PR_CLOSEREPORT    "Kapat" 
	#DEFINE PR_PRINTREPORT    "Yazdir" 
	#DEFINE PR_MINIATURES     "Minyat�rleri G�ster" 
	#DEFINE PR_GLOBALPREVIEW  "Genel �nizleme" 

	#DEFINE PR_AVAILABLEPRINT "Kullanilabilir Yazicilar" 

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO 
	#DEFINE PR_GOTOPG_OK      "Tamam" 
	#DEFINE PR_CANCEL  "Vazge�" 

	#DEFINE PR_PRINTINGPREF   "Yazim tercihleri"

	#DEFINE PR_PREFCAPTION    "Yazdirmayi Kisisellestir"
	#DEFINE PR_PREFTAB        "Genel"
	#DEFINE PR_PREFBUTTON     "Tercihler"
	#DEFINE PR_PREFPGINTERVAL "Sayfa Araliklari"
	#DEFINE PR_PREFALLPG      "T�m Sayfalar"
	#DEFINE PR_PREFCURRPG     "Bu Sayfa"
	#DEFINE PR_PREFPAGES      "Sayfalar :"
#ENDIF


* Italian translation
#IFDEF  PR_ITALIANO 
	#DEFINE PR_PRINT	'Stampa' 

	#DEFINE PR_MENUTOP        'Prima pagina' 
	#DEFINE PR_MENUPREV       'Precedente' 
	#DEFINE PR_MENUNEXT       'Successiva' 
	#DEFINE PR_MENULAST       'Iltima pagina' 
	#DEFINE PR_MENUGOTO       'Vai alla pagina' 
	#DEFINE PR_MENUSHOWPAGES  'Visualizza pagine' 
	#DEFINE PR_MENUPRINT      'Stampa' 
	#DEFINE PR_MENUCLOSE      'Chiudi anteprima' 
	#DEFINE PR_MENUTOOLB      "Toolbar" 

	#DEFINE PR_CBOZOOMWHOLEPG "Tulla la pagina" 
	#DEFINE PR_CBOZOOMPGWIDTH "Larghezza pagina" 
	#DEFINE PR_CMDGOTOPGTTIP  "Vai a pagina" 

	#DEFINE PR_ONEPGTTIP      "Una pagina" 
	#DEFINE PR_TWOPGTTIP      "Due pagine" 
	#DEFINE PR_FOURPGTTIP     "Quattro pagine" 

	#DEFINE PR_ONEPGMENU	  PR_ONEPGTTIP
	#DEFINE PR_TWOPGMENU	  PR_TWOPGTTIP
	#DEFINE PR_FOURPGMENU	  PR_FOURPGTTIP

	#DEFINE PR_REPORTTITLE    "Anteprima stampa..." 
	#DEFINE PR_ERR_CREATINGFILE "Errore nella creazione del file !" + CHR(13) + "Riprovare pi� tardi." 
	#DEFINE PR_ERROR          "Errore" 
	#DEFINE PR_ERRNOPRINTER   "Nessun stampanti trovato. Si prega di installare una stampante e provare a eseguire nuovamente il report."

	#DEFINE PR_MENUPROOF      "\<Miniature..."
	#DEFINE PR_COPIES         "Copie" 
	#DEFINE PR_SAVEREPORT     "Salva Stampa" 

	#DEFINE PR_SAVEASIMAGE    "Salva come immagine..." 
	#DEFINE PR_SAVEASPDF      "Salva come PDF" 
	#DEFINE PR_SAVEASHTML     "Salva come HTML" 
	#DEFINE PR_SAVEASRTF      "Salva come RTF" 
	#DEFINE PR_SAVEASXLS      "Salva come XLS" 

	#DEFINE PR_SENDTOEMAIL    "Invia la stampa per e-mail" 
	#DEFINE PR_CLOSEREPORT    "Chiudi stampa" 
	#DEFINE PR_PRINTREPORT    "Stampa" 
	#DEFINE PR_MINIATURES     "Visualizza miniature" 
	#DEFINE PR_GLOBALPREVIEW  "Anteprima globale" 

	#DEFINE PR_AVAILABLEPRINT "Stampanti disponibili" 

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO 
	#DEFINE PR_GOTOPG_OK      "Ok" 
	#DEFINE PR_CANCEL  "Annullare" 

	#DEFINE PR_PRINTINGPREF   "Preferenze stampa"

	#DEFINE PR_PREFCAPTION    "Preferenze stampa"
	#DEFINE PR_PREFTAB        "Generale"
	#DEFINE PR_PREFBUTTON     "Preferenze"
	#DEFINE PR_PREFPGINTERVAL "Pagine sa Stampare"
	#DEFINE PR_PREFALLPG      "Tutte"
	#DEFINE PR_PREFCURRPG     "Pagina Corrente"
	#DEFINE PR_PREFPAGES      "Pagine:"
#ENDIF 


#IFDEF  PR_CZECH
	* codepage 1250
	#DEFINE PR_PRINT          "Tisk"

	#DEFINE PR_MENUTOP        'Prvn� strana'
	#DEFINE PR_MENUPREV       'P�edchoz�'
	#DEFINE PR_MENUNEXT       'Dal��'
	#DEFINE PR_MENULAST       'Posledn� strana'
	#DEFINE PR_MENUGOTO       'Jdi na stranu...'
	#DEFINE PR_MENUSHOWPAGES  'Zobrazit str�nky'
	#DEFINE PR_MENUPRINT      'Tisknout'
	#DEFINE PR_MENUCLOSE      'Zav��t n�hled'
	#DEFINE PR_MENUTOOLB      "N�stroje"

	#DEFINE PR_CBOZOOMWHOLEPG "Cel� str�nka"
	#DEFINE PR_CBOZOOMPGWIDTH "Cel� ���ka"
	#DEFINE PR_CMDGOTOPGTTIP  "Jdi na ..."

	#DEFINE PR_ONEPGTTIP      "Zobrazit jednu str�nku"
	#DEFINE PR_TWOPGTTIP      "Zobrazit dv� str�nky"
	#DEFINE PR_FOURPGTTIP     "Zobrazit �ty�i str�nky"

	#DEFINE PR_ONEPGMENU	  PR_ONEPGTTIP
	#DEFINE PR_TWOPGMENU	  PR_TWOPGTTIP
	#DEFINE PR_FOURPGMENU	  PR_FOURPGTTIP

	#DEFINE PR_REPORTTITLE    "N�hled tisku..."
	#DEFINE PR_ERR_CREATINGFILE "Chyba p�i vytv��en� souboru !" + CHR(13) + "Zkuste to pros�m znovu."
	#DEFINE PR_ERROR          "Chyba"
	#DEFINE PR_ERRNOPRINTER   "C. tisk�rny nalezeno. Pros�m, nainstalujte tisk�rnu a zkuste zpr�vu znovu."

	#DEFINE PR_MENUPROOF      "\<N�hledy..."

	#DEFINE PR_COPIES         "Po�et kopi�"
	#DEFINE PR_SAVEREPORT     "Ulo�it jako..."

	#DEFINE PR_SAVEASIMAGE    "Ulo�it jako obr�zek..."
	#DEFINE PR_SAVEASPDF      "Ulo�it jako PDF"
	#DEFINE PR_SAVEASHTML     "Ulo�it jako HTML"
	#DEFINE PR_SAVEASRTF      "Ulo�it jako RTF"
	#DEFINE PR_SAVEASXLS      "Ulo�it jako XLS"

	#DEFINE PR_SENDTOEMAIL    "Odeslat sestavu e-mailem"
	#DEFINE PR_CLOSEREPORT    "Zav��t"
	#DEFINE PR_PRINTREPORT    "Tisknout"
	#DEFINE PR_MINIATURES     "Zobrazit n�hledy"
	#DEFINE PR_GLOBALPREVIEW  "N�hledy"

	#DEFINE PR_AVAILABLEPRINT "Dostupn� tisk�rny"

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO
	#DEFINE PR_GOTOPG_OK      "Ok"
	#DEFINE PR_CANCEL  "Storno"

	#DEFINE PR_PRINTINGPREF   "Nastaven� tisku"

	#DEFINE PR_PREFCAPTION    "Nastaven� tisku"
	#DEFINE PR_PREFTAB        "Obecn�"
	#DEFINE PR_PREFBUTTON     "P�edvolby"
	#DEFINE PR_PREFPGINTERVAL "Rozsah str�nek"
	#DEFINE PR_PREFALLPG      "V�echny str�nky"
	#DEFINE PR_PREFCURRPG     "Aktu�ln� strana"
	#DEFINE PR_PREFPAGES      "Str�nky:"
#ENDIF

#IFDEF  PR_PERSIAN
	#Define PR_PRINT          "�ǁ"

	#Define PR_MENUTOP        '����� ����'
	#Define PR_MENUPREV       '����'
	#Define PR_MENUNEXT       '����'
	#Define PR_MENULAST       '����� ����'
	#Define PR_MENUGOTO       '��� �� ����'
	#Define PR_MENUSHOWPAGES  '����� �����'
	#Define PR_MENUPRINT      '�ǁ �����'
	#Define PR_MENUCLOSE      '���� ��� �����'
	#Define PR_MENUTOOLB      "���������"

	#Define PR_CBOZOOMWHOLEPG "���� ����"
	#Define PR_CBOZOOMPGWIDTH "��� ����"
	#Define PR_CMDGOTOPGTTIP  "��� �� ����"

	#Define PR_ONEPGTTIP      "� ����"
	#Define PR_TWOPGTTIP      "�� ����"
	#Define PR_FOURPGTTIP     "���� ����"

	#DEFINE PR_ONEPGMENU	PR_ONEPGTTIP
	#DEFINE PR_TWOPGMENU	PR_TWOPGTTIP
	#DEFINE PR_FOURPGMENU	PR_FOURPGTTIP

	#Define PR_REPORTTITLE    "��� ����� ����� ..."
	#Define PR_ERR_CREATINGFILE "���� ���� ������ ���!" + Chr(13) + "���� ������ ���� ����."
	#Define PR_ERROR          "���"
	#DEFINE PR_ERRNOPRINTER   "???? ?????? ?? ?? ????. ???? ??? ????? ?? ?????? ???? ? ?? ??? ???? ????? ??????."

	*!*	IF you got error for this remove menu shortcut \<
	#Define PR_MENUPROOF      "\<������ �捘"

	#Define PR_COPIES         "����� ��"
	#Define PR_SAVEREPORT     "����� �����"

	#Define PR_SAVEASIMAGE    "����� �� ���� ���� ������ ..."
	#Define PR_SAVEASPDF      "����� �� ���� PDF"
	#Define PR_SAVEASHTML     "����� �� ���� HTML"
	#Define PR_SAVEASRTF      "����� �� ���� RTF"
	#Define PR_SAVEASXLS      "����� �� ���� XLS"

	#Define PR_SENDTOEMAIL    "����� ����� ������ ��� ��������"
	#Define PR_CLOSEREPORT    "���� �����"
	#Define PR_PRINTREPORT    "�ǁ �����"
	#Define PR_MINIATURES     "����� ������ �捘 "
	#Define PR_GLOBALPREVIEW  "��� ����� ���"

	#Define PR_AVAILABLEPRINT "�ǁ����� �����"

	#Define PR_GOTOPG_CAPTION PR_MENUGOTO
	#Define PR_GOTOPG_OK      "�����"
	#Define PR_CANCEL  "������"

	#Define PR_PRINTINGPREF   "������� �ǁ"

	#Define PR_PREFCAPTION    "������ ����� �ǁ"
	#Define PR_PREFTAB        "�����"
	#Define PR_PREFBUTTON     "������"
	#Define PR_PREFPGINTERVAL "������ �����"
	#Define PR_PREFALLPG      "���� �����"
	#Define PR_PREFCURRPG     "���� ����"
	#Define PR_PREFPAGES      "�����"

#ENDIF



#IFDEF  PR_GREEK 
	* Set the CodePage for this file =1253 (Greek Windows)... 

	#Define PR_PRINT          "�Print"

	#DEFINE PR_MENUTOP        '����� ������' 
	#DEFINE PR_MENUPREV       '�����������' 
	#DEFINE PR_MENUNEXT       '�������' 
	#DEFINE PR_MENULAST       '��������� ������' 
	#DEFINE PR_MENUGOTO       '�������� �� ������' 
	#DEFINE PR_MENUSHOWPAGES  '�������� �������' 
	#DEFINE PR_MENUPRINT      '�������� ��������' 
	#DEFINE PR_MENUCLOSE      '�������� ��������������' 

	#DEFINE PR_MENUTOOLB      "������������" 

	#DEFINE PR_CBOZOOMWHOLEPG "�������� ������" 
	#DEFINE PR_CBOZOOMPGWIDTH "������ ������ �������" 
	#DEFINE PR_CMDGOTOPGTTIP  "�������� �� ������" 

	#DEFINE PR_ONEPGTTIP      "��� ������" 
	#DEFINE PR_TWOPGTTIP      "��� �������" 
	#DEFINE PR_FOURPGTTIP     "�������� �������" 

	#DEFINE PR_ONEPGMENU "1 ������" 
	#DEFINE PR_TWOPGMENU "2 �������" 
	#DEFINE PR_FOURPGMENU "4 �������" 

	#DEFINE PR_REPORTTITLE    "������� ��������������..." 
	#DEFINE PR_ERR_CREATINGFILE "�������� ����������� ������� !" + CHR(13) + "�������� ��������� ���� ��������." 
	#DEFINE PR_ERROR          "�����" 
	#DEFINE PR_ERRNOPRINTER   "?e? �?????a? e?t?p?t??. ?a?a?a?e?s?e ?a e??atast?sete ??a? e?t?p?t? ?a? p??spa??ste ?a e?te??sete ?a?? t?? a?af???."

	#DEFINE PR_MENUPROOF      "\<������������..." 

	#DEFINE PR_COPIES         "���������" 
	#DEFINE PR_SAVEREPORT     "���������� ��������" 

	#DEFINE PR_SAVEASIMAGE    "���������� �� ������� �������..." 
	#DEFINE PR_SAVEASPDF      "���������� �� PDF" 
	#DEFINE PR_SAVEASHTML     "���������� �� HTML" 
	#DEFINE PR_SAVEASRTF      "���������� �� RTF" 
	#DEFINE PR_SAVEASXLS      "���������� �� XLS" 

	#DEFINE PR_SENDTOEMAIL    "�������� �������� ���� e-mail" 
	#DEFINE PR_CLOSEREPORT   PR_MENUCLOSE 

	#DEFINE PR_PRINTREPORT    "�������� ��������" 
	#DEFINE PR_MINIATURES     "�������� ������������" 
	#DEFINE PR_GLOBALPREVIEW  "�������� �������������" 

	#DEFINE PR_AVAILABLEPRINT "���������� ���������" 

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO 
	#DEFINE PR_GOTOPG_OK      "��" 
	#DEFINE PR_CANCEL         "�������" 

	#DEFINE PR_PRINTINGPREF   "���������� ���������" 

	#DEFINE PR_PREFCAPTION    PR_PRINTINGPREF   &&"Customize Printing" 
	#DEFINE PR_PREFTAB        "������" && "General" 
	#DEFINE PR_PREFBUTTON     "�����������" && "Preferences" 
	#DEFINE PR_PREFPGINTERVAL "����� �������" && "Page Range" 
	#DEFINE PR_PREFALLPG      "���� �� �������" && "All Pages" 
	#DEFINE PR_PREFCURRPG    "�������� ������" && "Current Page" 
	#DEFINE PR_PREFPAGES      "�������" && "Pages" 

	#DEFINE PR_CBOZOOMTTIP    "����������"

#ENDIF