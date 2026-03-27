*****************************************
** Autor:Claudia Antoniow
*****************************************
** Actualizo tabla de gi - re -es -pe
*****************************************
** fecha ulttima Modificacion :21/05/2003
*****************************************

parameters mhd, mhh, mh1, mh2, mh3, mh4, mh5, mh6, mh7, mh8, mh9, mh10,;
	mmg, mmi, mcant, mcrit, mfd1, mfh1, mtipotur, mcual, mid_a


if mcual = 1

	mfg		= sp_busco_fecha_serv("DT")

	if !empty(mfh1)


		mret = sqlexec(mcon1, " update tabreservado " + ;
			"set fecvigenh = ?mfh1, " + ;
			"fechagraba = ?mfg, usuario = ?midusu,centromedico = ?mxcentromedico  " + ;
			"where id = ?mid_a ")
		if mret < 0
			messagebox("ERROR AL ACTUALIZAR RESERVADOS" , 16, "Validacion")
		endif

	endif

else
	mcodmed = mwkhoradoc7.codmed
	mndia	= mwkhoradoc7.diasem
	mfg		= sp_busco_fecha_serv("DT")
	mhorad  = mwkhoradoc7.horadesde
	mhorah  = mwkhoradoc7.horahasta


	if !isnull(mhd) or !isnull(mh1) or !isnull(mmg) or !isnull(mmi) or !isnull(mcant)
		mret = sqlexec(mcon1," insert into tabreservado  " + ;
			"( Diasem , HoraDesde , HoraHasta , HoraRDesde , HoraRHasta , HoraRes1 "+;
			", HoraRes10 , HoraRes2 , HoraRes3 , HoraRes4 , HoraRes5 , HoraRes6 , HoraRes7 , HoraRes8 , HoraRes9 "+;
			",TipoTurno , cantidad , codesp , codmed , criterio , fechagraba , fecvigend "+;
			", fecvigenh , guardia , internado , usuario ,codambito,centromedico  ) "+;
			" values(?mndia, ?mhorad, ?mhorah, ?mhd, ?mhh, ?mh1, "+;
			" ?mh10, ?mh2, ?mh3, ?mh4, ?mh5, ?mh6, ?mh7, ?mh8, ?mh9, "+;
			" ?mtipotur, ?mcant, '',?mncodmed, ?mcrit, ?mfg, ?mfd1, "+;
			" ?mfh1, ?mmg, ?mmi, ?midusu, ?mxambito, ?mxcentromedico  ) ")

		if mret < 0
			messagebox("ERROR AL ACTUALIZAR RESERVADOS" , 16, "Validacion")
		endif


	endif
endif



