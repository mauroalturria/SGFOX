****
** Generacion de estadistica de turnos dados por operador
****
parameter mfecha1, mfecha2,mbusq,lfecha

lsigue = .t.
mtipofec = 'fechatomado'
mfecpas = ctod("01/01/1900")


if vartype(lfecha)="N"
	mtipofec = iif(lfecha = 1,'fechatomado',"horatur")
	mbusq = mbusq + iif(lfecha = 1,'',' and turnos.fechatur <= ?mfecha2 ')
endif
mselsab = ''

mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_turnos_tomados1'
	cancel
endif
mret = sqlexec(mcon1,"select * from tabambito ","mwkdescamb")

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

mret = sqlexec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa, upper(turnos.usuario) as usuario,nomape,'    +;
	'datepart(dd,&mtipofec) as dia,usuariosector,' +;
	'datepart(hh,&mtipofec) as hora, turnos.id, turnos.tipotomado ' +;
	',turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli, '+;
	'turnos.codserv,turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura,turnos.codambito '+;
	',reg_nombrepac,REG_telefonos,REG_numdocumento '+;
	'from turnos '+;
	'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
	' left join registracio on afiliado = reg_nroregistrac '+;
	'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
	'where turnos.fechatur  >= ?mfecha1  '  + mbusq , 'mwktomadosar')

mret = sqlexec(mcon1,'select turnos.afiliado,turnos.fechatomado, turnos.horatur,turnos.observa, upper(turnos.usuario) as usuario,nomape,'    +;
	'datepart(dd,&mtipofec) as dia,usuariosector,' +;
	'datepart(hh,&mtipofec) as hora, turnos.id, turnos.tipotomado ' +;
	',turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli, '+;
	'turnos.codserv,turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura,turnos.codambito '+;
	',preregistra.nombre as reg_nombrepac, preregistra.telefono as REG_telefonos, preregistra.nrodocumento as REG_numdocumento '+;
	'from turnos '+;
	'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
	' left join preregistra on turnos.afiliado = preregistra.id '+;
	'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
	'where turnos.fechatur  >= ?mfecha1  '  + mbusq , 'mwktomadosap')

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_turnos_tomados2'
	cancel
else
select * from mwktomadosar where !isnull(reg_nombrepac) union select * from mwktomadosap where !isnull(reg_nombrepac) into cursor mwktomadosa
	mret = sqlexec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa, upper(turnos.usuario) as usuario, '+;
		'nomape,datepart(dd,&mtipofec) as dia,usuariosector, datepart(hh,&mtipofec) as hora, ' + ;
		'turnos.id, tipotomado ,turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli, '+;
		'turnos.codserv,turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura,turnos.codambito '+;
		',reg_nombrepac,REG_telefonos,REG_numdocumento '+;
		'from turnoscancel as turnos '+;
		'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
		'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
		' left join registracio on afiliado = reg_nroregistrac '+;
		'where turnos.fechatur >= ?mfecha1 and codcancela<>27 ' + mbusq , 'mwktomadosc')
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_turnos_tomados3'
		cancel
	else

		if mfecha1 <= mfechalimite
			mret = sqlexec(mcon1,'select afiliado,turnos.fechatomado, turnos.horatur,turnos.observa, upper(turnos.usuario) as usuario,'+;
				'nomape,' +;
				'datepart(dd,&mtipofec) as dia,usuariosector, datepart(hh,&mtipofec) as hora,'+;
				'turnos.id, cast(0 as integer) as tipotomado  ' +;
				',turnos.codreserva, turnos.codesp, turnos.diasem, turnos.codprest, turnos.codmedsoli,'+;
				'turnos.codserv,turnos.codent, turnos.codmed, turnos.tipoturno, tabtipoturno.abreviatura,turnos.codambito '+;
				',reg_nombrepac,REG_telefonos,REG_numdocumento '+;
				'from turnoshis as turnos '+;
				'left join tabusuario on turnos.usuario= tabusuario.idusuario ' +;
				'left join tabtipoturno on turnos.tipoturno = tabtipoturno.tipoturno ' + ;
				' left join registracio on afiliado = reg_nroregistrac '+;
				'where turnos.fechatur >= ?mfecha1 '+ mbusq , 'mwktomadosb')

			if mret < 0
				=aerr(eros)
				do prg_error with eros,'sp_lista_turnos_tomados4'

