****
** Busco presupuestos
****
Parameters mid, mestad, mbusca

If vartype(mbusca) # "C"
	mbusca = " and tabpestado.tipo < 2 "
Endif

if INLIST(mwkexe.nomexe,'PISOS','PRESUPUESTOS','ADMISION')
	msec = " and sectorefec <> 'AMB' "
else
	msec = " and sectorefec = 'AMB' "
endif
mfecnull = CTOD("01/01/1900")
msec = msec+" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "

lcWhere = " where 1=1 " + msec + iif(empty(mestad),''," and EstadoActual = ?mestad or paciente = '' ")

mret = sqlexec(mcon1, "SELECT * FROM tabpresupuestos"+;
	" join tabpestado on tabpestado.id = tabpresupuestos.estadoactual "+ lcWhere+mbusca ,"mwkPres")

*!*	mret = sqlexec(mcon1, "SELECT * FROM tabpresupuestos"+;
*!*		" left join tabpestado on tabpestado.id = tabpresupuestos.estadoactual"+ mbusca + lcWhere,"mwkPres")

If mret < 0
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif
