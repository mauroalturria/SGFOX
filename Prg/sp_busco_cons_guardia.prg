****
** Busco todos los vales abiertos por prestacion para estadistica de guardia
***

parameters mfecdes, mfechas, mbuscaent, mbuscaserv, mtipopac

*!*	mret = sqlexec(mcon1, "select VAL_codvaleasist, "+ ;
*!*		" VAL_circuitoorigen VAL_fechasolicitud, VAL_horasolicitud, " + ;
*!*		"pia_codprest, pia_cantsolicitada, pre_descriprest " + ;
*!*		"from presinsuvas, valesasist, prestacions " + ;
*!*		"where valesasist = pia_valesasist and " + ;
*!*		"pre_codprest = pia_codprest and " + ;
*!*		"VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas and " + ;
*!*		"VAL_tipopaciente = ?mtipopac " + mbuscaserv , "mwktodogua2")

*!*	if mret < 0
*!*		=aerr(eros)
*!*		if eros(1) = 1526 and eros(5) = 400
*!*			messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
*!*		else
*!*			messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
*!*		endif
*!*	else

*!*		mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_codservvale, COB_codentidad, " + ;
*!*			"ENT_descrient, ser_descripserv " + ;
*!*			"from valesasist  " + ;
*!*			"left join coberturas on VAL_codadmision = COB_pacientes "+;
*!*			"left outer join servicios on VAL_codservvale = ser_codserv " + ;
*!*			 "left join entidades on COB_codentidad = ENT_codent " + ;
*!*			"where VAL_fechasolicitud >= ?mfecdes and VAL_fechasolicitud <= ?mfechas and " + ;
*!*			"VAL_tipopaciente = ?mtipopac " + mbuscaserv + mbuscaent +;
*!*			"group by VAL_codvaleasist, VAL_codservvale ", "mwktodogua3")

mret = sqlexec(mcon1, "select VAL_codvaleasist, VAL_codservvale, COB_codentidad "+ ;
	", VAL_circuitoorigen, VAL_fechaconforme, VAL_horasolicitud " + ;
	", pia_codprest, pia_cantsolicitada, pre_descriprest " + ;
	", ENT_descrient, ser_descripserv, pia_secuen_carga  " + ;
	"from valesasist " + ;
	"left join presinsuvas on valesasist.valesasist = pia_valesasist "+;
	"left join prestacions on prestacions .pre_codprest = presinsuvas .pia_codprest  "+;
	"left join coberturas on valesasist.VAL_codadmision = coberturas .COB_pacientes "+;
	"left outer join servicios on valesasist.VAL_codservvale = servicios .ser_codserv " + ;
	"left join entidades on coberturas .COB_codentidad = entidades .ENT_codent " + ;
	" where  VAL_fechaconforme >= ?mfecdes and VAL_fechaconforme <= ?mfechas and " + ;
	" VAL_codsector = ?mtipopac" + mbuscaserv+ mbuscaent +;
	" "  , "mwktodogua")
if mret < 0
	=aerr(eros)
	if eros(1) = 1526 and eros(5) = 400
		messagebox("ERROR EN LA GENERACION DEL CURSOR"+ chr(13) +"SELECCIONE UN RANGO MENOR", 16, "Validacion")
	else
		messagebox("ERROR "+eros(2)+"EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	endif
else
*	" and VAL_circuitoorigen in('0', '1', '2', '5', '6') " + ;
*group by valesasist, pia_secuen_carga 
	select sum(pia_cantsolicitada) as cantidad, * from mwktodogua;
		group by pia_codprest, COB_codentidad,VAL_codservvale ;
		order by COB_codentidad,pia_codprest ;
		into cursor mwkconsulta

endif