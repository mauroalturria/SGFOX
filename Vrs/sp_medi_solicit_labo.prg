***
** medicos solicitantes de vales ambulatorio
***

parameter mfecdes, mfechas, mbusco1

 mret = sqlexec(mcon3,"select val_medicosolicit, nombre, val_fechasolicitud, " + ;
 				"pia_codprest, pia_cantsolicitada, pre_descriprest " + ;
 				"from valesasist, presinsuvas, prestadores, prestacions " + ;
 				"where val_medicosolicit = prestadores.id and " + ;
	 			"valesasist = pia_valesasist and " + ;
 				"pia_codprest = pre_codprest and " + ;
 				"val_fechasolicitud >= ?mfecdes and " + ;
 				"val_fechasolicitud <= ?mfechas and " + ;
 				"VAL_codsector = 'AMB' &mbusco1 ", "mwktodos")

