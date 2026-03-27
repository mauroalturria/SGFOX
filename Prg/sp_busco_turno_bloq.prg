*
* Busqueda de un Turno para el profesional, fechas y horas establecidas como parametros mwhere
*

Lparameters mlcodmed, mwhere

If vartype(mwhere)#'C'
	mwhere = ""
Endif

If Used("mwkturnosb")
  Use in mwkturnosb
Endif

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret = sqlexec(mcon1,"select * from Turnos"+;
	" where &mccpoamb  tipoturno <> 9 and codmed = ?mlcodmed"+mwhere,"mwkturnosb")

If mret < 0
	Messagebox("EN CONSULTA DE TURNOS",16,"ERROR")
Endif
