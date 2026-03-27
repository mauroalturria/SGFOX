*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
Do sp_conexion
yu= 0
Do sp_busco_phordatos
mcarch = "TurnoAnual3.txt"
mnarch = fcreate(mcarch)
mccad = "H.Clinica" + chr(9) + "Fechahora" + chr(9) +  "Medico"+ chr(9) +  ;
	"Prestacion"+ chr(9) +  "Especialidad"+ chr(9) +  "tipo"+ chr(9) + ;
	"Fechatomado" + chr(9) +"tipotomado" + chr(9) + "Observacion" 
Fputs(mnarch, mccad)

Select hcli3
mfecan = ctod("01/04/2010")
Go top
Scan
	mhcli = hclin
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, turnos.confirmado, turnos.fechatomado,turnos.tipotomado, ' + ;
		'turnos.codmed, turnos.observa,' + ;
		'turnos.tipoturno ,REG_nrohclinica  ' + ;
		'from turnos , registracio ' + ;
		'where  ' + ;
		'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
		'REG_nrohclinica = ?mhcli ' +;
		'group by turnos.fechatur, turnos.codmed, turnos.codreserva, turnos.horatur ' + ;
		'', 'mwkphorario3')

	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, turnos.confirmado, turnos.fechatomado,turnos.tomado as tipotomado, ' + ;
		'turnos.codmed, turnos.observa,' + ;
		'turnos.tipoturno ,REG_nrohclinica  ' + ;
		'from turnoshis as turnos , registracio ' + ;
		'where  ' + ;
		"turnos.fechatur >= ?mfecan and " + ;
		'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
		'REG_nrohclinica = ?mhcli ' +;
		'group by turnos.fechatur, turnos.codmed, turnos.codreserva, turnos.horatur ' + ;
		'', 'mwkphorario1')

	If mret < 0
		=aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	Endif

&& busco los cancelados
	mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
		"turnos.diasem, turnos.codprest, cast(3 as integer) as confirmado,turnos.fechatomado,turnos.tipotomado, " + ;
		"turnos.codmed, turnos.observa,turnos.tipoturno ,REG_nrohclinica " + ;
		"from registracio, turnoscancel as turnos  " + ;
		"where  " + ;
		'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
		"turnos.fechatur >= ?mfecan and " + ;
		'REG_nrohclinica = ?mhcli and codcancela<>5 ' +;
		"group by turnos.fechatur, turnos.codmed, turnos.codreserva, turnos.horatur " + ;
		"", "mwkphorario5")

*	"turnos.fechatur >= medpresta.fecvigend and " +
*	'medpresta.fecvigenh <> medpresta.fecvigend and ' +
*	"turnos.codprest = medpresta.codprest and " +

&&  *	"turnos.fechatur <  medpresta.fecvigenh and "


	Select * from mwkphorario3 ;
		union all ;
	Select * from mwkphorario1 ;
		union all ;
		select id, fechatur, horatur, codesp, diasem, codprest ;
		, confirmado,fechatomado,tipotomado, codmed,left(observa,100) as  observa,tipoturno,REG_nrohclinica  ;
		from mwkphorario5 ;
		into cursor mwkphorario

	Select mwkphorario.*,mwkpmed.nombre,pre_descriprest,ESP_descripcion;
		from mwkphorario ;
		left join mwkpesp on codesp = esp_codesp ;
		left join mwkpmed on codmed = mwkpmed.id ;
		left join mwkppres on codprest = pre_codprest ;
		order by fechatur, codmed, horatur	;
		into cursor mwkphorarios
	Select mwkphorarios
	Scan
		yu = yu +1
		mccad = REG_nrohclinica+ chr(9) + ttoc(horatur) + chr(9) + nombre+ chr(9) +  pre_descriprest+ ;
			chr(9) + ESP_descripcion+ chr(9) +  ;
			iif(confirmado=1,"SI",iif(confirmado=0,"NO","AN"))+ chr(9) +ttoc(fechatomado)+ chr(9) + ;
			iif(tipotomado=1,"PERS","TELE")+chr(9) +observa
		Fputs(mnarch, mccad)
	Endscan
	Select hcli3
	wait windows mhcli +"_"+transf(yu)+"- "+transform(recno()) nowait
Endscan
fclose(mnarch)

Do sp_desconexion
