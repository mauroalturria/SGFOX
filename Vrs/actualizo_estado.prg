*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
*do sp_conexion
select consulta
scan
	ndato = dato
	mret = sqlexec(mcon1,"SELECT descrip FROM Guardia, Tabtipoaltas, Guardiavale"+;
 		" WHERE Tabtipoaltas.ID = Guardia.codestado AND Guardia.protocolo  =Guardiavale.protocolo  "+;
		" and nrovale = ?ndato " , "mwkbuspacie")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif
	if reccount( "mwkbuspacie")>0
		mesta   = mwkbuspacie.descrip 
		select consulta
		replace estado with mesta   
	endif
endscan
do sp_desconexion