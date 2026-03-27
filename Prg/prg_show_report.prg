Lparameters tcReportName, tbPrinter, tbSoloPrint, tnCantPrint

If Vartype(tnCantPrint) # "N"
	tnCantPrint = 1
Endif 	

*!*	tcReportName = HOME() + 'Samples\Solution\Reports\colors.frx' 
*!*	tbPrinter = .F.

*----------- START CODE
*
*-----------------------------------
* AUTHOR: Trevor Hancock
* CREATED: 02/24/05 02:47:08 PM
* ABSTRACT:
*   Shows how to disable printing from
*   PREVIEW when you use object-assisted
*   reporting in VFP9.
*
*   Also includes a workaround for problem
*   where the PREVIEW toolbar does not
*   recognize the TextOnToolbar or
*   PrintFromPreview settings between
*   toolbar displays during same preview.
*-----------------------------------

*-- Defines whether to alllow for
*-- printing during preview. Used to set
*-- the "AllowPrintfromPreview" property
*-- of the object-assisted preview container
*-- later in this code.
#Define PrintFromPreview tbPrinter 

Local loPreviewContainer As Form, ;
	loReportListener As ReportListener, ;
	loExHandler As ExtensionHandler Of Sys(16)

*-- Get a preview container from the
*-- .APP registered to handle object-assisted
*-- report previewing.
loPreviewContainer = Null
Do (_ReportPreview) With loPreviewContainer
*-- Create a PREVIEW listener
loReportListener = Newobject('ReportListener')
loReportListener.ListenerType = 1 &&Preview

*-- Link the Listener and preview container
loReportListener.PreviewContainer = loPreviewContainer


*-- Changing this property prevents printing from the Preview toolbar
*-- and from right-clicking on the preview container, and then clicking "print".
*-- This property is not in the VFP9 documentation at this point.
loPreviewContainer.AllowPrintfromPreview = PrintFromPreview
*-- Controls appearance of text on some of the
*-- Preview toolbar buttons. .F. is the default.
*-- Included here just to show that it is an available option.
loPreviewContainer.TextOnToolbar = .F.
&& agregado 
loPreviewContainer.ToolbarIsVisible = .T.

*-- Create an extension handler and hook it to the
*-- preview container. This will let you manipulate
*-- properties of the container and its Preview toolbar
loExHandler = Newobject('ExtensionHandler')
loPreviewContainer.SetExtensionHandler( loExHandler )

If tbSoloPrint
	For I = 1 To tnCantPrint
		Report Form (tcReportName) To Printer  
	Next 	
Else
	Report Form (tcReportName) OBJECT loReportListener 
Endif 	

Release loPreviewContainer, loReportListener, loExHandler



*-------------------------
*-------------------------
Define Class ExtensionHandler As Custom
*-- Ref to the Preview Container's Preview Form
	PreviewForm  = Null

*-- Here you implement (hook into) the PreviewForm_Assign
*-- event of the preview container's parent proxy
	Procedure PreviewForm_Assign( loRef )
*-- Perform default behavior: assign obj ref.
	This.PreviewForm = loRef

*-- Grab the obj ref to the preview form and bind to its
*-- ShowToolbar() method. This lets the
*-- STB_Handler() method of this extension handler
*-- to run code whenever the Preview toolbar is shown
*-- by the PreviewForm.ShowToolbar() method.
	If !Isnull( loRef )
		Bindevent(This.PreviewForm, ;
			'ShowToolbar', This, 'STB_Handler')
	Endif
	Endproc

	Procedure STB_Handler(lEnabled)
*-- Here you work around the setting
*-- persistence problem in the Preview toolbar.
*-- The Preview toolbar class (frxpreviewtoolbar)
*-- already has code that you can use to enforce
*-- setting's persistence; it is just not called. Here,
*-- you call it.
	With This.PreviewForm.Toolbar
		.Refresh()
*-- When you call frxpreviewtoolbar::REFRESH(), the
*-- toolbar caption is set to its Preview form,
*-- which differs from typical behavior. You must revert that
*-- to be consistent. If you did not do this,
*-- you would see " - Page 2" appended to the toolbar
*-- caption if you skipped pages.
		.Caption = This.PreviewForm.formCaption
	Endwith
	Endproc


*-- A preview container requires these methods
*-- to be implemented in an associated preview extension handler.
*-- They are not used in this example, but still must be here.
	Procedure AddBarsToMenu( cPopup, iNextBar )
	Procedure Show( iStyle )
	Endproc
	Procedure HandledKeyPress( nKeyCode, nShiftAltCtrl )
	Return .F.
	Endproc
	Procedure Paint
	Endproc
	Procedure Release
	Return .T.
	Endproc 
Enddefine
*
*
*----------- END CODE