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

	#DEFINE PR_MENUTOP        'Início'
	#DEFINE PR_MENUPREV       'Pág. Anterior'
	#DEFINE PR_MENUNEXT       'Pág. Seguinte'
	#DEFINE PR_MENULAST       'Última página'
	#DEFINE PR_MENUGOTO       'Ir para página'
	#DEFINE PR_MENUSHOWPAGES  'Mostrar páginas'
	#DEFINE PR_MENUPRINT      'Imprimir'
	#DEFINE PR_MENUCLOSE      'Fechar'
	#DEFINE PR_MENUTOOLB      "Barra de Ferramentas"

	#DEFINE PR_CBOZOOMWHOLEPG "Página Inteira"
	#DEFINE PR_CBOZOOMPGWIDTH "Largura da Página"
	#DEFINE PR_CMDGOTOPGTTIP  "Ir para a página"

	#DEFINE PR_ONEPGTTIP      "Uma página"
	#DEFINE PR_TWOPGTTIP      "Duas páginas"
	#DEFINE PR_FOURPGTTIP     "Quatro páginas"

	#DEFINE PR_ONEPGMENU	  "1 página"
	#DEFINE PR_TWOPGMENU	  "2 páginas"
	#DEFINE PR_FOURPGMENU	  "4 páginas"

	#DEFINE PR_REPORTTITLE    "Previsualizando relatório..."
	#DEFINE PR_ERR_CREATINGFILE "Falha na criação do arquivo !" + CHR(13) + "Tente novamente."
	#DEFINE PR_ERROR          "Erro"
	#DEFINE PR_ERRNOPRINTER   "Impressora não encontrada." + CHR(13) + "Instale uma impressora e execute o relatório novamente."

	#DEFINE PR_MENUPROOF      "\<Miniaturas..."

	#DEFINE PR_COPIES         "Cópias"
	#DEFINE PR_SAVEREPORT     "Salvar relatório"

	#DEFINE PR_SAVEASIMAGE    "Salvar em arquivo de imagem..."
	#DEFINE PR_SAVEASPDF      "Salvar em PDF"
	#DEFINE PR_SAVEASHTML     "Salvar em HTML"
	#DEFINE PR_SAVEASRTF      "Salvar em RTF"
	#DEFINE PR_SAVEASXLS      "Salvar em XLS"

	#DEFINE PR_SENDTOEMAIL    "Enviar relatório por email"
	#DEFINE PR_CLOSEREPORT    "Fechar relatório"
	#DEFINE PR_PRINTREPORT    "Imprimir"
	#DEFINE PR_MINIATURES     "Mostrar Miniaturas"
	#DEFINE PR_GLOBALPREVIEW  "Previsualização geral"

	#DEFINE PR_AVAILABLEPRINT "Impressoras disponíveis"

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO
	#DEFINE PR_GOTOPG_OK      "Ok"
	#DEFINE PR_CANCEL  "Cancelar"

	#DEFINE PR_PRINTINGPREF   "Preferências de Impressão"

	#DEFINE PR_PREFCAPTION    "Customizar Impressão"
	#DEFINE PR_PREFTAB        "Geral"
	#DEFINE PR_PREFBUTTON     "Preferências"
	#DEFINE PR_PREFPGINTERVAL "Intervalo de Páginas"
	#DEFINE PR_PREFALLPG      "Tudo"
	#DEFINE PR_PREFCURRPG     "Página Atual"
	#DEFINE PR_PREFPAGES      "Páginas :"

#ENDIF


