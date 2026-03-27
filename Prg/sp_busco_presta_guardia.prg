*
* Busqueda de servicios s/protocolo
*
Lparameters mlproto

Use in select("mwkbustexto")

mret = sqlexec(mcon1, "select pre_codprest,pre_descriprest,pre_codservicio,"+;
	"pre_especialidad,pre_duracion,ser_descripserv, guardiavale.codserv,nrovale,"+;
	"pia_codprest,pia_cantsolicitada"+;
	",pre_duracion as PA_duracion, "+;
	" Pre_retiroestudios as PA_retiroestudios,pre_tipomuestra,PRE_Lateralidad ,PRE_tipozona  "+;
	" from valesasist " + ;
	" Inner join guardiavale on guardiavale.nrovale = valesasist.VAL_codvaleasist " + ;
	" Inner join presinsuvas on valesasist.VAL_codpun = presinsuvas.pia_valesasist " + ;
	" Inner join prestacions on pre_codprest = pia_codprest " + ;
	" Inner join servicios on SER_codserv = guardiavale.codserv "+;
	" where  guardiavale.codserv not in (5410)"+;
	" and protocolo = ?mlproto", "mwkbustexto")

*!* not in (5410,6400,6800,7000)

If mret < 0
	Messagebox("CONSULTA DE PRESTACIONES DE INTERCONSULTA"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.



