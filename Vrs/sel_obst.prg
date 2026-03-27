If Reccount('mwkpressiSG') > 0 &&& busca con quien se atendio previamente
	Do sp_busco_turnos_tomados With mfecdia-(9*30),mfecdia," and afiliado = "+Transform(mwkbuspacie1.reg_nroregistrac)+;
	" and turnos.codprest = "+Transform(mncodp )+" and confirmado = 1 "
	If Used('mwkTurnosTom')
		If Reccount('mwkTurnosTom') > 0
			Select * From mwkTurnosTom Into Cursor mwkTurnosTomsoloSG
			Go Bott
			mcodmedobst = mwkTurnosTom.codmed
			Messagebox("SOLO PUEDE TOMAR TURNOS EN EL SG CON EL PROFESIONAL "+Alltrim(mwkTurnosTom.nombre),0+64,"Control Lima")
		Endif
	Endif
Endif


If lesdistancia Or mcodmedobst >0
	mfiltratur = " (&mturhab or  (horatur<= mfechalibre and liberable<3) ) "+mfiltratur
Else
	mfiltratur = "   (tipoturno in (select tipoturno from  mwktxeok ) or "+;
	" (horatur<= mfechalibre and liberable<3)  ) "+mfiltratur
Endif
If mxambito = 1  And Reccount('mwkpresnoSG')>0
	If   recint =0
		Messagebox("ESTA PRESTACION DEBE REALIZARSE EN EL CENTRO MEDICO LIMA",64,"Control de Prestaciones")
		If maudi=1
			Messagebox("COMO SUPERVISOR PUEDE TOMAR TURNOS EN EL SG PERO NO CORRESPONDE",64,"Control de Prestaciones")
		Else
			If mcodmedobst >0
				mfiltratur = mfiltratur + ' and ( at("LIMA",sala)>0 or fechatur<mwkpresnoSG.PXE_VigenciaDesde or codmed = '+Transform(mcodmedobst)+") "
			Else
				mfiltratur = mfiltratur + ' and (at("LIMA",sala)>0  or fechatur<mwkpresnoSG.PXE_VigenciaDesde) '
			Endif
		Endif
	Endif
Endif
