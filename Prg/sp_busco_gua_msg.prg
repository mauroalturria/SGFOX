Parameters xmproto, xmfecdes, xmfechas, xmbusco

If Empty(xmproto)
	mbusca = ''
Else
	mbusca = " and TGM_protocolo = ?xmproto "
Endif
mitime = Seconds()
If mcual = 3  && si es desde hasta
	mret = SQLExec(mcon1, "select TGM_protocolo,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
		" from TabGuaMsg " + ;
		" where TGM_Fechah >= ?mf1 and TGM_Fechah< ?mf2 and TGM_estado <> 9 and TGM_codmed = 1 " +mbusca+ ;
		" ", "mwkprotomsg0")
Else
	mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
		" from TabGuaMsg " + ;
		" where TGM_Fechah >= ?mfecha and TGM_estado <> 9 and TGM_codmed = 1 " +mbusca+ ;
		" ", "mwkprotomsg0")
Endif

