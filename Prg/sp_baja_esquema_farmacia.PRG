*
* Pasivacion de Esquemas Oncológicos
*
Parameters mlid

mfec = sp_busco_fecha_serv('DD')

mret = sqlexec(mcon1,"update TabFarmEsq set TFE_fechapasiva=?mfec"+;
	" where id=?mlid")

If mret < 0
	Messagebox("EN BAJA DEL ESQUEMA ONCOLOGICO EN FARMACIA",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.