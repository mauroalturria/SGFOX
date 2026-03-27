
*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
Do sp_conexion
yu= 0
	use in select('mwkpent')
	use in select('mwkpesp')
	use in select('mwkpmed')
	use in select('mwkppres')
	use in select("mwkespecag")
	use in select("mwkpser")
	use in select("mwkentexc")
	
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ent_turnoshabilit, ent_fecpas " + ;
	" from entidades ", "mwkpent")

mret = sqlexec(mcon1,"SELECT id, nombre FROM prestadores " + ;
	" ", "mwkpMed" )

mret=sqlexec(mcon1,"SELECT PRE_codprest, PRE_descriprest, PRE_especialidad "+;
	" FROM prestacions  " + ;
	"","Mwkppres")

mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
			" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret=sqlexec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
	" " ,"MWKpesp")

mret = sqlexec(mcon1,"select ser_codserv, ser_descripserv from servicios ","mwkpser")

mfecpas = ctod('01/01/1900')
mret = sqlexec(mcon1, "select codent, tipoturno,fecpasiva from entidexclu " + ;
	"where id <100000 and fecpasiva = ?mfecpas and tipoturno = 7 and tpopac = 'AMB' " , "mwkentexc")

mcarch = "TurnoAnual.txt"
mnarch = fcreate(mcarch)
mccad = "H.Clinica" + chr(9) + "Fechahora" +  chr(9) + "Medico"+ chr(9) +  "Entidad" + chr(9) +   ;
	"Prestacion"+ chr(9) +  "Especialidad"+ chr(9) +  "tipo"+ chr(9) + ;
	"Fechatomado" + chr(9) +"tipotomado" + chr(9) + "Observacion" 
Fputs(mnarch, mccad)

Select hclin1
mfecan = ctod("01/01/2012")
Go top
Scan
	mhcli = hclin
	mret = sqlexec(mcon1, 'select turnos.id, turnos.codent, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, turnos.confirmado, turnos.fechatomado,turnos.tipotomado, ' + ;
		'turnos.codmed, turnos.observa,' + ;
		'turnos.tipoturno ,REG_nrohclinica  ' + ;
		'from turnos , registracio ' + ;
		'where  ' + ;
		'turnos.afiliado = registracio.REG_nroregistrac and ' + ;
		'REG_nrohclinica = ?mhcli ' +;
		'group by turnos.fechatur, turnos.codmed, turnos.codreserva, turnos.horatur ' + ;
		'', 'mwkphorario3')

	mret = sqlexec(mcon1, 'select turnos.id, turnos.codent, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
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
	mret = sqlexec(mcon1, "select turnos.id, turnos.codent, turnos.fechatur, turnos.horatur, turnos.codesp, " + ;
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
		select id,codent,  fechatur, horatur, codesp, diasem, codprest ;
		, confirmado,fechatomado,tipotomado, codmed,left(observa,100) as  observa,tipoturno,REG_nrohclinica  ;
		from mwkphorario5 ;
		into cursor mwkphorario

	Select mwkphorario.*,mwkpmed.nombre,pre_descriprest,ESP_descripcion;
		from mwkphorario ;
		left join mwkpesp on codesp = esp_codesp ;
		left join mwkpMed on codmed = mwkpMed.id ;
		left join mwkppres on codprest = pre_codprest ;
		order by fechatur, codmed, horatur	;
		into cursor mwkphorarios
	Select mwkphorarios
	Scan
		yu = yu +1
		mccad = REG_nrohclinica+ chr(9) + ttoc(horatur) + chr(9) + nombre+ chr(9) + transf(codent) + chr(9) +    pre_descriprest+ ;
			chr(9) + ESP_descripcion+ chr(9) +  ;
			iif(confirmado=1,"SI",iif(confirmado=0,"NO","AN"))+ chr(9) +ttoc(fechatomado)+ chr(9) + ;
			iif(tipotomado=1,"PERS","TELE")+chr(9) +observa
		Fputs(mnarch, mccad)
	Endscan
	Select hclin1
	wait windows mhcli +"_"+transf(yu)+" - " +transform(recno()) nowait

Endscan
fclose(mnarch)

Do sp_desconexion
