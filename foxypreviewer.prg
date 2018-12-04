* FoxyPreviewer Version 1.31

#INCLUDE FoxyPreviewer.h

LPARAMETER loPreviewContainer

LOCAL loPreviewContainer AS FORM, ;
	loListener AS REPORTLISTENER, ;
	loExHandler AS ExtensionHandler OF SYS(16)

*-- Get a preview container from the
*-- .APP registered to handle object-assisted
*-- report previewing.
loPreviewContainer = NULL
DO HOME() + "ReportPreview.App" WITH loPreviewContainer

* Create a PREVIEW listener
TRY 
	loListener = NEWOBJECT('FXListener', "Listener.vcx", "ReportOutput.App")
CATCH
	loListener = CREATEOBJECT("ReportListener")
ENDTRY 
loListener.LISTENERTYPE = 1 && Preview

*-- Link the Listener and preview container
loListener.PREVIEWCONTAINER = loPreviewContainer

* Create an extension handler and hook it to the
* preview container. This will let you manipulate
* properties of the container and its Preview toolbar
loExHandler = NEWOBJECT('ExtensionHandler')

RELEASE goHelper
PUBLIC  goHelper
goHelper = CREATEOBJECT("PreviewHelper")
goHelper.lExtended = .F.

loPreviewContainer.SetExtensionHandler(loExHandler)

RELEASE loPreviewContainer, loListener, loExHandler
RETURN


DEFINE CLASS PreviewHelper AS Custom
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

	lQuietMode      = .T.

	cDestFile       = ""  && the destination file (image, htm, pdf, etc)
	lPrinted        = .F.  && knows if the user printed the report
	lSaved          = .F.  && knows if the user saved the report to a file
	lEmailed 		= .F.  && knows if the user emailed the report

	nPageTotal      = 0 && Total pages of the current report
	nCopies         = 1 && The quantity of copies to be printed
	cTitle          = PR_REPORTTITLE && The preview window title 
	oListener = NULL
	cDefaultListener = "FXLISTENER"
	nCanvasCount = 1 && initial nr of pages rendered on the preview form. 
			&& Valid values are 1 (default), 2, or 4.

	nZoomLevel	= 5 && initial zoom level of the preview window. Possible values are:
			&& 1-10%, 2-25%, 3-50%, 4-75%, 5-100% default, 6-150% ;
			&& 7-200%, 8-300%, 9-500%, 10-whole page

	lExtended	= .T. && Flag that tells if the report is being run automatically
					&& using the _REPORTPERVIEW global variable

	nWindowState = 0 && Normal

	nDockType	= .F. && false MEANS TO KEEP THE CURRENT DOCK SETTINGS FROM THE RESOURCE
	*!*		–1 Undocks the toolbar or form.
	*!*	 	 0 Positions the toolbar or form at the top of the main Visual FoxPro window.
	*!*		 1 Positions the toolbar or form at the left side of the main Visual FoxPro window.
	*!*		 2 Positions the toolbar or form at the right side of the main Visual FoxPro window.
	*!*		 3 Positions the toolbar or form at the bottom of the main Visual FoxPro window.

 	cFormIcon = PR_FORMICON

	lEmailAuto = .T. 		&& Automatically generates the report output file
	cEmailType = "PDF" 		&& The file type to be used in Emails (PDF, RTF, HTML or XLS)
	cCodePage  = "CP1252"	&& CodePage, to be used by PDF Listener
	*!*	CP1250 Microsoft Windows Codepage 1250 (EE)
	*!*	CP1251 Microsoft Windows Codepage 1251 (Cyrl)
	*!*	CP1252 Microsoft Windows Codepage 1252 (ANSI)
	*!*	CP1253 Microsoft Windows Codepage 1253 (Greek)
	*!*	CP1254 Microsoft Windows Codepage 1254 (Turk)
	*!*	CP1255 Microsoft Windows Codepage 1255 (Hebr)
	*!*	CP1256 Microsoft Windows Codepage 1256 (Arab)
	*!*	CP1257 Microsoft Windows Codepage 1257 (BaltRim)
	*!*	CP1258 Microsoft Windows Codepage 1258 (Viet)

	cWaterMarkImage = ""
 	lPDFasImage     = .F.
 
	* Internal use properties
	_ClausenRangeFrom = 1
	_ClausenRangeTo = -1 && All pages
	
	_ClausenPrintRangeFrom = 0
	_ClausenPrintRangeTo   = 0
	
	_ClauselSummary = .F.
	_ClausecHeading = ""

	_cFRXName      = "" && the ReportFrxName
	_cFRXFullName  = ""

	_oReports = "" && Internal use, collection that contains the report names to be used
	_oReportSource = ""
	_oClauses = ""
	_oProofSheet = ""

	_cOriginalPrinter = SET("Printer",3)
	_lSendToPrinter = .F.	&& Flag that will tell the object to 
							&& run the report again and send the output 
							&& to another printer after the preview window is closed
	_lNoWait = .F.
	_OldReportOutput = ""
	_oExHandler = ""
	_oCaller = "" && The caller object, used in the APP mode, when called from an EXE
	_oParentForm = ""
	_DE_Name = "" && the dataenvironment name, to be used on cleanup
	_oReport = ""
	_lSendingEmail = .F.

	_cDefaultFolder = SYS(5) + SYS(2003)

PROCEDURE Init
	IF This.lExtended = .T.
		RELEASE goHelper
		PUBLIC goHelper
		goHelper = This

		LOCAL lcClassPath, lcPDFFile, lcTestPath
		lcClassPath = IIF(EMPTY(This.ClassLibrary), "", ADDBS(JUSTPATH(This.ClassLibrary)))
		lcPDFFile = "libhpdf.dll"
		IF FILE(lcPDFFile) AND EMPTY(SYS(2000,lcPDFFile))
			** File is an embedded resource
			lcTestPath = lcClassPath + lcPDFFile && FULLPATH("libhpdf.dll")
			IF PR_PathFileExists(lcTestPath + CHR(0)) = 0
				STRTOFILE(FILETOSTR(lcPDFFile), lcClassPath + lcPDFFile)
			ENDIF
		ENDIF 
	ENDIF 

ENDPROC 

PROCEDURE Destroy

	LOCAL loParent as Custom  
	loParent = This._oCaller
	IF VARTYPE(loParent) = "O"
		loParent.lSaved = This.lSaved
		loParent.lPrinted = This.lPrinted
		loParent.cDestFile = This.cDestFile
	ENDIF 

	This._oReport = NULL


	IF NOT EMPTY(This.cWatermarkImage)
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
	ENDIF 

	* Just for safety, to ensure the helper object will not remain in memory
	RELEASE goHelper
ENDPROC 










PROCEDURE CloseProof
	IF VARTYPE(This._oProofSheet) = "O"
		This._oProofSheet.Release()
	ENDIF 
ENDPROC 


PROCEDURE AddReport(tcReport, tcClauses)
* populates a collection object with the report files and clauses
* This method can be called many times, providing an easy way to merge reports.
	IF VARTYPE(This._oReports) <> "O"
		This._oReportSource = CREATEOBJECT("Collection")
		This._oClauses = CREATEOBJECT("Collection")
	ENDIF
	This._oReportSource.Add(tcReport)
	This._oClauses.Add(EVL(tcClauses,""))
ENDPROC


PROCEDURE PrepareFRX
	LOCAL n, lnCount, lcSrcFile, lcDstFile, lcReport, lcTempDir
	lcTempDir = ADDBS(GETENV("TEMP"))
	lnCount = This._oReportSource.Count

	This._oReports = CREATEOBJECT("Collection")

	LOCAL loWM as WaterMarkHelper


	FOR n = 1 TO lnCount

		IF NOT EMPTY(goHelper.cWaterMarkImage)

			lcSrcFile = FORCEEXT(This._oReportSource(n), "FRX")
			lcDstFile = lcTempDir + "TMP_FP_" + SYS(2015) + "."
		
			COPY FILE (lcSrcFile) TO (lcDstFile + "FRX")
			COPY FILE (FORCEEXT(lcSrcFile, "FRT")) TO (lcDstFile + "FRT")

			loWM = CREATEOBJECT("WaterMarkHelper")
			WITH loWM
				.cWaterMarkImage = goHelper.cWaterMarkImage
				.nWaterMarkRatio = 0.9    && 100%
				.nWaterMarkType  = 2    && 2 = stretch   1 = Isometric
				.nWaterMarkAlpha = 0.9 && 25%
				.cReport         = lcSrcFile
				.lMakeTemp       = .T.
			ENDWITH 
			
			loWM.AddWaterMark()
			This._oReports.Add(loWM.cWMReport)
			loWM = NULL && cleans up temp files
	
		ELSE 
*			This._oReports.Add(lcDstFile + "FRX")
			This._oReports.Add(This._oReportSource(n))
		ENDIF 

	ENDFOR

ENDPROC



PROCEDURE CallReport(toListener as ReportListener, tlKeepHandle)
	* Executar o relatório
	LOCAL lcReport, lcClauses, loListener as ReportListener 

	IF VARTYPE(toListener) = "O"
		loListener = toListener
	ELSE
		loListener = This.oListener
	ENDIF 

	IF UPPER(ALLTRIM(SET("Printer", 3))) <> UPPER(This.cPrinterName)
		This.SetPrinter(This.cPrinterName)
	ENDIF 
		
	* For the case of labels we'll not deal with merged reports
	IF LOWER(JUSTEXT(This._oReports(1))) = "lbx"
		lcReport = This._oReports(1)
		lcClauses = This._oClauses(1)
		LABEL FORM (lcReport) OBJECT loListener &lcClauses.
	ELSE
		LOCAL lcUser, n, lnCount
		lnCount = This._oReports.Count

		FOR n = 1 TO lnCount
			DO CASE
			CASE lnCount = 1 OR lnCount = n
				lcUser = ""
			OTHERWISE
				lcUser = "NOPAGEEJECT" && + " NORESET"
			ENDCASE
			lcReport = This._oReports(n)
			lcClauses = This._oClauses(n)

			IF tlKeepHandle
				IF n = lnCount
					loListener.WaitForNextReport = .F. && last report, allow closing
				ELSE 
					loListener.WaitForNextReport = .T.
				ENDIF 
			ENDIF
			
			IF NOT FILE(FORCEEXT(lcReport, "FRX"))
				MESSAGEBOX("Could not locate the Report source file: " + lcReport, 16, "FoxyPreviewer error")
				* LOOP 
			ENDIF
	
			REPORT FORM (lcReport) OBJECT loListener &lcClauses. &lcUser. 
		ENDFOR
	ENDIF 
ENDPROC


PROCEDURE RestorePrinter
	WITH This
		IF UPPER(._cOriginalPrinter) <> UPPER(SET("Printer",3)) && Current printer
			.SetPrinter(._cOriginalPrinter)
		ENDIF 
	ENDWITH 
ENDPROC 


PROCEDURE RunReport(toParent)

	IF APRINTERS(gaPrinters) = 0
		MESSAGEBOX(PR_ERRNOPRINTER, 16, PR_ERROR)
		RETURN .F.
	ENDIF 


	WITH This
		.lPrinted = .F.
		._oCaller = toParent

		.PrepareFRX()

		IF VARTYPE(.oListener) <> "O"
			* Create a PREVIEW listener
			TRY 
				.oListener = CREATEOBJECT(.cDefaultListener)
			CATCH
				.oListener = CREATEOBJECT("ReportListener")
			ENDTRY 
		ENDIF


		IF EMPTY(This.cDestFile)
	*		DO (_ReportOutput) WITH 3, .oListener
			DO (ADDBS(HOME()) + "ReportOutput.App") WITH 3, .oListener
	
			.oListener.ListenerType = 1 && Preview

			LOCAL loPreviewContainer
			loPreviewContainer = NULL

			DO HOME() + "ReportPreview.App" WITH loPreviewContainer

			* Create an extension handler and hook it to the
			* preview container. This will let you manipulate
			* properties of the container and its Preview toolbar
			LOCAL loExHandler as ExtensionHandler OF SYS(16)
			loExHandler = NEWOBJECT('ExtensionHandler')
			loPreviewContainer.SetExtensionHandler(loExHandler)
			goHelper._oExHandler = loExHandler

			loPreviewContainer.ZoomLevel = goHelper.nZoomLevel
			loPreviewContainer.CanvasCount = goHelper.nCanvasCount

			* Link the Listener and preview container
			.oListener.PreviewContainer = loPreviewContainer

			* Run the report
			.CallReport()
		ENDIF 
		IF NOT goHelper._lNoWait
			This.DoOutput()
		ENDIF 

	ENDWITH 
	
ENDPROC 	


PROCEDURE DoOutput
	LPARAMETERS tlEmail

	WITH This
		LOCAL lcFileFormat
		lcFileFormat = ""
		
		* Prepare the output file
		IF NOT EMPTY(.cDestFile) AND NOT .lSaved
			.lSaveToFile = .T.
			lcFileFormat = LOWER(JUSTEXT(.cDestFile))

			* 1st step, try to delete a file with the same name
			TRY 
				ERASE (.cDestFile)
			CATCH 
			ENDTRY 

		ENDIF

	ENDWITH

	DO CASE
		CASE This.lSaved

		CASE lcFileFormat = "pdf"
		* Using PDFx - by Luis Navas

		LOCAL lnType
		lnType = IIF(goHelper.lPDFasImage, 2, 1)
				&& 1 = normal PDF, 2 = Image
		If lnType = 1 Then && Normal Pdf	
			Local loListener As "PdfListener" Of "PR_Pdfx.vcx"
			loListener = NewObject('PdfListener', 'PR_PDFx.vcx')
			loListener.cCodePage = goHelper.cCodePage &&CodePage
		Else &&PDF As Image
			Local loListener As "PDFasImageListener" Of "PR_Pdfx.vcx"
			loListener = NewObject('PDFasImageListener', 'PR_PDFx.vcx')
		EndIf

		loListener.cTargetFileName = Alltrim(This.cDestFile)
		loListener.QuietMode   = goHelper.lQuietMode
		loListener.lCanPrint   = .T.
		loListener.lCanEdit    = .T.
		loListener.lCanCopy    = .T.
		loListener.lCanAddNotes= .T.
		loListener.lEncryptDocument = .F.
		loListener.cMasterPassword  = ""
		loListener.cUserPassword    = ""
		loListener.lOpenViewer      = .F.
		*To be Developed, not ready yet
		*	loListener.MergeDocument=.MergeDocument.Value
		*	loListener.MergeDocumentName=.MergeFileName.Value

		This.CallReport(loListener, .T.) && flag to keep opened till last report
		loListener = NULL

		IF NOT FILE(This.cDestFile)
			MESSAGEBOX(PR_ERR_CREATINGFILE, 0+16, PR_ERROR)
		ELSE
			This.lSaved = .T.
		ENDIF


	CASE INLIST(lcFileFormat, "htm", "html")

		*!*	loListener2 = NewObject("UtilityReportListener", "_ReportListener.vcx")
		*!*	loListener2.ListenerType = 5
		*!*	loListener2.TargetFileName = This.cDestFile
		*!*	This.CallReport(loListener2)
		*!*	loListener2 = NULL

	
		DEFINE WINDOW Window_HTML FROM 04,05 TO 27,75 
		ACTIVATE WINDOW Window_HTML NOSHOW 

		LOCAL loListener2 as "HTMLListener" OF HOME() + "FFC/_ReportListener.vcx"
