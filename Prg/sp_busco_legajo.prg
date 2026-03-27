***
*** Busqueda de usuario por legajo
***
lparameters mlegajo, mtipo
mpaso = .t.
if used('mwklegajo')
	use in mwklegajo
endif
mfecnull = ctod("01/01/1900")

if mtipo = 1
	mbusca = mlegajo
	mwhere1 = "where Legajo = ?mbusca and fechaegreso=?mfecnull"
	mwhere2 = "where LEG_ID = ?mbusca"
else
	mbusca = alltrim(mlegajo)
*	mwhere1 = "where Apellido = ?mbusca and fechaegreso=?mfecnull"
*	mwhere2 = "where LEG_APELLIDO = ?mbusca"
	mwhere1 = "where Apellido LIKE '%&mbusca%' and fechaegreso=?mfecnull"
	mwhere2 = "where LEG_APELLIDO LIKE '%&mbusca%'"
endif
mret = sqlexec(mcon3, "select legajo as LEG_ID,apellido as LEG_APELLIDO,"+;
	"nombre as LEG_NOMBRE,* "+;
	"from TTLegajos "+mwhere1, "mwklegajo")
	
if mret <1
	messagebox("EN BUSQUEDA EN MAESTRO DE LEGAJOS CENTRAL TELEF.",16,"ERROR")
	do prg_cancelo
else
	select mwklegajo
	go top
	if reccount('mwklegajo')>0
		mpaso = .f.
	endif
	if mpaso
		mret = sqlexec(mcon3, "select * from LEGAJOS " + mwhere2, "mwklegajo")
		if reccount("mwklegajo") = 0
			messagebox("LEGAJO AUN NO INGRESADO, REINTENTE MAS TARDE",16, "Validacion")
		endif
		if mret < 0
			messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
			do prg_cancelo
		endif
		if reccount("mwklegajo") > 0
			select *,0 as id,00000 as pin,0000 as sector,00000 as responsable  from mwklegajo into cursor mwklegajo
		endif
	endif
endif
