Do sp_conexion
Set Step On
Select b_ambula
Go Top
*GO bottom
SCAN
mid = id 	
miambi = pac_codambito
		mret   = SQLExec(mcon1, "Update TabAmbulatorio Set codambito  = ?miambi Where id = ?mid " )
		If mret < 0
			=Aerror(merror)
			Messagebox("ACTUALIZACION DEL PROTOCOLO"+Chr(10)+;
				alltrim(merror(3)),16,"ERROR")
			Set Step On
		Endif
ENDSCAN

Do sp_desconexion
SET STEP ON 
Do sp_conexion
Set Step On
Select B_VALES
Go Top
*GO bottom
mfate = Ctot("01/01/1900")
mfHoy = Date()
madmi = VAL_codadmision
mcpre= PIA_codprest
mregi = PAC_codhci
mcmed = VAL_prestador
mserv = val_codservvale
Do While !Eof()
	madmi = VAL_codadmision
	mcpre= PIA_codprest
	mregi = PAC_codhci
	mcmed = VAL_prestador
	mserv = val_codservvale
	mret = SQLExec(mcon1,"select id,protocolo from TabAmbulatorio where"+;
		"   nroregistrac = ?mregi"+;
		" and codmed = ?mcmed"+;
		" and fechahoraing >= {fn curdate()} ","mwkctr")
	If Reccount("mwkctr") =0
*!*		Valesasist.VAL_codpun, Valesasist.VAL_codadmision,;
*!*	  Valesasist.VAL_fechasolicitud, Valesasist.VAL_codvaleasist,;
*!*	  Valesasist.VAL_codservvale, Valesasist.VAL_medicosolicit,;
*!*	  Valesasist.VAL_observaciones, Valesasist.VAL_OperadorCarga,;
*!*	  Valesasist.VAL_FHSolicitud, Valesasist.VAL_IdEvol,;
*!*	  Valesasist.VAL_NroProtocolo, Valesasist.VAL_circuitoorigen,;
*!*	  Valesasist.VAL_prestador, Pacientes.PAC_codhci, Pacientes.PAC_codhce,;
*!*	  Pacientes.PAC_codambito, Prestadores.nombre, Presinsuvas.PIA_codprest,;
*!*	  Tabusuario.idusuario
		Select B_VALES
		mprot_aux = "CAR"+Padl(Int(Seconds()),5,'0')
		mdemanda = Iif(VAL(val_circuitoorigen) =1,0,1)
		mfing =VAL_FHSolicitud
		mcodent = IIF(PAC_codambito=26,100, 948)
		mcodpun = VAL_codvaleasist
		mcest = 1
		musua = idusuario
		mcambito = PAC_codambito
		mret = SQLExec(mcon1, "insert into TabAmbulatorio (" + ;
			"protocolo, nroregistrac,demanda, fechahoraate, fechahoraing, " + ;
			"codent, codprest, codmed, nrovale, codestado, usuario, fechaate,codambito)" + ;
			"values(" + ;
			"?mprot_aux  ,?mregi,?mdemanda, ?mfate, ?mfing, " + ;
			"?mcodent, ?mcpre, ?mcmed, ?mcodpun, ?mcest, ?musua, ?mfHoy ,?mcambito )")


		If mret < 0
			=Aerr(eros)
			Messagebox(eros(3))
		Endif

		mret = SQLExec(mcon1, "Select * from TabAmbulatorio Where Protocolo = ?mprot_aux "   , "mwkAuxAmb" )
		If mret < 0
			=Aerror(merror)
			Messagebox("ERROR EN LA LECTURA"+Chr(10)+;
				alltrim(merror(3)),16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return
		Endif
		Select mwkAuxAmb
		If Reccount('mwkAuxAmb')=0
			Set Step On
		Endif
		Go Bottom
		mProto = Padl(Alltrim(Str(Id)),8,"0") + "-" + Right(Dtoc(mfHoy),2)
		mid    = Id
		mret   = SQLExec(mcon1, "Update TabAmbulatorio Set Protocolo = ?mProto Where id = ?mid " )
		If mret < 0
			=Aerror(merror)
			Messagebox("ACTUALIZACION DEL PROTOCOLO"+Chr(10)+;
				alltrim(merror(3)),16,"ERROR")
			Set Step On
		Endif
	Endif
	Select B_VALES
	Skip
	Do While !Eof() And mregi = PAC_codhci And mcmed = VAL_prestador And mserv = val_codservvale
		Skip
	Enddo

Enddo
Do sp_desconexion