*		loListener2 = NEWOBJECT("HTMLListener", HOME() + "FFC/_ReportListener.vcx")
		loListener2 = NEWOBJECT("HTMLListener", "_ReportListener.vcx")
		loListener2.TargetFileName = This.cDestFile
		loListener2.QuietMode = goHelper.lQuietMode

		* Run the report
		This.CallReport(loListener2)
		loListener2 = NULL

		RELEASE WINDOWS Window_HTML

		IF NOT FILE(This.cDestFile)
			MESSAGEBOX(PR_ERR_CREATINGFILE, 0+16, PR_ERROR)
		ELSE
			This.lSaved = .T.
		ENDIF

	CASE INLIST(lcFileFormat, "rtf", "doc")
		* Using RTFListener bt Vladimir Zhuravlev

		loRtfListener = NEWOBJECT("RTFreportlistener", "PR_RTFListener")
		loRtfListener.TargetFileName = This.cDestFile
*		loRtfListener.OutputType = 1

		This.CallReport(loRtfListener, .T.) && flag to keep opened till last report
		loRtfListener = NULL

		IF NOT FILE(This.cDestFile)
			MESSAGEBOX(PR_ERR_CREATINGFILE, 0+16, PR_ERROR)
		ELSE
			This.lSaved = .T.
		ENDIF


	Case Inlist(lcFileFormat, "xls")
		Local loReportListener As "ExcelListener" Of Home() + "FFC/_ReportListener.vcx"
		loReportListener = Newobject("ExcelListener","pr_ExcelListener.vcx")
		loReportListener.ListenerType = 3	&& ?
		loReportListener.lOutputToCursor = .T.
		loReportListener.cWorkbookFile	= This.cDestFile
		loReportListener.cWorksheetName = "Sheet"

		This.CallReport(loReportListener, .F.) && flag to keep opened till last report
		loReportListener = Null

		If Not File(This.cDestFile)
			Messagebox(PR_ERR_CREATINGFILE, 0+16, PR_ERROR)
		Else
			This.lSaved = .T.
		Endif
	

	CASE This._lSendToPrinter

		TRY 
			LOCAL loListener as ReportListener 
			TRY 
				loListener = CREATEOBJECT(This.cDefaultListener)
			CATCH
				loListener = CREATEOBJECT("ReportListener")
			ENDTRY
			loListener.ListenerType = 0 && Printer Output

*!*				IF goHelper._ClausenPrintRangeFrom > 0
*!*					loListener.CommandClauses.PrintRangeFrom = goHelper._ClausenPrintRangeFrom
*!*					loListener.CommandClauses.PrintRangeTo   = goHelper._ClausenPrintRangeTo
*!*				ENDIF 

			FOR n = 1 TO This.nCopies
				This.CallReport(loListener)
			ENDFOR 

			This.lPrinted = .T.
			This.RestorePrinter()

		CATCH TO loException
		ENDTRY 

	OTHERWISE 

	ENDCASE


	IF goHelper._lSendingEmail = .T.

		IF NOT FILE(This.cDestFile)
			MESSAGEBOX(PR_ERR_CREATINGFILE, 0+16, PR_ERROR)

		ELSE 
			
*!*				LOCAL hWindow, lcDelimiter, lcFiles, lcMsgSubj
*!*				hWindow = PR_GetActiveWindow()
*!*				lcDelimiter = ";"
*!*				lcMsgSubj = JUSTFNAME(This.cDestFile)
*!*				=PR_MAPISendDocuments (hWindow, lcDelimiter, (This.cDestFile), lcMsgSubj, 0)

			=SendMailEx(This.cDestFile)

			goHelper.lEmailed = .T.
		
			*	lEmailAuto = .T. && Automatically generates the report output file
			*	cEmailType = "PDF" && The file type to be used in Emails (PDF, RTF, HTML or XLS)
			IF goHelper.lEmailAuto
				TRY 
					DELETE FILE (This.cDestFile)
				CATCH
				ENDTRY
				goHelper.lSaved = .F.
			ENDIF 

		ENDIF 

	ENDIF 

	* Restore the default directory
	SET DEFAULT TO (goHelper._cDefaultFolder)

	This.ReportReleased()

ENDPROC




PROCEDURE ReportReleased(toExt)

	UNBINDEVENTS(This)
	DOEVENTS 
	* WAIT WINDOW ("Preview Closed" + CHR(13) + ;
		This.cPrinterName + CHR(13) + ;
		This._cFRXName) NOWAIT 

	IF VARTYPE(toExt) = "O"
		toExt = NULL
	ENDIF 

	* if changed, restore the printer to the original
	IF UPPER(This._cOriginalPrinter) <> UPPER(This.cPrinterName)
		This.SetPrinter(This._cOriginalPrinter)
	ENDIF 

	This.CloseProof()


	* Restore the default folder if needed
	IF (SET("Default") + SYS(2003)) <> goHelper._cDefaultFolder
		SET DEFAULT TO (goHelper._cDefaultFolder)
	ENDIF 


	RELEASE goHelper

ENDPROC




PROCEDURE ClearCache
	* Trying to clear the report preview cache
	* If there is another Preview factory, disable it
	* http://spacefold.com/colin/archive/articles/reportpreview/rp_extend.html

	LOCAL lcFile
	lcFile = _ReportPreview

	TRY 
		_oReportOutput["1"].PreviewContainer = .NULL.
	CATCH 
	ENDTRY 

	* Prepare the new Report preview factory
	_ReportPreview = lcFile
	SET REPORTBEHAVIOR 90
ENDPROC 


PROCEDURE SetPrinter(tcPrinterName)
	LOCAL lcPrinter, llReturn
	llReturn  = .T. 
	lcPrinter = tcPrinterName
	TRY 
		SET PRINTER TO NAME '&lcPrinter'
	CATCH
		llReturn = .F.
	ENDTRY 
	RETURN llReturn
ENDPROC 


ENDDEFINE


*-------------------------
*-------------------------
DEFINE CLASS ExtensionHandler AS CUSTOM
	*-- Ref to the Preview Container's Preview Form
	PreviewForm  = NULL

	PROCEDURE STB_Handler(lEnabled)
		* Here you work around the setting
		* persistence problem in the Preview toolbar. 
		* The Preview toolbar class (frxpreviewtoolbar)
		* already has code that you can use to enforce
		* setting's persistence; it is just not called. Here,
		* you call it.
		WITH THIS.PreviewForm.TOOLBAR
			.REFRESH()
			* When you call frxpreviewtoolbar::REFRESH(), the
			* toolbar caption is set to its Preview form,
			* which differs from typical behavior. You must revert that
			* to be consistent. If you did not do this,
			* you would see " - Page 2" appended to the toolbar
			* caption if you skipped pages.
			.CAPTION = THIS.PreviewForm.formCaption
		ENDWITH
	ENDPROC


	PROCEDURE AddBarsToMenu( cPopup, iNextBar )
	* Rename the menu text to portuguese version
	* RELEASE BAR 8 OF (m.cPopup)

	DEFINE BAR 1 OF (m.cPopup) PROMPT PR_MENUTOP   PICTURE "pr_top.bmp"
	DEFINE BAR 2 OF (m.cPopup) PROMPT PR_MENUPREV  PICTURE "pr_previous.bmp"
	DEFINE BAR 3 OF (m.cPopup) PROMPT PR_MENUNEXT  PICTURE "pr_next.bmp"
	DEFINE BAR 4 OF (m.cPopup) PROMPT PR_MENULAST  PICTURE "pr_bottom.bmp" 
	DEFINE BAR 5 OF (m.cPopup) PROMPT PR_MENUGOTO  PICTURE "pr_gotopage.bmp" 
	DEFINE BAR 8 OF (m.cPopup) PROMPT PR_MENUSHOWPAGES 
	DEFINE BAR 10 OF (m.cPopup) PROMPT PR_MENUTOOLB 
	DEFINE BAR 13 OF (m.cPopup) PROMPT PR_MENUCLOSE  PICTURE "pr_close.bmp" 


	#IFDEF PR_CBOZOOMTTIP 
		DEFINE BAR 7 OF (m.cPopup) PROMPT PR_CBOZOOMTTIP 
	#ENDIF


	ON SELECTION BAR 5 OF (m.cPopup) ; 
		    oRef.ExtensionHandler.ActionGotoPage()

	ON SELECTION BAR 13 OF (m.cPopup) ; 
		    oRef.ExtensionHandler.ActionClose()

	ON SELECTION BAR 10 OF (m.cPopup) oRef.ExtensionHandler.actionToolbarVisibility()

	IF goHelper.lPrintVisible
	
        DEFINE BAR 15 ;
			OF (m.cPopup) ;
			PROMPT PR_MENUPRINT ;
			PICTURE "pr_print.bmp" 

        ON SELECTION BAR 15 OF (m.cPopup) ; 
		    oRef.ExtensionHandler.ActionPrint()

		* Printing preferences item
		IF goHelper.lPrinterPref
			DEFINE BAR 16 ;
				OF (m.cPopup) ;
				PROMPT PR_PRINTINGPREF ;
				PICTURE "pr_printPref.bmp" 

			ON SELECTION BAR 16 OF (m.cPopup) ; 
				oRef.ExtensionHandler.DoCustomPrint()
		ENDIF 

 
 		* Save to file item
		IF goHelper.lSaveToFile
	        DEFINE BAR 17 ;
				OF (m.cPopup) ;
				PROMPT PR_SAVEREPORT ;
				PICTURE "pr_Save.bmp" 

			LOCAL lcSaveMenu
			lcSaveMenu = SYS(2015)
	
			DEFINE POPUP (m.lcSaveMenu) SHORTCUT RELATIVE
			IF NOT goHelper.lExtended && Original report
	    	    ON SELECTION BAR 17 OF (m.cPopup) ; 
					oRef.ExtensionHandler.DoSaveType(1)
			ELSE 
	
				ON BAR 17 OF (m.cPopup) ACTIVATE POPUP &lcSaveMenu.
	
				IF goHelper.lSaveAsImage
					DEFINE BAR 1 OF (lcSaveMenu) PROMPT PR_SAVEASIMAGE PICTURE "pr_Img.bmp"
					on Selection Bar 1 of (lcSaveMenu) oRef.ExtensionHandler.DoSaveType(1)
				ENDIF 
				
				IF goHelper.lExtended
					IF goHelper.lSaveAsPDF
						DEFINE BAR 2 OF (lcSaveMenu) PROMPT PR_SAVEASPDF  PICTURE "pr_Pdf.bmp"
						on Selection Bar 2 of (lcSaveMenu) oRef.ExtensionHandler.DoSaveType(2)
					ENDIF 
					IF goHelper.lSaveAsHTML
						DEFINE BAR 3 OF (lcSaveMenu) PROMPT PR_SAVEASHTML PICTURE "pr_Html.bmp"
						on Selection Bar 3 of (lcSaveMenu) oRef.ExtensionHandler.DoSaveType(3)
					ENDIF 
					IF goHelper.lSaveAsRTF
						DEFINE BAR 4 OF (lcSaveMenu) PROMPT PR_SAVEASRTF  PICTURE "pr_Word.bmp"
						on Selection Bar 4 of (lcSaveMenu) oRef.ExtensionHandler.DoSaveType(4)
					ENDIF 
					IF goHelper.lSaveAsXLS
						DEFINE BAR 5 OF (lcSaveMenu) PROMPT PR_SAVEASXLS  PICTURE "pr_Excel.bmp"
						on Selection Bar 5 of (lcSaveMenu) oRef.ExtensionHandler.DoSaveType(5)
					ENDIF 
				ENDIF 
