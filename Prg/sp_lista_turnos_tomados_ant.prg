****
** Generacion de estadistica de turnos dados por operador
****
parameter mfecha1, mfecha2, mopcion, mbusq,lsab,lfecha

lsigue = .t.
mtipofec = 'fechatomado'
if vartype(lfecha)="N"
	mtipofec = iif(lfecha = 1,'fechatomado',"horatur")
	mbusq = mbusq + iif(lfecha = 1,'',' and turnos.fechatur <= ?mfecha2 ')
endif
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif
mfecpas = ctod("01/01/1900")

mselsab = ''
if vartype(lsab)="N"
	mselsab = iif(lsab = 1,''," and dow(fechatomado) < 7 ")
endif

mret = sqlexec(mcon1,"select TRAM_registracio from TabRegAdvMed " + ;
	" Where TRAM_registracio > 1 and TRAM_fechapasiva = ?mfecpas and TRAM_tipo = 0" ,"mwkAdvmedgral")

mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoamb id<100000  order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_turnos_tomados1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha
cf1 = prg_dtoc(mfecha1)
cf2 = prg_dtoc(mfecha2 + 1)

fd1 = dtot(mfecha1)
fd2 = dtot(mfecha2 + 1)
do sp_busco_phordatos
if !used('mwkMedicosall')
	do sp_medicos_all
endif


mjoin = ''
mcpojoin = ''
if mopcion = 3
	mjoin = ' left join registracio on afiliado = reg_nroregistrac '
	mcpojoin = ',REG_nrohclinica,reg_email,reg_domicilio,reg_telefonos, REG_numdocumento, REG_fecnacimiento '
endif
mret = sqlexec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa,  upper(turnos.usuario) as usuario,nomape,'    +;
	'tabsectores.descrip as sector, datepart(dd,&mtipofec) as dia,' +;
	'datepart(hh,&mtipofec) as hora, turnos.id, turnos.tipotomado ' +;
	',turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli, '+;
	'turnos.codserv,turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura ' + mcpojoin + ;
	'from turnos '+;
	'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
	'left join tabsectorusuario on (tabusuario.id = tabsectorusuario.codusuario and preferido = 1)' +;
	'left join tabsectores on tabsectorusuario.codsector = tabsectores.id ' + mjoin + ;
	'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
	" where &mccpoamb turnos.codreserva<>'' and  turnos.fechatur  >= ?mfecha1  " + mbusq , 'mwktomadosa')


if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_turnos_tomados2'
	cancel
else
	mret = sqlexec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa,  upper(turnos.usuario) as usuario, '+;
		'nomape,tabsectores.descrip as sector, datepart(dd,&mtipofec) as dia, datepart(hh,&mtipofec) as hora, ' + ;
		'turnos.id, tipotomado ,turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli, turnos.codserv,'+;
		'turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura '+mcpojoin+;
		'from turnoscancel as turnos '+;
		'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
		'left join tabsectorusuario on (tabusuario.id = tabsectorusuario.codusuario and preferido = 1)' + ;
		'left join tabsectores on tabsectorusuario.codsector = tabsectores.id '+mjoin+;
		'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
		" where &mccpoamb turnos.codreserva<>'' and  turnos.fechatur >= ?mfecha1 and codcancela<>27 " + mbusq , 'mwktomadosc')
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_turnos_tomados3'
		cancel
	else

		if mfecha1 <= mfechalimite
			mret = sqlexec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur, turnos.observa, upper(turnos.usuario) as usuario,'+;
				'nomape,tabsectores.descrip as sector, ' +;
				'datepart(dd,&mtipofec) as dia, datepart(hh,&mtipofec) as hora,'+;
				'turnos.id, cast(0 as integer) as tipotomado  ' +;
				',turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli, turnos.codserv,'+;
				'turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura '+mcpojoin+;
				'from turnoshis as turnos '+;
				'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
				'left join tabsectorusuario on (tabusuario.id = tabsectorusuario.codusuario and preferido = 1)' +;
				'left join tabsectores on tabsectorusuario.codsector = tabsectores.id '+mjoin+;
				'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
				" where &mccpoamb turnos.codreserva<>'' and  turnos.fechatur >= ?mfecha1 "+ mbusq , 'mwktomadosb')

			if mret < 0
				=aerr(eros)
				do prg_error with eros,'sp_lista_turnos_tomados4'
				select afiliado,fechatomado, horatur, left(observa,100) as observa, usuario,nomape,sector, dia;
					, hora,id, tipotomado,  codreserva, codesp, diasem, codprest, codmedsoli,codserv,;
					codent, codmed, tipoturno, abreviatura &mcpojoin ,ttod(&mtipofec) as fechat from mwktomadosc ;
					where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
					union all ;
					select afiliado,fechatomado, horatur, left(observa,100) as observa, usuario,nomape,sector, dia;
					, hora,id, tipotomado,  codreserva, codesp, diasem, codprest, codmedsoli,codserv,;
					codent, codmed, tipoturno, abreviatura &mcpojoin ,ttod(&mtipofec) as fechat from mwktomadosa ;
					where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
					into cursor mwktomados0
			else
				select *,ttod(&mtipofec) as fechat from mwktomadosa ;
					where tipoturno#9 and afiliado > 1  and &mtipofec>= fd1 and &mtipofec < fd2 &mselsab;
					union all ;
					select *,ttod(fechatomado) as fechat from mwktomadosb ;
					where tipoturno#9 and afiliado > 1  and fechatomado>= fd1 and fechatomado < fd2 &mselsab;
					union all ;
					select *,ttod(fechatomado) as fechat from mwktomadosc ;
					where tipoturno#9 and afiliado > 1  and fechatomado>= fd1 and &mtipofec < fd2 &mselsab;
					into cursor mwktomados0
			endif

		else
			select afiliado,fechatomado, horatur, left(observa,100) as observa, usuario,nomape,sector, dia;
				, hora,id, tipotomado,  codreserva, codesp, diasem, codprest, codmedsoli,codserv,;
				codent, codmed, tipoturno, abreviatura &mcpojoin ,ttod(&mtipofec) as fechat from mwktomadosc ;
				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
				union all ;
				select afiliado,fechatomado, horatur, left(observa,100) as observa, usuario,nomape,sector, dia;
				, hora,id, tipotomado,  codreserva, codesp, diasem, codprest, codmedsoli,codserv,;
				codent, codmed, tipoturno, abreviatura &mcpojoin ,ttod(&mtipofec) as fechat from mwktomadosa ;
				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
				into cursor mwktomados0
		endif

		select * from mwktomados0 ;
			where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
			order by  &mtipofec, usuario, tipotomado,id ;
			group by  &mtipofec, usuario, tipotomado,id ;
			into cursor mwktomados

