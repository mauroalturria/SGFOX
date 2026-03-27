****
** busca los protocolo de guardia para para un paciente
****

parameter mbusco

mfechactr = sp_busco_fecha_serv('DT')
mfecha = mfechactr - 86400  && 57600 && 16hs   &&  86400  &&  24hs
mret = sqlexec(mcon1, "select * from  guardia,tabtipoaltas " + ;
	" where nroregistrac = ?mbusco and " + ;
	" guardia.codestado 	= tabtipoaltas.id and " + ;
	" guardia.fechahoraing >= ?mfecha " + ;
	" and tipoest in (2,4,5)", "mwkguardia")
if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
endif