*!*					FOR n = 1 TO 5
*!*						on Selection Bar n of (lcSaveMenu) oRef.ExtensionHandler.DoSaveType(BAR())
*!*					ENDFOR 
			ENDIF 

		ENDIF 
	ENDIF 



	* Show miniatures
	IF goHelper.lShowMiniatures
		DEFINE BAR 18 OF (m.cPopup) PROMPT '\-'

        DEFINE BAR 19 ;
			OF (m.cPopup) ;
			PROMPT PR_MENUPROOF ;
			PICTURE "pr_Locate.bmp" 

		* It is a documented fact that, at the time
		* the popup is activated, there is an object 
		* reference to the PreviewContainer instance
		* in scope in a variable called "oRef":
        ON SELECTION BAR 19 OF (m.cPopup) ; 
		    oRef.ExtensionHandler.DoProof()
	ENDIF 


	* Translating the Zoom and Page menu items for non English users
	#IFDEF PR_NONENGLISH

	PRIVATE lcZoom2, lcPages2
	lcZoom2  = SYS(2015)
	lcPages2 = SYS(2015)
	ON BAR 7 OF (m.cPopup) ACTIVATE POPUP &lcZoom2
	ON BAR 8 OF (m.cPopup) ACTIVATE POPUP &lcPages2

	*------------------------------------------------------
	* Define the Zoom popup: 
	* slightly adapted from the Report Preview project
	* the author of this piece of code is MS, (Lisa Slater Nicholls)
	* code extracted from the XSource.Zip file
	*------------------------------------------------------
	DEFINE POPUP (m.lcZoom2) SHORTCUT RELATIVE

	* Loop through all the array items, in case user is using a modified 
	* context menu (Joao Batista)
	*!*		oRef.ZoomLevels(10,1) = PR_CBOZOOMWHOLEPG
	*!*		oRef.ZoomLevels(11,1) = PR_CBOZOOMPGWIDTH

	LOCAL lcItem, i
	FOR i = 1 TO ALEN(oRef.ZoomLevels, 1) && Rows
		lcItem = LOWER(oRef.ZoomLevels(i, 1))
		IF lcItem = "whole page"
			oRef.ZoomLevels(i, 1) = PR_CBOZOOMWHOLEPG
		ENDIF
		IF lcItem = "fit to width"
			oRef.ZoomLevels(i, 1) = PR_CBOZOOMPGWIDTH
		ENDIF
	ENDFOR 

	for i = 1 to alen(oRef.ZoomLevels,1)
		define Bar m.i of(m.lcZoom2) prompt oRef.zoomLevels[m.i,1] && ZOOM_LEVEL_PROMPT
		on Selection Bar m.i of (m.lcZoom2) oref.actionSetZoom( bar() )
	endfor
	*---------------------- Set the mark:
	set mark of bar (oRef.ZoomLevel) of (m.lcZoom2) to .T.

	
	*------------------------------------------------------
	* Define the Page Count popup:
	*------------------------------------------------------
	DEFINE POPUP (m.lcPages2) SHORTCUT RELATIVE
	DEFINE BAR 1 OF (m.lcPages2) PROMPT PR_ONEPGMENU

	*---------------------- Disable multi-page view for high zoom levels:
	local iPagesAllowed
	iPagesAllowed = oRef.ZoomLevels[ oRef.zoomLevel, 3 ] && ZOOM_LEVEL_CANVAS
*	iPagesAllowed = MIN(goHelper.nPageTotal, iPagesAllowed)

	if m.iPagesAllowed > 1
		DEFINE BAR 2 OF (m.lcPages2) PROMPT PR_TWOPGMENU
	else
		DEFINE BAR 2 OF (m.lcPages2) PROMPT "\" + PR_TWOPGMENU
	endif
	if m.iPagesAllowed > 2
		DEFINE BAR 3 OF (m.lcPages2) PROMPT PR_FOURPGMENU
	else
		DEFINE BAR 3 OF (m.lcPages2) PROMPT "\" + PR_FOURPGMENU
	endif

	ON SELECTION BAR 1 OF (m.lcPages2) oRef.actionSetCanvasCount(1)		
	ON SELECTION BAR 2 OF (m.lcPages2) oRef.actionSetCanvasCount(2)
	ON SELECTION BAR 3 OF (m.lcPages2) oRef.actionSetCanvasCount(4)

	*---------------------- Set the mark:
	do case
	case oRef.canvasCount = 1
		set Mark of bar 1 of (m.lcPages2) to .T.
	case oRef.canvasCount = 2
		set Mark of bar 2 of (m.lcPages2) to .T.
	case oRef.canvasCount = 4
		set Mark of bar 3 of (m.lcPages2) to .T.
	endcase
	#ENDIF

	ENDPROC


	PROCEDURE CheckHelperClass
		IF VARTYPE(goHelper) <> "O"
			PUBLIC goHelper
			goHelper = CREATEOBJECT("PreviewHelper")
			goHelper.lExtended = .F.
		ENDIF 
	ENDPROC 


	PROCEDURE ActionToolbarVisibility
		*--------------------------------------------------
		* .ActionToolbarVisibility() - called from menu
		*--------------------------------------------------
		if isnull( THIS.PreviewForm.toolbar )
			THIS.PreviewForm.ToolbarIsVisible = .F.
			THIS.PreviewForm.CreateToolbar()
			This.UpdateToolbar()
		endif
		if THIS.PreviewForm.ToolbarIsVisible 
			* Hide the toolbar:
			THIS.PreviewForm.Toolbar.Hide()
			THIS.PreviewForm.ToolbarIsVisible = .F.
		else
			* Show the toolbar:
			THIS.PreviewForm.ShowToolbar(.T.)	
			THIS.PreviewForm.ToolbarIsVisible = .T.
		ENDIF
	ENDPROC 


	PROCEDURE ActionGoToPage
		*-----------------------------------------------------------
		* ActionGoToPage()
		*-----------------------------------------------------------
		#define WINDOWTYPE_MODELESS		0
		#define WINDOWTYPE_MODAL		1

		local loForm, iPageNo
		loForm = CREATEOBJECT("CustomFrxGotoPageForm")
		loForm.oParentForm = THIS.PreviewForm

		IF VARTYPE(THIS.PreviewForm.Toolbar) = "O"
			THIS.PreviewForm.ShowToolbar(.F.)
			loForm.Show( WINDOWTYPE_MODAL )
			THIS.PreviewForm.ShowToolbar(.T.)
		ELSE 
			loForm.Show( WINDOWTYPE_MODAL )		
		ENDIF 

		iPageNo = loForm.PageNo
		RELEASE m.loForm
		ACTIVATE WINDOW (THIS.PreviewForm.Name)

		IF m.iPageNo <> THIS.PreviewForm.currentPage
			THIS.PreviewForm.setCurrentPage( m.iPageNo )
		ENDIF 
	ENDPROC


	PROCEDURE DoCustomPrint
		*-----------------------------------------------------------
		* DoCustomPrint()
		*-----------------------------------------------------------
		IF UPPER(goHelper._cOriginalPrinter) <> UPPER(goHelper.cPrinterName)
			goHelper.SetPrinter(goHelper.cPrinterName)
		ENDIF 

		This.PreviewForm.oReport.CommandClauses.Prompt = .T.
		
		=BindPrinter(.T.)
		This.PreviewForm.oReport.onPreviewClose(.T.)
		This.RestoreParent()

		=BindPrinter(.F.)


		
		goHelper.lPrinted = .T.
	ENDPROC


	PROCEDURE ActionClose
		This.PreviewForm.oReport.OnPreviewClose(.F.)
		This.PreviewForm.oReport = NULL
		This.PreviewForm = NULL
		goHelper.ClearCache()
		This.RestoreParent()
	ENDPROC


	PROCEDURE RestoreParent
		UNBINDEVENTS(This)
		TRY 
			IF VARTYPE(goHelper._oParentForm) = "O"
				LOCAL loForm as Form
				loForm = goHelper._oParentForm 
				loForm.ControlBox = loForm.ControlBox
				loForm.TitleBar = loForm.TitleBar
				loForm.Closable = .T.
				loForm.Draw()
				loForm.Paint()
			ENDIF 
		CATCH
		ENDTRY 
	ENDPROC 


	PROCEDURE ActionPrint
		This.PreviewForm.oReport.OnPreviewClose(.T.)
	ENDPROC


	PROCEDURE ActionPrintEx
		* Ensure the proof sheet is closed
		goHelper.CloseProof()

		IF ALLTRIM(UPPER(goHelper.cPrinterName)) = ALLTRIM(UPPER(goHelper._cOriginalPrinter))
		&& Default printer not changed, go ahead with the default behavior	
			* Do the default behavior
			* Hide the Preview form
			This.PreviewForm.Visible = .F.

			* Print the current report
			goHelper.lPrinted = .T.
			
			* Decrease the nCopies property
			goHelper.nCopies = goHelper.nCopies - 1
			goHelper._lSendToPrinter = .T.
			This.PreviewForm.oReport.OnPreviewClose(.T.)

			IF NOT goHelper.lExtended
				goHelper.ClearCache()
			ENDIF 
		ELSE 
			&& Changed the printer, so finish the preview and
			&& print from outside the preview window
			goHelper._lSendToPrinter = goHelper.SetPrinter(goHelper.cPrinterName)
			This.PreviewForm.oReport.OnPreviewClose(.F.)
		ENDIF 
	
		IF goHelper._lNoWait
			goHelper.DoOutput()
		ENDIF 
	ENDPROC 


	PROCEDURE Show(iStyle)

		* Ensure that we have a parent helper class
		This.CheckHelperClass()

		WITH This.PreviewForm
			LOCAL llNoWait, llTopForm
			TRY
				llTopForm = This.PreviewForm.TopForm && to avoid the error "TopForm" property does not exist
			CATCH
			ENDTRY 

			This.PreviewForm.Icon = goHelper.cFormIcon

	* Don't permit the parent top-level form to be closable
	IF llTopForm OR This.PreviewForm.ShowWindow > 0 && In Top-Level or As Top-Level form
		LOCAL lcParentTitle, lcCaption, loForm as Form
		lcParentTitle = GetParentWindow()
		FOR EACH loForm IN _Screen.Forms FOXOBJECT 
			lcCaption = loForm.Caption
			IF lcCaption = lcParentTitle
		*		BINDEVENT(loForm, "QueryUnload", This, "ParentClosed")

				TRY 
					IF loForm.Closable = .T. 
						loForm.Closable = .F.
						BINDEVENT(This.PreviewForm, "QueryUnload", This, "RestoreParent")
						BINDEVENT(This.PreviewForm, "Destroy", This, "RestoreParent")
						goHelper._oParentForm = loForm
					ENDIF
				CATCH 
				ENDTRY 
				
				EXIT 
			ENDIF 
		ENDFOR 

*!*			* This is to add buttons directly in the PreviewForm canvas
*!*			BINDEVENT(This.PreviewForm, "SynchCanvases", This, "SynchCanvasesEx", 1)
*!*			This.AddButtonsToCanvas()

	ENDIF 

	*!*		LOCAL lcDE_Name && DataEnvironment name, to be used on cleanup
	*!*		lcDE_Name = This.PreviewForm.oReport.CommandClauses.DE_Name		
	*!*		goHelper._DE_Name = lcDE_Name
	*!*		* goHelper._oReport = This.PreviewForm.oReport

			llNowait = llTopForm or ;
				This.PreviewForm.oReport.CommandClauses.NoWait
			goHelper._lNoWait = llNowait

			IF VARTYPE(goHelper.nDockType) = "N" && false MEANS TO KEEP THE CURRENT DOCK SETTINGS FROM THE RESOURCE
				This.PreviewForm.Toolbar.dock(goHelper.nDockType)
				*!*	–1 Undocks the toolbar or form.
				*!*	 0 Positions the toolbar or form at the top of the main Visual FoxPro window.
				*!*	 1 Positions the toolbar or form at the left side of the main Visual FoxPro window.
				*!*	 2 Positions the toolbar or form at the right side of the main Visual FoxPro window.
				*!*	 3 Positions the toolbar or form at the bottom of the main Visual FoxPro window.
			ENDIF 

			* This.PreviewForm.oReport.CommandClauses.InWindow = ""

			* Defining the previewform.WindowState
			* 0 = Normal, 1 = Minimized, 2 = Maximized
			This.PreviewForm.WindowState = goHelper.nWindowState 

			LOCAL loListener
			loListener = This.PreviewForm.oReport

			goHelper.nPageTotal = .PageTotal
			goHelper._cFRXName  = .FrxFileName
		*!*	goHelper._cFRXFullName = loListener.CommandClausesFile

			* Retrieve report clauses
			goHelper._ClausenRangeFrom = loListener.CommandClauses.RangeFrom
			goHelper._ClausenRangeTo = loListener.CommandClauses.RangeTo && -1 = All pages
			goHelper._ClauselSummary = loListener.CommandClauses.Summary 
			goHelper._ClausecHeading = loListener.CommandClauses.Heading

		ENDWITH 

		This.UpdateToolBar()

		DODEFAULT(iStyle)
	ENDPROC

	*!* Only works after SP1, so we keep calling "UpdateToolbar()" directly
	*!*	PROCEDURE InitializeToolBar()
	*!*		This.UpdateToolBar()
	*!*	ENDPROC 

PROCEDURE AddButtonsToCanvas
	WITH This.PreviewForm
		.AddObject("cmdTopEx1","cmdTopEx")
		.AddObject("cmdPrevEx1","cmdPrevEx")
		.AddObject("cmdNextEx1","cmdNextEx")
		.AddObject("cmdBottomEx1","cmdBottomEx")
	
		.cmdPrevEx1.Left = .cmdTopEx1.Left + .cmdTopEx1.Width + 1
		.cmdNextEx1.Left = .cmdPrevEx1.Left + .cmdPrevEx1.Width + 1
		.cmdBottomEx1.Left = .cmdNextEx1.Left + .cmdNextEx1.Width + 1

	ENDWITH 
ENDPROC 

PROCEDURE SynchCanvasesEx
*---------------------------------
* SynchCanvases() - 
*
* re-arrange the Shapes on the page to match the 
* current settings:
*---------------------------------
*-------------------------------------------------------
* Canvas Offsets
*-------------------------------------------------------

#define CANVAS_TOP_OFFSET_PIXELS          30 &&15		
#define CANVAS_LEFT_OFFSET_PIXELS         15
#define CANVAS_VERTICAL_GAP_PIXELS        30 &&10
#define CANVAS_HORIZONTAL_GAP_PIXELS      10

with This.PreviewForm
*!*		*-----------------------------------------------------
*!*		* Prevent .RenderPages() from being called from within
*!*		* the .Paint() event:
*!*		*-----------------------------------------------------
*!*		.SuppressRendering = .T.

*!*		*-----------------------------------------------------
*!*		* Use a spacer to allow the scrolling to have a 
*!*		* a border to the right and bottom of the window:
*!*		*-----------------------------------------------------
*!*		.Spacer.BackColor = .BackColor
*!*		.Spacer.Width  = CANVAS_LEFT_OFFSET_PIXELS
*!*		.Spacer.Height = CANVAS_TOP_OFFSET_PIXELS

*!*		local iLeft, iWidth, iHeight, iZoomPercent

*!*		iZoomPercent = THIS.PreviewForm.getZoomPercent()
*!*		iWidth  	 = int( .pageWidth  * .screenDPI * (m.iZoomPercent/100) )
*!*		iHeight 	 = int( .pageHeight * .screenDPI * (m.iZoomPercent/100) )

