*******************
* Claudia Antoniow
*******************
* Fecha:05/11/2002
*******************
* Actualizado: Carmen
**********************************************
* Trae la fecha del día del servidor
* Parametro DT si es datetime y DD si es date
**********************************************
Function sp_busco_fecha_2(vr_tipo)

mret=sqlexec(mcon1,"SELECT {fn convert({fn TIMESTAMPADD(SQL_TSI_DAY,dias,currENT_timestamp)},SQL_timestamp)} as fechaHora "+;
				   "from deltfec ","MWKFecServ")

if mret < 0
	mret = 0
	messagebox('ERROR DE GENERACION DE CURSOR, AVISAR A SISTEMAS',16,'VALIDACION')
else
	if vr_tipo = 'DT'	
		vr_fdia = MWKFecServ.fechaHora
	else
		vr_fdia = ttod(MWKFecServ.fechaHora)
	endif
	return vr_fdia
endif