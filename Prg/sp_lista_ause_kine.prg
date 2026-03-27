****
** listado de ausentismo de foniatria
****

parameter mfechades, mcodesp

mfecha	  = date() - 1

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
	"nombre, REG_nombrepac, afiliado " + ;
	"from turnos, registracio, afiliacion, prestadores " + ;
	"where turnos.codreserva<>'' and  " + mccpoamb +;
	"turnos.codesp = ?mcodesp and codmed = prestadores.id and " + ;
	"afiliado = afiliacion.registracio and codent = AFI_codentidad and " + ;
	"afiliacion.registracio = registracio.REG_nroregistrac " + ;
	"order by codreserva, fechatur", "mwktodos1")

if mret < 0
	=aerr(eros)
	messagebox(eros(2), 16, "Validacion")
	messagebox(eros(3), 16, "Validacion")
endif
*fechatur >= ?mfechades and
mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
	"prestadores.nombre, preregistra.nombre, turnos.afiliado " + ;
	"from turnos, preregistra, prestadores " + ;
	"where turnos.codreserva<>'' and  " + mccpoamb +;
	"turnos.codesp = ?mcodesp and codmed = prestadores.id and " + ;
	"turnos.afiliado = preregistra.id " + ;
	"order by codreserva, fechatur", "mwktodos2")

if mret < 0
	=aerr(eros)
	messagebox(eros(2), 16, "Validacion")
	messagebox(eros(3), 16, "Validacion")
endif
select * from mwktodos1 where fechatur >= mfechades ;
	union all ;
	select * from mwktodos2 where fechatur >= mfechades ;
	into cursor mwktodos

select nombre, REG_nombrepac, codreserva, ;
	sum(iif(confirmado = 0 and fechatur <= mfecha, 1, 0)) as falto,  ;
	sum(iif(confirmado = 1 and fechatur <= mfecha, 1, 0)) as vino, ;
	sum(iif(fechatur > mfecha, 1, 0)) as quedan ;
	from mwktodos ;
	group by nombre, REG_nombrepac ;
	order by REG_nombrepac ;
	into cursor mwktodosf

select * from mwktodosf ;
	where falto > 0 and quedan > 0  ;
	order by nombre, REG_nombrepac ;
	into cursor mwklista