*!*		do case
*!*		case THIS.PreviewForm.ZoomLevel < alen(THIS.PreviewForm.zoomLevels,1)-1
*!*			*---------------------------------------------------
*!*			* Enable scrollbars for arbitary zoom:
*!*			*---------------------------------------------------
*!*			if THIS.PreviewForm.ScrollBars <> 3
*!*				THIS.PreviewForm.ScrollBars = 3
*!*			endif
*!*		
*!*		case THIS.PreviewForm.ZoomLevel = alen(THIS.PreviewForm.ZoomLevels,1)-1
*!*			*---------------------------------------------------
*!*			* Turn off scrollbars for fit to page
*!*			*---------------------------------------------------
*!*			if THIS.PreviewForm.ScrollBars > 0
*!*				THIS.PreviewForm.ScrollBars = 0
*!*			endif

*!*		otherwise
*!*			*---------------------------------------------------
*!*			* Just vertical for fit to width
*!*			*---------------------------------------------------
*!*			if THIS.PreviewForm.ScrollBars <> 2
*!*				THIS.PreviewForm.ScrollBars = 2	
*!*			endif
*!*		endcase

*!*		*--------------------------------
*!*		* Arrange the shapes on the page:
*!*		*  [1][2]
*!*		*  [3][4]
*!*		*--------------------------------
*!*		do case
*!*		case .canvasCount = 1
*!*			if this.PreviewForm.Canvas1.Baseclass = "Image"
*!*				store .T. to this.PreviewForm.Canvas1.Visible
*!*				store .F. to ;
*!*					this.PreviewForm.Canvas2.Visible,;
*!*					this.PreviewForm.Canvas3.Visible,;
*!*					this.PreviewForm.Canvas4.Visible
*!*			endif				

*!*			if THIS.PreviewForm.zoomLevel = alen(THIS.PreviewForm.zoomLevels,1)
*!*				*-------------------------------------------
*!*				* Auto-zoom mode, center the page:
*!*				*-------------------------------------------
*!*				iLeft = int((.Width - m.iWidth)/2)
*!*			else
*!*				iLeft = CANVAS_LEFT_OFFSET_PIXELS
*!*			endif

*!*			.canvas1.Move(  m.iLeft, ;
*!*							CANVAS_TOP_OFFSET_PIXELS, ;
*!*							m.iWidth, m.iHeight )
*!*			.spacer.Move( m.iLeft + m.iWidth, CANVAS_TOP_OFFSET_PIXELS + m.iHeight )


*!*		case .canvasCount = 2
*!*			if this.PreviewForm.Canvas1.Baseclass = "Image"
*!*				store .T. to ;
*!*					this.PreviewForm.Canvas1.Visible, ;
*!*					this.PreviewForm.Canvas2.Visible
*!*				store .F. to ;
*!*					this.PreviewForm.Canvas3.Visible,;
*!*					this.PreviewForm.Canvas4.Visible
*!*			endif

*!*			.canvas1.Move(  CANVAS_LEFT_OFFSET_PIXELS, ;
*!*							CANVAS_TOP_OFFSET_PIXELS, ;
*!*							m.iWidth, m.iHeight )
*!*			.canvas2.Move(  CANVAS_LEFT_OFFSET_PIXELS + m.iWidth + CANVAS_HORIZONTAL_GAP_PIXELS, ;
*!*							CANVAS_TOP_OFFSET_PIXELS, ;
*!*							m.iWidth, m.iHeight )
*!*			.spacer.Move( 	.canvas2.Left + .canvas2.Width, ;
*!*							.canvas2.Top + .canvas2.Height )	


*!*		case .canvasCount = 4
*!*			if this.PreviewForm.Canvas1.Baseclass = "Image"
*!*				store .T. to ;
*!*					this.Canvas1.Visible, ;
*!*					this.Canvas2.Visible, ;
*!*					this.Canvas3.Visible, ;
*!*					this.Canvas4.Visible
*!*			endif				
*!*		
*!*			.canvas1.Move(  CANVAS_LEFT_OFFSET_PIXELS, ;
*!*							CANVAS_TOP_OFFSET_PIXELS, ;
*!*							m.iWidth, m.iHeight )
*!*			.canvas2.Move(  CANVAS_LEFT_OFFSET_PIXELS + m.iWidth + CANVAS_HORIZONTAL_GAP_PIXELS, ;
*!*							CANVAS_TOP_OFFSET_PIXELS, ;
*!*							m.iWidth, m.iHeight )
*!*			.canvas3.Move(	CANVAS_LEFT_OFFSET_PIXELS, ;
*!*							CANVAS_TOP_OFFSET_PIXELS + m.iHeight + CANVAS_VERTICAL_GAP_PIXELS, ;
*!*							m.iWidth, m.iHeight )
*!*			.canvas4.Move(  CANVAS_LEFT_OFFSET_PIXELS + m.iWidth + CANVAS_HORIZONTAL_GAP_PIXELS, ;
*!*							CANVAS_TOP_OFFSET_PIXELS + m.iHeight + CANVAS_VERTICAL_GAP_PIXELS, ;
*!*							m.iWidth, m.iHeight )
*!*			.spacer.Move(  .canvas4.Left + .canvas4.Width, ;
*!*						   .canvas4.Top + .canvas4.Height )

*!*		endcase	

	.SuppressRendering = .T.

	This.PreviewForm.cmdTopEx1.ZOrder(0)
	This.PreviewForm.cmdPrevEx1.ZOrder(0)

	This.PreviewForm.cmdNextEx1.ZOrder(0)
	This.PreviewForm.cmdNextEx1.Top = 1
	This.PreviewForm.cmdBottomEx1.Visible = .T.

	.SuppressRendering = .F.

endwith
ENDPROC 








	PROCEDURE UpdateToolBar

		With This.PreviewForm
			.AllowPrintfromPreview = .F. && Force this value, 
				&& dont worry, because we'll add manually a new "Print" button

			LOCAL lcReportName
			
			IF NOT goHelper.lExtended
				BINDEVENT(This, "Destroy", goHelper, "ReportReleased")
				lcReportName = goHelper._cFRXName
			ELSE 
				lcReportName = JUSTSTEM(goHelper._oReportSource(1))
			ENDIF 

			IF NOT EMPTY(goHelper.cTitle)
				This.PreviewForm.formCaption = goHelper.cTitle + ;
					IIF(NOT goHelper.lExtended, "", ;
						IIF(goHelper._oReports.Count > 1, "", ;
							SPACE(5) + "-" + SPACE(5) + JUSTSTEM(goHelper._oReportSource(1))))
				This.PreviewForm.Caption = goHelper.cTitle + " - " + lcReportName
			ENDIF 

			With .Toolbar as Toolbar

				IF goHelper.lShowMiniatures && shows the miniatures page
					.AddObject("cmdProof1","cmdProof")
				ENDIF 

				LOCAL loCombo as ComboBox
				loCombo = .cboZoom


			#IFDEF PR_NONENGLISH

				* Replace the GoToPage button
				.cntPrev.AddObject("cmdGoto1", "cmdGotoEx")
				.cmdGotoPage.Visible = .F.

				* Translate toolbar buttons ToolTips to non English language
				#IFDEF PR_CBOZOOMTTIP 
					.cboZoom.ToolTipText = PR_CBOZOOMTTIP 
				#ELSE
					.cboZoom.ToolTipText = "Zoom"
				#ENDIF


				* Translate the combo items
				LOCAL n, lcItem
				FOR n = 1 TO loCombo.ListCount
					lcItem = LOWER(loCombo.ListItem(n))
					IF lcItem = "whole page"
						loCombo.ListItem(n) = PR_CBOZOOMWHOLEPG
					ENDIF
					IF lcItem = "fit to width"
						loCombo.ListItem(n) = PR_CBOZOOMPGWIDTH
					ENDIF
				ENDFOR
				loCombo.Width = loCombo.Width + 10

				.cmdGoToPage.ToolTipText = PR_CMDGOTOPGTTIP

				With .opgPageCount
					.opt1.ToolTipText = PR_ONEPGTTIP
					.opt2.ToolTipText = PR_TWOPGTTIP
					.opt3.ToolTipText = PR_FOURPGTTIP
				ENDWITH

				WITH .cntNext
					.cmdBottom.ToolTipText  = PR_MENULAST
					.cmdForward.ToolTipText = PR_MENUNEXT
				ENDWITH 

				WITH .cntPrev
					.cmdBack.ToolTipText = PR_MENUPREV
					.cmdTop.ToolTipText  = PR_MENUTOP
				ENDWITH
				
			#ENDIF

				With .cntNext
					.cmdBottom.Picture      = "pr_bottom.bmp"
					.cmdForward.Picture     = "pr_next.bmp"
				Endwith

				With .cntPrev
					.cmdBack.Picture     = "pr_previous.bmp"
					.cmdTop.Picture      = "pr_top.bmp"
				Endwith
				.Refresh()
				
			IF goHelper.lPrintVisible
		
				.AddObject("cmbPrinters1", "cmbPrinters")
				.cmbPrinters1.Height = loCombo.Height
				.cmbPrinters1.FontSize = loCombo.FontSize

				* Show the copies spinner
				IF goHelper.lShowCopies AND goHelper.lExtended
					.AddObject("cntCopies1","cntCopies")
					.cntCopies1.SpnCopies1.FontSize = loCombo.FontSize
					.cntCopies1.LblCopies1.FontSize = loCombo.FontSize
				ENDIF  && goHelper.lShowCopies

				* Show the Save to file button
				IF goHelper.lSaveToFile && AND goHelper.lExtended
					.AddObject("cmdSave1", "cmdSave")
					.AddObject("cmbSave1", "cmbSave")
					
					LOCAL lnCmbIndex
					lnCmbIndex = 0
					WITH .CmbSave1
						IF goHelper.lSaveAsImage
		*					DEFINE BAR 1 OF (lcSaveMenu) PROMPT PR_SAVEASIMAGE PICTURE "pr_Img.bmp"
							lnCmbIndex = lnCmbIndex + 1
							.AddItem(PR_SAVEASIMAGE)
							.Picture[lnCmbIndex] = "pr_Img.bmp"
							.List[.NewIndex, 2] = '1'
						ENDIF 

						IF goHelper.lExtended
							IF goHelper.lSaveAsPDF
		*						DEFINE BAR 2 OF (lcSaveMenu) PROMPT PR_SAVEASPDF  PICTURE "pr_Pdf.bmp"
								lnCmbIndex = lnCmbIndex + 1
								.AddItem(PR_SAVEASPDF)
								.Picture[lnCmbIndex] = "pr_Pdf.bmp"
								.List[.NewIndex, 2] = '2'
							ENDIF 
							IF goHelper.lSaveAsHTML
		*						DEFINE BAR 3 OF (lcSaveMenu) PROMPT PR_SAVEASHTML PICTURE "pr_Html.bmp"
								lnCmbIndex = lnCmbIndex + 1
								.AddItem(PR_SAVEASHTML)
								.List[.NewIndex, 2] = '3'
								.Picture[lnCmbIndex] = "pr_HTML.bmp"
							ENDIF 
							IF goHelper.lSaveAsRTF
		*						DEFINE BAR 4 OF (lcSaveMenu) PROMPT PR_SAVEASRTF  PICTURE "pr_Word.bmp"
								lnCmbIndex = lnCmbIndex + 1
								.AddItem(PR_SAVEASRTF)
								.List[.NewIndex, 2] = '4'
								.Picture[lnCmbIndex] = "pr_Word.bmp"
							ENDIF 
							IF goHelper.lSaveAsXLS
		*						DEFINE BAR 5 OF (lcSaveMenu) PROMPT PR_SAVEASXLS  PICTURE "pr_Excel.bmp"
								lnCmbIndex = lnCmbIndex + 1
								.AddItem(PR_SAVEASXLS)
								.List[.NewIndex, 2] = '5'
								.Picture[lnCmbIndex] = "pr_Excel.bmp"
							ENDIF 
						ENDIF 
					
					ENDWITH 
					
				ENDIF  && goHelper.lSaveToFile

				* Show the Send to Email button
				IF goHelper.lSendToEmail AND goHelper.lExtended
					.AddObject("cmdEmail1", "cmdEmail")
				ENDIF && goHelper.lSendToEmail

				* Show the Printer preferences button
				IF goHelper.lPrinterPref AND goHelper.lExtended
					.AddObject("cmdPrinterProps1", "cmdPrinterProps")
				ENDIF 

				* Replace the original Print button
				.AddObject("cmdPrint1", "cmdPrintEx")
				#IFDEF PR_NONENGLISH
					.cmdPrint1.ToolTipText = PR_PRINTREPORT
				#ELSE
					.cmdPrint1.ToolTipText = .cmdPrint.ToolTipText
				#ENDIF

			ENDIF

			* Replace the original Close button
			.cmdClose.Visible = .F.
			.AddObject("cmdExit1", "cmdExit")
			#IFDEF PR_NONENGLISH
				.CmdExit1.ToolTipText  = PR_CLOSEREPORT
			#ELSE
				.CmdExit1.ToolTipText  = .cmdClose.ToolTipText
			#ENDIF

			ENDWITH 

		ENDWITH 

	ENDPROC 


	PROCEDURE ParentClosed
		UNBINDEVENTS(This)
		This.ActionClose()
		goHelper.ReportReleased(This)
	ENDPROC 


	PROCEDURE DoProof()
		goHelper._oProofSheet = CREATEOBJECT("ProofSheet")
		goHelper._oProofSheet.SetReport( THIS.PreviewForm.oReport )
		goHelper._oProofSheet.Caption = PR_GLOBALPREVIEW
	
	
				IF VARTYPE(goHelper._oParentForm) = "O"
					ACTIVATE WINDOW (goHelper._oParentForm.Name)
					Activate Window (This.PreviewForm.Name)
				ENDIF 	
	
	
		goHelper._oProofSheet.Show(1)
		* read the selected page and move to it, 
		* using the .SetCurrentPage() method of 
		* the default preview container:
		TRY 
			THIS.PreviewForm.SetCurrentPage( goHelper._oProofSheet.Currentpage )
			goHelper._oProofSheet = ""
		CATCH 
		ENDTRY 
	ENDPROC


	PROCEDURE DoSave(tnIndex)

		This.DoSaveType(tnIndex)

