****
** Busco Detalle de lpresupuesto Ambulatorio reducido
****

Lparameters mfechad ,mfechas, mcwhere

If vartype(mfechad )="D"
	mfec = " and fechasolic>=?mfechad and fechasolic<=?mfechas"
Else
	mfec = ''
Endif
If vartype(mcwhere) # "C"
	mcwhere = ''
Endif
mfecnull = CTOD("01/01/1900")
mfec = mfec +" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "
mfec = mfec +" and (tabpdetpresupuesto.fecpasiva is null or tabpdetpresupuesto.fecpasiva = ?mfecnull) "

mret = sqlexec(mcon1,"SELECT tabpresupuestos.id,paciente,nroafiliado,sectorsol "+;
	" FROM tabpdetpresupuesto,tabpresupuestos"+;
	" where idDetp = tabpresupuestos.id "+mfec + mcwhere ,"mwkEstadoPres01")

If mret < 0
*!*		=aerr(eros)
*!*		Messagebox(eros(3)+"ERROR de LECTURA , Reintente", 48, "Validacion")
	Return
Endif

