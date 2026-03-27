**************************
* AUTOR: Claudia Antoniow
**************************
* FECHA: 26/09/2002
**************************
* MODIFICADO :02/10/2002
**************************
parameter vrlista,vrMwkWork
*do sp_conexion


mret = sqlexec(mcon1,"SELECT * FROM TabCriterios Where agrupa in ("+ vrlista +;
			") and id<1000000000 ORDER BY Id",vrMwkWork)


if mret< 0
	messagebox("ERROR DE CURSOR Criterios, AVISAR A SISTEMA",16,"VALIDACION")
	mret = 0
	do prg_cancelo
endif

