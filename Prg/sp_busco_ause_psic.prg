****
** ausentes PSIC
****

parameter mfecha, mcodesp,mbusco
if vartype(mbusco)#"C"
	mbusco = ''
endif
mfecnul = CTOD("01/01/1900")
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' order by fechacierre ','mwkctrlfecha')
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
go bottom in mwkctrlfecha
skip -1
mfechacan = mwkctrlfecha.fechacierre

mfaltas = 2
mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
	"afiliado,codent,fechatomado " + ;
	"from turnos " + ;
	"where turnos.codesp = ?mcodesp and fechatur< ?mfecha" + mbusco + ;
	"group by afiliado,fechatur", "mwktodos")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif


select afiliado,codreserva,  ;
	sum(iif(confirmado = 0 , 1, 0)) as falto,  ;
	sum(iif(confirmado = 1 , 1, 0)) as vino  ;
	from mwktodos ;
	group by afiliado;
	order by afiliado having falto>0   ;
	into cursor mwkfaltas

select afiliado, codreserva, confirmado ,fechatur,codent ;
	from mwktodos ;
	where afiliado in (select afiliado from mwkfaltas) ;
	group by afiliado, fechatur ;
	order by afiliado, fechatur desc ;
	into cursor mwkdetfaltas

create cursor faltas ;
	(afiliadoa n(10), entidad c(50), reserva c(15);
	, presen n(2), ausen n(2),aband n(2))
select mwkdetfaltas
go top
mcodres= codreserva
mafiliadoa = afiliado
presentes = 0
ausentes = 0
mconf  = confirmado
abandono = 0
qqueda = 0
lvino = .f.
ment = ''
do while !eof()
	do while mafiliadoa = afiliado and !eof()
		if confirmado = 1
			lvino = .t.
		endif
		presentes =presentes +iif(confirmado =1 ,1,0)
		ausentes =ausentes +iif(confirmado =0 ,1,0)
		abandono = abandono + iif((confirmado =0 ) and !lvino ,1,0)
		mconf  = confirmado
		skip
	enddo
	if abandono > 0
		if ausentes =0 and presentes=0 and abandono=0 
			if mafiliadoa # afiliado
				qqueda = 0
			endif
			mcodres= codreserva
			mafiliadoa = afiliado
			mconf  = confirmado
			presentes = 0
			ausentes = 0
			abandono = 0
			lvino = .f.
		else
			insert into faltas(afiliadoa , entidad, reserva ;
				, presen , ausen,aband) values (mafiliadoa , ment,mcodres,presentes ;
				,ausentes ,abandono )
			mcodres= codreserva
			mafiliadoa = afiliado
			mconf  = confirmado
			presentes = 0
			ausentes = 0
			qqueda = 0
			abandono = 0
			lvino = .f.
		endif
	else
			mcodres= codreserva
			mafiliadoa = afiliado
			mconf  = confirmado
			presentes = 0
			ausentes = 0
			qqueda = 0
			abandono = 0
			lvino = .f.

	endif
	
enddo

select faltas

