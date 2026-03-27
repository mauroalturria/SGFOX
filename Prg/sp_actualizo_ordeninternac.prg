****
** Actualizo ordeninternac
****
parameter mnroadm,mautor
mret = sqlexec(mcon1, "update pacientes set PAC_ordeninternac = ?mautor" + ;
	" where PAC_codadmision = ?mnroadm ")
if mret < 0
	messagebox('NO SE ACTUALIZO AUTORIZACION, AVISAR A SISTEMAS', 16, 'Validacion')
endif
