****
** busco pacientes internados que hayan tenido intervencion 

Parameters mfecdes, mnroregis

mfecant1    = mfecdes - 1

Text To lcSql Textmerge Noshow Pretext 7

select
     codmed,estado 
    from TabQuirofano
      where Nroregistrac = ?mnroregis and fechaquirof >= ?mfecant1 
Endtext         

mret = SqlExec(mcon1, lcSql, "mwkpacquir"	)
If mret<1
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
 	=Aerror(eros)
	Messagebox(eros(3)  )
	Messagebox(eros(3))
Endif