select afiliado,fechatomado,horatur,padr(observa,250) as observa,usuario,nomape,codambito;
					,reg_nombrepac,REG_telefonos,REG_numdocumento ;
				,dia,hora,id,tipotomado,codreserva,codesp,diasem,codprest,;
				codmedsoli,codserv,codent,codmed,tipoturno,abreviatura;
				,ttod(&mtipofec) as fechat from mwktomadosa ;
				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
				union all ;
				select afiliado,fechatomado,horatur,left(observa,255) as observa,usuario,nomape,codambito;
					,reg_nombrepac,REG_telefonos,REG_numdocumento ;
				,dia,hora,id,tipotomado,codreserva,codesp,diasem,codprest,;
				codmedsoli,codserv,codent,codmed,tipoturno,abreviatura ;
				,ttod(&mtipofec) as fechat from mwktomadosc ;
				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
				into cursor mwktomados0
			else
				select afiliado,fechatomado,horatur,padr(observa,250) as observa,usuario,nomape,codambito;
					,reg_nombrepac,REG_telefonos,REG_numdocumento ;
					,dia,hora,id,tipotomado,codreserva,codesp,diasem,codprest,;
					codmedsoli,codserv,codent,codmed,tipoturno,abreviatura  ;
					,ttod(&mtipofec) as fechat from mwktomadosa ;
					where tipoturno#9 and afiliado > 1  and &mtipofec>= fd1 and &mtipofec < fd2 ;
					union all ;
					select afiliado,fechatomado,horatur,padr(observa,250) as observa,usuario,nomape,codambito;
					,reg_nombrepac,REG_telefonos,REG_numdocumento ;
					,dia,hora,id,tipotomado,codreserva,codesp,diasem,codprest,;
					codmedsoli,codserv,codent,codmed,tipoturno,abreviatura ;
					,ttod(&mtipofec) as fechat from mwktomadosb ;
					where tipoturno#9 and afiliado > 1  and fechatomado>= fd1 and fechatomado < fd2 ;
					union all ;
					select afiliado,fechatomado,horatur,left(observa,255) as observa,usuario,nomape,codambito;
					,reg_nombrepac,REG_telefonos,REG_numdocumento ;
					,dia,hora,id,tipotomado,codreserva,codesp,diasem,codprest,;
					codmedsoli,codserv,codent,codmed,tipoturno,abreviatura ;
					,ttod(&mtipofec) as fechat from mwktomadosc ;
					where tipoturno#9 and afiliado > 1  and fechatomado>= fd1 and &mtipofec < fd2 ;
					into cursor mwktomados0

			endif

		else
			select afiliado,fechatomado,horatur,padr(observa,250) as observa,usuario,nomape,codambito;
					,reg_nombrepac,REG_telefonos,REG_numdocumento ;
				,dia,hora,id,tipotomado,codreserva,codesp,diasem,codprest,;
				codmedsoli,codserv,codent,codmed,tipoturno,abreviatura ;
				,ttod(&mtipofec) as fechat from mwktomadosa ;
				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 ;
				union all ;
				select afiliado,fechatomado,horatur,left(observa,255) as observa,usuario,nomape,codambito;
					,reg_nombrepac,REG_telefonos,REG_numdocumento ;
				,dia,hora,id,tipotomado,codreserva,codesp,diasem,codprest,;
				codmedsoli,codserv,codent,codmed,tipoturno,abreviatura ;
				,ttod(&mtipofec) as fechat from mwktomadosc ;
				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 ;
				into cursor mwktomados0
		endif

		select * from mwktomados0 ;
			where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 ;
			order by  &mtipofec, usuario, tipotomado,id ;
			group by  &mtipofec, usuario, tipotomado,id ;
			into cursor mwktomados

*!*	        select &mtipofec, usuario, tipotomado,id from mwktomados0 ;
*!*				where tipoturno#9 and afiliado > 1  and &mtipofec >= fd1 and &mtipofec < fd2 &mselsab;
*!*				order by &mtipofec, usuario, tipotomado,id ;
*!*				group by &mtipofec, usuario, tipotomado,id ;
*!*				into cursor mwktomados

				select mwktomados.*,ent_descrient, pre_descriprest,medpres.nombre, esp_descripcion ;
					,medsol.nombre as nombresol,desclarga  ;
					from mwktomados ;
					left join mwkpent on codent = ent_codent ;
					left join mwkpesp on codesp = esp_codesp ;
					left join mwkMedicosall as medpres on codmed = medpres.id ;
					left join mwkMedicosall as medsol on codmedsoli = medsol.id ;
					left join mwkppres on codprest = pre_codprest ;
					left join mwkdescamb on codambito = mwkdescamb.id ;
					order by  &mtipofec, usuario, tipotomado,mwktomados.id ;
					group by  &mtipofec, usuario, tipotomado,mwktomados.id ;
					into cursor mwktomados1

	endif
endif
use in select('mwkAdvmedgral')
