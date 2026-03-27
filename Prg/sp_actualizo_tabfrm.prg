****
** Actualizo tabla TabFrm
****

parameter mnomfrm, mdescri, mmenu, mfecpas, mprimaria, mabm, midfrm

	if mabm = 1	&& nuevo frm
		mfecpas = ctod('01/01/1900')
	
		mret = sqlexec(mcon1, "insert into tabfrm(descrip, fecpasiva, nomfrm, primaria, puntomenu) " + ;
								"values(?mdescri, ?mfecpas, ?mnomfrm, ?mprimaria, ?mmenu)")
	else
	
		mret = sqlexec(mcon1, "update tabfrm set descrip = ?mdescri, fecpasiva = ?mfecpas, " + ;
							"nomfrm = ?mnomfrm, primaria = ?mprimaria, puntomenu = ?mmenu where id = ?midfrm ")		
	endif
	