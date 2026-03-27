****
** listado de ausentismo de foniatria
****

parameter mfechades, mfechahas, mcodesp
do sp_conexion
mfechades= ctod("01/01/2005")
mfechahas= ctod("31/05/2005")
mfechacorte= ctod("01/09/2004")
mret =sqlexec(mcon1,"SELECT ENT_descrient, ENT_codent FROM entidades" ,"MWKEntidades")

mcodesp = "KINE"
mret = Sqlexec(mcon1,"SELECT nombre, id " + ;
	"FROM Prestadores, Medpresta " + ;
	"WHERE medpresta.codmed = prestadores.id and " + ;
	"(estado = 1 or fecpasiva > ?mfechahas ) and " + ;
	"medpresta.codesp = ?mcodesp " + ;
	"group by nombre " + ;
	"ORDER BY Nombre", "mwkmedicos")


mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
	"nombre, REG_nombrepac, afiliado,codmedsoli,codmed,codent " + ;
	"from turnos, registracio, afiliacion, prestadores " + ;
	"where afiliado > 0 and fechatur >= ?mfechades and " + ;
	"turnos.codesp = ?mcodesp and codmedsoli = prestadores.id and " + ;
	"fechatur <= ?mfechahas and " + ;
	"tipoturno < 9 and " + ;
	"afiliado = afiliacion.registracio and codent = AFI_codentidad and " + ;
	"afiliacion.registracio = registracio.REG_nroregistrac " + ;
	"order by codreserva, fechatur", "mwktodos1")

mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
	"nombre, REG_nombrepac, afiliado,codmedsoli,codmed,codent " + ;
	"from turnoshis as turnos, registracio, afiliacion, prestadores " + ;
	"where afiliado > 0 and fechatur >= ?mfechades and " + ;
	"turnos.codesp = ?mcodesp and codmedsoli = prestadores.id and " + ;
	"tipoturno < 9 and " + ;
	"afiliado = afiliacion.registracio and codent = AFI_codentidad and " + ;
	"afiliacion.registracio = registracio.REG_nroregistrac " + ;
	"order by codreserva, fechatur", "mwktodos2")

mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
	"nombre, REG_nombrepac, afiliado,codmedsoli,codmed,codent " + ;
	"from turnoscancel as turnos, registracio, afiliacion, prestadores " + ;
	"where afiliado > 0 and fechatur >= ?mfechades and " + ;
	"turnos.codesp = ?mcodesp and codmedsoli = prestadores.id and " + ;
	"codcancel not in (5,3) and " + ;
	"afiliado = afiliacion.registracio and codent = AFI_codentidad and " + ;
	"afiliacion.registracio = registracio.REG_nroregistrac " + ;
	"order by codreserva, fechatur", "mwktodos3")


mret = sqlexec(mcon1, "select codreserva " + ;
	"from turnos " + ;
	"where afiliado > 0 and " + ;
	"codesp = ?mcodesp and " + ;
	"fechatur > ?mfechahas and " + ;
	"tipoturno < 9 " + ;
	"group by codreserva", "mwkfuera1")
	
mret = sqlexec(mcon1, "select codreserva " + ;
	"from turnoshis " + ;
	"where afiliado > 0 and " + ;
	"codesp = ?mcodesp and " + ;
	"fechatur < ?mfechades and " + ;
	"fechatur > ?mfechacorte and " + ;
	"tipoturno < 9 " + ;
	"group by codreserva", "mwkfuera2")
	
select * from mwkfuera1;
	union all ;
	select * from mwkfuera2;
	into cursor mwkfuera

select * from mwktodos1 where codreserva not in (select codreserva from mwkfuera) ;
	union all ;
	select * from mwktodos2 where codreserva not in (select codreserva from mwkfuera) ;
		union all ;
		select * from mwktodos3 where codreserva not in (select codreserva from mwkfuera) ;
	into cursor mwktodos

select REG_nombrepac,count(nombre) as todos   ;
	from mwktodos ;
	group by REG_nombrepac having todos>25;
	order by REG_nombrepac ;
	into cursor mwkcontrol

select mwkmedicos.nombre as profesional,mwktodos.nombre as solicitante, REG_nombrepac, fechatur,codreserva,codmedsoli,  ;
	count(codmed) as todos ,  ;
	sum(iif(confirmado = 0 or isnull(confirmado), 1, 0)) as falto,  ;
	sum(iif(confirmado = 1 , 1, 0)) as vino,codent,ENT_descrient ;
	from mwktodos left join mwkmedicos on codmed = mwkmedicos.id;
	left join mwkentidades on codent = ENT_codent;
	where REG_nombrepac in (select REG_nombrepac from mwkcontrol);
	group by REG_nombrepac, codmedsoli,codreserva,codmed  ;
	order by REG_nombrepac ;
	into cursor mwkdet25

select codreserva,  ;
	sum(iif(confirmado = 0 or isnull(confirmado) , 1, 0)) as falto  ;
	from mwktodos group by codreserva having falto>1 ;
	into cursor mwkfaltas

select mwkmedicos.nombre as profesional,mwktodos.nombre as solcitante, REG_nombrepac, ;
	confirmado ,fechatur,codreserva,codmedsoli,codent,ENT_descrient  ;
	from mwktodos left join mwkmedicos on codmed = mwkmedicos.id;
	left join mwkentidades on codent = ENT_codent;
	where codreserva in (select codreserva from mwkfaltas);
	order by REG_nombrepac, codreserva, fechatur desc;
	into cursor mwkdetfaltas

create cursor faltas ;
	(paciente c(50), profesional c(50), solicitante c(50),entidad c(50), reserva c(15);
	, presen n(2), ausen n(2),aband n(2))
select mwkdetfaltas
go top
mcodres= codreserva
mprof= profesional
msolic = solcitante
mpaciente = REG_nombrepac
presentes = 0
ausentes = 0
ment = ENT_descrient
abandono = 0
lvino = .f.
do while !eof()
	do while mcodres= codreserva and !eof()
		if confirmado =1
			lvino = .t.
		endif
		presentes =presentes +iif(confirmado =1 ,1,0)
		ausentes =ausentes +iif(confirmado =0 or isnull(confirmado),1,0)
		abandono = abandono + iif((confirmado =0 or isnull(confirmado)) and !lvino ,1,0)
		skip
	enddo
	insert into faltas(paciente , profesional , solicitante ,entidad, reserva ;
		, presen , ausen,aband) values (mpaciente , mprof,msolic ,ment,mcodres,presentes ;
		,ausentes ,abandono )

	mcodres= codreserva
	mprof= profesional
	msolic = solcitante
	mpaciente = REG_nombrepac
	ment = ENT_descrient
	presentes = 0
	ausentes = 0
	abandono = 0
	lvino = .f.

enddo


brow
