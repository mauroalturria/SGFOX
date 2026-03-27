lparameters mfechat,nhorades,nhorahas,mfiltratipo 
If Vartype(mfiltratipo )<>"C"
	mfiltratipo =''
Endif
select mwkctrmed
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
scan
	mret = 1
	wait windows "DESBLOQUEANDO... " + mwkctrmed.nombre nowait
	if nhorades>=0 and nhorahas>0
		if hhmmdes <= nhorahas and hhmmhas>= nhorades
			munmed = codmed
			mhd = iif(hhmmdes<nhorades,nhorades,hhmmdes)
			mhh = iif(hhmmhas>nhorahas,nhorahas ,hhmmhas )
			mret=sqlexec(mcon1,"update turnos set afiliado= 0 where &mccpoamb afiliado = 1 "+;
				"and codmed = ?munmed  and fechatur = ?mfechat and hhmmtur >= ?mhd "+;
				"and hhmmtur < ?mhh "+mfiltratipo )
		endif
	else
		munmed = codmed
		mhd = hhmmdes
		mhh = hhmmhas
		mret=sqlexec(mcon1,"update turnos set afiliado= 0 where &mccpoamb afiliado = 1 "+;
			"and codmed = ?munmed  and fechatur = ?mfechat and hhmmtur >= ?mhd "+;
			"and hhmmtur < ?mhh "+mfiltratipo )
	endif

	if mret < 0
		=aerr(eros)
		wait windows eros(3)
	else
		select mwkctrmed
		delete
	endif
endscan
