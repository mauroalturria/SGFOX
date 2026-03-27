*!*
*!*	 Generacion de Turnos
*!*
*!*	 Nuevo parámetro : mbusfecha Tipo Lógico
*!*                    valor por defecto nullo, si esta definido viene con .T. para buscar por FECHATUR
*!*                    caso contrario busca por HORATUR
*!*

Parameters mfecturno,mbuscoesp

lsigo = !Inlist(Dow(mfecturno), 1)
mccpoambf = ''
mccpoamb = ''
mccpoambu = ''
If Vartype(mbuscoesp)#"C"
	mbuscoesp= ''
Endif
mret=SQLExec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfecturno ",'MWKFeriados')
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_phorarios_24_1'
	Cancel
Endif
If Reccount('MWKFeriados')>0
	lsigo = .F.
Endif
If Used('MWKFeriados')
	Use In 	mwkferiados
Endif
If lsigo
mccentro = Iif(mxambito = 1,Iif(mxcentromedico =1," and (sala not like '%LIMA%' AND sala not like '%CP%' ) ",;
		Iif(mxcentromedico =2, " and sala like '%LIMA%' "," AND sala like '%CP%' "  )),' ')

	Do sp_busco_medprestam With mfecturno,mccentro
	Do sp_muestra_ubicacion
	Select * From MwkUbica Into Cursor mwkconsultorio
	mcbusca2 = " turnos.fechatur = ?mfecturno  "+mbuscoesp
	If mxambito >1
		mccpoambu = " where codambito = ?mxambito "
		mccpoamb = "  and codambito = ?mxambito "
		mccpoambf = "  and franjahoraria.codambito = ?mxambito "
	Endif

	mret=SQLExec(mcon1,"SELECT * FROM TabHCUbica "  ,'MWKubica')
	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_phorarios_24_2'
		Cancel
	Endif

	mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"turnos.codmed, turnos.diasem, turnos.codprest, AFI_nroafiliado, REG_telefonos, " + ;
		"turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, " + ;
		"registracio.REG_nombrepac, turnos.codent,hhmmtur ,hca_motfalta,hca_fechaInic, " + ;
		"turnos.fechatomado, turnos.codserv, turnos.usuario, turnos.afiliado, REG_fecnacimiento as fechanac " + ;
		"from turnos , afiliacion, registracio" + ;
		" left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
		"where " + ;
		"turnos.afiliado = registracio.REG_nroregistrac and " + ;
		"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
		"turnos.codent = afiliacion.AFI_codentidad and " + ;
		mcbusca2 + mccpoamb+" order by turnos.fechatur,AFI_nroafiliado, turnos.codreserva ,"+;
		"turnos.hhmmtur desc ", "mwkphorario1")

	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_phorarios_24_4'
		Cancel
	Endif

	Select * From  mwkphorario1 Group By fechatur, codmed,AFI_nroafiliado, codreserva Into Cursor mwkphorario1
	mret = SQLExec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"preregistra.telefono as REG_telefonos, turnos.diasem, turnos.codprest, preregistra.afiliado as AFI_nroafiliado, " + ;
		"turnos.codreserva, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento, " + ;
		"(preregistra.nombre) as REG_nombrepac, turnos.codent,hhmmtur , " + ;
		"turnos.fechatomado, turnos.codserv, turnos.usuario, turnos.codmed, turnos.afiliado, fechanac " + ;
		"from turnos , preregistra " + ;
		"where " + ;
		"turnos.afiliado = preregistra.id and " + ;
		mcbusca2  + mccpoamb+" order by turnos.fechatur,AFI_nroafiliado, turnos.codreserva ,"+;
		"turnos.hhmmtur desc ", "mwkphorario2")


	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_phorarios_24_5'
		Cancel
	Endif

	Select * From  mwkphorario2 Group By fechatur, codmed,AFI_nroafiliado, codreserva Into Cursor mwkphorario2

	Select Left(Ttoc(horatur,2), 5) As hora, Left(reg_nombrepac, 40) As reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, Left(reg_nrohclinica, 10) As reg_nrohclinica, ;
		reg_telefonos, mwkphorario1.usuario, fechatomado, mwkphorario1.codserv, fechatur, nombre, AFI_nroafiliado, reg_numdocumento, ;
		horatur, mwkphorario1.Id, Left(Right(Alltrim(reg_nrohclinica), 4), 2) As Termina, esp_descripcion, ;
		ttoc(hdesde1,2) As hdesde1, hhasta1, mwkphorario1.codesp, mwkphorario1.codmed, mwkphorario1.diasem, sala, ;
		'*' + Str(mwkphorario1.diasem,1) + Strtran(Str(mwkphorario1.codmed,4), ' ', '0') + ;
		strtran(Substr(Dtoc(fechatur),1, 5),'/','') +  Left(Ttoc(hdesde1,2), 2) + '*' As codbarra, afiliado, ;
		int((mfecturno-Nvl(fechanac,mfecturno))/365) As edad, Left(sala,1) As piso, mwkphorario1.codprest,;
		nvl(hca_motfalta,0) As hca_motfalta,Nvl(hca_fechaInic,Ctot("01/01/1900")) As hca_fechaInic;
		from mwkphorario1 ;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkppres On codprest = pre_codprest ;
		inner Join mwkmpfecha On (mwkphorario1.codmed = mwkmpfecha.codmed And ;
		mwkphorario1.codprest = mwkmpfecha.codprest And ;
		mwkphorario1.fechatur >= mwkmpfecha.fecvigend And ;
		mwkphorario1.fechatur < mwkmpfecha.fecvigenh And ;
		mwkphorario1.hhmmtur >= mwkmpfecha.hhmmdes And ;
		mwkphorario1.hhmmtur < mwkmpfecha.hhmmhas And ;
		mwkphorario1.diasem = mwkmpfecha.diasem );
		where generaagen = 1 ;
		order By fechatur, horatur, AFI_nroafiliado	;
		into Cursor mwkphorario3

	Select Left(Ttoc(horatur,2), 5) As hora, Left(reg_nombrepac, 40) As reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, Left(reg_nrohclinica, 10) As reg_nrohclinica, ;
		reg_telefonos, mwkphorario2.usuario, fechatomado, mwkphorario2.codserv, fechatur, nombre, AFI_nroafiliado, reg_numdocumento, ;
		horatur, mwkphorario2.Id, Left(Right(Alltrim(reg_nrohclinica), 4), 2) As Termina, esp_descripcion, ;
		ttoc(hdesde1,2) As hdesde1, hhasta1, mwkphorario2.codesp, mwkphorario2.codmed, mwkphorario2.diasem, sala, ;
		'*' + Str(mwkphorario2.diasem,1) + Strtran(Str(mwkphorario2.codmed,4), ' ', '0') + ;
		strtran(Substr(Dtoc(fechatur),1, 5),'/','') +  Left(Ttoc(hdesde1,2), 2) + '*' As codbarra, afiliado , ;
		int((mfecturno-Nvl(fechanac,mfecturno))/365) As edad, Left(sala,1) As piso, mwkphorario2.codprest  ;
		,0 As hca_motfalta,Ctot("01/01/1900") As hca_fechaInic;
		from mwkphorario2 ;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkppres On codprest = pre_codprest ;
		inner Join mwkmpfecha On (mwkphorario2.codmed = mwkmpfecha.codmed And ;
		mwkphorario2.codprest = mwkmpfecha.codprest And ;
		mwkphorario2.fechatur >= mwkmpfecha.fecvigend And ;
		mwkphorario2.fechatur < mwkmpfecha.fecvigenh And ;
		mwkphorario2.hhmmtur >= mwkmpfecha.hhmmdes And ;
		mwkphorario2.hhmmtur < mwkmpfecha.hhmmhas And ;
		mwkphorario2.diasem = mwkmpfecha.diasem );
		where generaagen = 1 ;
		order By fechatur, horatur;
		into Cursor mwkphorario4

	Select * From mwkphorario3 ;
		union ;
		select * From mwkphorario4;
		into Cursor mwkphorarioss


*	messagebox ("tardo" + transf(seconds()- nsegu ))

	Select mwkphorarioss.*,	abrevio,mwkconsultorio.interno;
		from mwkphorarioss ;
		left Join MWKubica On codubi = hca_motfalta ;
		left Outer Join mwkconsultorio On mwkconsultorio.lugar = mwkphorarioss.sala;
		order By reg_nombrepac,reg_numdocumento ;
		into Cursor mwkphorarios

	If Used('mwkphorarioss')
		Use In  mwkphorarioss
	Endif
	If Used('mwkphorario3')
		Use In  mwkphorario3
	Endif
	If Used('mwkphorario4')
		Use In  mwkphorario4
	Endif
Endif
