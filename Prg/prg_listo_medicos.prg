*************************************************************
* Lista medicos 
* AUTOR:Claudia Antoniow
*****************************
* FECHA:26/09/2003
**************************************
* Fecha Ult. Modificación: 26/09/2003
* corre en sp_sobreoferta
**************************************
parameters vr_lista

mret =sqlexec(mcon1,'SELECT * FROM prestadores WHERE cast(id as smallint) in ' + vr_lista ,'MwkLisMed')

if mret < 0
	messagebox('ERROR DE CURSOR. Ingrese nuevamente',64,'VALIDACION')
	do prg_cancelo
endif