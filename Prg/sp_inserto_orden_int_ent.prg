****
** inserto registro de ordenes de internacion
****

parameter morden, mnroen, mcodtel, mestado, mfecdes, mfechas, mobserv

	mret = sqlexec(mcon1, "insert into tabordentint(codigote, estado, fechadesde, " +  ;
					"fechahasta, nrorden, observa,  ordint) " + ;
					"values(?mcodtel, ?mestado, ?mfecdes, ?mfechas, ?morden, " + ;
					"?mobserv, ?mnroen )")
					
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")		
	DO sp_desconexion WITH "error"
		cancel
	endif	