*******************
* Claudia Antoniow
*******************
* Fecha:05/11/2002
*******************
* Actualizado:
**********************************************
* Trae la fecha del día del servidor
* Parametro DT si es datetime y DD si es date
**********************************************
Function sp_busco_fecha_serv(vr_tipo)
mret = 0
ncant = 0
do while mret <= 0 or ncant < 4  
	mret=sqlexec(mcon1,"SELECT {fn convert({fn TIMESTAMPADD(SQL_TSI_DAY,dias,currENT_timestamp)},SQL_timestamp)} as fechaHora "+;
				   "from deltfec ","MWKFecServ")
	ntiempo = seconds()
	if mret < 0
		ncant = ncant +1
		do while seconds() - tiempo < 4
		enddo
	endif
enddo
if mret < 0

	messagebox('ERROR DE GENERACION DE CURSOR, REINTENTE',16,'VALIDACION')
	cancel
else
	if vr_tipo = 'DT'	
		vr_fdia = MWKFecServ.fechaHora
	else
		vr_fdia = ttod(MWKFecServ.fechaHora)
	endif
	return vr_fdia
endif

*!*		if vr_tipo = 'DT'	
*!*			return datetime()
*!*		else
*!*			return date()

*!*		endif
