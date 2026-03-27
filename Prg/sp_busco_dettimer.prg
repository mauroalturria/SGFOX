****
** sp_Busco_dettimer
****

mfec = sp_busco_fecha_serv('DD')-60

if  INLIST(mwkexe.nomexe,'PISOS','PRESUPUESTOS','ADMISION')
	msec = " and sectorefec <> 'AMB' "
else
	msec = " and sectorefec = 'AMB' "
endif
mfecnull = CTOD("01/01/1900")
msec = msec+" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "

mret = sqlexec(mcon1,"SELECT paciente , nroafiliado , sectorsol ,"+;
	" tabpresupuestos.id ,"+;
	" estadoActual, entidad "+;
	" FROM tabpresupuestos "+;
	" where nroafiliado is not null" + msec + " and Fechasolic >= ?mfec ","mwkEstadoPresTime")

If mret < 0
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif

