***
*** Generacion de planilla de Turnos mal
***

mfechad = date()
mret = sqlexec(mcon1, "select * from medpresta " + ;
	"where fecvigenh > fecvigend and fecvigenh >?mfechad " , "medpres")

mret=sqlexec(mcon1," SELECT FranjaHoraria.* "+;
	"FROM FranjaHoraria WHERE fecvigenh >fecvigend " ,"franja")

mret=sqlexec(mcon1," SELECT prestadores.id, prestadores.nombre ,fecpasiva  "+;
	"FROM prestadores  " ,"prestaall")


mret=sqlexec(mcon1,"SELECT PRE_codprest, PRE_descriprest, PRE_especialidad,PRE_fechapasiva  "+;
	" FROM prestacions " + ;
	" WHERE PRE_agendaturnos='S' "+;
	" GROUP BY PRE_codprest " + ;
	" ORDER BY PRE_descriprest ","Mwkprestac")

select * from franja ;
	left join medpres on ;
	(medpres.codmed   = franja.codmed and ;
	medpres.diasem	 = franja.diasem and ;
	medpres.fecvigend>= franja.fecvigend and ;
	medpres.fecvigenh<= franja.fecvigenh and ;
	medpres.hhmmDes >= franja.hhmmDes and  ;
	medpres.hhmmHas <= franja.hhmmHas ) ;
	order by franja.diasem, franja.fecvigend, franja.fecvigenh, franja.horadesde ;
	into cursor mal1

select * from medpres,prestaall,Mwkprestac ;
	where prestaall.id=codmed and PRE_codprest=codprest and ;
	medpres.id not in (select id_b from mal1) order by PRE_fechapasiva desc into cursor malmal1
browse last
