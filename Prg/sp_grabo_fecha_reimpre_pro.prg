*********
* Grabo fecha hora de impresion del vale en guardiavale por protocolo
*********

mfechahora = sp_busco_fecha_serv('DT')
select idgv from mwkvalesimp group by idgv into cursor mwkvalesgrabo
select mwkvalesgrabo
scan
	mid= mwkvalesgrabo.idgv
	mret = SQLExec(mcon1,"update guardiavale set fechamodif = ?mfechahora "+;
		" where id = ?mid ")
	if mret < 0
		Messagebox("ERROR AL GRABAR FECHA... VEIFIQUE",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	endif
endscan
