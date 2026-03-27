****
** busco Observaciones
****
Parameters mId,ccursor,mbusco,madmi,mtodos
If Vartype(ccursor) # "C"
	ccursor = "mwkpacobobs"
Endif
If Vartype(mbusco) # "C"
	mbusco = ''
Endif
If Vartype(mtodos) # "N"
	mtodos = 0
Endif
If mtodos = 1
	mret = SQLExec(mcon1," select  PO_admision,POO_Estado , POO_FechaObs , POO_Idpacob "+;
	" from TabPacObitoObs,Tabpacobito,pacinternad  "+;
	" where Tabpacobito .id = POO_Idpacob and PO_admision = pin_codadmision "+mbusco, ccursor)
Else

	If Vartype(madmi) # "C"
		mret = SQLExec(mcon1," select  POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario ,"+;
		"tabestados.descrip, idusuario,nomape "+;
		" from TabPacObitoObs,tabestados,tabusuario "+;
		" where tabestados.estado = TabPacObitoObs.POO_Estado and propietario = 8 "+mbusco+;
		" and TabPacObitoObs.POO_Usuario = tabusuario.codigovax and POO_Idpacob = ?mId ", ccursor)
	Else
		mret = SQLExec(mcon1," select  POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario ,"+;
		"tabestados.descrip, idusuario,nomape "+;
		" from TabPacObitoObs,tabestados,tabusuario,Tabpacobito  "+;
		" where Tabpacobito .id = POO_Idpacob and  tabestados.estado = TabPacObitoObs.POO_Estado and propietario = 8 "+mbusco+;
		" and TabPacObitoObs.POO_Usuario = tabusuario.codigovax and PO_admision = ?madmi", ccursor)

	Endif
Endif
If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Else
	Return Reccount()
Endif
