Lparameters toObj
*!* --------------------------------------------------------------------------- 
Do Case
	Case Inlist(Upper(toObj.BaseClass),"GRID")
		lnCant = toObj.ColumnCount
	Case Inlist(Upper(toObj.BaseClass),"COLUMN")
		lnCant = 0
	Otherwise
		lnCant = toObj.Objects.Count

Endcase 

Return lnCant