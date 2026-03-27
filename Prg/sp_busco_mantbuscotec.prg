*
* Contemplo Técnicos Full ó excluyo pasivados
*
Parameters midOt

If vartype(midOt) <> "C"
	midOt = "S"
Endif

If midOt = "S"
	mfecnull = ctod("01/01/1900")
	mwhere   = " where FechaPasiva = ?mfecnull"
Else
	mwhere   = ""	
Endif

mret = sqlexec(mcon1,"select * from tabmanttecnico "+mwhere,"mwkMantTecnico")

If mret < 1
	=aerr(eros)
	Messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
Endif


