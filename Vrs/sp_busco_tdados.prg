***
*** Generacion de planilla de Turnos
***
public mcon1
mfecturno=ctod("01/11/2004")
do sp_conexion
mret = sqlexec(mcon1, 'select fechatur, horatur, diasem,codreserva, fechatomado, turnos.usuario, afiliado as afi_nroafiliado, ' + ;
	' tipoturno,reg_nombrepac ,codmed,codprest '+;
	' from turnos ,registracio  ' + ;
	' where turnos.afiliado = registracio.reg_nroregistrac and ' + ;
	' cast(fechatomado as date) = ?mfecturno and ' + ;
	" afiliado > 0 " + ;
	' group by fechatur, afiliado, codreserva,codmed,codprest ' + ;
	' ', 'mwkphorario1')
if mret < 0
=aerr(eros)
	=sqldisconnect(mcon1)
	set step on
else

mret = sqlexec(mcon1, "select fechatur, horatur, diasem,codreserva, fechatomado, turnos.usuario," + ;
	"preregistra.afiliado as afi_nroafiliado, " + ;
	"tipoturno,(preregistra.nombre) as reg_nombrepac,codmed,codprest " + ;
	" from turnos  ,preregistra " + ;
	" where turnos.afiliado = preregistra.id and " + ;
	" cast(fechatomado as date) = ?mfecturno and " + ;
	" turnos.afiliado > 0 " + ;
	"", "mwkphorario2")

if mret < 0
=aerr(eros)
	set step on
	=sqldisconnect(mcon1)
else
	=sqldisconnect(mcon1)
set step on
	select usuario, fechatomado,  left(reg_nombrepac, 40) as reg_nombrepac, ;
		codreserva, afi_nroafiliado, ;
		horatur, codmed,codprest,tipoturno ;
		from mwkphorario1 ;
		order by usuario,afi_nroafiliado,fechatomado  into cursor mwkphorario3

	select  usuario, fechatomado, left(reg_nombrepac, 40) as reg_nombrepac, ;
		codreserva, 0 as afi_nroafiliado,;
		horatur, codmed,codprest,tipoturno ;
		from mwkphorario2 ;
		order by usuario,afi_nroafiliado,fechatomado  into cursor mwkphorario4
mret = sqlexec(mcon1, 'select fechatur, horatur, diasem,codreserva, fechatomado, turnos.usuario, afiliado as afi_nroafiliado, ' + ;
	' reg_nombrepac ,codmed,codprest '+;
	' from turnosCANCEL  AS TURNOS ,registracio  ' + ;
	' where turnos.afiliado = registracio.reg_nroregistrac and ' + ;
	' cast(fechatomado as date) = ?mfecturno and ' + ;
	" afiliado > 0 " + ;
	' group by fechatur, afiliado, codreserva,codmed,codprest ' + ;
	' ', 'mwkphorario11')
mret = sqlexec(mcon1, "select fechatur, horatur, diasem,codreserva, fechatomado, turnos.usuario," + ;
	"preregistra.afiliado as afi_nroafiliado, " + ;
	" (preregistra.nombre) as reg_nombrepac,codmed,codprest " + ;
	" from turnosCANCEL AS TURNOS ,preregistra " + ;
	" where turnos.afiliado = preregistra.id and " + ;
	" cast(fechatomado as date) = ?mfecturno and " + ;
	" turnos.afiliado > 0 " + ;
	"", "mwkphorario22")
	select usuario, fechatomado,  left(reg_nombrepac, 40) as reg_nombrepac, ;
		codreserva, afi_nroafiliado, ;
		horatur, codmed,codprest,9 AS tipoturno ;
		from mwkphorario11 ;
		order by usuario,afi_nroafiliado,fechatomado  into cursor mwkphorarioA

	select  usuario, fechatomado, left(reg_nombrepac, 40) as reg_nombrepac, ;
		codreserva, 0 as afi_nroafiliado,;
		horatur, codmed,codprest,9 AS tipoturno ;
		from mwkphorario22 ;
		order by usuario,afi_nroafiliado,fechatomado  into cursor mwkphorarioB

	select * from mwkphorario3 ;
		union ;
		select * from mwkphorario4;
		union ;
		select * from mwkphorarioA;
				union ;
		select * from mwkphorarioB;
		into cursor mwkphorarios

	select * from mwkphorarios order by usuario,afi_nroafiliado,fechatomado ;
	into cursor mwkturnos
endif