*!*	        select &mtipofec, usuario, tipotomado,id from mwktomados0 ;
*!*				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
*!*				order by &mtipofec, usuario, tipotomado,id ;
*!*				group by &mtipofec, usuario, tipotomado,id ;
*!*				into cursor mwktomados

		do case
			case mopcion = 1	&& cerrado por dia

				select sector, fechat, dia, usuario , nomape,;
					sum(iif(tipotomado = 1, 1, 0))  as tipo1, ;
					sum(iif(tipotomado = 2, 1, 0))  as tipo2, ;
					sum(iif(tipotomado = 3, 1, 0))  as tipo3, ;
					sum(iif(inlist(tipotomado,1,2,3), 0, 1)) as tipootros ;
					from mwktomados ;
					group by sector, fechat, usuario ;
					order by sector, fechat, usuario ;
					into cursor mwktomados1
&&  		sum(iif(hora < 14, 1, 0))  as hasta14,
&&  		sum(iif(hora >= 14, 1, 0)) as hasta21

			case mopcion = 2	&& abierto por hora

				select sector, fechat, dia, usuario,nomape, hora, ;
					sum(iif(tipotomado = 1, 1, 0))  as total1, ;
					sum(iif(tipotomado = 2, 1, 0))  as total2, ;
					sum(iif(tipotomado = 3, 1, 0))  as total3, ;
					sum(iif(inlist(tipotomado,1,2,3), 0, 1))  as totalotros ;
					from mwktomados ;
					group by sector, fechat, hora, usuario ;
					order by sector, fechat, hora, usuario ;
					into cursor mwktomados1
&&		sum(1) as total
			case mopcion = 3	&& abierto tabla dinamica
				select mwktomados.*,ent_descrient, pre_descriprest,medpres.nombre, esp_descripcion ;
					,medsol.nombre as nombresol,mwkAdvmedgral.* ;
					from mwktomados ;
					left join mwkpent on codent = ent_codent ;
					left join mwkpesp on codesp = esp_codesp ;
					left join mwkMedicosall as medpres on codmed = medpres.id ;
					left join mwkMedicosall as medsol on codmedsoli = medsol.id ;
					left join mwkppres on codprest = pre_codprest ;
					left join mwkAdvmedgral on TRAM_registracio = afiliado ;
					order by  &mtipofec, usuario, tipotomado,mwktomados.id ;
					group by  &mtipofec, usuario, tipotomado,mwktomados.id ;
					into cursor mwktomados1


		endcase
	endif
endif