* Spanish translation
#IFDEF	PR_ESPANIOL

	#DEFINE PR_PRINT 		'Imprimir'

	#DEFINE PR_MENUTOP		'Inicio'
	#DEFINE PR_MENUPREV		'Página anterior'
	#DEFINE PR_MENUNEXT 		'Página siguiente'
	#DEFINE PR_MENULAST 		'Última página'
	#DEFINE PR_MENUGOTO 		'Ir a página'
	#DEFINE PR_MENUSHOWPAGES 	'Mostrar páginas'
	#DEFINE PR_MENUPRINT 		'Imprimir'
	#DEFINE PR_MENUCLOSE 		'Cerrar'

	#DEFINE PR_MENUTOOLB 		"Barra de herramientas"

	#DEFINE PR_CBOZOOMWHOLEPG 	"Página entera"
	#DEFINE PR_CBOZOOMPGWIDTH 	"Ancho de página"
	#DEFINE PR_CMDGOTOPGTTIP 	"Ir a página"

	#DEFINE PR_ONEPGTTIP 		"Una página"
	#DEFINE PR_TWOPGTTIP 		"Dos páginas"
	#DEFINE PR_FOURPGTTIP 		"Cuatro páginas"
	
	#DEFINE PR_ONEPGMENU		"1 página"
	#DEFINE PR_TWOPGMENU		"2 páginas"
	#DEFINE PR_FOURPGMENU		"4 páginas"
	
	#DEFINE PR_REPORTTITLE 		"Vista previa del informe..."
	#DEFINE PR_ERR_CREATINGFILE "No se pudo crear el archivo!" + CHR(13) + "Por favor inténtelo nuevamente."
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

	#DEFINE PR_SENDTOEMAIL 		"Enviar informe por correo electrónico"
	#DEFINE PR_CLOSEREPORT 		"Cerrar informe"
	#DEFINE PR_PRINTREPORT 		"Imprimir informe"
	#DEFINE PR_MINIATURES 		"Mostrar miniaturas"
	#DEFINE PR_GLOBALPREVIEW 	"Vista previa global"
	#DEFINE PR_AVAILABLEPRINT 	"Impresoras disponibles"

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO
	#DEFINE PR_GOTOPG_OK		"Ok"
	#DEFINE PR_CANCEL	"Cancelar"

	#DEFINE PR_PRINTINGPREF   "Preferencias de impresión"

	#DEFINE PR_PREFCAPTION    "Personalizar Impresión"
	#DEFINE PR_PREFTAB        "General"
	#DEFINE PR_PREFBUTTON     "Preferencias"
	#DEFINE PR_PREFPGINTERVAL "Rango de Páginas"
	#DEFINE PR_PREFALLPG      "Todas las Páginas"
	#DEFINE PR_PREFCURRPG     "Página Actual"
	#DEFINE PR_PREFPAGES      "Páginas :"

#ENDIF

