*
* Graba bloqueo de protocolo por pasaje a archivo
*
parameters  mprotocolo

*set step on
mccpoamb = ''
mcampo  = ''
minser = ''
if mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
	mcampo = ", codambito "
	minser = ",?mxambito "
endif
mfechaarchivo = sp_busco_fecha_serv("DT")
mret = sqlexec(mcon1,"select id from TabAmbulatorio where"+;
	" protocolo = ?mprotocolo" + mccpoamb ,"mwkambctrl")
if mret < 0
	=aerror(merror)
	messagebox("EN CONSULTA AMBULATORIO, PROTOCOLOS PREVIOS"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return
else
	if reccount("mwkambctrl")>0
		select mwkambctrl
		go top
		mid = mwkambctrl.id
		mret = sqlexec(mcon1, "update TabAmbulatorio set archivado = 1 "+;
			" , fechaarchivado = ?mfechaarchivo where id = ?mId")
		if mret < 0
			=aerror(merror)
			messagebox("EN BUSQUEDA DE PROTOCOLO"+chr(10)+;
				alltrim(merror(3)),16,"ERROR")
			do log_errores with error(), message(), message(1), program(), lineno()
			return
		endif
	endif
endif
