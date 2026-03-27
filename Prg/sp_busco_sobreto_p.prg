*************************
*AUTOR: Claudia Antoniow
*FECHA:21/06/2002
*************************
*Modificado:24/6/2002
*************************
parameters vd_fecha_d

mret=sqlexec(mcon1,"select * from tabsobretoA where codmed = ?mncodmed "+;
			" and diasem = ?mndiasem "+;
			" and ?vd_fecha_d between fvigend and fvigenh ","MwkSobreto")
			
if mret < 0
	messagebox('ERROR DE CURSOR, AVISAR A SISTEMAS',16,'VALIDACION')
	mret=0
endif			