****
** Actualizo tabla de so - st -ps
****

parameters mso, mst, mps, mfd1, mfh1, mfd2, mfh2, mcual

mccpoamb = ''
mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif
if mcual = 1

	mfg		= sp_busco_fecha_serv('DT')

	if !empty(mfh1)

		mid_a = mwkhoradoc6.id
		mret = sqlexec(mcon1, "update tabsobretoa " + ;
			"set fvigenh = ?mfh1,centromedico = ?mxcentromedico, " + ;
			"fechagraba = ?mfg, usuario = ?midusu " + ;
			"where id = ?mid_a ")
		if mret < 0
			=aerr(eros)
			messagebox(eros(2), 16, "Validacion")
			messagebox(eros(3), 16, "Validacion")
		endif
	else
		mid_b = mwkhoradoc8.id
		mret = sqlexec(mcon1, "update tabprepaga " + ;
			"set usuario = ?midusu, fecvigenh = ?mfh2, " + ;
			"fechagraba = ?mfg, usuario = ?midusu,centromedico = ?mxcentromedico " + ;
			"where id = ?mid_b ")

		if mret < 0
			=aerr(eros)
			messagebox(eros(2), 16, "Validacion")
			messagebox(eros(3), 16, "Validacion")
		endif
	endif

else
	mcodmed = mwkhoradoc7.codmed
	mdia	= mwkhoradoc7.diasem
	mfg		= sp_busco_fecha_serv('DT')
	mhorad  = mwkhoradoc7.horadesde
	mhorah  = mwkhoradoc7.horahasta
	hhmmd	= val(left(ttoc(mhorad,2),2)+substr(ttoc(mhorad,2),4,2))
	hhmmh	= val(left(ttoc(mhorah,2),2)+substr(ttoc(mhorah,2),4,2))
	if mso > 0 or mst > 0
		mret = sqlexec(mcon1, "insert into tabsobretoa (cantidad, codmed, codprest,diasem, fechagraba, fvigend,"+;
			"fvigenh, hhmmDes, hhmmHas,horadesde, horahasta, porcentaje,"+;
			" tipoturno, usuario,centromedico  &mcicpoamb )" + ;
			"values(?mst, ?mcodmed, 0, ?mdia, ?mfg, ?mfd1, ?mfh1, " + ;
			"?hhmmD, ?hhmmH, ?mhorad, ?mhorah, ?mso, 2, ?midusu,?mxcentromedico &mvicpoamb)")
		if mret < 0
			=aerr(eros)
			messagebox(eros(2), 16, "Validacion")
			messagebox(eros(3), 16, "Validacion")
		endif

	endif

	if mps > 0
		mret = sqlexec(mcon1,"insert into tabprepaga (Cantidadps, Codmed, Criterio,"+;
  				"Diasem, Fechagraba, Fecvigend,Fecvigenh, HhmmDes, HhmmHas,"+;
  				"Horadesde, Horahasta, Idfranja,Tipodato, Usuario,centromedico   &mcicpoamb)" + ;
			"values(?mps, ?mcodmed, 'F', ?mdia,?mfg, " + ;
			"?mfd2, ?mfh2, ?hhmmD, ?hhmmH, ?mhorad, ?mhorah, 0, 'R', ?midusu,  ?mxcentromedico  &mvicpoamb)")

		if mret < 0
			=aerr(eros)
			messagebox(eros(2), 16, "Validacion")
			messagebox(eros(3), 16, "Validacion")
		endif
	endif
endif

if mret < 0
	messagebox("ERROR AL ACTUALIZAR SOBRETURNOS" , 16, "Validacion")
	do prg_cancelo
endif

