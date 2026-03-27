****
** Generacion de estadistica de turnos dados por operador
****
Parameter mfecha1, mfecha2, mopcion, mbusq,lsab,lfecha,lctrlevol
If Vartype(lctrlevol)<>"N"
	lctrlevol = 0
Endif
lsigue = .T.
mtipofec = 'fechatomado'
mfecpas = Ctod("01/01/1900")

If mxambito >1 And mopcion<9
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ' '
Endif

If mxambito >1
	mcamb = "  ,turnos.codambito "
	mcamb2 = "  ,codambito "
Else
	mcamb = ' '
	mcamb2 = ' '
Endif
mccpocmed = " centromed = ?mxcentromedico and "
If Vartype(lfecha)="N"
	mtipofec = Iif(lfecha = 1,'fechatomado',"horatur")
	mbusq = mbusq + Iif(lfecha = 1,' ',' and turnos.fechatur <= ?mfecha2 ')
Endif

mselsab = ' '
If Vartype(lsab)="N"
	mselsab = Iif(lsab = 1,' '," and dow(fechatomado) < 7 ")
Endif
*!*------------------------------------------------------------------------------------------------------------------------------
mret=SQLExec(mcon1,"SELECT  centromed,codmed,diasem, hhmmdes, hhmmhas,fecvigend, fecvigenh  "+;
	" from  franjahoraria  "+;
	" where &mccpoamb &mccpocmed  fecvigenh >= ?mfecha1 "+;
	" and  fecvigend <> fecvigenh "  ,"mwkfranjahT")
*!*------------------------------------------------------------------------------------------------------------------------------
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoamb id < 100000  order by fechacierre ','mwkctrlfecha')

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif
*!*------------------------------------------------------------------------------------------------------------------------------
mret = SQLExec(mcon1,"select TRAM_registracio from TabRegAdvMed " + ;
	" Where TRAM_registracio > 1 and TRAM_fechapasiva = ?mfecpas and TRAM_tipo = 0" ,"mwkAdvmedgral")

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif
*!*------------------------------------------------------------------------------------------------------------------------------
mret = SQLExec(mcon1,"select * from tabambito ","mwkdescamb")
If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif
*!*------------------------------------------------------------------------------------------------------------------------------
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha
cf1 = prg_dtoc(mfecha1)
cf2 = prg_dtoc(mfecha2 + 1)

fd1 = Dtot(mfecha1)
fd2 = Dtot(mfecha2 + 1)

Do sp_busco_phordatos

If !Used('mwkMedicosall')
	Do sp_medicos_all
Endif

mjoin = ' '
mcpojoin = ' '
If Inlist(mopcion , 3, 9)
	mjoin = ' left join registracio on afiliado = reg_nroregistrac   '
	mcpojoin = ',reg_nombrepac,REG_nrohclinica,reg_email,reg_domicilio,reg_telefonos, REG_numdocumento, REG_fecnacimiento '
Endif
*!*------------------------------------------------------------------------------------------------------------------------------
mret = SQLExec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa, upper(turnos.usuario) as usuario,nomape,'    +;
	'tabsectores.descrip as sector, datepart(dd,&mtipofec) as dia,usuariosector,' +;
	'datepart(hh,&mtipofec) as hora, turnos.id, turnos.tipotomado ' +;
	',turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli,1 as activo, '+;
	'turnos.codserv, turnos.nrovale,turnos.confirmado,turnos.codent, turnos.codmed'+;
	', turnos.tipoturno, tabtipoturno.abreviatura,NVL(turnos.tomado,0) as tomado '+;
	' ,turnos.fechatur, turnos.hhmmtur' +mcamb  + mcpojoin + ;
	'from turnos '+;
	'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
	'left join tabsectores on tabsectores.ID = usuariosector  '+mjoin+;
	'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
	" where &mccpoamb turnos.codreserva<>'' and  turnos.fechatur  >= ?mfecha1  "  + mbusq , 'mwktomadosa')

