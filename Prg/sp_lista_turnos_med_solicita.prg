 ****
**  Estadistica de turnos solicitados por
****

parameter mfecdes, mfechas, mbusco1, mcual


if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoamb id<100000  order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_turnos_med_solicita1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

mcFecDes = prg_dtoc(mfecdes)
mcFecHas = prg_dtoc(mfechas+1 )


if mcual = 1

	mret = sqlexec(mcon1, "select med.nombre, soli.nombre, count(codmedsoli)as turnos " + ;
		"from turnos, prestadores as med, prestadores as soli " + ;
		"where &mccpoamb turnos.codreserva<>'' and (turnos.tipoturno < 8 or turnos.tipoturno >=13) and afiliado > 1 and " + ;
		"fechatomado >= ?mcfecdes and " + ;
		"fechatomado <= ?mcfechas and " + ;
		"codmed = med.id and codmedsoli = soli.id " + ;
		"&mbusco1" + ;
		"group by med.nombre, soli.nombre " + ;
		"order by med.nombre, soli.nombre" , "mwklista2")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_turnos_med_solicita2'
		cancel
	endif

	if mfecdes <= mfechalimite
		mret = sqlexec(mcon1, "select med.nombre, soli.nombre, count(codmedsoli)as turnos " + ;
			"from turnoshis as turnos, prestadores as med, prestadores as soli " + ;
			"where &mccpoamb turnos.codreserva<>'' and (turnos.tipoturno < 8 or turnos.tipoturno >=13) and afiliado > 1 and " + ;
			"fechatomado >= ?mcfecdes and " + ;
			"fechatomado <= ?mcfechas and " + ;
			"codmed = med.id and codmedsoli = soli.id " + ;
			"&mbusco1" + ;
			"group by med.nombre, soli.nombre " + ;
			"order by med.nombre, soli.nombre" , "mwklista1")
		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_lista_turnos_med_solicita3'
			cancel
		endif

	endif

endif

if mcual = 2

	mret = sqlexec(mcon1, "select med.nombre, sol.nombre, upper(turnos.usuario) as usuario , " + ;
		"count(codmedsoli)as turnos " + ;
		"from turnos, prestadores as med, prestadores as sol " + ;
		"where &mccpoamb  turnos.codreserva<>'' and turnos.codmed = med.id  and " + ;
		"turnos.codmedsoli = sol.id  and " + ;
		"(turnos.tipoturno < 8 or turnos.tipoturno >=13) and afiliado > 1 and " + ;
		"fechatomado >= ?mcfecdes and " + ;
		"fechatomado <= ?mcfechas " + ;
		"&mbusco1" + ;
		"group by med.nombre, sol.nombre, turnos.usuario " + ;
		"order by med.nombre, sol.nombre, usuario" , "mwklista2")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_turnos_med_solicita3'
		cancel
	endif


	if mfecdes <= mfechalimite
		mret = sqlexec(mcon1, "select med.nombre, sol.nombre, upper(turnos.usuario) as usuario , " + ;
			"count(codmedsoli)as turnos " + ;
			"from turnoshis as turnos, prestadores as med, prestadores as sol " + ;
			"where &mccpoamb turnos.codreserva<>'' and  turnos.codmed = med.id  and " + ;
			"turnos.codmedsoli = sol.id  and " + ;
			"(turnos.tipoturno < 8 or turnos.tipoturno >=13) and afiliado > 1 and " + ;
			"fechatomado >= ?mcfecdes and " + ;
			"fechatomado <= ?mcfechas " + ;
			"&mbusco1" + ;
			"group by med.nombre, sol.nombre, turnos.usuario " + ;
			"order by med.nombre, sol.nombre, usuario" , "mwklista1")
		if mret < 0
			=aerr(eros)
			do prg_error with eros,'sp_lista_turnos_med_solicita4'
			cancel
		endif

	endif
endif

if mfecdes <= mfechalimite
	select * from mwklista2 ;
		union all ;
		select * from mwklista1 ;
		into cursor mwklista
else
	select * from mwklista2 ;
		into cursor mwklista
endif


