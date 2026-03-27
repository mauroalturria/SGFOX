***
*** Busqueda de usuario por legajo
***
Lparameters mlegajo, mtipo

mpaso = .t.
If used('mwklegajo')
	Use in mwklegajo
Endif
mfecnull = ctod("01/01/1900")

If mtipo = 1
	mbusca = mlegajo
	mwhere1 = "where Legajo = ?mbusca and fechaegreso=?mfecnull"
	mwhere2 = "where LEG_ID = ?mbusca"
Else
	mbusca = alltrim(mlegajo)
*!*	*mwhere1 = "where Apellido = ?mbusca and fechaegreso=?mfecnull"
*!*	*mwhere2 = "where LEG_APELLIDO = ?mbusca"
	mwhere1 = "where Apellido LIKE '%&mbusca%' and fechaegreso=?mfecnull"
	mwhere2 = "where LEG_APELLIDO LIKE '%&mbusca%'"
Endif

mret = sqlexec(mcon3, "select legajo as LEG_ID,apellido as LEG_APELLIDO,nombre as LEG_NOMBRE,'TTLEGAJO' as LEG_PROV,* "+;
	"from TTLegajos "+mwhere1, "mwklegajo")
	
If mret <1
	Messagebox("EN BUSQUEDA EN MAESTRO DE LEGAJOS CENTRAL TELEF.",16,"ERROR")
	Do prg_cancelo
Else
	Select mwklegajo
	Go top
	If reccount('mwklegajo')>0
		mpaso = .f.
	Endif
	If mpaso
		mret = sqlexec(mcon3, "select * from LEGAJOS " + mwhere2, "mwklegajo")
*		mret = sqlexec(mcon3, "select * from legajito " + mwhere2, "mwklegajo")
		If reccount("mwklegajo") = 0
			mret = sqlexec(mcon3, "select * from LEGAJOS2 " + mwhere2, "mwklegajo")
*			mret = sqlexec(mcon3, "select * from legajito " + mwhere2, "mwklegajo")
		Endif
		If mret < 0
			Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
			Do prg_cancelo
		Endif
		If reccount("mwklegajo") > 0
			Select *,'LEGAJOS' as LEG_PROV,00000 as pin from mwklegajo into cursor mwklegajo
		Endif

	Endif
Endif