* German translation
#IFDEF PR_GERMAN
	#DEFINE PR_PRINT 'Drucken'

	#DEFINE PR_MENUTOP 'Erste Seite'
	#DEFINE PR_MENUPREV 'Zurück'
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

	#DEFINE PR_REPORTTITLE "Vorschau für ..."
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
	#DEFINE PR_GLOBALPREVIEW "Übersicht"

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
	#DEFINE PR_MENUPREV       'Önceki Sayfa' 
	#DEFINE PR_MENUNEXT       'Sonraki Sayfa' 
	#DEFINE PR_MENULAST       'Son Sayfa' 
	#DEFINE PR_MENUGOTO       'Sayfaya Git' 
	#DEFINE PR_MENUSHOWPAGES  'Sayfalari Göster' 
	#DEFINE PR_MENUPRINT      'Raporu Yazdir' 
	#DEFINE PR_MENUCLOSE      'Önizlemeyi Kapat' 
	#DEFINE PR_MENUTOOLB      "Araç Çubugu" 

	#DEFINE PR_CBOZOOMWHOLEPG "Tüm Sayfa" 
	#DEFINE PR_CBOZOOMPGWIDTH "Sayfa Genisligi" 
	#DEFINE PR_CMDGOTOPGTTIP  "Sayfaya Git" 

	#DEFINE PR_ONEPGTTIP      "Tek Sayfa" 
	#DEFINE PR_TWOPGTTIP      "Iki Sayfa" 
	#DEFINE PR_FOURPGTTIP     "Dört Sayfa" 

	#DEFINE PR_ONEPGMENU	  PR_ONEPGTTIP
	#DEFINE PR_TWOPGMENU	  PR_TWOPGTTIP
	#DEFINE PR_FOURPGMENU	  PR_FOURPGTTIP

	#DEFINE PR_REPORTTITLE    "Rapor Önizleme..." 	
	#DEFINE PR_ERR_CREATINGFILE "Dosya Olusturma Hatasi !" + CHR(13) + "Tekrar Deneyin.." 
	#DEFINE PR_ERROR          "Hata" 
	#DEFINE PR_ERRNOPRINTER   "Hayir yazicilar bulundu. Lütfen bir yazici yüklemek ve raporu tekrar çalistirmayi deneyin."

	#DEFINE PR_MENUPROOF      "\<Minyatürler..." 

	#DEFINE PR_COPIES         "Kopya Sayisi" 
	#DEFINE PR_SAVEREPORT     "Raporu Kaydet" 

	#DEFINE PR_SAVEASIMAGE    "Image Dosyasi Olarak Kaydet..." 	
	#DEFINE PR_SAVEASPDF      "PDF Olarak Kaydet" 
	#DEFINE PR_SAVEASHTML     "HTML Olarak Kaydet" 
	#DEFINE PR_SAVEASRTF      "RTF Olarak Kaydet" 
	#DEFINE PR_SAVEASXLS      "XLS Olarak Kaydet" 

	#DEFINE PR_SENDTOEMAIL    "Raporu e-mail olarak gönder" 
	#DEFINE PR_CLOSEREPORT    "Kapat" 
	#DEFINE PR_PRINTREPORT    "Yazdir" 
	#DEFINE PR_MINIATURES     "Minyatürleri Göster" 
	#DEFINE PR_GLOBALPREVIEW  "Genel Önizleme" 

	#DEFINE PR_AVAILABLEPRINT "Kullanilabilir Yazicilar" 

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO 
	#DEFINE PR_GOTOPG_OK      "Tamam" 
	#DEFINE PR_CANCEL  "Vazgeç" 

	#DEFINE PR_PRINTINGPREF   "Yazim tercihleri"

	#DEFINE PR_PREFCAPTION    "Yazdirmayi Kisisellestir"
	#DEFINE PR_PREFTAB        "Genel"
	#DEFINE PR_PREFBUTTON     "Tercihler"
	#DEFINE PR_PREFPGINTERVAL "Sayfa Araliklari"
	#DEFINE PR_PREFALLPG      "Tüm Sayfalar"
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
	#DEFINE PR_ERR_CREATINGFILE "Errore nella creazione del file !" + CHR(13) + "Riprovare più tardi." 
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

	#DEFINE PR_MENUTOP        'První strana'
	#DEFINE PR_MENUPREV       'Pøedchozí'
	#DEFINE PR_MENUNEXT       'Další'
	#DEFINE PR_MENULAST       'Poslední strana'
	#DEFINE PR_MENUGOTO       'Jdi na stranu...'
	#DEFINE PR_MENUSHOWPAGES  'Zobrazit stránky'
	#DEFINE PR_MENUPRINT      'Tisknout'
	#DEFINE PR_MENUCLOSE      'Zavøít náhled'
	#DEFINE PR_MENUTOOLB      "Nástroje"

	#DEFINE PR_CBOZOOMWHOLEPG "Celá stránka"
	#DEFINE PR_CBOZOOMPGWIDTH "Celá šíøka"
	#DEFINE PR_CMDGOTOPGTTIP  "Jdi na ..."

	#DEFINE PR_ONEPGTTIP      "Zobrazit jednu stránku"
	#DEFINE PR_TWOPGTTIP      "Zobrazit dvì stránky"
	#DEFINE PR_FOURPGTTIP     "Zobrazit ètyøi stránky"

	#DEFINE PR_ONEPGMENU	  PR_ONEPGTTIP
	#DEFINE PR_TWOPGMENU	  PR_TWOPGTTIP
	#DEFINE PR_FOURPGMENU	  PR_FOURPGTTIP

	#DEFINE PR_REPORTTITLE    "Náhled tisku..."
	#DEFINE PR_ERR_CREATINGFILE "Chyba pøi vytváøení souboru !" + CHR(13) + "Zkuste to prosím znovu."
	#DEFINE PR_ERROR          "Chyba"
	#DEFINE PR_ERRNOPRINTER   "C. tiskárny nalezeno. Prosím, nainstalujte tiskárnu a zkuste zprávu znovu."

	#DEFINE PR_MENUPROOF      "\<Náhledy..."

	#DEFINE PR_COPIES         "Poèet kopií"
	#DEFINE PR_SAVEREPORT     "Uložit jako..."

	#DEFINE PR_SAVEASIMAGE    "Uložit jako obrázek..."
	#DEFINE PR_SAVEASPDF      "Uložit jako PDF"
	#DEFINE PR_SAVEASHTML     "Uložit jako HTML"
	#DEFINE PR_SAVEASRTF      "Uložit jako RTF"
	#DEFINE PR_SAVEASXLS      "Uložit jako XLS"

	#DEFINE PR_SENDTOEMAIL    "Odeslat sestavu e-mailem"
	#DEFINE PR_CLOSEREPORT    "Zavøít"
	#DEFINE PR_PRINTREPORT    "Tisknout"
	#DEFINE PR_MINIATURES     "Zobrazit náhledy"
	#DEFINE PR_GLOBALPREVIEW  "Náhledy"

	#DEFINE PR_AVAILABLEPRINT "Dostupné tiskárny"

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO
	#DEFINE PR_GOTOPG_OK      "Ok"
	#DEFINE PR_CANCEL  "Storno"

	#DEFINE PR_PRINTINGPREF   "Nastavení tisku"

	#DEFINE PR_PREFCAPTION    "Nastavení tisku"
	#DEFINE PR_PREFTAB        "Obecné"
	#DEFINE PR_PREFBUTTON     "Pøedvolby"
	#DEFINE PR_PREFPGINTERVAL "Rozsah stránek"
	#DEFINE PR_PREFALLPG      "Všechny stránky"
	#DEFINE PR_PREFCURRPG     "Aktuální strana"
	#DEFINE PR_PREFPAGES      "Stránky:"
