****
** Graba el archivo de protocolo de guardia y vales de guardia
****

parameter mcual, mpriori, mcodent,mfecha,mhora

musua	= allt(mwkusuario.idusuario)
if type('mfecha') = "D"
	mfing	= ctot(dtoc(mfecha) + " " + alltrim(mhora))
else
	mfing	= sp_busco_fecha_serv('DT')
endif
mfate	= ctot('01/01/1900 00:00:00')
mdiag	= ''
mprot_aux = left(allt(mwkusuario.idusuario),5)+padl(int(seconds()),5,'0')
mcest	= mcual
mprot	= iif(mcual = 1, allt(mprot_aux), mprotocolo)
mregi	= mwkbuspacie1.REG_nroregistrac
mcmed	= 1
mcpre	= mwksep_presta.codprest

if mwksep_presta.codserv = 8000	or mwksep_presta.codserv =5800
	mret = sqlexec(mcon1, "select fechahoraing from guardia where protocolo = ?mprot and  nroregistrac= ?mregi"+;
		" and codprest = ?mcpre ","mwkcontrol")
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
	endif

	if reccount("mwkcontrol") = 0
		mret = sqlexec(mcon1, "insert into guardia(protocolo, nroregistrac, codcie9, fechahoraate, " + ;
			"fechahoraing, codent, codprest, codmed, codmedcie9, diagnostico, codestado, usuario, prioridad,puesto) " + ;
			"values(?mprot, ?mregi, 0, ?mfate, ?mfing, ?mcodent, ?mcpre, ?mcmed, ?mcmed, ?mdiag, " + ;
			"?mcest, ?musua, ?mpriori,0)")
		if mret < 0
			=aerr(eros)
			mmsgerr = eros(3)
			mdetalle= mprot + chr(9) + transform(mregi) + chr(9) + transform(mfate);
				+ chr(9) + transform(mfing) + chr(9) +transform(mcodent)+ chr(9) ;
				+transform(mcpre)+ chr(9) +transform(mcest)

			do sp_insert_tabCtrlErr with mdetalle, mmsgerr , mwkusuario.idusuario, "prg_grabo_protocolo_guardia"
*			messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')
		endif
	else
		if mfing - mwkcontrol.fechahoraing > 15
			mret = sqlexec(mcon1, "insert into guardia(protocolo, nroregistrac, codcie9, fechahoraate, " + ;
				"fechahoraing, codent, codprest, codmed, codmedcie9, diagnostico, codestado, usuario, prioridad,puesto) " + ;
				"values(?mprot, ?mregi, 0, ?mfate, ?mfing, ?mcodent, ?mcpre, ?mcmed, ?mcmed, ?mdiag, " + ;
				"?mcest, ?musua, ?mpriori,0)")
			if mret < 0
				=aerr(eros)
				mmsgerr = eros(3)
				mdetalle= mprot + chr(9) + transform(mregi) + chr(9) + transform(mfate);
					+ chr(9) + transform(mfing) + chr(9) +transform(mcodent)+ chr(9) ;
					+transform(mcpre)+ chr(9) +transform(mcest)

				do sp_insert_tabCtrlErr with mdetalle, mmsgerr , mwkusuario.idusuario, "prg_grabo_protocolo_guardia"
*			messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')
			endif
		endif
	endif
endif
if mcual = 1
	mret = sqlexec(mcon1, "select * from guardia where protocolo = ?mprot_aux", "mwkproto")
	go bottom
	mid			= mwkproto.id
	mprotocolo	= strtran(str(mwkproto.id, 7), ' ','0') + '-' + ;
		strtran(substr(str(year(date()),4), 3, 2), ' ','0')

	mret = sqlexec(mcon1, "update guardia set protocolo = ?mprotocolo where id = ?mid ")
endif

mvale = dat_vale(1)
mnemo = dat_vale(2)

mret = sqlexec(mcon1, "select scv_codservicio from servcargval " + ;
	"where scv_mnemonico = ?mnemo", "mwkserv2")

mcser = mwkserv2.scv_codservicio

if mcual = 1
	msecu = 1
else
	mret = sqlexec(mcon1, "select * from guardiavale where protocolo = ?mprotocolo " + ;
		"order by nrosec desc", "mwksec")
	msecu = mwksec.nrosec + 1
endif

mret = sqlexec(mcon1, "insert into guardiavale(codmed, codserv, fechahora, nrosec, nrovale, protocolo,diagnostico ) " + ;
	"values( ?mcmed, ?mcser, ?mfate, ?msecu, ?mvale, ?mprotocolo, ?myip )")

