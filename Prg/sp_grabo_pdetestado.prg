***
** Grabo Detalle de estado del presupuesto
****
lparameters mBanderaEstado,mabm
mret = 1
mfecHoraDia  = ttoc(sp_busco_fecha_srv2('DT'))
mfecHoraDia2  = sp_busco_fecha_srv2('DT')
if mabm = 1
	midpEst  = mkwIdActual.ultimoid && UltimoIdActual
	mxestado = mBanderaEstado
else
	select mwkPres
	midpEst  = mwkPres.id
	mxestado = estado
endif
select mwkEstado
midesta = iif(mBanderaEstado,14,mwkEstado.id)

if !mBanderaEstado && si no esta tildado el cheq para finalizar el proceso del presupuesto
	do sp_busco_maxest with midpEst
	select mwkEstActual
	if idEsta <> midesta &&Controlo si e movimiento anterior no es = al actual, en caso de ser asi no inserto registro
*IF mxestado = .t. &&Para no actualizar si el estado es cero
*mret  = SQLEXEC(mcon1,"update tabPresupuestos set estado = 0 where id = ?midesta")
		mret = SQLEXEC(mcon1,"insert into TabPPreDetEst(idpres,idesta,fecha) values (?midpEst,?midesta,?mfecHoraDia2)")
		if mret < 0
			messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
		endif
*ENDIF
	endif
else
	do sp_busco_maxest with midpEst
	if idEsta <> midesta &&Controlo si e movimiento anterior no es = al actual, en caso de ser asi no inserto registro
		mret = SQLEXEC(mcon1,"insert into TabPPreDetEst(idpres,idesta,fecha) values (?midpEst,?midesta,?mfecHoraDia2)")
	endif
	if mret < 0
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif
	mret = SQLEXEC(mcon1,"update tabPresupuestos set estado = 1 where id = ?midesta")

	if  mret < 0
		messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
	endif
endif

UltimoIdActual = 0
if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