&&	'left join tabsectores on tabsectorusuario.codsector = tabsectores.id ' + mjoin +

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif
*!*------------------------------------------------------------------------------------------------------------------------------
mret = SQLExec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa, upper(turnos.usuario) as usuario, '+;
	'nomape,tabsectores.descrip as sector, datepart(dd,&mtipofec) as dia,usuariosector, datepart(hh,&mtipofec) as hora, ' + ;
	'turnos.id, tipotomado ,turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli,2 as activo, turnos.codserv, turnos.nrovale,turnos.confirmado,'+;
	'turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura,NVL(turnos.tomado,0) as tomado '+;
	' ,turnos.fechatur, turnos.hhmmtur' +mcamb +mcpojoin+;
	'from turnoscancel as turnos '+;
	'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
	'left join tabsectores on tabsectores.id = usuariosector  '+mjoin+;
	'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
	" where &mccpoamb  turnos.codreserva<>'' and turnos.fechatur >= ?mfecha1 and codcancela<>27 " + mbusq , 'mwktomadosc')

If mret < 0
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Cancel
Endif
*!*------------------------------------------------------------------------------------------------------------------------------
If mfecha1 <= mfechalimite
	mret = SQLExec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa, upper(turnos.usuario) as usuario,'+;
		'nomape,tabsectores.descrip as sector, ' +;
		'datepart(dd,&mtipofec) as dia,usuariosector, datepart(hh,&mtipofec) as hora,'+;
		'turnos.id, cast(0 as integer) as tipotomado  ' +;
		',turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli,1 as activo, turnos.codserv, turnos.nrovale,turnos.confirmado,'+;
		'turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura, NVL(turnos.tomado,0) as tomado '+;
		' ,turnos.fechatur, turnos.hhmmtur' +mcamb +mcpojoin+;
		'from turnoshis as turnos '+;
		'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
		'left join tabsectores on tabsectores.id = usuariosector  '+mjoin+;
		'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
		"where &mccpoamb turnos.codreserva<>'' and  turnos.fechatur >= ?mfecha1 " + mbusq , 'mwktomadosb')

	If mret < 0
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()

		Select afiliado,fechatomado,horatur,Padr(observa,250) As observa,usuario,nomape,sector;
			,dia,usuariosector,hora,Id,tipotomado,codreserva,codesp,diasem,codprest,;
			codmedsoli,activo,codserv, nrovale,confirmado,codent,codmed,tipoturno,abreviatura,Tomado;
			,fechatur,hhmmtur &mcamb2 ;
			&mcpojoin,Ttod(&mtipofec) As fechat From mwktomadosa ;
			where tipoturno#9 And afiliado > 1  And &mtipofec >= fd1 And &mtipofec < fd2 &mselsab;
			union All ;
			select afiliado,fechatomado,horatur,Left(observa,255) As observa,usuario,nomape,sector;
			,dia,hora,Id,tipotomado,codreserva,codesp,diasem,codprest,;
			codmedsoli,activo,codserv, nrovale,confirmado,codent,codmed,tipoturno,abreviatura,Tomado;
			,fechatur,hhmmtur &mcamb2 ;
			&mcpojoin,Ttod(&mtipofec) As fechat From mwktomadosc ;
			where tipoturno#9 And afiliado > 1  And &mtipofec >= fd1 And &mtipofec < fd2 &mselsab;
			into Cursor mwktomados0

	Else
		Select afiliado,fechatomado,horatur,Padr(observa,250) As observa,usuario,nomape,sector;
			,dia,hora,Id,tipotomado,codreserva,codesp,diasem,codprest,;
			codmedsoli,activo,codserv, nrovale,confirmado,codent,codmed,tipoturno,abreviatura,Tomado;
			,fechatur,hhmmtur &mcamb2 ;
			&mcpojoin,Ttod(&mtipofec) As fechat From mwktomadosa ;
			where tipoturno#9 And afiliado > 1  And &mtipofec>= fd1 And &mtipofec < fd2 &mselsab;
			union All ;
			select afiliado,fechatomado,horatur,Padr(observa,250) As observa,usuario,nomape,sector;
			,dia,hora,Id,tipotomado,codreserva,codesp,diasem,codprest,;
			codmedsoli,activo,codserv, nrovale,confirmado,codent,codmed,tipoturno,abreviatura,Tomado;
			,fechatur,hhmmtur &mcamb2;
			&mcpojoin,Ttod(&mtipofec) As fechat From mwktomadosb ;
			where tipoturno#9 And afiliado > 1  And fechatomado>= fd1 And fechatomado < fd2 &mselsab;
			union All ;
			select afiliado,fechatomado,horatur,Left(observa,255) As observa,usuario,nomape,sector;
			,dia,hora,Id,tipotomado,codreserva,codesp,diasem,codprest,;
			codmedsoli,activo,codserv, nrovale,confirmado,codent,codmed,tipoturno,abreviatura,Tomado;
			,fechatur,hhmmtur &mcamb2;
			&mcpojoin,Ttod(&mtipofec) As fechat From mwktomadosc ;
			where tipoturno#9 And afiliado > 1  And fechatomado>= fd1 And &mtipofec < fd2 &mselsab;
			into Cursor mwktomados0
	Endif

