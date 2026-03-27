****
** Generacion de estaditica de turnos dados por operador
****
parameter mfecha1, mfecha2, mopcion, vr_sector
lsigue = .t.
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where id<100000 order by fechacierre ','mwkctrlfecha')
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

if atc(',',vr_sector,1) > 1
	mbusq =' AND tabsectores.descrip in (' + vr_sector + ') '
else
	if !type(vr_sector)#'C'
		mbusq =' AND tabsectores.descrip = ' + vr_sector
	else
		mbusq =''
	endif
endif

mret = sqlexec(mcon1,'select turnos.*,'    +;
	'tabsectores.descrip as sector, ' +;
	'' +;
	'from turnos, tabusuario ' +;
	'left join tabsectorusuario on tabusuario.id = tabsectorusuario.codusuario ' +;
	'left join tabsectores on tabsectorusuario.codsector = tabsectores.id ' +;
	'where upper(turnos.usuario) = tabusuario.idusuario ' +;
	'and preferido = 1 ' +;
	'and cast(turnos.fechatomado as date) >= ?mfecha1  '  +;
	'and cast(turnos.fechatomado as date) <= ?mfecha2  '  + mbusq +;
	'order by dia, upper(usuario), sector', 'mwktomadosa')

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
else
	mret = sqlexec(mcon1,'select turnos.fechatomado, upper(turnos.usuario) as usuario, tabsectores.descrip as sector, ' + ;
		'datepart(dd,fechatomado) as dia, datepart(hh,fechatomado) as hora, turnos.id, tipotomado  ' + ;
		'from turnoscancel as turnos, tabusuario ' + ;
		'left join tabsectorusuario on tabusuario.id = tabsectorusuario.codusuario ' + ;
		'left join tabsectores on tabsectorusuario.codsector = tabsectores.id ' + ;
		'where upper(turnos.usuario) = tabusuario.idusuario and ' + ;
		'tabusuario.id = tabsectorusuario.codusuario and ' + ;
		'cast(turnos.fechatomado as date) >= ?mfecha1 and ' + ;
		'cast(turnos.fechatomado as date) <= ?mfecha2  ' + mbusq + ;
		'and preferido = 1 ' +;
		'order by dia, upper(usuario), sector', 'mwktomadosc')

	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
	else

		if mfecha1 <= mfechalimite
			mret = sqlexec(mcon1,'select turnos.fechatomado, upper(turnos.usuario) as usuario,'+;
				'tabsectores.descrip as sector, ' +;
				'datepart(dd,fechatomado) as dia, datepart(hh,fechatomado) as hora,'+;
				'turnos.id, cast(0 as integer) as tipotomado  ' +;
				'from turnoshis as turnos, tabusuario ' +;
				'left join tabsectorusuario on tabusuario.id = tabsectorusuario.codusuario ' +;
				'left join tabsectores on tabsectorusuario.codsector = tabsectores.id ' +;
				'where upper(turnos.usuario) = tabusuario.idusuario and ' +;
				'tabusuario.id = tabsectorusuario.codusuario and ' +;
				'cast(turnos.fechatomado as date) >= ?mfecha1 and ' +;
				'cast(turnos.fechatomado as date) <= ?mfecha2  '+ mbusq +;
				'and preferido = 1 ' +;
				'order by dia, upper(usuario), sector', 'mwktomadosb')

			if mret < 0
				messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "Validacion")
				select * from mwktomadosa ;
					union all ;
					select * from mwktomadosc ;
					into cursor mwktomados0

			else
				select * from mwktomadosa ;
					union all ;
					select * from mwktomadosb ;
					union all ;
					select * from mwktomadosc ;
					into cursor mwktomados0
			endif

		else
			select * from mwktomadosa ;
				union all ;
				select * from mwktomadosc ;
				into cursor mwktomados0
		endif

		select * from mwktomados0 ;
			order by  fechatomado, usuario, tipotomado,id ;
			group by  fechatomado, usuario, tipotomado,id ;
			into cursor mwktomados


		if mopcion = 1	&& cerrado por dia

			select sector, dia, usuario , ;
				sum(iif(tipotomado = 1, 1, 0))  as tipo1, ;
				sum(iif(tipotomado = 2, 1, 0))  as tipo2, ;
				sum(iif(tipotomado = 3, 1, 0))  as tipootros ;
				from mwktomados ;
				group by sector, dia, usuario ;
				order by sector, dia, usuario ;
				into cursor mwktomados1
&&  		sum(iif(hora < 14, 1, 0))  as hasta14, ;
&&  		sum(iif(hora >= 14, 1, 0)) as hasta21 ;

		else	&& abierto por hora

			select sector, dia, usuario, hora, ;
				sum(iif(tipotomado = 1, 1, 0))  as total1, ;
				sum(iif(tipotomado = 2, 1, 0))  as total2, ;
				sum(iif(tipotomado = 1 or tipotomado = 2, 0, 1))  as totalotros ;
				from mwktomados ;
				group by sector, dia, hora, usuario ;
				order by sector, dia, hora, usuario ;
				into cursor mwktomados1
&&		sum(1) as total ;

		endif
	endif
endif
*!*		=aerr(eros)
*!*		messagebox(eros(2))
*!*		set step on
