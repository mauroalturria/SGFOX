*
* Graba protocolo de la atencion
*
Parameters  mregi, mfate, mfing, mcodent, mcpre, mcmed, mcodpun,;
	mcest, musua, mcua, mprotocolo, mdemanda
*!*	do sp_grabo_ambulatorio with mregi, mfate, mfing, mcodent, ;
*!*					mcPre, mcmed, mnrovale, mcest, musua, mcua, mproto, 0

*set step on

mfHoy     = sp_busco_fecha_serv('DD')
mprot_aux = left(allt(mwkusuario.idusuario),5)+padl(int(seconds()),5,'0')
mprot 	  = mprot_aux
mfctrl    = mfing - 120

mccpoamb = ''
mcampo = ""
minser = ""
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
	mcampo = ", codambito "
	minser = ",?mxambito "  
Endif 


Use in select("mwkctrl2")
mret = sqlexec(mcon1,"select * from tabambulatorio"+;
	" where nroregistrac = ?mregi"+;
	" and codmed = ?mcmed"+;
	" and codprest = ?mcpre"+;
	" and fechaate = ?mfHoy " + mccpoamb ,"mwkctrl2")

If reccount("mwkctrl2")>0
	messagebox("LA H.C.E. SE ENCONTRABA DESBLOQUEADA...",48,"Validación")
Else
	mret = sqlexec(mcon1, "insert into TabAmbulatorio (" + ;
		"protocolo, nroregistrac,demanda, fechahoraate, fechahoraing, " + ;
		"codent, codprest, codmed, nrovale, codestado, usuario, fechaate " + mcampo + " ) " + ;
		"values(" + ;
		"?mprot ,?mregi,?mdemanda, ?mfate, ?mfing, " + ;
		"?mcodent, ?mcpre, ?mcmed, ?mcodpun, ?mcest, ?musua, ?mfHoy " + minser + ")")
Endif
mret = sqlexec(mcon1, "Select * from TabAmbulatorio Where Protocolo = ?mprot_aux " + mccpoamb , "mwkAuxAmb" )
If mret < 0
	=aerror(merror)
	Messagebox("ERROR EN LA LECTURA"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return
else
	Select mwkAuxAmb
	Go bottom
	mProto = padl(alltrim(str(id)),8,"0") + "-" + right(dtoc(mfHoy),2)
	mid    = id
	mret   = sqlexec(mcon1, "Update TabAmbulatorio Set Protocolo = ?mProto Where id = ?mid " )
	If mret < 0
		=aerror(merror)
		Messagebox("ACTUALIZACION DEL PROTOCOLO"+chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return
	Endif
Endif
mret = sqlexec(mcon1, "Select Protocolo from TabAmbulatorio Where id = ?mId ", "mwkAuxAmb" )
If mret < 0
	=aerror(merror)
	Messagebox("EN BUSQUEDA DE PROTOCOLO"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return
Endif