Else
	Select afiliado,fechatomado,horatur,Padr(observa,250) As observa,usuario,nomape,sector;
		,dia,hora,Id,tipotomado,codreserva,codesp,diasem,codprest,;
		codmedsoli,activo,codserv, nrovale,confirmado,codent,codmed,tipoturno,abreviatura,Tomado ;
		,fechatur,hhmmtur &mcamb2;
		&mcpojoin,Ttod(&mtipofec) As fechat From mwktomadosa ;
		where tipoturno#9 And afiliado > 1  And &mtipofec >= fd1 And &mtipofec < fd2 &mselsab;
		union All ;
		select afiliado,fechatomado,horatur,Left(observa,255) As observa,usuario,nomape,sector;
		,dia,hora,Id,tipotomado,codreserva,codesp,diasem,codprest,;
		codmedsoli,activo,codserv, nrovale,confirmado,codent,codmed,tipoturno,abreviatura,Tomado;
		,fechatur,hhmmtur &mcamb2;
		&mcpojoin,Ttod(&mtipofec) As fechat From mwktomadosc ;
		where tipoturno#9 And afiliado > 1 And &mtipofec >= fd1 And &mtipofec < fd2 &mselsab;
		into Cursor mwktomados0
Endif

Select *,Ttod(fechatomado) As diatomado From mwktomados0 ;
	where tipoturno#9 And afiliado > 1 And &mtipofec >= fd1 And &mtipofec < fd2 &mselsab;
	order By  &mtipofec, usuario, tipotomado,Id ;
	group By  &mtipofec, usuario, tipotomado,Id ;
	into Cursor mwktomados

*!*	        select &mtipofec, usuario, tipotomado,id from mwktomados0 ;
*!*				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
*!*				order by &mtipofec, usuario, tipotomado,id ;
*!*				group by &mtipofec, usuario, tipotomado,id ;
*!*				into cursor mwktomados

Do Case
Case mopcion = 1	&& cerrado por dia

	Select sector, fechat, dia, usuario , nomape,;
		sum(Iif(tipotomado = 1, 1, 0))  As tipo1, ;
		sum(Iif(tipotomado = 2, 1, 0))  As tipo2, ;
		sum(Iif(tipotomado = 3, 1, 0))  As tipo3, ;
		sum(Iif(tipotomado = 4, 1, 0))  As tipo4, ;
		sum(Iif(tipotomado = 5, 1, 0))  As tipo5, ;
		sum(Iif(tipotomado > 5, 1, 0)) As tipootros,diatomado  ;
		from mwktomados ;
		group By sector, fechat, usuario ;
		order By sector, fechat, usuario ;
		into Cursor mwktomados1
&&  		sum(iif(hora < 14, 1, 0))  as hasta14,
&&  		sum(iif(hora >= 14, 1, 0)) as hasta21

