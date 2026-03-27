*********************************************************************************
* Busca las última llamadas del operador
*********************************************************************************
parameters mfecdes,midusua,mfechas,mopcion

if type ('mopcion')#"N"
	mret = sqlexec(mcon1,"select * from TabRegCall " + ;
		"where Usuario = ?midusua and fecha = ?mfecdes " + ;
		" order by hora desc" , "mwkllamadas")
else
	if mopcion=1
		mret = sqlexec(mcon1,"select * from TabRegCall " + ;
			"where fecha >= ?mfecdes and fecha <= ?mfechas " , "mwkllamadas")
	else
		mret = sqlexec(mcon1,"select * from TabRegCall " + ;
			"where Usuario = ?midusua and fecha >= ?mfecdes and fecha <= ?mfechas " + ;
			" " , "mwkllamadas")
	endif
endif
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	do prg_cancelo
endif
