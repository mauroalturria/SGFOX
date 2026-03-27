****
** Busco todos los vales para estadistica de guardia
***

parameters mfecdes, mfechas,mbus

mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
	"VAL_URGENCIASERV,VAL_codadmision,val_codsector,VAL_codservvale  "+;
	"from valesasist " + ;
	"where VAL_codservvale in "+mbus+" and VAL_fechasolicitud >= ?mfecdes" +;
	" and VAL_fechasolicitud <= ?mfechas and val_codsector<>'GUA' and val_codsector<>'AMB' ", "mwkvalesfar0")
	
mret = sqlexec(mcon1, "select * FROM habitacions " + ;
	"where hab_codpaciente <>'0' " ,"MWKCAMAS")
	
	select VAL_codvaleasist, CTOT(DTOC(VAL_fechasolicitud)+ ;
		" " +STRTRAN(ALLTRIM(VAL_horasolicitud),".",":")+":00") AS FECHAHORA,;
		VAL_URGENCIASERV ,HAB_Sectores,HAB_codhabitacion,HAB_codcama,val_codsector,VAL_codservvale   ;
	FROM mwkvalesfar0 left join MWKCAMAS on VAL_codadmision = hab_codpaciente ;
	INTO CURSOR mwkvalesfar1
if mret < 0
	=aerr(eros)
	messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
endif
