****
**  Estadistica de turnos solicitados por
*** Modificado por Claudia el 12/6/03 lineas 7 y 8 en ambos querys
****

parameter mfecdes, mfechas, mbusco1, mcual

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''
endif

mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	'  where &mccpoamb id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_turnos_entidad1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha


mret = sqlexec(mcon1, "select ENT_descrient, codmed, codesp, fechatur, " + ;
	"confirmado, tipoturno " + ;
	"from turnos left join entidades on turnos.codent = entidades.ENT_codent " + ;
	"where &mccpoamb  turnos.codreserva<>'' and afiliado>1 and "+;
	"fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
	"( entidades.ENT_fecpas is null or entidades.ENT_fecpas > ?mfecdes )" + ;
	" &mbusco1 " + ;
	"order by ENT_descrient, fechatur" , "mwklista3")
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_lista_turnos_entidad2'
	cancel
endif
*** turnos.codent > 0 and "
** "tipoturno < 8 and afiliado > 0 and "
if mfecdes <= mfechalimite
	mret = sqlexec(mcon1, "select ENT_descrient, codmed, codesp, fechatur, " + ;
		"confirmado, tipoturno " + ;
		"from turnoshis as turnos, entidades " + ;
		"where &mccpoamb  turnos.codreserva<>'' and afiliado>1 and turnos.codent = entidades.ENT_codent  and " + ;
		"fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
		"( entidades.ENT_fecpas is null or entidades.ENT_fecpas > ?mfecdes )" + ;
		" &mbusco1 " + ;
		"order by ENT_descrient, fechatur" , "mwklista2")

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_lista_turnos_entidad3'
		cancel
	endif
**	 							"turnos.codent > 0 and "
**	 							"tipoturno < 8 and afiliado > 0 and "
	select * from mwklista3 ;
		union all ;
		select * from mwklista2 ;
		into cursor mwklista1
else
	select * from mwklista3 ;
		into cursor mwklista1
endif

if mcual = 1

	select ENT_descrient, sum(1) as total, ;
		sum(iif(confirmado = 0, 1, 0)) as ausente, ;
		sum(iif(confirmado = 1, 1, 0)) as presente ;
		from mwklista1 ;
		group by ENT_descrient ;
		order by ENT_descrient ;
		into cursor mwklista

endif

if mcual = 2

	select ENT_descrient, fechatur, sum(1) as total, ;
		sum(iif(confirmado = 0, 1, 0)) as ausente, ;
		sum(iif(confirmado = 1, 1, 0)) as presente ;
		from mwklista1 ;
		group by ENT_descrient, fechatur ;
		order by ENT_descrient, fechatur ;
		into cursor mwklista

endif
