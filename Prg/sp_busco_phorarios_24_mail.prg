*!*
*!*	 Generacion de planilla de Turnos
*!*
*!*	 Nuevo parámetro : mbusfecha Tipo Lógico
*!*                    valor por defecto nullo, si esta definido viene con .T. para buscar por FECHATUR
*!*                    caso contrario busca por HORATUR
*!*

Parameters mfecturno, mhasta
mccpoambf = ''
mccpoamb = ''
mbuscoval  =  " "
mcjoinvales = ""
if mxambito >1
	mccpoamb = "  and Turnos.codambito = ?mxambito "
	mccpoambf = "  and franjahoraria.codambito = ?mxambito "
	mcjoinvales = " inner join pacientes on valesasist.VAL_codadmision = pacientes.pac_codadmision "
	mbuscoval  =  " and pac_codambito=?mxambito " 
endif

	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"turnos.codmed, turnos.diasem, turnos.codprest, AFI_nroafiliado, REG_telefonos, " + ;
		"turnos.codreserva, registracio.REG_nrohclinica, registracio.REG_numdocumento, " + ;
		"registracio.REG_nombrepac, turnos.codent,hhmmtur ,hca_motfalta,hca_fechaInic, " + ;
		"turnos.fechatomado, turnos.codserv, turnos.usuario, turnos.afiliado, REG_fecnacimiento as fechanac,reg_email " + ;
		"from turnos , afiliacion, registracio" + ;
		" left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
		"where " + ;
		"turnos.afiliado = registracio.REG_nroregistrac and " + ;
		"registracio.REG_nroregistrac = afiliacion.registracio and " + ;
		"turnos.codent = afiliacion.AFI_codentidad and " + ;
		" turnos.fechatur between ?mfecturno and ?mhasta " + mccpoamb+;
		" order by turnos.fechatur,AFI_nroafiliado, turnos.codreserva ,turnos.hhmmtur desc ", "mwkphorario1")

	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_busco_phorarios_24_4'
		Cancel
	Endif

	Select * from  mwkphorario1 group by fechatur, codmed,AFI_nroafiliado, codreserva into cursor mwkphorario1
	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"preregistra.telefono as REG_telefonos, turnos.diasem, turnos.codprest, preregistra.afiliado as AFI_nroafiliado, " + ;
		"turnos.codreserva, ('0000000000') as REG_nrohclinica, nrodocumento as REG_numdocumento, " + ;
		"(preregistra.nombre) as REG_nombrepac, turnos.codent,hhmmtur , " + ;
		"turnos.fechatomado, turnos.codserv, turnos.usuario, turnos.codmed, turnos.afiliado, fechanac " + ;
		"from turnos , preregistra " + ;
		"where " + ;
		"turnos.afiliado = preregistra.id and " + ;
		" turnos.fechatur between ?mfecturno and ?mhasta " + mccpoamb+;
		" order by turnos.fechatur,AFI_nroafiliado, turnos.codreserva ,turnos.hhmmtur desc ", "mwkphorario2")

*	" codesp in('LABO', 'PSIC', 'FONI') and "

	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_busco_phorarios_24_5'
		Cancel
	Endif

	Select * from  mwkphorario2 group by fechatur, codmed,AFI_nroafiliado, codreserva into cursor mwkphorario2

	Select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
		reg_telefonos, mwkphorario1.usuario, fechatomado, mwkphorario1.codserv, fechatur,  AFI_nroafiliado, reg_numdocumento, ;
		horatur, mwkphorario1.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, esp_descripcion, ;
		mwkphorario1.codesp, mwkphorario1.codmed, mwkphorario1.diasem, ;
		'*' as codbarra, afiliado, ;
		int((mfecturno-nvl(fechanac,mfecturno))/365) as edad, mwkphorario1.codprest,;
		nvl(hca_motfalta,0) as hca_motfalta,nvl(hca_fechaInic,ctot("01/01/1900")) as hca_fechaInic,reg_email;
		from mwkphorario1 ;
		left join mwkpent on codent = ent_codent ;
		left join mwkpesp on codesp = esp_codesp ;
		left join mwkppres on codprest = pre_codprest ;
		order by fechatur, horatur, AFI_nroafiliado	;
		into cursor mwkphorario3

	Select left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
		ent_descrient, pre_descriprest, codreserva, left(reg_nrohclinica, 10) as reg_nrohclinica, ;
		reg_telefonos, mwkphorario2.usuario, fechatomado, mwkphorario2.codserv, fechatur, AFI_nroafiliado, reg_numdocumento, ;
		horatur, mwkphorario2.id, left(right(alltrim(reg_nrohclinica), 4), 2) as termina, esp_descripcion, ;
		mwkphorario2.codesp, mwkphorario2.codmed, mwkphorario2.diasem, ;
		'*' as codbarra, afiliado , ;
		int((mfecturno-nvl(fechanac,mfecturno))/365) as edad, mwkphorario2.codprest  ;
		,0 as hca_motfalta,ctot("01/01/1900") as hca_fechaInic;
		from mwkphorario2 ;
		left join mwkpent on codent = ent_codent ;
		left join mwkpesp on codesp = esp_codesp ;
		left join mwkppres on codprest = pre_codprest ;
		order by fechatur, horatur;
		into cursor mwkphorario4

	Select * from mwkphorario3 ;
		union ;
		select *,"NO TIENE" AS reg_email from mwkphorario4;
		into cursor mwkphorarioss

*** Busca primer medico para archivo


	Select mwkphorarioss.* ;
		from mwkphorarioss ;
		into cursor mwkphorarios

	If used('mwkphorarioss')
		Use in  mwkphorarioss
	Endif
	If used('mwkphorario3')
		Use in  mwkphorario3
	Endif
	If used('mwkphorario4')
		Use in  mwkphorario4
	Endif
