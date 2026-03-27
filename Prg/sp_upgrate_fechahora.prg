****
** actualizo fechahora de listado de archivo
****

parameter mfecha,mhora

if vartype(mhora) # "T"
	mhora = sp_busco_fecha_serv('DT')
endif
mret = sqlexec(mcon1, "insert into tabfechora (fecha, hora) values(?mfecha, ?mhora)")

if mret < 0
	messagebox("ERROR EN LA ACTUALIZACION DEL CURSOR", 16,"Validacion")
	cancel
endif
