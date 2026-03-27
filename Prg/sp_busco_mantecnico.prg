*********************************************************************************
* Busco tecnicos
*********************************************************************************
mfecnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"select *  from tabmanttecnico "+;
	" left join tabmantespecialidad "+;
	" on tabmanttecnico.idespecialidad = tabmantespecialidad.id "+;
	" where TabMantTecnico.FechaPasiva = ?mfecnull" ,"mwkMantTecnico")

if mret < 1
	=aerr(eros)
	messagebox('ERROR EN EL INGRESO, REINTENTE O AVISE A SISTEMAS', 64,'Validacion')
endif

