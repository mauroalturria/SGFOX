****
** Busco todos los vales para estadistica de guardia
***

Parameters mfecdes, mfechas

*!*	mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechasolicitud, VAL_horasolicitud, " + ;
*!*		"VAL_URGENCIASERV,VAL_codadmision,val_codsector  "+;
*!*		"from valesasist " + ;
*!*		"where VAL_codservvale = 5410 and VAL_fechasolicitud >= ?mfecdes" +;
*!*		" and VAL_fechasolicitud <= ?mfechas and val_codsector<>'GUA' ", "mwkvalesfar0")

*!*	mret = sqlexec(mcon1, "select * FROM habitacions " + ;
*!*		"where hab_codpaciente <>'0' " ,"MWKCAMAS")

*!*	select VAL_codvaleasist, ctot(dtoc(VAL_fechasolicitud)+ ;
*!*		" " +strtran(alltrim(VAL_horasolicitud),".",":")+":00") as FECHAHORA,;
*!*		VAL_URGENCIASERV ,HAB_Sectores,HAB_codhabitacion,HAB_codcama,val_codsector   ;
*!*		from mwkvalesfar0 left join MWKCAMAS on VAL_codadmision = hab_codpaciente ;
*!*		into cursor mwkvalesfar1


mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_fechacargasoli, VAL_horacargasolic, " + ;
	"VAL_URGENCIASERV,VAL_codadmision,val_codsector  "+;
	"from valesasist " + ;
	"where VAL_codservvale = 5410 and VAL_fechacargasoli >= ?mfecdes" +;
	" and VAL_fechacargasoli <= ?mfechas and val_codsector <> 'GUA' ", "mwkvalesfar0")

mret = sqlexec(mcon1, "select * FROM habitacions " + ;
	"where hab_codpaciente <>'0' " ,"MWKCAMAS")

Select VAL_codvaleasist, ;
	ctot(dtoc(VAL_fechacargasoli)+" "+right(ttoc(VAL_horacargasolic),8)) as FECHAHORA,;
	VAL_URGENCIASERV ,HAB_Sectores,HAB_codhabitacion,HAB_codcama,val_codsector   ;
	from mwkvalesfar0 left join MWKCAMAS on VAL_codadmision = hab_codpaciente ;
	into cursor mwkvalesfar1

If mret < 0
	=aerr(eros)
	Messagebox("ERROR "+eros(3)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
Endif