#ENDIF

#IFDEF  PR_PERSIAN
	#Define PR_PRINT          "Ç"

	#Define PR_MENUTOP        'Çæáíä ÕÝÍå'
	#Define PR_MENUPREV       'ÞÈáí'
	#Define PR_MENUNEXT       'ÈÚÏí'
	#Define PR_MENULAST       'ÂÎÑíä ÕÝÍå'
	#Define PR_MENUGOTO       'ÈÑæ Èå ÕÝÍå'
	#Define PR_MENUSHOWPAGES  'äãÇíÔ ÕÝÍÇÊ'
	#Define PR_MENUPRINT      'Ç ÒÇÑÔ'
	#Define PR_MENUCLOSE      'ÈÓÊä íÔ äãÇíÔ'
	#Define PR_MENUTOOLB      "äæÇÑÇÈÒÇÑ"

	#Define PR_CBOZOOMWHOLEPG "ÊãÇã ÕÝÍå"
	#Define PR_CBOZOOMPGWIDTH "Øæá ÕÝÍå"
	#Define PR_CMDGOTOPGTTIP  "ÈÑæ Èå ÕÝÍå"

	#Define PR_ONEPGTTIP      "í˜ ÕÝÍå"
	#Define PR_TWOPGTTIP      "Ïæ ÕÝÍå"
	#Define PR_FOURPGTTIP     "åÇÑ ÕÝÍå"

	#DEFINE PR_ONEPGMENU	PR_ONEPGTTIP
	#DEFINE PR_TWOPGMENU	PR_TWOPGTTIP
	#DEFINE PR_FOURPGMENU	PR_FOURPGTTIP

	#Define PR_REPORTTITLE    "íÔ äãÇíÔ ÒÇÑÔ ..."
	#Define PR_ERR_CREATINGFILE "ÓÇÎÊ ÝÇíá äÇãæÝÞ ÈæÏ!" + Chr(13) + "áØÝÇ ÏæÈÇÑå ÊáÇÔ ˜äíÏ."
	#Define PR_ERROR          "ÎØÇ"
	#DEFINE PR_ERRNOPRINTER   "???? ?????? ?? ?? ????. ???? ??? ????? ?? ?????? ???? ? ?? ??? ???? ????? ??????."

	*!*	IF you got error for this remove menu shortcut \<
	#Define PR_MENUPROOF      "\<ÊÕÇæíÑ ˜æ˜"

	#Define PR_COPIES         "ÑæäÔÊ åÇ"
	#Define PR_SAVEREPORT     "ÐÎíÑå ÒÇÑÔ"

	#Define PR_SAVEASIMAGE    "ÐÎíÑå Èå ÕæÑÊ ÝÇíá ÊÕæíÑí ..."
	#Define PR_SAVEASPDF      "ÐÎíÑå Èå ÕæÑÊ PDF"
	#Define PR_SAVEASHTML     "ÐÎíÑå Èå ÕæÑÊ HTML"
	#Define PR_SAVEASRTF      "ÐÎíÑå Èå ÕæÑÊ RTF"
	#Define PR_SAVEASXLS      "ÐÎíÑå Èå ÕæÑÊ XLS"

	#Define PR_SENDTOEMAIL    "ÇÑÓÇá ÒÇÑÔ ÈæÓíáå ÓÊ Çá˜ÊÑæäí˜í"
	#Define PR_CLOSEREPORT    "ÈÓÊä ÒÇÑÔ"
	#Define PR_PRINTREPORT    "Ç ÒÇÑÔ"
	#Define PR_MINIATURES     "äãÇíÔ ÊÕÇæíÑ ˜æ˜ "
	#Define PR_GLOBALPREVIEW  "íÔ äãÇíÔ ˜áí"

	#Define PR_AVAILABLEPRINT "ÇÑåÇí ãæÌæÏ"

	#Define PR_GOTOPG_CAPTION PR_MENUGOTO
	#Define PR_GOTOPG_OK      "ÊÇÆíÏ"
	#Define PR_CANCEL  "ÇäÕÑÇÝ"

	#Define PR_PRINTINGPREF   "ÊäÙíãÇÊ Ç"

	#Define PR_PREFCAPTION    "ÓÝÇÑÔí äãæÏä Ç"
	#Define PR_PREFTAB        "Úãæãí"
	#Define PR_PREFBUTTON     "ãÔÎÕÇÊ"
	#Define PR_PREFPGINTERVAL "ãÍÏæÏå ÕÝÍÇÊ"
	#Define PR_PREFALLPG      "ÊãÇã ÕÝÍÇÊ"
	#Define PR_PREFCURRPG     "ÕÝÍå ÌÇÑí"
	#Define PR_PREFPAGES      "ÕÝÍÇÊ"

