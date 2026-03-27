*!*	devuelve algun dato especifico de una prestacion
Lparameters lnopcion,lncodprest,lncodesp

If Vartype(lncodesp)<>"C"
	lncodesp = ''
Endif
mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, pre_especialidad,PRE_CargaQuirofano "+;
	" FROM prestacions where pre_fechapasiva is null and " + ;
	" pre_codprest = ?lncodprest " , "mwkprestdi")
lncodesp = mwkprestdi.pre_especialidad
lnservi = mwkprestdi.pre_codservicio
lncargaqx = mwkprestdi.PRE_CargaQuirofano
lndescri =  mwkprestdi.pre_descriprest
Use In Select("mwkprestdi")

Do Case
Case  lnopcion = 1
	Return lncargaqx
Otherwise
	Return lndescri
Endcase
