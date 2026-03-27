lparameters mfechat,miarchi
select mwkctrmed
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
scan
	mret = 1
	wait windows "DESBLOQUEANDO... " + transform(codmed) nowait
	munmed = codmed
	mcuan = cuantos
	mccad =  transform(munmed )+chr(9)+transform(mcuan)
	fputs(miarchi, mccad)

	mret=sqlexec(mcon1,"update turnos set afiliado= 0 where &mccpoamb afiliado = 1 "+;
		"and codmed = ?munmed  and fechatur = ?mfechat ")
	if mRet <= 0
		mccad =  transform(munmed )+chr(9)+"ERROR"
		fputs(miarchi, mccad)
		messagebox("ERROR DE LECTURA ",16,"ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
	else
		select mwkctrmed
		delete
	endif
endscan