Case mopcion = 2	&& abierto por hora

	Select sector, fechat, dia, usuario,nomape, hora, ;
		sum(Iif(tipotomado = 1, 1, 0))  As total1, ;
		sum(Iif(tipotomado = 2, 1, 0))  As total2, ;
		sum(Iif(tipotomado = 3, 1, 0))  As total3, ;
		sum(Iif(tipotomado = 4, 1, 0))  As tipo4, ;
		sum(Iif(tipotomado = 5, 1, 0))  As tipo5, ;
		sum(Iif(tipotomado > 5, 1, 0)) As tipootros,diatomado  ;
		from mwktomados ;
		group By sector, fechat, hora, usuario ;
		order By sector, fechat, hora, usuario ;
		into Cursor mwktomados1
&&		sum(1) as total
Case mopcion = 3	&& abierto tabla dinamica
	Select mwktomados.*,mwkfranjahT.centromed;
		From mwkfranjahT,mwktomados Where mwkfranjahT.codmed = mwktomados.codmed ;
		AND mwkfranjahT.diasem = mwktomados.diasem And mwkfranjahT.hhmmdes <= mwktomados.hhmmtur ;
		AND mwkfranjahT.hhmmhas>= mwktomados.hhmmtur And mwkfranjahT.fecvigend <= mwktomados.fechatur ;
		AND mwkfranjahT.fecvigenh>= mwktomados.fechatur Order By  fechaT Into Cursor mwktodos


	Select mwkfranjahT.centromed, mwktomados.*,ent_descrient, pre_descriprest,medpres.nombre, esp_descripcion ;
		,medsol.nombre As nombresol,mwkAdvmedgral.*;
		,Iif(codserv = 2200 And nrovale>4000000 And confirmado = 1,sp_busco_ambu_datos(1,nrovale,afiliado),Space(20)) As evolucion ;
		from mwkfranjahT,mwktomados ;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkMedicosall As medpres On codmed = medpres.Id ;
		left Join mwkMedicosall As medsol On codmedsoli = medsol.Id ;
		left Join mwkppres On codprest = pre_codprest ;
		left Join mwkAdvmedgral On TRAM_registracio = afiliado ;
		Where mwkfranjahT.codmed = mwktomados.codmed ;
		AND mwkfranjahT.diasem = mwktomados.diasem And mwkfranjahT.hhmmdes <= mwktomados.hhmmtur ;
		AND mwkfranjahT.hhmmhas>= mwktomados.hhmmtur And mwkfranjahT.fecvigend <= mwktomados.fechatur ;
		AND mwkfranjahT.fecvigenh>= mwktomados.fechatur ;
		order By  &mtipofec, usuario, tipotomado,mwktomados.Id ;
		group By  &mtipofec, usuario, tipotomado,mwktomados.Id ;
		into Cursor mwktomados1
Case mopcion = 9	&& abierto tabla dinamica
	Select  mwkfranjahT.centromed,mwktomados.*,ent_descrient, pre_descriprest,medpres.nombre, esp_descripcion ;
		,medsol.nombre As nombresol,mwkAdvmedgral.*,desclarga  ;
		,Iif(codserv = 2200 And nrovale>0,sp_busco_ambu_datos(1,nrovale,afiliado),Space(20)) As evolucion ;
		from mwkfranjahT ,mwktomados;
		left Join mwkpent On codent = ent_codent ;
		left Join mwkpesp On codesp = esp_codesp ;
		left Join mwkMedicosall As medpres On codmed = medpres.Id ;
		left Join mwkMedicosall As medsol On codmedsoli = medsol.Id ;
		left Join mwkppres On codprest = pre_codprest ;
		left Join mwkAdvmedgral On TRAM_registracio = afiliado ;
		left Join mwkdescamb On codambito = mwkdescamb.Id ;
		Where mwkfranjahT.codmed = mwktomados.codmed ;
		AND mwkfranjahT.diasem = mwktomados.diasem And mwkfranjahT.hhmmdes <= mwktomados.hhmmtur ;
		AND mwkfranjahT.hhmmhas>= mwktomados.hhmmtur And mwkfranjahT.fecvigend <= mwktomados.fechatur ;
		AND mwkfranjahT.fecvigenh>= mwktomados.fechatur
	Order By  &mtipofec, usuario, tipotomado,mwktomados.Id ;
		group By  &mtipofec, usuario, tipotomado,mwktomados.Id ;
		into Cursor mwktomados1

Endcase

Use In Select('mwkAdvmedgral')
