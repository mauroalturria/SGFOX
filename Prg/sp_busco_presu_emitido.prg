***************
** busco relacion con presup
**********

lparameters mPA_idAutprevia,mPA_idTabautpre

mfecpas = ctod("01/01/1900")
mret = sqlexec(mcon1, "SELECT CodAmbito, PA_idAutprevia, PA_idPresu,PA_idTabautpre, PA_tipopac"+;
	" FROM  Zabpresuaut  Where PA_idAutprevia = ?mPA_idAutprevia and "+;
	" PA_idTabautpre = ?mPA_idTabautpre and PA_fechapas = ?mfecpas ", "mwkPresaut")
if mret < 0
	=aerror(merror)
	messagebox("EN CONSULTA AMBULATORIO, PROTOCOLOS PREVIOS"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif
