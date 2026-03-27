PARAMETERS mIdDoc,mRevi,mIdUsuario
	mret = sqlexec(mcon1," select Revision from TabGcvincproc where IdDoc= ?mIdDoc order by Revision","mwkcontrol")
	if reccount("mwkcontrol")=0
		mrevi = 1
	else 	
		select mwkcontrol
		go bottom
			mrevi = Revision + 1
	endif
	mfecha = sp_busco_fecha_serv('DT')	
	mret = sqlexec(mcon1,"insert into TabGcvincproc(IdDoc,Revision,Usuario,Fecha) values (?mIdDoc,?mRevi,?mIdUsuario,?mfecha) ")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	mret=0
	cancel
ENDIF