*!*			IF NOT goHelper.lExtended && Original report
*!*				This.DoSaveType(1) && Allow only saving as image
*!*			ELSE 
*!*				* Ensure the proof sheet is closed
*!*				goHelper.CloseProof()

*!*				LOCAL lcSaveMenu, lnOption
*!*				lnOption = 0
*!*				lcSaveMenu = SYS(2015)

*!*					LOCAL loForm as Form

*!*					IF VARTYPE(goHelper._oParentForm) = "O"
*!*	*					loForm = This.PreviewForm
*!*						loForm = goHelper._oParentForm
*!*					ELSE 	
*!*						loForm = _Screen
*!*					ENDIF 

*!*	*					loForm = _Screen



*!*					IF VARTYPE(goHelper._oParentForm) = "O"
*!*	*!*						ACTIVATE SCREEN
*!*	*!*						ACTIVATE WINDOW (goHelper._oParentForm.Name)
*!*	*!*						Activate Window (This.PreviewForm.Name)
*!*						LOCAL x, y
*!*						x = mcol(loForm.Name)
*!*						y = mrow(loForm.Name)

*!*						LOCAL loToolBar as Toolbar 
*!*						loToolBar = This.PreviewForm.ToolBar
*!*						IF (VARTYPE(loToolBar) = "O") AND (loToolBar.Docked) 
*!*							LOCAL lnPos
*!*							lnPos = loToolBar.DockPosition

*!*							DO CASE
*!*							CASE lnPos = 0 && Top
*!*								y = y + Pix2Fox(12, .T.)
*!*		
*!*							CASE lnpos = 3 && Bottom
*!*								y = y + loForm.Height && Pix2Fox(loForm.Height, .T.)

*!*							CASE lnpos = 1 && Left
*!*		
*!*							CASE lnpos = 2 && Right
*!*								x = x + loForm.Width && Pix2Fox(loForm.Width, .F.) && Width

*!*							OTHERWISE

*!*							ENDCASE
*!*						ENDIF 

*!*		
*!*						define popup (m.lcSaveMenu) ;
*!*							shortcut ;
*!*							relative ;
*!*							in window (loForm.Name) ;			
*!*							from y, x		

*!*					ELSE 	

*!*						LOCAL lcPoint, x, y
*!*						lcPoint = SPACE(8)
*!*						=PR_GetCursorPos(@lcPoint)
*!*						=PR_ScreenToClient(loForm.hWnd, @lcPoint)
*!*						x = CTOBIN(LEFT(lcPoint,4), "4RS")  /(loForm.width/scols())
*!*						y = CTOBIN(RIGHT(lcPoint,4), "4RS") /(loForm.height/srows())



*!*						ACTIVATE SCREEN
*!*						DEFINE POPUP (lcSaveMenu) FROM y,x SHORTCUT RELATIVE MARGIN
*!*					ENDIF 


*!*				IF goHelper.lSaveAsImage
*!*					DEFINE BAR 1 OF (lcSaveMenu) PROMPT PR_SAVEASIMAGE PICTURE "pr_Img.bmp"
*!*				ENDIF 
*!*				

*!*				IF goHelper.lExtended
*!*					IF goHelper.lSaveAsPDF
*!*						DEFINE BAR 2 OF (lcSaveMenu) PROMPT PR_SAVEASPDF  PICTURE "pr_Pdf.bmp"
*!*					ENDIF 
*!*					IF goHelper.lSaveAsHTML
*!*						DEFINE BAR 3 OF (lcSaveMenu) PROMPT PR_SAVEASHTML PICTURE "pr_Html.bmp"
*!*					ENDIF 
*!*					IF goHelper.lSaveAsRTF
*!*						DEFINE BAR 4 OF (lcSaveMenu) PROMPT PR_SAVEASRTF  PICTURE "pr_Word.bmp"
*!*					ENDIF 
*!*					IF goHelper.lSaveAsXLS
*!*						DEFINE BAR 5 OF (lcSaveMenu) PROMPT PR_SAVEASXLS  PICTURE "pr_Excel.bmp"
*!*					ENDIF 
*!*				ENDIF 

*!*				ON SELECTION POPUP (lcSaveMenu) lnOption = BAR()

*!*				ACTIVATE POPUP (lcSaveMenu)

*!*				IF lnOption = 0
*!*					RETURN
*!*				ENDIF 

*!*				This.DoSaveType(lnOption)
*!*			ENDIF 

		IF goHelper._lNoWait AND ; && Top form
				NOT EMPTY(goHelper.cDestFile) && Selected a file output
			goHelper.DoOutput()
		ENDIF 
	ENDPROC



	PROCEDURE DoSaveType(tnType)

		LOCAL lcFile
		lcFile = ""
		
		DO CASE
		CASE tnType = 1 && Image file
			lcFile = PUTFILE(PR_SAVEASIMAGE + "...", "", ;
				"Png;Bmp;Jpg;Gif;Tif;Emf")
			IF NOT EMPTY(lcFile) && Invalid File Name
				LOCAL loListener
				loListener = This.PreviewForm.oReport
				goHelper.lSaved = Report2Pic(loListener, lcFile, JUSTEXT(lcFile))
				loListener = NULL
			ENDIF

		CASE tnType = 2 && PDF
			lcFile = PUTFILE(PR_SAVEASPDF + "...", "", "Pdf")

		CASE tnType = 3 && HTML
			lcFile = PUTFILE(PR_SAVEASHTML + "...", "", "Htm;Html")

		CASE tnType = 4 && RTF
			lcFile = PUTFILE(PR_SAVEASRTF + "...", "", "Rtf;Doc")

		CASE tnType = 5 && XLS
			lcFile = PUTFILE(PR_SAVEASXLS + "...", "", "Xls")

		OTHERWISE 

		ENDCASE

		IF NOT EMPTY(lcFile) && Invalid File Name
			goHelper.cDestFile = lcFile
			
			* Close the preview form completely
			This.ActionClose()
		ENDIF
	ENDPROC 


	PROCEDURE DoSendEmail

		* Ensure the proof sheet is closed
		goHelper.CloseProof()

		LOCAL lcFile, lcFolder
		*	lEmailAuto = .T. && Automatically generates the report output file
		*	cEmailType = "PDF" && The file type to be used in Emails (PDF, RTF, HTML or XLS)
		IF goHelper.lEmailAuto 
			lcFolder = ADDBS(GETENV("TEMP"))			
			lcFile = lcFolder + FORCEEXT(JUSTFNAME(goHelper._cFRXName), goHelper.cEmailType)
		ELSE 
			lcFile = PUTFILE("Save file as ...", "", "Pdf;Rtf;Htm;Xls")
		ENDIF 
		
		IF EMPTY(lcFile)
			RETURN
		ENDIF 

		goHelper.cDestFile = lcFile
		goHelper._lSendingEmail = .T.

		* Close the preview form completely
		This.ActionClose()
	
		IF goHelper._lNoWait AND ; && Top form
				NOT EMPTY(goHelper.cDestFile) && Selected a file output
			goHelper.DoOutput()
		ENDIF 
	
	ENDPROC 




	PROCEDURE DoSetPrinterProps()
		IF UPPER(goHelper._cOriginalPrinter) <> UPPER(goHelper.cPrinterName)
			goHelper.SetPrinter(goHelper.cPrinterName)
		ENDIF 
		DO SetPrinterProps
	ENDPROC 



	PROCEDURE HandledKeyPress( nKeyCode, nShiftAltCtrl )
		RETURN .F.
	ENDPROC

	PROCEDURE PAINT
	ENDPROC

	PROCEDURE RELEASE
		RETURN .T.
	ENDPROC 

	PROCEDURE destroy
	ENDPROC 

ENDDEFINE
*-- END CODE


* Included controls classes
DEFINE CLASS cmdReport AS CommandButton
	Caption = ""
	Width   = 24
	Height  = 22
*	SpecialEffect = 2 && Hot tracking
ENDDEFINE

DEFINE CLASS cntCopies AS Container
	BackStyle = 0 && Transparent					
	BorderWidth = 0
	Height = 23
	Width = 50
	Visible = .T.
	
	ADD OBJECT spnCopies1 AS spnCopies
	ADD OBJECT lblCopies1 AS lblCopies
	
	PROCEDURE Init
		This.lblCopies1.Left = 3
		This.lblCopies1.Top  = 2
		This.spnCopies1.Left = 3 + This.lblCopies1.Width 
		This.Width = 3 + This.lblCopies1.Width + 2 + This.spnCopies1.Width + 1
	ENDPROC 
ENDDEFINE


DEFINE CLASS spnCopies AS Spinner
	Width   = 42
	Height  = 22
	SpecialEffect = 2 && Hot tracking
	Increment = 1
	SpinnerHighValue = 99
	SpinnerLowValue = 1	
	KeyboardHighValue = 99
	KeyboardLowValue = 1
	ToolTipText = PR_COPIES
	Visible = .T.

	PROCEDURE Init
		This.Value = goHelper.nCopies
	ENDPROC

	PROCEDURE InteractiveChange
		goHelper.nCopies = This.Value
	ENDPROC
ENDDEFINE


DEFINE CLASS lblCopies AS Label
	Caption = PR_COPIES 
	AutoSize = .T.
	BackStyle = 0 && Transparent					
	Visible = .T.
ENDDEFINE


DEFINE CLASS cmdSave AS cmdReport
	ToolTipText = PR_SAVEREPORT
	Picture     = "pr_save.bmp"
	Visible     = .T.

	PROCEDURE Click
		* This.Parent.PreviewForm.ExtensionHandler.DoSave()

		IF NOT goHelper.lExtended && Original report
			This.Parent.PreviewForm.ExtensionHandler.DoSave(1)
		ELSE 
			This.Parent.CmbSave1.Value = ""
			This.Parent.CmbSave1.SetFocus()
			KEYBOARD "{ALT+DNARROW}"
		ENDIF 

	ENDPROC
ENDDEFINE


DEFINE CLASS cmbSave AS ComboBox
	ToolTipText = PR_SAVEREPORT
	Height      = 1
	Width       = 1
	Visible     = .T.
	nIndex      = 0

*!*		PROCEDURE Click
*!*			This.Parent.PreviewForm.ExtensionHandler.DoSave()
*!*		ENDPROC
	
	PROCEDURE DropDown
		This.Value = ""
		This.nIndex = 0
	ENDPROC 
	
	PROCEDURE Valid
		IF NOT EMPTY(This.Value)
			LOCAL lnIndex
			lnIndex = VAL(This.List(This.ListIndex,2))
			This.nIndex = lnIndex
			This.Value = ""
			This.Parent.PreviewForm.ExtensionHandler.DoSave(lnIndex)
		ENDIF 
	ENDPROC 

ENDDEFINE




DEFINE CLASS cmdTopEx AS cmdReport
	ToolTipText = PR_MENUTOP
	Picture     = "pr_Top.bmp"
	Visible     = .T.

	PROCEDURE Click
		This.Parent.ActionGoFirst()
	ENDPROC
ENDDEFINE

DEFINE CLASS cmdPrevEx AS cmdReport
	ToolTipText = PR_MENUPREV
	Picture     = "pr_Previous.bmp"
	Visible     = .T.

	PROCEDURE Click
		This.Parent.ActionGoPrev()
	ENDPROC
ENDDEFINE

DEFINE CLASS cmdNextEx AS cmdReport
	ToolTipText = PR_MENUNEXT
	Picture     = "pr_next.bmp"
	Visible     = .T.

	PROCEDURE Click
		This.Parent.ActionGoNext()
	ENDPROC
ENDDEFINE

DEFINE CLASS cmdBottomEx AS cmdReport
	ToolTipText = PR_MENULAST
	Picture     = "pr_Bottom.bmp"
	Visible     = .T.

	PROCEDURE Click
		This.Parent.ActionGoLast()
	ENDPROC
ENDDEFINE


DEFINE CLASS cmdPrinterProps AS cmdReport
	ToolTipText = PR_PRINTINGPREF
	Picture     = "pr_printPref.bmp"
	Visible     = .T.

	PROCEDURE Click
		This.Parent.PreviewForm.ExtensionHandler.DoCustomPrint()
	ENDPROC
ENDDEFINE


DEFINE CLASS cmdEmail AS cmdReport
	ToolTipText = PR_SENDTOEMAIL
	Picture     = "pr_Mail.bmp"
	Visible     = .T.

	PROCEDURE Click
		This.Parent.PreviewForm.ExtensionHandler.DoSendEmail()
	ENDPROC

ENDDEFINE


DEFINE CLASS cmdExit AS cmdReport
	Picture     = "pr_close.bmp"
	Visible     = .T.

	PROCEDURE Click
		* Hide the Preview form
		This.Parent.PreviewForm.Visible = .F.
		goHelper.lPrinted = .F.

		* Ensure the proof sheet is closed
		goHelper.CloseProof()

		* Close the report window
		This.Parent.PreviewForm.ExtensionHandler.ActionClose()

	ENDPROC

	PROCEDURE MouseEnter
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		This.Picture = "pr_close2.bmp"
	ENDPROC

	PROCEDURE MouseLeave
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		This.Picture = "pr_close.bmp"
	ENDPROC

	PROCEDURE Init
		This.Width = This.Parent.cmdClose.Width
	ENDPROC 

ENDDEFINE



DEFINE CLASS cmdPrintEx AS cmdReport
	Picture     = "pr_print.bmp"
	Visible     = .T.

	PROCEDURE Init 
		#IFDEF PR_NONENGLISH
			This.ToolTipText = PR_PRINTREPORT
		#ELSE
			This.ToolTipText = This.Parent.cmdPrint.ToolTipText
		#ENDIF
	ENDPROC 

	PROCEDURE RightClick
		* This.Parent.PreviewForm.ExtensionHandler.DoCustomPrint()
	ENDPROC 

	PROCEDURE Click
		This.Parent.PreviewForm.ExtensionHandler.ActionPrintEx()
	ENDPROC

	PROCEDURE Init
		This.Width = This.Parent.cmdPrint.Width
	ENDPROC 
ENDDEFINE


