*
* Graba protocolo de la atencion
*
Parameters  mregi, mfate, mfing, mcodent, mcpre, mcmed, mcodpun,;
	mcest, musua, mcua, mprotocolo, mdemanda

*set step on
If Type('mfecha_ant')="D"
	mfHoy = mfecha_ant
Else
	mfHoy = mfing
Endif
mprot_aux = Left(Allt(mwkusuario.idusuario),5)+Padl(Int(Seconds()),5,'0')
mfctrl    = mfing - 120

mccpoamb = ''
mcampo = ""
minser = ""
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
	mcampo = ", codambito "
	minser = ",?mxambito "
Endif

If mcua = 1
	If Used("mwkambctrl")
		Use In mwkambctrl
	Endif
	mret = SQLExec(mcon1,"select id,protocolo from TabAmbulatorio where"+;
		" codent = ?mcodent"+;
		" and nroregistrac = ?mregi"+;
		" and codmed = ?mcmed"+;
		" and fechahoraing >= ?mfctrl"+;
		" and usuario = ?musua" + mccpoamb ,"mwkambctrl")
	If mret < 0
		=Aerror(merror)
		Messagebox("EN CONSULTA AMBULATORIO, PROTOCOLOS PREVIOS"+Chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return
	Else
		If Used("mwkambctrl")
			If Reccount("mwkambctrl")>0
				Select mwkambctrl
				Go Top
				mid = mwkambctrl.Id
				mret = SQLExec(mcon1, "Select Protocolo from TabAmbulatorio Where id = ?mId ", "mwkAuxAmb" )
				If mret < 0
					=Aerror(merror)
					Messagebox("BUSQUEDA DE PROTOCOLO"+Chr(10)+;
						alltrim(merror(3)),16,"ERROR")
					Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
					Return
				Endif
				mprotocolo = mwkambctrl.protocolo
				mcua = 2
				Use In mwkambctrl
			Endif
		Endif
	Endif
Endif

Use In Select("mwkctrl2")
If mcua<3
	mret = SQLExec(mcon1,"select * from tabambulatorio"+;
		" where nroregistrac = ?mregi"+;
		" and codmed = ?mcmed"+;
		" and codprest = ?mcpre"+;
		" and fechahoraate = ?mfate" + mccpoamb ,"mwkctrl2")

	If mret < 0
		=Aerror(merror)
		Messagebox("MAESTRO DE AMBULATORIOS"+Chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return
	Endif
Endif
mcest = Iif(mcua <= 3, 1, mcua)
mprot = Iif(mcua = 1, Alltrim(mprot_aux), mprotocolo)
mpaso = .T.

If Used("mwkctrl2")
	If Reccount("mwkctrl2")>0
		Select * From mwkctrl2 Where Ttod(fechahoraing) = mfHoy Into Cursor mwkctrl2
		If Used("mwkctrl2")
			If Reccount("mwkctrl2")>0
				mpaso = .F.
				mid   = mwkctrl2.Id
			Endif
		Endif
	Endif
Endif
Use In Select("mwkctrl2")

If !mpaso

	mret = SQLExec(mcon1, "update TabAmbulatorio set codestado = ?mcest,"+;
		"demanda = ?mdemanda, nrovale = ?mcodpun,"+;
		"usuario = ?musua where id = ?mId")
Else
	mret = SQLExec(mcon1, "insert into TabAmbulatorio (" + ;
		"protocolo, nroregistrac,demanda, fechahoraate, fechahoraing, " + ;
		"codent, codprest, codmed, nrovale, codestado, usuario, fechaate,centromedico  " + mcampo + "  ) " + ;
		"values(" + ;
		"?mprot ,?mregi,?mdemanda, ?mfate, ?mfing, " + ;
		"?mcodent, ?mcpre, ?mcmed, ?mcodpun, ?mcest, ?musua, ?mfHoy,?mxcentromedico " + minser + " )")


Endif

If mret < 0
	=Aerr(eros)
	mmsgerr  = eros(3)
	mdetalle = mprot + Chr(9) + Transform(mregi) + Chr(9) + Transform(mfate) ;
		+ Chr(9) + Transform(mfing) + Chr(9) + Transform(mcodent) ;
		+ Chr(9) + Transform(mcpre) + Chr(9) + Transform(mcest)
	Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, Program(0)
	Messagebox("ERROR EN LA ACTUALIZACION",48, "VALIDACION")
*!*	Do prg_cancelo
Endif

IF EMPTY(mprotocolo) && Actualizo el Protocolo
	If mpaso
		mret = SQLExec(mcon1, "Select * from TabAmbulatorio Where Protocolo = ?mprot_aux " + mccpoamb , "mwkAuxAmb" )
		If mret < 0
			=Aerror(merror)
			Messagebox("ERROR EN LA LECTURA"+Chr(10)+;
				alltrim(merror(3)),16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return
		Endif
		Select mwkAuxAmb
		Go Bottom
		mProto = Padl(Alltrim(Str(Id)),8,"0") + "-" + Right(Dtoc(mfHoy),2)
		mid    = Id
		mret   = SQLExec(mcon1, "Update TabAmbulatorio Set Protocolo = ?mProto Where id = ?mid " )
		If mret < 0
			=Aerror(merror)
			Messagebox("ACTUALIZACION DEL PROTOCOLO"+Chr(10)+;
				alltrim(merror(3)),16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return
		Endif
	Endif
	mret = SQLExec(mcon1, "Select Protocolo from TabAmbulatorio Where id = ?mId ", "mwkAuxAmb" )
	If mret < 0
		=Aerror(merror)
		Messagebox("EN BUSQUEDA DE PROTOCOLO"+Chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return
	Endif
Endif
