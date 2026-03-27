*********
* 	Actualizo los sinonimos de un diagnostico
*********
parameter mid,msino

mret = sqlexec(mcon1, "select * from  TabCiap2E  where id = ?mid", "mwkCiapThess")
if mret>=0
	msinonimo = alltrim(nvl(mwkCiapThess.sinonimos,'')) + ;
		iif(empty(alltrim(nvl(mwkCiapThess.sinonimos,''))),'',chr(10))
	ccad = ''
	do while len(msino) > 2 and at("|", msino)>0
		mcontad  = atc("|", msino)
		dato_busca = alltrim(left( msino, mcontad - 1  ))
		if at(dato_busca,msinonimo ) = 0
			ccad = ccad + iif(empty(ccad),'',chr(9)) + dato_busca
		endif
		msino	= subs(msino,  mcontad + 1 )
	enddo
	dato_busca = alltrim(msino)
	if at(dato_busca,msinonimo ) = 0
		ccad = ccad + iif(empty(ccad),'',chr(9)) + dato_busca
	endif
	msinonimo = msinonimo + ccad
	mret = SQLExec(mcon1,"Update TabCiap2E  set sinonimos =?msinonimo  where id = ?mid")
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
		mret=0
	endif
else
*	messagebox("ERROR EN LA ACTUALIZACION",16, "Validacion")
endif