DEFINE CLASS cmdGotoEx AS cmdReport
	Picture     = "pr_GotoPage.bmp"
	Visible     = .T.

	PROCEDURE Init 
		LOCAL loOrigGoto as CommandButton 
		loOrigGoto = This.Parent.Parent.cmdGotoPage

		#IFDEF PR_NONENGLISH
			This.ToolTipText = PR_CMDGOTOPGTTIP
		#ELSE
			This.ToolTipText = loOrigGoto.ToolTipText
		#ENDIF
		This.Left = This.Parent.Width
		This.Height = loOrigGoto.Height
		This.Width = loOrigGoto.Width
		This.Parent.Width = This.Parent.Width + This.Width
	ENDPROC 

	PROCEDURE Click
		This.Parent.Parent.PreviewForm.ExtensionHandler.ActionGotoPage()
	ENDPROC

ENDDEFINE


DEFINE CLASS cmbPrinters AS Combobox
	Width = 190
	ColumnCount = 2
	ColumnLines = .F.
	RowSourceType = 0 && None
	ColumnWidths = "200,130"
	Style = 2 && DropDown List
	ToolTipText = PR_AVAILABLEPRINT
	Visible = .T.
	_cOriginalPrinter = ""

	PROCEDURE Init

		LOCAL ARRAY laPrinters(1)
		=APRINTERS(laPrinters)

		LOCAL lcDefPrintern, lcCurrPrinter, n
		lcDefPrinter = SET("Printer",3)

		WITH This as ComboBox

			FOR n = 1 TO ALEN(laPrinters) STEP 2
				lcCurrPrinter = laPrinters(n)
				IF UPPER(ALLTRIM(lcDefPrinter)) = UPPER(ALLTRIM(lcCurrPrinter))
					lcDefPrinter = lcCurrPrinter
					.AddItem(lcCurrPrinter)
					.List(.NewIndex, 2) = laPrinters(n+1)
					EXIT 
				ENDIF
			ENDFOR

			FOR n = 1 TO ALEN(laPrinters) STEP 2
				lcCurrPrinter = laPrinters(n)
				IF NOT (UPPER(ALLTRIM(lcDefPrinter)) = UPPER(ALLTRIM(lcCurrPrinter)))
					.AddItem(lcCurrPrinter)
					.List(.NewIndex, 2) = laPrinters(n+1)
				ENDIF
			ENDFOR

			* .Value = lcDefPrinter
			.ListIndex = 1
			._cOriginalPrinter = lcDefPrinter

			LOCAL lcItem
			FOR n = 1 TO .ListCount
				lcItem = .List(n,1)
				IF LEFT(lcItem,1) = "\"
					.List(n,1) = "\\" + lcItem
				ENDIF 
			
				lcItem = .List(n,2)
				IF LEFT(lcItem,1) = "\"
					.List(n,2) = "\\" + lcItem
				ENDIF 
		ENDFOR 

		ENDWITH
	
		IF goHelper.lExtended = .F.
			BINDEVENT(This, "Enabled", This, "DisableCombo", 1)
		ENDIF 

	ENDPROC

	PROCEDURE DisableCombo
		This.Enabled = .F.		
	ENDPROC 


	PROCEDURE Valid
		LOCAL lcValue, lcOrigPrinter
		lcValue = This.Value
		lcOrigPrinter = goHelper._cOriginalPrinter

		IF LEFT(lcValue,1) = "\" AND SUBSTR(lcValue,2,1) <> "\" 
			lcValue = "\" + lcValue
		ENDIF 
		
		IF ALLTRIM(UPPER(lcValue)) <> ALLTRIM(UPPER(lcOrigPrinter))
			goHelper.cPrinterName = lcValue
		ENDIF 
	ENDPROC

ENDDEFINE

DEFINE CLASS cmdProof AS CmdReport
   Picture = "pr_Locate.bmp"
   ToolTipText = PR_MINIATURES
   Visible = .T.
   
   PROCEDURE Click()
      THIS.Parent.PreviewForm.ExtensionHandler.DoProof()
   ENDPROC
ENDDEFINE



* Helper functions
PROCEDURE Report2Pic(toListener, tcDestFile, tcFileFormat)

	IF VARTYPE(toListener) <> "O"
		ERROR "Report Listener could not be accessed"
		RETURN .F.
	ENDIF

	IF VARTYPE(tcFileFormat) = "L"
		tcFileFormat = JUSTEXT(tcDestFile)
	ENDIF
	tcFileFormat = LOWER(tcFileFormat)

	LOCAL lnPageCount, lnFileType, lnDeviceType
	lnPageCount = goHelper.nPageTotal && toListener.PageTotal

	DO CASE
	*!*	100 - imagem de tipo EMF
	*!*	101 - imagem de tipo TIFF
	*!*	102 - imagem de tipo JPEG
	*!*	103 - imagem de tipo GIF
	*!*	104 - imagem de tipo PNG
	*!*	105 - imagem de tipo BMP

	CASE tcFileFormat = "emf"
		lnFileType = 100

	CASE tcFileFormat = "tiff" OR tcFileFormat = "tif"
		lnFileType = 101

		#define OutputNothing -1
		#define OutputTIFF 101
		#define OutputTIFFAdditive (OutputTIFF+100)

		LOCAL lnPageNo
		FOR lnPageNo = 1 TO lnPageCount
			IF (lnPageNo == 1)
				lnDeviceType = OutputTIFF
			ELSE
				lnDeviceType = OutputTIFFAdditive
			ENDIF
			toListener.OutputPage(lnPageNo,tcDestFile,lnDeviceType)
		ENDFOR
		RETURN


	CASE tcFileFormat = "jpeg" OR tcFileFormat = "jpg"
		lnFileType = 102

	CASE tcFileFormat = "gif"
		lnFileType = 103

	CASE tcFileFormat = "png"
		lnFileType = 104

	CASE tcFileFormat = "bmp" OR  tcFileFormat = "bitmap"
		lnFileType = 105

	ENDCASE

	* Assegurarse de que não existe o arquivo gráfico
	ERASE (tcDestFile)

	LOCAL lcPathFile, lcDestFile, lcIndex, llSuccess
	llSuccess = .T.
	lcPathFile = ADDBS(JUSTPATH(tcDestFile)) + JUSTSTEM(tcDestFile)

	FOR lnPageNo = 1 TO lnPageCount
		IF lnPageCount = 1
			lcIndex = ""
		ELSE
			lcIndex = TRANSFORM(lnPageNo)
		ENDIF
		lcDestFile = FORCEEXT((lcPathFile + lcIndex),tcFileFormat)
		toListener.OutputPage(lnPageNo, lcDestFile, lnFileType)
		IF NOT FILE(lcDestFile)
			llSuccess = .F.
		ENDIF 
	ENDFOR
	RETURN llSuccess
ENDPROC





**************************************************
*-- Class:        frxgotopageform
*-- ParentClass:  frmReport
*-- BaseClass:    form
*
DEFINE CLASS CustomFrxGotoPageForm AS frmReport

	Height = 92
	Width = 345
	ShowWindow = 1
	DoCreate = .T.
	AutoCenter = .T.
	BorderStyle = 2
	Closable = .F.
	MaxButton = .F.
	MinButton = .F.
	AlwaysOnTop = .T.
	AllowOutput = .F.
	*-- Provides the current page number for report output.
	pageno = 0
	*-- Provides a PageTotal for report output.
	pagetotal = 0
	oparentform = (.NULL.)
	Name = "frxgotopageform"

	ADD OBJECT shp1 AS shape WITH ;
		Top = 15, ;
		Left = 12, ;
		Height = 66, ;
		Width = 224, ;
		BackStyle = 0, ;
		ZOrderSet = 0, ;
		Style = 3, ;
		Name = "Shp1"

	ADD OBJECT spnpageno AS spinner WITH ;
		Height = 21, ;
		InputMask = "9999", ;
		Left = 64, ;
		Top = 36, ;
		Width = 126, ;
		ZOrderSet = 1, ;
		Name = "spnPageno"

	ADD OBJECT lblcaption AS label WITH ;
		Left = 20, ;
		Top = 8, ;
		ZOrderSet = 2, ;
		Style = 3, ;
		Name = "lblCaption", ;
		Autosize = .T.

	ADD OBJECT cmdok AS cmdReport WITH ;
		Top = 15, ;
		Left = 248, ;
		Width = 84, ;
		Height = 25, ;
		Default = .T., ;
		ZOrderSet = 3, ;
		Name = "cmdOK", ;
		SpecialEffect = 0 && 3D


	ADD OBJECT cmdcancel AS cmdReport WITH ;
		Top = 47, ;
		Left = 248, ;
		Width = 84, ;
		Height = 25, ;
		Cancel = .T., ;
		ZOrderSet = 4, ;
		Name = "cmdCancel", ;
		SpecialEffect = 0 && 3D


	PROCEDURE Show
		LPARAMETERS nStyle
		*-----------------------------------------
		* Fix for SP1: Handle positioning in top-level form
		* See frxPreviewForm::ActionGoToPage()
		* Addresses bug# 474691
		*-----------------------------------------
		THIS.pageNo    = THIS.oParentForm.currentPage
		THIS.pageTotal = THIS.oParentForm.pageTotal
		THIS.Caption   = PR_REPORTTITLE
		THIS.lblCaption.Caption = PR_GOTOPG_CAPTION + " (1-" + transform(THIS.pageTotal) + ")"

		if THIS.oParentForm.ShowWindow = 2 && as top-level form
			*-----------------------------------
			* If parent preview window is a top-level form,
			* center the child window in the view port:
			*-----------------------------------
			THIS.AutoCenter = .F.
			THIS.Left = THIS.oParentForm.ViewPortLeft + int(THIS.oParentForm.Width/2  - THIS.Width/2)  
			THIS.Top  = THIS.oParentForm.ViewPortTop  + int(THIS.oParentForm.Height/2 - THIS.Height/2)
		else
			THIS.AutoCenter = .T.
		endif
		*--------------

		THIS.spnPageNo.SpinnerLowValue = 1
		THIS.spnPageNo.SpinnerHighValue = THIS.pageTotal

		THIS.spnPageNo.KeyboardLowValue = 1
		THIS.spnPageNo.KeyboardHighValue = THIS.pageTotal

		THIS.spnPageNo.Value = THIS.pageNo

		dodefault(m.nStyle)
	ENDPROC

	PROCEDURE Init
		THIS.cmdOK.Caption     = PR_GOTOPG_OK
		THIS.cmdCancel.Caption = PR_CANCEL
	ENDPROC

	PROCEDURE spnpageno.LostFocus
		if THIS.Value < THIS.SpinnerLowValue
			THIS.Value = 1
		endif
		if THIS.Value > THIS.SpinnerHighValue
			THIS.Value = THIS.SpinnerHighValue
		endif
		dodefault()
	ENDPROC

	PROCEDURE cmdok.Click
		THIS.Parent.pageNo = THIS.Parent.spnPageNo.Value
		THIS.Parent.Hide()
	ENDPROC

	PROCEDURE cmdcancel.Click
		THIS.Parent.Hide()
	ENDPROC

ENDDEFINE
*-- EndDefine: frxgotopageform
**************************************************


**************************************************
*-- Class:        frmReport
*-- ParentClass:  form
*-- BaseClass:    form
*-- Author:       CChalom
DEFINE CLASS frmReport AS Form
	icon = PR_FORMICON
ENDDEFINE
*-- EndDefine: frxgotopageform
**************************************************


**************************************************
*-- Class:        proofshape
*-- ParentClass:  shape
*-- BaseClass:    shape
*-- Author:       Colin Nicholls
DEFINE CLASS proofshape AS shape
	Height = 110
	Width = 85
	*-- Provides the current page number for report output.
	pageno = 0
	Name = "proofshape"

	PROCEDURE MouseLeave
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		This.MousePointer = 0 && Default
		*This.ResetToDefault("BorderColor")
	ENDPROC

	PROCEDURE MouseEnter
		LPARAMETERS nButton, nShift, nXCoord, nYCoord
		This.MousePointer = 15 && Hand
		*This.BorderColor = RGB(255,0,0) && Red
		This.Parent.nCurrShape = This.PageNo
	ENDPROC

	PROCEDURE Click
		THISFORM.CurrentPage = THIS.PageNo
		THISFORM.Hide()
		activate screen
	ENDPROC
ENDDEFINE
*-- EndDefine: proofshape
**************************************************


**************************************************
*-- Class:        proofsheet
*-- ParentClass:  form
*-- BaseClass:    form
*-- Author:       Colin Nicholls
DEFINE CLASS proofsheet AS frmReport
	Height = 274
	Width = 622
	ScrollBars = 3
	DoCreate = .T.
	AutoCenter = .T.
	ShowWindow = 1 && In Top-Level Form

	currentpage = 0
	reportlistener = .NULL.
	lstarted = .F.
	npages = 1
	lpainted = .F.
	ncurrshape = 0
	Name = "proofsheet"

	PROCEDURE setreport
		lparameters oReport
		THIS.ReportListener = m.oReport
		This.nPages = m.oReport.OutputPageCount
	ENDPROC

	PROCEDURE Resize
		This.Show()
	ENDPROC

	PROCEDURE QueryUnload
		THIS.Hide()
		activate screen
	ENDPROC

	PROCEDURE Paint
		if (not isnull(THIS.ReportListener))
			for i = 1 to min(64, This.nPages)
				THIS.ReportListener.OutputPage( m.i, THIS.Objects[m.i],2)
			endfor
		endif
	ENDPROC

	PROCEDURE Show
		LPARAMETERS nStyle
		#define SPACE_PIXELS 10

		iRowOffset = SPACE_PIXELS
		iColOffset = SPACE_PIXELS
		iColCount  = INT((Thisform.Width - iColOffset)/ 95) && 6
		for i = 1 to min(64,This.nPages)
			IF NOT This.lStarted
				THIS.AddObject(sys(2015),"ProofShape")
				THIS.Objects[i].Visible = .T.
				THIS.Objects[i].PageNo = m.i
			ENDIF 

			* Arrange shapes on form:
			TRY 
				THIS.Objects[i].Top  = iRowOffset
				THIS.Objects[i].Left = iColOffset
				if mod(m.i,iColCount) = 0
					iRowOffset = iRowOffset + SPACE_PIXELS + THIS.Objects[m.i].Height
					iColOffset = SPACE_PIXELS
				else
					iColOffset = iColOffset + THIS.Objects[i].Width + SPACE_PIXELS
				endif
			CATCH 
			ENDTRY 
		ENDFOR 
		This.lStarted = .T.
		dodefault(nStyle)
	ENDPROC

	PROCEDURE Destroy
		THIS.ReportListener = null
	ENDPROC
