Parameters toGrid As Grid

Local lnI As Integer
Local loCol As Column

For lnI = 1 To toGrid.ColumnCount
	loCol = toGrid.Columns(lnI)
	lcCaption = loCol.Header1.Caption
	loCol.RemoveObject("Header1")
	loCol.AddObject("Header1","MyHeader2")
	loCol.Header1.Caption = lcCaption
	loCol.Header1.Alignment=2
Next

Define Class MyHeader2 As Header OlePublic
	
*!*------------------------------------------------------------------------------------------------------------------------------
	Procedure Click
*!*------------------------------------------------------------------------------------------------------------------------------
	Local loGrid As Grid
	Local loCol As Column
	Local mcord01
	Local lnId

	loGrid = This.Parent.Parent
	If !Pemstatus(loGrid,"lcOrdenCampo",5)
		loGrid.AddProperty("lcOrdenCampo","")
	Endif
	If !Pemstatus(loGrid,"lcOrden",5)
		loGrid.AddProperty("lcOrden","")
	Endif

	loCol = This.Parent

	mcBase = loGrid.RecordSource
	mcCampo = Upper(loCol.ControlSource)

	
	lnId = &mcBase..Id &&

	If "." $ mcCampo
		lnPos = At(".",mcCampo,1)+1
		mcCampo = Substr(mcCampo,lnPos)
		lnPos = At(")",mcCampo,1)
		If lnPos > 0
			mcCampo = Substr(mcCampo,1,lnPos-1)
		Endif
	Endif

	If loGrid.lcOrdenCampo <> mcCampo
		loGrid.lcOrdenCampo = mcCampo
		loGrid.lcOrden = ""
	Endif 	

	Select &mcBase

	Do Case
		Case loGrid.lcOrden = "ASC"
			loGrid.lcOrden ="DESC"
		Case loGrid.lcOrden = "DESC"
			loGrid.lcOrden ="ASC"
		Otherwise
			loGrid.lcOrden ="ASC"
	Endcase

	Declare vdatCol(loGrid.ColumnCount)
	For I = 1 To loGrid.ColumnCount
		vdatCol(I) = loGrid.Columns(I).ControlSource
	Next

	loGrid.RecordSource = ""
	mcord01 = Transform(loGrid.lcOrdenCampo) + " " + loGrid.lcOrden
	
	Select * ;
		From &mcBase ;
		Into Cursor mwkAux000G8 ;
		Order By &mcord01

	Use In Select(mcBase)
	
	Select * ;
		From mwkAux000G8 ;
		Into Cursor &mcBase Readwrite

	loGrid.RecordSource = "mwkProtocolos"

	For I = 1 To loGrid.ColumnCount
		loGrid.Columns(I).ControlSource = vdatCol(I)
	Next

	This.SacoPict(loGrid)

	Do Case
		Case loGrid.lcOrden = "ASC"
			loCol.Header1.Picture = "c:\desaguemes\bmp\asc.bmp"
		Case loGrid.lcOrden = "DESC"
			loCol.Header1.Picture = "c:\desaguemes\bmp\desc.bmp"
		Otherwise
			loCol.Header1.Picture = "c:\desaguemes\bmp\asc.bmp"
	Endcase

	Select &mcBase
	Go Top

	loGrid.Refresh

	Select &mcBase
	Locate For Id = lnId

	loGrid.SetFocus()

	Endproc

	*--------------------------------------------------------------
	Procedure SacoPict
	Parameters toGrid
	*--------------------------------------------------------------
	Local lnI As Integer
	Local loCol As Column
	For lnI = 1 To toGrid.ColumnCount
		loCol = toGrid.Columns(lnI)
		loCol.Header1.Picture = ''
		loCol.Header1.Tag = ""
	Next
	Endproc

	Procedure Init

	Endproc

	Procedure Destroy

	Endproc

	Procedure Error(nError, cMethod, nLine)
		*Messagebox("Error " + Transform(nError) + Chr(13)+ " Metodo " + Transform(cMethod)+ Chr(13)+ " Linea " + Transform(nLine),16,"ERROR")
	Endproc

Enddefine





