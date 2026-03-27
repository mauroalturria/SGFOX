*******************************
* AUTOR:Claudia Antoniow
* FECHA:15/07/2003
* ULTIMA MODIFICACION:15/07/2003
*******************************
*Cuando se da de baja una prestacion
*en medpresta hay que dar la baja
*correspondiente en Franjahoraria
********************************
Parameters vr_mdvigenh, vr_usu, vr_mfgraba, vr_mfecturnod, vr_mfecturnoh, vr_codmed,;
	vr_diasem, vr_mthorad, vr_mthorah, vr_prestac, vr_id

mccampo = ''
If mxambito >1
	mccampo = "  and codambito = ?mxambito "
Endif

mret = SQLExec(mcon1," Update Medpresta set FecvigenH = ?vr_mdvigenh, "+;
	" usuario = ?vr_usu, fhgraba = ?vr_mfgraba "+;
	" where fecvigend = ?vr_mfecturnod And "+;
	" fecvigenh = ?vr_mfecturnoh  And codmed = ?vr_codmed "+;
	" And codprest =?vr_prestac and diasem = ?vr_diasem "+;
	" And horadesde = ?vr_mthorad and horahasta = ?vr_mthorah "+;
	" And id = ?vr_id " )

If mret < 0
	Messagebox("NO SE GUARDO LA MODIFICACIÓN, VERIFIQUE",16, "Modificacion de Datos")
	mret=0
	Do prg_cancelo
Else
	Messagebox("SE GUARDO CON EXITO LA MODIFICACIÓN",64, "Modificacion de Datos")
Endif
