****
** busco protocolo de guardia
****

Parameter mproto, mcual, mcvales,mfiltro

If Vartype(mcvales)<>"C"
	mcvales = "N"
Endif
If Vartype(mfiltro)<>"C"
	mfiltro = ""
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif

mcual = Iif(Vartype(mcual) # "N", 3, mcual)   && mcual = 3 busca evolucion
mret  = SQLExec(mcon1, "select * from tabambulatorio,tabtipoaltas   "+;
"where codestado = tabtipoaltas.id and protocolo = ?mproto" + mccpoamb , "mwkveoproto")
If Reccount("mwkveoproto")>0
	mregistracio = Round(mwkveoproto.nroregistrac, 0)
	miprot = mwkveoproto.protocolo

	If mcual <= 2

		mbusco1 = "where REG_nroregistrac = ?mregistracio and "
		Do sp_busco_nombre_paciente_1 With mbusco1, 1, ''
		If mcual = 1
			frmambula01.grid1.RecordSource = msql_reg
		Else
			&msql_reg
		Endif

	Else

		mret = SQLExec(mcon1, "SELECT TabAmbEvol.*,TabAmbEvolmed.* " + ;
		"FROM TabAmbEvol, TabAmbEvolmed  " + ;
		"Left join TabAmbulatorio on TabAmbulatorio.Protocolo = TabAmbEvol.EA_protocolo " + ;
		" where EA_protocolo = ?miprot and EA_nroregistrac = ?mregistracio "+;
		" and EA_protocolo = EAM_proto" + mccpoamb , "mwkEvol0")
		If mret < 0
			=Aerr(eros)
			Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
		Endif
		If Reccount( "mwkEvol0")=0
			mret = SQLExec(mcon1, "SELECT TabAmbEvol.*,TabAmbEvolmed.* " + ;
			"FROM TabAmbEvolhis as TabAmbEvol,TabAmbEvolmedhis as  TabAmbEvolmed  " + ;
			"Left join TabAmbulatoriohis  as TabAmbulatorio on TabAmbulatorio.Protocolo = TabAmbEvol.EA_protocolo " + ;
			" where EA_protocolo = ?miprot and EA_nroregistrac = ?mregistracio "+;
			" and EA_protocolo = EAM_proto" + mccpoamb , "mwkEvol0")

		Endif
	Endif

*!* 06/04/2011

	If mcvales = "S"

		mret = SQLExec(mcon1, "select nrovale, ser_descripserv,val_operadorcarga,"+;
		"idusuario,val_fechasolicitud,val_horasolicitud,val_medicosolicit,"+;
		"nombre,HIS_codentidad,pre_descriprest "+;
		" from tabambulatorio"+;
		" join valesasist on VAL_codvaleasist = tabambulatorio.nrovale"+;
		" join prestacions on (PRE_codprest = tabambulatorio.codprest &mfiltro )"+;
		" join histambgua on HIS_codadmision = VAL_codadmision and HIS_nroregistrac = ?mregistracio"+;
		" join servicios  on ser_codserv = PRE_codservicio"+;
		" left join prestadores on valesasist.val_medicosolicit = prestadores.id"+;
		" left join tabusuario on tabusuario.codigovax = valesasist.val_operadorcarga"+;
		" where protocolo = ?mproto " + mccpoamb + ;
		" order by nrovale","mwkvales")

		If mret < 0
			=Aerr(eros)
			Messagebox(eros(3))
			Do sp_desconexion With "Err sp_busco_protocolo_ambula"
			Cancel
		Endif

	Endif
Else &&& vamos a lhistorico
	mret  = SQLExec(mcon1, "select * from tabambulatoriohis as tabambulatorio,tabtipoaltas   "+;
	"where codestado = tabtipoaltas.id and protocolo = ?mproto" + mccpoamb , "mwkveoproto")
	mregistracio = Round(mwkveoproto.nroregistrac, 0)
	miprot = mwkveoproto.protocolo

	If mcual <= 2

		mbusco1 = "where REG_nroregistrac = ?mregistracio and "
		Do sp_busco_nombre_paciente_1 With mbusco1, 1, ''
		If mcual = 1
			frmambula01.grid1.RecordSource = msql_reg
		Else
			&msql_reg
		Endif

	Else


		mret = SQLExec(mcon1, "SELECT TabAmbEvol.*,TabAmbEvolmed.* " + ;
		"FROM TabAmbEvolhis as TabAmbEvol,TabAmbEvolmedhis as  TabAmbEvolmed  " + ;
		"Left join TabAmbulatoriohis  as TabAmbulatorio on TabAmbulatorio.Protocolo = TabAmbEvol.EA_protocolo " + ;
		" where EA_protocolo = ?miprot and EA_nroregistrac = ?mregistracio "+;
		" and EA_protocolo = EAM_proto" + mccpoamb , "mwkEvol0")

	Endif

*!* 06/04/2011

	If mcvales = "S"

		mret = SQLExec(mcon1, "select nrovale, ser_descripserv,val_operadorcarga,"+;
		"idusuario,val_fechasolicitud,val_horasolicitud,val_medicosolicit,"+;
		"nombre,HIS_codentidad,pre_descriprest "+;
		" from tabambulatoriohis as tabambulatorio"+;
		" join valesasist on VAL_codvaleasist = tabambulatorio.nrovale"+;
		" join prestacions on (PRE_codprest = tabambulatorio.codprest &mfiltro )"+;
		" join histambgua on HIS_codadmision = VAL_codadmision and HIS_nroregistrac = ?mregistracio"+;
		" join servicios  on ser_codserv = PRE_codservicio"+;
		" left join prestadores on valesasist.val_medicosolicit = prestadores.id"+;
		" left join tabusuario on tabusuario.codigovax = valesasist.val_operadorcarga"+;
		" where protocolo = ?mproto " + mccpoamb + ;
		" order by nrovale","mwkvales")

		If mret < 0
			=Aerr(eros)
			Messagebox(eros(3))
			Do sp_desconexion With "Err sp_busco_protocolo_ambula"
			Cancel
		Endif

	Endif
Endif
