DEFINE CLASS FoxyPreviewerCaller AS Custom
	cPrinterName = SET("Printer",3)

	lSaveToFile     = .T. && adds the save to file button
	lSendToEmail    = .T. && adds the send to email button
	lPrintVisible   = .T. && shows the print button in the toolbar
	lShowCopies     = .T. && shows the copies spinner
	lShowMiniatures = .T. && shows the miniatures page
	lPrinterPref    = .T. && shows the printer preferences button

	* Output types allowed in the "Save as.." button from the toolbar
	lSaveAsImage	= .T.
	lSaveAsHTML		= .T.
	lSaveAsRTF		= .T.
	lSaveAsXLS		= .T.
	lSaveAsPDF		= .T.

	nPageTotal      = 0 && Total pages of the current report
	nCopies         = 1 && The quantity of copies to be printed
	cTitle          = "" && The preview window title 
	oListener = NULL
	cDefaultListener = "FXLISTENER"
	nCanvasCount = 1 && initial nr of pages rendered on the preview form. 
			&& Valid values are 1 (default), 2, or 4.

	nZoomLevel = 5 && initial zoom level of the preview window. Possible values are:
			&& 1-10%, 2-25%, 3-50%, 4-75%, 5-100% default, 6-150% ;
			&& 7-200%, 8-300%, 9-500%, 10-whole page

	lExtended = .T. && Flag that tells if the report is being run automatically
					&& using the _REPORTPERVIEW global variable

	nWindowState = 0 && Normal
	nDockType	= .F.

	cDestFile       = ""  && the destination file (image, htm, pdf, etc)
	lPrinted        = .F.  && knows if the user printed the report
	lSaved          = .F.  && knows if the user saved the report to a file

	cFormIcon  = "" && "wwrite.ico"
	lEmailAuto = .T.
	cEmailType = "PDF"
	lEmailed   = .F.
	cCodePage  = "CP1252" && CodePage, to be used by PDF Listener





	* Internal use properties
	_oReports = "" && Internal use, collection that contains the report names to be used
	_oClauses = ""


PROCEDURE AddReport(tcReport, tcClauses)
* populates a collection object with the report files and clauses
* This method can be called many times, providing an easy way to merge reports.

	LOCAL lcReport, lcTempDir, lcFile
	lcTempDir = ADDBS(GETENV("TEMP"))

	* Retrieve the FRX and FRT files from the EXE
	lcFile = lcTempDir + "TMP_FP_" + SYS(2015) + "."

	IF EMPTY(SYS(2000, tcReport))
		STRTOFILE(FILETOSTR(FORCEEXT(tcReport,"FRX")), lcFile + "FRX")
		STRTOFILE(FILETOSTR(FORCEEXT(tcReport,"FRT")), lcFile + "FRT")
	ELSE
		lcFile = tcReport
	ENDIF 

	IF VARTYPE(This._oReports) <> "O"
		This._oReports = CREATEOBJECT("Collection")
		This._oClauses = CREATEOBJECT("Collection")
	ENDIF
	This._oReports.Add(FORCEEXT(lcFile, "FRX"))
	This._oClauses.Add(EVL(tcClauses,""))
ENDPROC


PROCEDURE RunReport

	SET PROCEDURE TO FoxyPreviewer.App ADDITIVE 

	LOCAL loReport as "PreviewHelper" OF "FoxyPreviewer.App"
	loReport = CREATEOBJECT("PreviewHelper")
	
	WITH loReport

		LOCAL n, lnCount
		lnCount = This._oReports.Count
		FOR n = 1 TO lnCount
			loReport.AddReport(This._oReports(n), This._oClauses(n))
		ENDFOR

		.cTitle 			= This.cTitle
		.lSendToEmail 		= This.lSendToEmail 
		.lSaveToFile 		= This.lSaveToFile 
		.lShowCopies 		= This.lShowCopies 
		.lShowMiniatures 	= This.lShowMiniatures 
		.lPrintVisible		= This.lPrintVisible
		.lPrinterPref		= This.lPrinterPref

		.nCopies 			= This.nCopies
		.lPrintVisible 		= This.lPrintVisible
		.cDefaultListener 	= This.cDefaultListener 
		.nCanvasCount 		= This.nCanvasCount 
		.nZoomLevel 		= This.nZoomLevel 
		.oListener			= This.oListener
		.cPrinterName 		= This.cPrinterName

		.lSaveAsImage		= This.lSaveAsImage
		.lSaveAsHTML		= This.lSaveAsHTML
		.lSaveAsRTF			= This.lSaveAsRTF
		.lSaveAsXLS			= This.lSaveAsXLS
		.lSaveAsPDF			= This.lSaveAsPDF

		.nWindowState		= This.nWindowState
		.nDockType			= This.nDockType
		
		IF NOT EMPTY(This.cFormIcon) 
			.cFormIcon  = This.cFormIcon
		ENDIF 

		.lEmailAuto = This.lEmailAuto
		.cEmailType = This.cEmailType
		.lEmailed   = This.lEmailed
		.cCodePage  = This.cCodePage
		
	ENDWITH 

	loReport.RunReport(This) && This flag will tell FoxyPreviewer that it has a caller object in an EXE
			&& The main class will update the properties "lSaved" and "lPrinted"

ENDPROC 

PROCEDURE Destroy
	* Clean up, delete the temporary FRX files
	LOCAL n, lnCount, lcFile
	lnCount = This._oReports.Count
	FOR n = 1 TO lnCount
		lcFile = This._oReports(n)
		IF LEFT(JUSTFNAME(lcFile),7) = "TMP_FP_" && We have a temp FRX file to delete
			TRY 
				DELETE FILE (lcFile)
				DELETE FILE FORCEEXT(lcFile, "FRT")
			CATCH
			ENDTRY 
		ENDIF 
	ENDFOR
ENDPROC 

ENDDEFINE