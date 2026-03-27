****
** Busco TabEstados para Monitor, Propietario = 32
****
Lparameters mdestino
if vartype(mdestino)#"N"
	mdestino = 0
endif
mretorno = .t.
If used('mwkTabEstados')
	Use in mwkTabEstados
Endif
if mdestino >0
	mret = sqlexec(mcon1,"select * from TabEstados "+;
		"where propietario = 32 and estado = ?mdestino", "mwkTabEstados")
else
	mret = sqlexec(mcon1,"select * from TabEstados "+;
		"where propietario = 32 and estado > ?mdestino", "mwkTabEstados")
endif
If mret<1
*!*	    =aerr(eros)
*!*	    messagebox(eros(3))
	Messagebox("ERROR EN EL CURSOR DE ESTADOS, AVISE A SISTEMAS",48,"Validacion")
	mretorno = .f.
Endif
Return mretorno