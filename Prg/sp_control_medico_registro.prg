****
** Medicos con registracion incompleta a la fecha actual + 8 dias
****
mfechaini = ttod(mwkfecserv.fechahora)
mfechafin = mfechaini + 8
mfechanull 	= ctot('01/01/1900')

mret = sqlexec(mcon1, "select prestadores.*, especialid.ESP_codesp, especialid.ESP_descripcion " +;
	"from prestadores, especialid  "+;
	"where lregincomp = 2 and codesp = esp_codesp and "+;
	"fecalta >= ?mfechaini and fecalta < ?mfechafin "+;
	"order by nombre ","mwkctrlreg")

if mret < 0
	= aerr(eros)
	messagebox(eros(3),16,'VALIDACION')
endif

