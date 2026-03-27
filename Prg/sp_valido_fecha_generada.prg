***************************
* AUTOR:Claudia Antoniow
* FECHA:06/11/2002
***************************
* Modificado:06/11/2003
***************************
parameter mfechagen

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret =sqlexec(mcon1,'SELECT count(id) as cantgen FROM turnos '+; 
					' WHERE &mccpoamb fechatur=?mfechagen and turnos.tipoturno <>9 ','MWKFecGen')
if mret < 0
	mret = 0
	messagebox('ERROR DEL CURSOR valido fecha turno Generados, AVISAR A SISTEMAS',16,'VALIDACION')
endif					