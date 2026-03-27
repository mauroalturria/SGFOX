*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* y recibe un parametro que indica si lo quiero de ambulatorio, *
* internacion o guardia - el nombre del campo.                  *
*****************************************************************

mfecturno	= sp_busco_fecha_serv('DD')
mfecha2 	= ctot('01/01/1900')

mret = sqlexec(mcon1," SELECT id, nombre, estado, bloquedesde, bloquehasta " + ;
	" FROM prestadores  " + ;
	" WHERE (fecpasivap = ?mfecha2  or fecpasivap > ?mfecturno) and &mcdedonde = 1 and (estado = 1 or fecpasiva > ?mfecturno) " + ;
	" And id > 1 ORDER BY nombre", "mwkMedico" )
if mret < 0
	messagebox('ERROR DE CURSOR mwkMedico , AVISAR A SISTEMAS',16,'VALIDACION')
	mret = 0
	cancel
endif
