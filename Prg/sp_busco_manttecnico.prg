*********************************************************************************
* Busco tecnicos
*********************************************************************************
Lparameters mltip

If vartype(mltip) <> "C"
	mltip = "S"
Endif

If mltip = "S"
	mfecnull = ctod("01/01/1900")
	mwhere   = " where TabMantTecnico.FechaPasiva = ?mfecnull "
Else
	mwhere = ""
Endif

mret = sqlexec(mcon1,"select *  from tabmanttecnico   "+;
	" left join tabmantespecialidad "+;
	" on tabmanttecnico.idespecialidad = tabmantespecialidad.id "+;
	mwhere+;
	" order by apellido " ,"mwkMantTecnico")

If mret < 1
	=aerr(eros)
	Messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
Endif