#ENDIF



#IFDEF  PR_GREEK 
	* Set the CodePage for this file =1253 (Greek Windows)... 

	#Define PR_PRINT          "Print"

	#DEFINE PR_MENUTOP        'Ðñþôç Óåëßäá' 
	#DEFINE PR_MENUPREV       'Ðñïçãïýìåíç' 
	#DEFINE PR_MENUNEXT       'Åðüìåíç' 
	#DEFINE PR_MENULAST       'Ôåëåõôáßá Óåëßäá' 
	#DEFINE PR_MENUGOTO       'ÌåôÜâáóç óå Óåëßäá' 
	#DEFINE PR_MENUSHOWPAGES  'ÅìöÜíéóç Óåëßäùí' 
	#DEFINE PR_MENUPRINT      'Åêôýðùóç ÁíáöïñÜò' 
	#DEFINE PR_MENUCLOSE      'Êëåßóéìï Ðñïåðéóêüðéóçò' 

	#DEFINE PR_MENUTOOLB      "ÅñãáëåéïèÞêç" 

	#DEFINE PR_CBOZOOMWHOLEPG "Ïëüêëçñç Óåëßäá" 
	#DEFINE PR_CBOZOOMPGWIDTH "ÐëÞñåò ÐëÜôïò Óåëßäïò" 
	#DEFINE PR_CMDGOTOPGTTIP  "ÌåôÜâáóç óå Óåëßäá" 

	#DEFINE PR_ONEPGTTIP      "Ìéá Óåëßäá" 
	#DEFINE PR_TWOPGTTIP      "Äõï Óåëßäåò" 
	#DEFINE PR_FOURPGTTIP     "ÔÝóóáñåò Óåëßäåò" 

	#DEFINE PR_ONEPGMENU "1 Óåëßäá" 
	#DEFINE PR_TWOPGMENU "2 Óåëßäåò" 
	#DEFINE PR_FOURPGMENU "4 Óåëßäåò" 

	#DEFINE PR_REPORTTITLE    "ÁíáöïñÜ Ðñïåðéóêüðéóçò..." 
	#DEFINE PR_ERR_CREATINGFILE "Áðïôõ÷ßá äçìéïõñãßáò áñ÷åßïõ !" + CHR(13) + "Ðáñáêáëþ äïêéìÜóôå ðÜëé áñãüôåñá." 
	#DEFINE PR_ERROR          "ËÜèïò" 
	#DEFINE PR_ERRNOPRINTER   "?e? ß?????a? e?t?p?t??. ?a?a?a?e?s?e ?a e??atast?sete ??a? e?t?p?t? ?a? p??spa??ste ?a e?te??sete ?a?? t?? a?af???."

	#DEFINE PR_MENUPROOF      "\<Ìéêñïãñáößåò..." 

	#DEFINE PR_COPIES         "Áíôßãñáöá" 
	#DEFINE PR_SAVEREPORT     "ÁðïèÞêåõóç ÁíáöïñÜò" 

	#DEFINE PR_SAVEASIMAGE    "ÁðïèÞêåõóç ùò áñ÷åßïõ åéêüíáò..." 
	#DEFINE PR_SAVEASPDF      "ÁðïèÞêåõóç ùò PDF" 
	#DEFINE PR_SAVEASHTML     "ÁðïèÞêåõóç ùò HTML" 
	#DEFINE PR_SAVEASRTF      "ÁðïèÞêåõóç ùò RTF" 
	#DEFINE PR_SAVEASXLS      "ÁðïèÞêåõóç ùò XLS" 

	#DEFINE PR_SENDTOEMAIL    "ÁðïóôïëÞ áíáöïñÜò ìÝóù e-mail" 
	#DEFINE PR_CLOSEREPORT   PR_MENUCLOSE 

	#DEFINE PR_PRINTREPORT    "Åêôýðùóç ÁíáöïñÜò" 
	#DEFINE PR_MINIATURES     "ÅìöÜíéóç Ìéêñïãñáöéþí" 
	#DEFINE PR_GLOBALPREVIEW  "ÊáèïëéêÞ Ðñïåðéóêüðéóç" 

	#DEFINE PR_AVAILABLEPRINT "ÄéáèÝóéìïé ÅêôõðùôÝò" 

	#DEFINE PR_GOTOPG_CAPTION PR_MENUGOTO 
	#DEFINE PR_GOTOPG_OK      "ÏÊ" 
	#DEFINE PR_CANCEL         "Áêýñùóç" 

	#DEFINE PR_PRINTINGPREF   "ÐñïóáñìïãÞ Åêôýðùóçò" 

	#DEFINE PR_PREFCAPTION    PR_PRINTINGPREF   &&"Customize Printing" 
	#DEFINE PR_PREFTAB        "ÃåíéêÜ" && "General" 
	#DEFINE PR_PREFBUTTON     "ÐñïôéìÞóåéò" && "Preferences" 
	#DEFINE PR_PREFPGINTERVAL "Åýñïò Óåëßäùí" && "Page Range" 
	#DEFINE PR_PREFALLPG      "¼ëåò ïé Óåëßäåò" && "All Pages" 
	#DEFINE PR_PREFCURRPG    "ÔñÝ÷ïõóá Óåëßäá" && "Current Page" 
	#DEFINE PR_PREFPAGES      "Óåëßäåò" && "Pages" 

	#DEFINE PR_CBOZOOMTTIP    "Áõîïìåßùóç"

#ENDIF