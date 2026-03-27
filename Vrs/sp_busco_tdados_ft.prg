***
*** Generacion de planilla de Turnos
***
public mcon1
do sp_conexion
mfecturno=ctod("01/10/2004")
mfecturna=ctod("15/10/2004")

mret = sqlexec(mcon1, 'select fechatur, horatur, diasem,codreserva, fechatomado, turnos.usuario, afiliado as afi_nroafiliado, ' + ;
	' tipoturno,reg_nombrepac ,codmed,codprest '+;
	' from turnos ,registracio  ' + ;
	' where turnos.afiliado = registracio.reg_nroregistrac and ' + ;
	' fechatur >= ?mfecturno and ' + ;
	' fechatur <= ?mfecturna and ' + ;
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
	" fechatur >= ?mfecturno and " + ;
	' fechatur <= ?mfecturna and ' + ;
	" turnos.afiliado > 0 " + ;
	"", "mwkphorario2")

if mret < 0
=aerr(eros)
	set step on
	=sqldisconnect(mcon1)
else
	select usuario, fechatomado,  left(reg_nombrepac, 40) as reg_nombrepac, ;
		codreserva, afi_nroafiliado, ;
		horatur, codmed,codprest,tipoturno ,space(15) as usucancela;
		from mwkphorario1 ;
		order by usuario,afi_nroafiliado,fechatomado  into cursor mwkphorario3

	select  usuario, fechatomado, left(reg_nombrepac, 40) as reg_nombrepac, ;
		codreserva, 0 as afi_nroafiliado,;
		horatur, codmed,codprest,tipoturno,space(15) as usucancela ;
		from mwkphorario2 ;
		order by usuario,afi_nroafiliado,fechatomado  into cursor mwkphorario4
mret = sqlexec(mcon1, 'select fechatur, horatur, diasem,codreserva, fechatomado, turnos.usuario, afiliado as afi_nroafiliado, ' + ;
	' reg_nombrepac ,codmed,codprest,usucancela '+;
	' from turnosCANCEL  AS TURNOS ,registracio  ' + ;
	' where turnos.afiliado = registracio.reg_nroregistrac and ' + ;
	' fechatur >= ?mfecturno and ' + ;
	' fechatur <= ?mfecturna and ' + ;
	" afiliado > 0 " + ;
	' group by fechatur, afiliado, codreserva,codmed,codprest ' + ;
	' ', 'mwkphorario11')
mret = sqlexec(mcon1, "SELECT ID,codcancela,codesp,codmed,codprest,codreserva"+;
" ,codserv,feccancela,fechatomado,horatur,observa,usucancela "+;
" from turnoscancel"+;
" where usuario=usucancela"+;
" and  fechatur>=to_date('01/09/2004','dd/mm/yyyy')"+;
" order by usucancela,horatur" , "mwkphorario22")
	select usuario, fechatomado,  left(reg_nombrepac, 40) as reg_nombrepac, ;
		codreserva, afi_nroafiliado, ;
		horatur, codmed,codprest,9 AS tipoturno,usucancela ;
		from mwkphorario11 ;
		order by usuario,afi_nroafiliado,fechatomado  into cursor mwkphorarioA

	select  usuario, fechatomado, left(reg_nombrepac, 40) as reg_nombrepac, ;
		codreserva, 0 as afi_nroafiliado,;
		horatur, codmed,codprest,9 AS tipoturno,usucancela  ;
		from mwkphorario22 ;
		order by usuario,afi_nroafiliado,fechatomado  into cursor mwkphorarioB
	=sqldisconnect(mcon1)

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