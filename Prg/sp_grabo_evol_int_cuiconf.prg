************
*   grabacion de cuidados complementarios
**********

lparameters midevolhce,mievol ,mabm

mabm = IIF(vartype(mabm)#"N",1,mabm )
IF mabm = 0
	mievol = "Cuidados realizados" + chr(13)
endif
if reccount('mwkcuiconf')>0
	mfechoy = sp_busco_fecha_serv("DT")

	if  used('mwkusuarios')
		midusu = mwkusuarios.id
		mnom = mwkusuarios.nomape
	else
		midusu = mwkusuario.id
		mnom = mwkusuario.nomape
	endif
	select mwkcuiconf
	scan
		mprest = idcui
		miest = iif(idcui >0,1,2)
		mobserva = cuidado
		if mabm = 1
			mret = sqlexec(mcon1, "insert into TabIntcui" + ;
				"(EICP_estado , EICP_fechaH , EICP_idevol , EICP_idnecpac , EICP_observa , EICP_usuario  )"+;
				" values (?miest , ?mfechoy , ?midevolhce, ?mprest , ?mobserva , ?midusu )")
			if mret < 0
				msg = left(transform(midevolhce)+"_"+transform(mprest )+"_"+transform(mobserva )+"_"+transform(midusu ),255)

				do log_errores with error(), msg , message(1), program(), lineno()

			endif
		else
			mievol = mievol + mobserva +chr(10)
		endif
	endscan
*!*		mret = sqlexec(mcon1, "insert into tabintevolNurse " + ;
*!*			" (EIn_codcienanda , EIn_evolnurse , EIn_fechah , EIN_idevol , EIn_usuario ) values "+;
*!*			" (1, ?mievol ,?mfechoy , ?midevolhce,?midusu )" )
*	mievol = TTOC(mfechoy)+" "+ALLTRIM(mnom )+ " "+ mievol
*!*		if mret < 0
*!*			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*				"AVISE A SISTEMAS",16, "ERROR")
*!*			do log_errores with error(), message(), message(1), program(), lineno()
*!*		endif
endif

