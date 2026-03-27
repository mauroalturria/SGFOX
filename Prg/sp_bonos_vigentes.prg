*********************
* Claudia Antoniow
*********************
* fecha 20/09/2004
***********************
*Todos los Bonos
*********************	


mhoy =sp_busco_fecha_serv('DD')

mret =sqlexec(mcon1," SELECT denominacion,id FROM Tabbono "+;
					" WHERE tabbono.Fecvigenh >= ?mhoy ","MWKBonos") 

if mret < 0
	messagebox("ERROR AL BUSCAR LOS DATOS, REINTENTE",16, "Validacion") 
	mret = 0
	do prg_cancelo	
endif 

