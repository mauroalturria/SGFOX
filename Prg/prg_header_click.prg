Parameters toGrid As Grid

Local lnI As Integer
Local loCol As Column

For lnI = 1 To toGrid.ColumnCount
	loCol = toGrid.Columns(lnI)
	lcCaption = loCol.Header1.Caption
	loCol.RemoveObject("Header1")
	loCol.AddObject("Header1","MyHeader")
	loCol.Header1.Caption = lcCaption
	loCol.Header1.Alignment=2
Next

Define Class MyHeader As Header OlePublic
*!*------------------------------------------------------------------------------------------------------------------------------
	Procedure Click
*!*------------------------------------------------------------------------------------------------------------------------------

	Local loGrid As Grid
	Local loCol As Column

	loGrid = This.Parent.Parent
	loCol = This.Parent

	mcBase = loGrid.RecordSource
	mcCampo = Upper(loCol.ControlSource)

	Local lnId
	lnId = &mcBase..Id &&

	If "." $ mcCampo
		lnPos = At(".",mcCampo,1)+1
		mcCampo = Substr(mcCampo,lnPos)
		lnPos = At(")",mcCampo,1)
		If lnPos > 0
			mcCampo = Substr(mcCampo,1,lnPos-1)
		Endif
	Endif

*cNomCampo = mcCampo && Substr(mcCampo,1,Len(mcCampo)-1)

	Select &mcBase

	lcTag = Tag()

	If lcTag <> cNomCampo
*		lcIndex = "Index on " + cNomCampo + " Tag p" + cNomCampo
		lcIndex = "Index on " + mcCampo + " Tag p" + mcCampo
		&lcIndex
	Else
		Return .F.
*		Messagebox(lcTag + Chr(13) + mcCampo)
	Endif

	This.SacoPict(loGrid)

	Do Case
	Case loCol.Header1.Tag = "A"
		lcOrden = "Set Order To p" + mcCampo + " In " + mcBase + " Descending"
		&lcOrden
		loCol.Header1.Picture = "c:\desaguemes\bmp\asc.bmp"
		loCol.Header1.Tag = "D"
	Case loCol.Header1.Tag = "D"
		lcOrden = "Set Order To p" + mcCampo + " In " + mcBase + " Ascending"
		&lcOrden
		loCol.Header1.Picture = "c:\desaguemes\bmp\desc.bmp"
		loCol.Header1.Tag = "A"
	Otherwise
		lcOrden = "Set Order To p" + mcCampo + " In " + mcBase + " Descending"
		&lcOrden
		loCol.Header1.Picture = "c:\desaguemes\bmp\asc.bmp"
		loCol.Header1.Tag = "D"
	Endcase

	Go Top

	loGrid.Refresh

	Select &mcBase
	Locate For Id = lnId

	loGrid.SetFocus()

	Endproc


	Procedure SacoPict
	Parameters toGrid
	Local lnI As Integer
	Local loCol As Column
	For lnI = 1 To toGrid.ColumnCount
		loCol = toGrid.Columns(lnI)
		loCol.Header1.Picture = ''
	Next
	Endproc

	Procedure Init

	Endproc

	Procedure Destroy

	Endproc

	Procedure Error(nError, cMethod, nLine)

	Endproc

Enddefine





