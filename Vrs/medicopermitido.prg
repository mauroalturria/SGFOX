**selecciono de Zabprestacexcluentidad
Select * From mwkExcPres Where PXE_TipoExclusion = 7 And PXE_CodPrestacion = mncodp ;
AND PXE_CodEntidad = mcodentag Into Cursor mwkpressiSG &&&busca las prestaciones que se dan en el SG si hubo un turno previo
If Reccount('mwkpressiSG') > 0 &&& busca con quien se atendio previamente 9 meses maximo, es lo que dura un embarazo
	Do sp_busco_turnos_tomados With mfecdia-(9*30),mfecdia," and afiliado = "+Transform(mwkbuspacie1.reg_nroregistrac)+;
	" and turnos.codprest = "+Transform(mncodp )+" and confirmado = 1 "
	If Used('mwkTurnosTom')
		If Reccount('mwkTurnosTom') > 0
			Select mwkTurnosTom
			Go Bott
			mcodmedobst = mwkTurnosTom.codmed
			Messagebox("SOLO PUEDE TOMAR TURNOS EN EL SG CON EL PROFESIONAL "+Alltrim(mwkTurnosTom.nombre),0+64,"Control Lima")
		Endif
	Endif
Endif

*al filtrar turnos
If mcodmedobst >0
	mfiltratur = mfiltratur + ' and ( at("LIMA",sala)>0 or fechatur<mwkpresnoSG.PXE_VigenciaDesde or codmed = '+Transform(mcodmedobst)+") "
Else
	mfiltratur = mfiltratur + ' and (at("LIMA",sala)>0  or fechatur<mwkpresnoSG.PXE_VigenciaDesde) '
Endif