ENDDEFINE
*-- EndDefine: proofsheet
**************************************************



*********************************************************************
FUNCTION PR_ScreenToClient(hWND, cPoint)
*********************************************************************
	DECLARE INTEGER ScreenToClient in user32 AS PR_ScreenToClient INTEGER hWND, STRING @cPoint
	RETURN PR_ScreenToClient(m.hWND, @m.cPoint)
ENDFUNC

*********************************************************************
FUNCTION PR_GetCursorPos(cPoint)
*********************************************************************
	DECLARE INTEGER GetCursorPos in user32 AS PR_GetCursorPos STRING @cPoint
	RETURN PR_GetCursorPos(@m.cPoint)
ENDFUNC

*********************************************************************
FUNCTION PR_PathFileExists(pszPath)
*********************************************************************
	DECLARE INTEGER PathFileExists IN shlwapi AS PR_PathFileExists STRING pszPath
	RETURN PR_PathFileExists(@m.pszPath)
ENDFUNC


*********************************************************************
FUNCTION PR_GetFocus()
*********************************************************************
	DECLARE INTEGER GetFocus IN user32 AS PR_GetFocus
	RETURN PR_GetFocus()
ENDFUNC


*********************************************************************
FUNCTION PR_GetWindowText(hwnd, lpString, cch)
*********************************************************************
    DECLARE INTEGER GetWindowText IN user32;
		AS PR_GetWindowText ;
        INTEGER hwnd, STRING @lpString, INTEGER cch
	RETURN PR_GetWindowText(hwnd, @lpString, cch)
ENDFUNC


*********************************************************************
FUNCTION PR_GetActiveWindow()
*********************************************************************
	DECLARE INTEGER GetActiveWindow IN user32 AS PR_GetActiveWindow
	RETURN PR_GetActiveWindow()
ENDFUNC

*********************************************************************
FUNCTION PR_MAPISendDocuments(ulUIParam, lpszDelimChar, lpszFullPaths, lpszFileNames, ulReserved)
*********************************************************************
    DECLARE INTEGER MAPISendDocuments IN mapi32;
				AS PR_MAPISendDocuments ;
		        INTEGER ulUIParam, STRING lpszDelimChar,;
		        STRING lpszFullPaths, STRING lpszFileNames,;
	    	    INTEGER ulReserved
	RETURN PR_MAPISendDocuments(ulUIParam, lpszDelimChar, lpszFullPaths, lpszFileNames, ulReserved)
ENDFUNC


********************************************************************
PROCEDURE SetPrinterProps
*********************************************************************
* Code from Barbara Peisch
* Allows changing the current printer settings
* Using the Printer perferences dialog
* http://www.foxite.com/archives/0000158197.htm

	* Lets the user set all possible printer properties
	LOCAL lcRptFile, lhWindow, lcOrigDevMode, lcModifiedDevMode, lcPrinter, lhPrinter

	* These constants come from the Windows.h file
	#DEFINE IDOK     1
	#DEFINE IDCANCEL 2

	#DEFINE DM_OUT_BUFFER 2
	#DEFINE DM_IN_BUFFER  8
	#DEFINE DM_IN_PROMPT  4

	DECLARE INTEGER OpenPrinter IN winspool.drv ;
		STRING pPrinterName, ;
		INTEGER @phPrinter, ;
		INTEGER pDefault

	DECLARE INTEGER GetActiveWindow IN user32

	DECLARE INTEGER DocumentProperties IN winspool.drv ;
		INTEGER hWnd, ;
		INTEGER hPrinter, ;
		STRING pDeviceName, ;
		STRING @pDevModeOutput, ;
		STRING @pDevModeInput, ;
		INTEGER fMode

	DECLARE INTEGER ClosePrinter IN winspool.drv INTEGER hPrinter

	lcPrinter = SET("Printer", 3)
	IF NOT EMPTY(lcPrinter)
		lhWindow = GetActiveWindow()

		lhPrinter = 0
		OpenPrinter(lcPrinter, @lhPrinter, 0)
		IF lhPrinter = 0
			Messagebox("Could not open printer.", 48, "Error")
			RETURN
		ENDIF

		lcRptFile = SYS(2015)+".FRX"

		TRY
			* Use a unique file name so we can use this in a multi-user situation
			* Using a cursor instead of a physical file doesn't work, but we can
			* create the FRX from a cursor.
			CREATE CURSOR TempCur (Temp C (10))
			CREATE REPORT (JUSTSTEM(lcRptFile)) FROM TempCur
			USE IN TempCur
			USE (lcRptFile) EXCLUSIVE ALIAS RptFile

			* Use SYS(1037,2) to read the printer settings instead of DocumentProperties
			SYS(1037,2)

			* We only want to save the original settings the first time
			lcOldExpr = EXPR
			lcOldTag  = TAG
			lcOldTag2 = TAG2
			lcOrigDevMode     = TAG2
			lcDevMode = TAG2
			lcModifiedDevMode = TAG2

			* Show printer settings dialog.
			lnResult = DocumentProperties(lhWindow, lhPrinter, lcPrinter, @lcModifiedDevMode, @lcOrigDevMode, DM_IN_PROMPT+DM_IN_BUFFER+DM_OUT_BUFFER)

			IF lnResult <> IDCANCEL
			* Set the printer to the new options
				SELECT RptFile
				replace expr WITH '', ;
					tag WITH '', ;
					TAG2 WITH lcModifiedDevMode
				lcDevMode = lcModifiedDevMode
				SYS(1037,3)		&& Writes the printer settings out to the printer
			ENDIF
		CATCH TO loException
		FINALLY 
			* Get rid of the temporary FRX
			IF USED("RptFile")
				USE IN RptFile
			ENDIF 
			IF FILE(lcRptFile)
				ERASE (JUSTSTEM(lcRptFile)+".*")
			ENDIF 

			* Close the printer handle
			IF NOT EMPTY(lhPrinter)
				ClosePrinter(lhPrinter)
			ENDIF 
		ENDTRY 
	ENDIF

ENDPROC 




*********************************************************************
PROCEDURE GetParentWindow
*********************************************************************
	* Returns the Windows handle from the active form
	LOCAL hWindow
	hWindow = PR_GetFocus()
	RETURN GetWinText(hWindow)
ENDPROC 

 
*********************************************************************
FUNCTION  GetWinText(hWindow)
*********************************************************************
    LOCAL lnBufsize, lcBuffer
    lnBufsize = 1024
    lcBuffer = Repli(Chr(0), lnBufsize)
    lnBufsize = PR_GetWindowText(hWindow, @lcBuffer, lnBufsize)
RETURN  Iif(lnBufsize=0, "", Left(lcBuffer,lnBufsize))
 




DEFINE CLASS WaterMarkHelper AS Custom
	cWaterMarkImage = ""
	nWaterMarkRatio = 1 && 100%
	nWaterMarkType  =  1     && 2 = stretch   1 = Isometric
	nWaterMarkAlpha =  0.5 && 50%
	cReport         = ""
	cTempPicture    = ""
	lMakeTemp       = .T.
	cWMReport       = ""

PROCEDURE AddWaterMark
	LOCAL lcFRX, lcFRT, lcImage
	IF This.lMakeTemp && Create a temporary copy of the report
		lcFRX = ADDBS(GETENV("TEMP")) + "Temp_PR_" + SYS(2015) + ".FRX"

		STRTOFILE(FILETOSTR(This.cReport),lcFRX)
		lcFRT = FORCEEXT(lcFRX,"FRT")
		STRTOFILE(FILETOSTR(FORCEEXT(This.cReport,"FRT")), lcFRT)
	ELSE
		lcFRX = This.cReport
	ENDIF 
	This.cWMReport = lcFRX

	lcImage = This.cWaterMarkImage

	LOCAL lnFactor, lnRatio, lnType, lnAlpha
	lnFactor = 10.4  && constant

	lnRatio  = This.nWaterMarkRatio   && 100%
	lnType   = This.nWaterMarkType    && 2 = stretch   1 = Isometric
	lnAlpha  = This.nWaterMarkAlpha   && 50%
	lcImage  = This.ApplyTransparency(lcImage, lnAlpha)

	* Run the report using the new report engine (object-assisted output)
	* This is only to get the canvas dimensions
	LOCAL loListener as ReportListener 
	loListener = CREATEOBJECT("HelperListener")
	loListener.LISTENERTYPE = 3
	REPORT FORM (This.cReport) OBJECT loListener

	LOCAL lnPgWidth, lnPgHeight, lnWidth, lnHeight
	lnPgWidth  = loListener.nWidth  * lnFactor
	lnPgHeight = loListener.nHeight * lnFactor
	loListener = NULL

	LOCAL lnX, lnY
	IF lnType = 2 && Stretch

		lnX      = ((1 - lnRatio) / 2) * lnPgWidth
		lnY      = ((1 - lnRatio) / 2) * lnPgHeight
		lnWidth  = lnRatio * lnPgWidth
		lnHeight = lnRatio * lnPgHeight

	ELSE && lnType = 1 - Isometric 
	
		LOCAL loVFPImg as Image
		LOCAL lnPicWidth, lnPicHeight
		loVFPImg = CREATEOBJECT("Image")
		loVFPImg.Picture = lcImage
		lnPicWidth  = loVFPImg.Width  * lnFactor * lnRatio
		lnPicHeight = loVFPImg.Height * lnFactor * lnRatio
		loVFPImg = NULL

		* Isometric Adjustment
		LOCAL lnHorFactor, lnVertFactor, lnResizeFactor
		lnHorFactor  = lnPgWidth  * lnRatio / lnPicWidth
		lnVertFactor = lnPgHeight * lnRatio / lnPicHeight
		lnResizeFactor = MIN(lnHorFactor, lnVertFactor)
		lnWidth   = lnPicWidth  * lnResizeFactor
		lnHeight  = lnPicHeight * lnResizeFactor

		lnX       = (lnPgWidth - lnWidth) / 2
		lnY       = (lnPgHeight - lnHeight) / 2

	ENDIF 	

	This.AddImage(lcImage, lcFRX, lnX, lnY, lnWidth, lnHeight, lnType)

ENDPROC 


PROCEDURE AddImage(tcImage, tcReport, tnX, tnY, tnWidth, tnHeight, tnType)
*-- Open the report file (FRX) as a table.

	USE (tcReport) IN 0 ALIAS TheReport EXCLUSIVE
	SELECT TheReport
	*-- Add a Picture/OLE Bound control to the report by inserting a
	*-- record with appropriate values. Using an object that is based on the EMPTY
	*-- class here and the GATHER NAME class later to insert the record makes it easier to
	*-- see which values line up to which fields (when compared to a large
	*-- SQL-INSERT command).
	LOCAL loNewRecObj AS EMPTY
	loNewRecObj = NEWOBJECT( 'EMPTY' )
	ADDPROPERTY( loNewRecObj, 'PLATFORM', 'WINDOWS' )
*	ADDPROPERTY( loNewRecObj, 'TimeStamp', 2014016647)
	ADDPROPERTY( loNewRecObj, 'Uniqueid', SYS(2015) )
	ADDPROPERTY( loNewRecObj, 'ObjType', 17 ) && "Picture/OLE Bound Control"
	ADDPROPERTY( loNewRecObj, 'ObjCode', 0 )
	ADDPROPERTY( loNewRecObj, 'Picture', ["] + (tcImage) + ["]) && The object ref to the IMAGE object.
	ADDPROPERTY( loNewRecObj, 'Hpos', tnX)
	ADDPROPERTY( loNewRecObj, 'Vpos', tnY)
	ADDPROPERTY( loNewRecObj, 'HEIGHT', tnHeight)
	ADDPROPERTY( loNewRecObj, 'WIDTH', tnWidth)
	ADDPROPERTY( loNewRecObj, 'DOUBLE', .T. ) && Picture is centered in the "Picture/OLE Bound Control"
	ADDPROPERTY( loNewRecObj, 'Supalways', .T. )
	ADDPROPERTY( loNewRecObj, 'General', tnType ) && Isometric = 1   Stretch = 2
	ADDPROPERTY( loNewRecObj, 'Mode', 1 ) 
	ADDPROPERTY( loNewRecObj, 'Top', .T. ) && Isometric = 1   Stretch = 2

	*-- For the Picture/OLE Bound control, the contents of the OFFSET field specify whether
	*-- Filename (0), General field name (1), or Expression (2) is the source.
	ADDPROPERTY( loNewRecObj, 'Offset', 0 )
	*-- Add the Picture/OLE Bound control record to the report.

	* Get Title band
	SELECT TheReport
	LOCAL lnRecord
	lnRecord = 1
	SCAN 	
*		IF INLIST(ObjCode, 0, 1) && 0 = Title    1 = Page Header
		IF NOT INLIST(ObjType, 0, 1, 9)
			lnRecord = RECNO() - 1
			EXIT
		ENDIF 
	ENDSCAN

	SELECT * FROM TheReport WHERE RECNO() > lnRecord INTO CURSOR TempRepo
	DELETE FROM TheReport WHERE RECNO() > lnRecord
	
	SELECT TheReport
	PACK 
	PACK MEMO
	
	APPEND BLANK IN TheReport
	GATHER NAME loNewRecObj MEMO

	APPEND FROM DBF("TempRepo")

	*-- Clean up and then close the report table.
	PACK MEMO
	
	USE IN SELECT( 'TheReport' )

ENDPROC 


* Apply transparency to image
PROCEDURE ApplyTransparency
	LPARAMETERS tcSource, tnAlpha

	LOCAL lcDestFile
	lcDestFile = ADDBS(GETENV("TEMP")) + "Temp_PR_" + SYS(2015) + ".Png"

	LOCAL loGdip
	loGdip = CREATEOBJECT("Empty")

