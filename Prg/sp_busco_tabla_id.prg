Lparameters lcTabla, lcBusco, lcCursor
*-------------------------------------------------------
If Vartype(lcCursor) # "C"
	lcCursor = "mwkTabDat" 
Endif 	
if empty(lcBusco)
	mwhere = ""
else 
	mwhere = " Where " + lcBusco 
endif
mRet = Sqlexec(mcon1,"Select * from " + lcTabla + mwhere ,lcCursor)
If mret <= 0
	=Aerror(EROS)
*!*		?EROS(3)
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif 	
