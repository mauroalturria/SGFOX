
set step on
select  webxls
scan
	wait windows transform(recno()) nowait
	if empty(mailant) or left(mailant,3)="***" or upper(mailant)=upper(email)
	else
		mctexto = documento
		mret = sqlexec(mcon1,"update registracio " + ;
			" set REG_email = ?email where REG_numdocumento = ?mctexto ")
		if mret <1
			replace mailant with "error"
		endif
	endif
endscan
do sp_desconexion 