*	DO System.Prg WITH loGdip

	WITH loGdip.System.Drawing

		LOCAL loBmp as xfcBitmap
		loBmp = .Bitmap.FromFile(tcSource)

		LOCAL loClrMatrix as xfcColorMAtrix 
		loClrMatrix = .Imaging.ColorMatrix.New(; 
	      1, 0, 0, 0, 0, ; 
	      0, 1, 0, 0, 0, ; 
	      0, 0, 1, 0, 0, ; 
    	  0, 0, 0, tnAlpha, 0, ; 
	      0, 0, 0, 0, 1) 

		loBmp.ApplyColorMatrix(loClrMatrix) 
	
		loBmp.Save(lcDestFile, .Imaging.ImageFormat.Png) 
	ENDWITH
	This.cTempPicture = lcDestFile
	
	RETURN lcDestFile
ENDPROC 



PROCEDURE Destroy
	* Clear the temporary files
	TRY
*		DELETE FILE (This.cTempPicture)

		IF This.lMakeTemp
*!*				DELETE FILE (This.cWMReport)
*!*				DELETE FILE (FORCEEXT(This.cWMReport, "FRT"))
		ENDIF 
	CATCH
	ENDTRY 
	RETURN
ENDPROC

ENDDEFINE






* Helper Listener used to get the report drawing dimensions
DEFINE CLASS HelperListener AS ReportListener
	nWidth = 0
	nHeight = 0
FUNCTION BEFOREREPORT
	This.nWidth  = This.GetPageWidth()
    This.nHeight = This.GetPageHeight()
	IF This.nWidth > 0
		This.CancelReport()
	ENDIF 
ENDFUNC
ENDDEFINE	




PROCEDURE BindPrinter
LPARAMETERS tlBind

IF tlBind

#DEFINE WM_SPOOLERSTATUS 0x2A

#define WM_PRINT 0x0317
#define WM_PRINTCLIENT 0x0318
#DEFINE GWL_WNDPROC     (-4)

PUBLIC oHandler
oHandler = NEWOBJECT('AppState')
BINDEVENT(_SCREEN.HWND, WM_SPOOLERSTATUS, oHandler, 'HandleEvent')
* MESSAGEBOX('Test by printing.')

ELSE 
	UNBINDEVENT(_SCREEN.HWND, WM_SPOOLERSTATUS)
ENDIF 

*-----------------------------------------------
DEFINE CLASS APPSTATE AS SESSION

nOldProc = 0

PROCEDURE INIT
	DECLARE INTEGER GetWindowLong IN WIN32API ;
		INTEGER nHWND, ;
		INTEGER nIndex
	DECLARE INTEGER CallWindowProc IN WIN32API ;
		INTEGER lpPrevWndFunc, ;
		INTEGER nHWND, ;
		INTEGER nMsg, ;
		INTEGER wParam, ;
		INTEGER LPARAM
	THIS.nOldProc = GetWindowLong(_VFP.HWND, GWL_WNDPROC)
ENDPROC

PROCEDURE HandleEvent(nHWND AS INTEGER, nMsg AS INTEGER, ;
	  wParam AS INTEGER, LPARAM AS INTEGER)
	LOCAL lResult AS INTEGER
	lResult=0
	* Note: for WM_THEMECHANGED, MSDN indicates the wParam and lParam
	* are reserved so can't use them.
	IF nMsg = WM_SPOOLERSTATUS
		MESSAGEBOX('Printed...')
	ENDIF

	* lResult = CallWindowProc(THIS.nOldProc, nHWND, nMsg, wParam, LPARAM)
	RETURN lResult
ENDPROC

PROCEDURE DESTROY
	UNBINDEVENT(_SCREEN.HWND, WM_PRINT)
ENDPROC

ENDDEFINE






* Convert pixels to foxels 
* By Sergey Berezniker
FUNCTION Pix2fox
LPARAMETER tnPixels, tlVertical, tcFontName, tnFontSize
* tnPixels - pixels to convert
* tlVertical - .F./.T. convert horizontal/vertical coordinates
* tcFontName, tnFontSize - use specified font/size 
*         or current form (active output window) font/size, if not specified 
LOCAL lnFoxels
 
IF PCOUNT() > 2
	lnFoxels = tnPixels/FONTMETRIC(IIF(tlVertical, 1, 6), tcFontName, tnFontSize)
ELSE
	lnFoxels = tnPixels/FONTMETRIC(IIF(tlVertical, 1, 6))
ENDIF	
 
RETURN lnFoxels





* Procedure to send email attachment using Mapi
PROCEDURE SendMailEx(tcAttachment, tcRecipient, tcSubject, tcText)

LOCAL lcAttachment, lcRecipient, lcSubject, lcText
lcAttachment  = EVL(tcAttachment, "")
lcRecipient   = EVL(tcRecipient, "")
lcSubject     = EVL(tcSubject, "")
lcText        = EVL(tcText, "")


* http://www.atoutfox.org/articles.asp?ACTION=FCONSULTER&ID=0000000120
* By Mike Gagnon
* À titre d’exemple voici comment utiliser les appels API pour faire appel au simple MAPI.
* Le code suivant est gracieuseté d’Anatoliy Mogylevets de www.news2news.com/vfp.
* The code below is a courtesy of Anatoliy Mogylevets, from www.news2news.com/vfp
* It received some few tweaks in order to accept attachments

* MAPISendMail function
* http://msdn.microsoft.com/en-us/library/dd296721(VS.85).aspx

#DEFINE MAPI_ORIG        0
#DEFINE MAPI_TO          1
#DEFINE MAPI_DIALOG      8
#DEFINE SUCCESS_SUCCESS  0

DO DeclMapi

LOCAL hSession
hSession = getNewSession()
IF hSession = 0
	* ? "Unable to log on."
	RETURN
ENDIF

LOCAL loRcpEmail, loSndBuf, lcRcpBuf, loSubject, loNoteText,;
	loRcpBuf, lcMapiMessage, lnResult


LOCAL lcAttachment
lcAttachment = tcAttachment


* MapiFileDesc Structure
* http://msdn.microsoft.com/en-us/library/dd296737(v=VS.85).aspx
*!*	typedef struct {
*!*	  ULONG  ulReserved;
*!*	  ULONG  flFlags;
*!*	  ULONG  nPosition;
*!*	  LPSTR  lpszPathName;
*!*	  LPSTR  lpszFileName;
*!*	  LPVOID lpFileType;
*!*	} MapiFileDesc, *lpMapiFileDesc

LOCAL loAttach, loAttPath, loAttName 
LOCAL lcAttStruct
loAttPath = CREATEOBJECT("PChar", lcAttachment)
loAttName = CREATEOBJECT("PChar", JUSTFNAME(lcAttachment))

lcAttStruct = ;
	num2dword( 0 ) +;
	num2dword( 0 ) +;
	num2dword( 0 ) +;
	num2dword( loAttPath.getAddr() ) +; && AttachmentPathName
	num2dword( loAttName.getAddr() ) +; && AttachmentName
	num2dword( 0 )
loAttach = CreateObject ("PChar", lcAttStruct)



* populating message recipient, subject and body
loSubject  = CreateObject ("PChar", lcSubject)
loNoteText = CreateObject ("PChar", lcText)

* initializing buffer with single recipient data
IF NOT EMPTY(lcRecipient)
	loRcpEmail = CreateObject ("PChar", lcRecipient)
	lcRcpBuf = num2dword(0) +;
		num2dword(MAPI_TO) +;
		num2dword(loRcpEmail.getAddr()) +;
		Repli(Chr(0), 12)
	loRcpBuf = CreateObject ("PChar", lcRcpBuf)
ENDIF 

* initializing buffer with sender data -- practically empty
loSndBuf = CreateObject ("PChar", Repli(Chr(0), 24))
* merging all parts to a message buffer -- no file attachments


* MapiMessage Structure
* http://msdn.microsoft.com/en-us/library/dd296732(v=VS.85).aspx
*!*	typedef struct {
*!*	  ULONG           ulReserved;
*!*	  LPSTR           lpszSubject;
*!*	  LPSTR           lpszNoteText;
*!*	  LPSTR           lpszMessageType;
*!*	  LPSTR           lpszDateReceived;
*!*	  LPSTR           lpszConversationID;
*!*	  FLAGS           flFlags;
*!*	  lpMapiRecipDesc lpOriginator;
*!*	  ULONG           nRecipCount;
*!*	  lpMapiRecipDesc lpRecips;
*!*	  ULONG           nFileCount;
*!*	  lpMapiFileDesc  lpFiles;
*!*	} MapiMessage, *lpMapiMessage

lcMapiMessage = num2dword(0) +;
	num2dword(loSubject.getAddr()) +;
	num2dword(loNoteText.getAddr()) +;
	num2dword(0) + num2dword(0) + num2dword(0) + num2dword(0) +;
	num2dword(loSndBuf.getAddr()) +;
	num2dword(IIF(EMPTY(lcRecipient), 0, 1)) +;
	num2dword(IIF(EMPTY(lcRecipient), 0, loRcpBuf.getAddr())) +;
	num2dword(IIF(EMPTY(lcAttachment), 0, 1)) +;
	num2dword(IIF(EMPTY(lcAttachment), 0, loAttach.getAddr()))

* sending the message with or without a confirmation dialog
lnResult = MAPISendMail(hSession, 0, @lcMapiMessage, MAPI_DIALOG, 0) && Confirm dialog
*lnResult = MAPISendMail(hSession, 0, @lcMapiMessage, 0, 0)


IF lnResult <> SUCCESS_SUCCESS
* 1 MAPI_E_USER_ABORT
* 2 MAPI_E_FAILURE
* 3 MAPI_E_LOGIN_FAILURE
* 5 MAPI_E_INSUFFICIENT_MEMORY
* 6 MAPI_E_ACCESS_DENIED
* 9 MAPI_E_TOO_MANY_FILES
*10 MAPI_E_TOO_MANY_RECIPIENTS
*15 MAPI_E_BAD_RECIPTYPE
*18 MAPI_E_TEXT_TOO_LARGE
*14 MAPI_E_UNKNOWN_RECIPIENT
* ...
	* ? "Error returned:", lnResult
ELSE
	* ? "Sent initiated successfully!"
ENDIF

* closing current MAPI session
= MAPILogoff (hSession, 0, 0, 0)

ENDPROC 






FUNCTION  getNewSession()

* creates a new MAPI session and returns its handle
	#DEFINE MAPI_LOGON_UI           1
	#DEFINE MAPI_NEW_SESSION        2
	#DEFINE MAPI_USE_DEFAULT       64
	#DEFINE MAPI_FORCE_DOWNLOAD  4096 && 0x1000
	#DEFINE MAPI_PASSWORD_UI   131072 && 0x20000

	LOCAL lnResult, lnSession, lcStoredPath
	lcStoredPath = SYS(5) + SYS(2003)
	lnSession = 0
	lnResult = MAPILogon (0, "", "",;
		MAPI_USE_DEFAULT+MAPI_NEW_SESSION, 0, @lnSession)

* sometimes you need to restore default path - Outlook Express
	SET DEFAULT TO (lcStoredPath)

	RETURN Iif(lnResult=SUCCESS_SUCCESS, lnSession, 0)

FUNCTION  num2dword (lnValue)
	RETURN BINTOC(lnValue, "4RS")


*| for some structures you need not just strings but pointers to strings
*| to be assigned to structure fields;
*| this class implements such "dual" strings

DEFINE CLASS PChar As Custom
	PROTECTED hMem

	PROCEDURE  Init (lcString)
		THIS.hMem = 0
		IF NOT EMPTY(lcString)
			THIS.setValue (lcString)
		ENDIF 

	PROCEDURE  Destroy
		THIS.ReleaseString

	FUNCTION getAddr  && returns a pointer to the string
		RETURN THIS.hMem

	FUNCTION getValue && returns string value

		LOCAL lnSize, lcBuffer
		lnSize = THIS.getAllocSize()
		lcBuffer = SPACE(lnSize)
		IF THIS.hMem <> 0
			DECLARE RtlMoveMemory IN kernel32 As Heap2Str;
				STRING @, INTEGER, INTEGER
			= Heap2Str (@lcBuffer, THIS.hMem, lnSize)
		ENDIF

		RETURN lcBuffer

	FUNCTION getAllocSize  && returns allocated memory size (string length)
		DECLARE INTEGER GlobalSize IN kernel32 INTEGER hMem
		RETURN Iif(THIS.hMem=0, 0, GlobalSize(THIS.hMem))

	PROCEDURE setValue (lcString) && assigns new string value
		#DEFINE GMEM_FIXED   0

		THIS.ReleaseString
		DECLARE INTEGER GlobalAlloc IN kernel32 INTEGER, INTEGER
		DECLARE RtlMoveMemory IN kernel32 As Str2Heap;
			INTEGER, STRING @, INTEGER

		LOCAL lnSize
		lcString = lcString + Chr(0)
		lnSize = Len(lcString)
		THIS.hMem = GlobalAlloc (GMEM_FIXED, lnSize)
		IF THIS.hMem <> 0
			= Str2Heap (THIS.hMem, @lcString, lnSize)
		ENDIF


	PROCEDURE ReleaseString  && releases allocated memory
		IF THIS.hMem <> 0
			DECLARE INTEGER GlobalFree IN kernel32 INTEGER
			= GlobalFree (THIS.hMem)
			THIS.hMem = 0
		ENDIF
	ENDPROC 
	
ENDDEFINE


PROCEDURE  DeclMapi
	DECLARE INTEGER MAPILogon IN mapi32;
		INTEGER ulUIParam, STRING lpszProfileName,;
		STRING lpszPassword, INTEGER flFlags,;
		INTEGER ulReserved, INTEGER @lplhSession

	DECLARE INTEGER MAPILogoff IN mapi32;
		INTEGER lhSession, INTEGER ulUIParam,;
		INTEGER flFlags, INTEGER ulReserved

	DECLARE INTEGER MAPISendMail IN mapi32;
		INTEGER lhSession, INTEGER ulUIParam, STRING @lpMessage,;
		INTEGER flFlags, INTEGER ulReserved
RETURN