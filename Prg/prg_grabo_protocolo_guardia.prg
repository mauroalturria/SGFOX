****
** Graba el archivo de protocolo de guardia y vales de guardia
****

Parameter mcual, mpriori, mcodent,mfecha,mhora,mcodcie9,mcmed,mcodmedcie9,lpreadm

musua	= Allt(mwkusuario.idusuario)
If Type('mfecha') = "D"
	mfing	= Ctot(Dtoc(mfecha) + " " + Alltrim(mhora))
Else
	mfing	= sp_busco_fecha_serv('DT')
Endif
If Vartype(mcodcie9)#"N"
	mcodcie9 = 0
Endif
If Vartype(mcmed)#"N"
	mcmed	= 1
Endif
If Vartype(mcodmedcie9)#"N"
	mcodmedcie9 = 1
Endif
If Vartype(lpreadm)#"N"
	lpreadm	= 0
Endif

mfate	= Ctot('01/01/1900 00:00:00')
mdiag	= ''
mprot_aux = Left(Allt(mwkusuario.idusuario),5)+Padl(Int(Seconds()),5,'0')
mcest	= mcual
mprot	= Iif(mcual = 1, Allt(mprot_aux), mprotocolo)
mregi	= mwkbuspacie1.REG_nroregistrac
mcpre	= mwksep_presta.codprest

If mwksep_presta.codserv = 8000	Or mwksep_presta.codserv =5800
	mret = SQLExec(mcon1, "select fechahoraing from guardia where protocolo = ?mprot and  nroregistrac= ?mregi"+;
		" and codprest = ?mcpre ","mwkcontrol")
	If mret < 0
		=Aerr(eros)
		Messagebox(eros(3))
	Endif

	If Reccount("mwkcontrol") = 0
		mret = SQLExec(mcon1, "insert into guardia(protocolo, nroregistrac, codcie9, fechahoraate, " + ;
			"fechahoraing, codent, codprest, codmed, codmedcie9, diagnostico, codestado, usuario, prioridad,puesto) " + ;
			"values(?mprot, ?mregi, ?mcodcie9, ?mfate, ?mfing, ?mcodent, ?mcpre, ?mcmed, ?mcodmedcie9, ?mdiag, " + ;
			"?mcest, ?musua, ?mpriori,0)")
		If mret < 0
			=Aerr(eros)
			mmsgerr = eros(3)
			mdetalle= mprot + Chr(9) + Transform(mregi) + Chr(9) + Transform(mfate);
				+ Chr(9) + Transform(mfing) + Chr(9) +Transform(mcodent)+ Chr(9) ;
				+Transform(mcpre)+ Chr(9) +Transform(mcest)

			Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "prg_grabo_protocolo_guardia"
*			messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')
		Endif
	Else
		If mfing - mwkcontrol.fechahoraing > 15
			mret = SQLExec(mcon1, "insert into guardia(protocolo, nroregistrac, codcie9, fechahoraate, " + ;
				"fechahoraing, codent, codprest, codmed, codmedcie9, diagnostico, codestado, usuario, prioridad,puesto) " + ;
				"values(?mprot, ?mregi, ?mcodcie9, ?mfate, ?mfing, ?mcodent, ?mcpre, ?mcmed, ?mcodmedcie9, ?mdiag, " + ;
				"?mcest, ?musua, ?mpriori,0)")
			If mret < 0
				=Aerr(eros)
				mmsgerr = eros(3)
				mdetalle= mprot + Chr(9) + Transform(mregi) + Chr(9) + Transform(mfate);
					+ Chr(9) + Transform(mfing) + Chr(9) +Transform(mcodent)+ Chr(9) ;
					+Transform(mcpre)+ Chr(9) +Transform(mcest)

				Do sp_insert_tabCtrlErr With mdetalle, mmsgerr , mwkusuario.idusuario, "prg_grabo_protocolo_guardia"
*			messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')
			Endif
		Endif
	Endif
Endif
If mcual = 1
	mret = SQLExec(mcon1, "select * from guardia where protocolo = ?mprot_aux", "mwkproto")
	Go Bottom
	mid			= mwkproto.Id
	mprotocolo	= Strtran(Str(mwkproto.Id, 7), ' ','0') + '-' + ;
		strtran(Substr(Str(Year(Date()),4), 3, 2), ' ','0')
	mpreadm = ''
	If lpreadm = 1
		mpreadm  = ",UserDbAdd = 'PREADM' "
	Endif
	mret = SQLExec(mcon1, "update guardia set protocolo = ?mprotocolo "+mpreadm +" where id = ?mid ")
	mprot_aux = mprotocolo
Else

Endif

mvale = dat_vale(1)
mnemo = dat_vale(2)

mret = SQLExec(mcon1, "select scv_codservicio from servcargval " + ;
	"where scv_mnemonico = ?mnemo", "mwkserv2")

mcser = mwkserv2.scv_codservicio

If mcual = 1
	msecu = 1
Else
	mret = SQLExec(mcon1, "select * from guardiavale where protocolo = ?mprotocolo " + ;
		"order by nrosec desc", "mwksec")
	msecu = mwksec.nrosec + 1
Endif
mipc =  Sys(0)
mipc = Left(Left(mipc,At("#",mipc)-1)+myip,50)
mret = SQLExec(mcon1, "insert into guardiavale(codmed, codserv, fechahora, nrosec, nrovale, protocolo,diagnostico ) " + ;
	"values( ?mcmed, ?mcser, ?mfate, ?msecu, ?mvale, ?mprotocolo, ?mipc )")
mret = SQLExec(mcon1, "select * from guardia where protocolo = ?mprot_aux", "mwknewproto")
Go Bottom
