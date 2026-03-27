*************************************************
** BUSCA PRESTACIONES TOMADAS PARA LA PRESTACION QUE
** SE ELIMINA
**************************************************
*MODIFICADO 02/06/2003
***************************************************
*hoy = sp_busco_fecha_serv('DD')
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret=sqlexec(mcon1,'SELECT * FROM turnos '+;
				   'WHERE &mccpoamb codmed = ?mncodmed AND ' +;
				   'codprest = ?mncodprest ','MWKTieneTur')
*and fechatur >= ?mhoy 
if mret < 0
	messagebox('ERROR DEL CURSOR TieneTur, REINTENTE',16,'Validación')
	mret=0
else
	mret=sqlexec(mcon1,'SELECT * FROM turnoshis '+;
	                   ' WHERE &mccpoamb codmed = ?mncodmed AND ' +;
				       ' codprest = ?mncodprest ','MWKTieneTur')
	*and fechatur >= ?mhoy 
	if mret < 0
		messagebox('ERROR DEL CURSOR TieneTur, REINTENTE',16,'Validación')
		mret=0
	endif			
endif				   
				   