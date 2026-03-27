****
** listado de ausentismo de foniatria
****

parameter mfechades, mfechahas, mcodesp
do sp_conexion
 mfechades= ctod("01/01/2005")
 mfechahas= ctod("31/05/2005")
 mfechacorte = ctod("30/11/2004")
 mcodesp = "FONI"
mret =sqlexec(mcon1,"SELECT ent_descrient, ent_codent FROM entidades ","MWKEntidades")


mret = Sqlexec(mcon1,"SELECT nombre, id " + ;
	"FROM Prestadores, Medpresta " + ;
	"WHERE medpresta.codmed = prestadores.id and " + ;
	"(estado = 1 or fecpasiva > ?mfechahas )  " + ;
	"group by nombre " + ;
	"ORDER BY Nombre", "mwkmedicos")


mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, cast(fechatomado as date) as ftom,  " + ;
	"nombre, reg_nombrepac, afiliado,codmedsoli,codmed,CODENT,fechatomado,fechaconfirma " + ;
	"from turnoshis as turnos, registracio, afiliacion, prestadores " + ;
	"where afiliado > 0 and fechatur >= ?mfechades and " + ;
	"turnos.codesp = ?mcodesp and codmedsoli = prestadores.id and " + ;
	"fechatur <= ?mfechahas and " + ;
	"tipoturno < 9 and " + ;
	"afiliado = afiliacion.registracio and codent = afi_codentidad and " + ;
	"afiliacion.registracio = registracio.reg_nroregistrac " + ;
	"order by codreserva, fechatur", "mwktodos1")

mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, cast(fechatomado as date) as ftom,  " + ;
	"nombre, reg_nombrepac, afiliado,codmedsoli,codmed,CODENT,fechatomado,fechaconfirma " + ;
	"from turnos, registracio, afiliacion, prestadores " + ;
	"where afiliado > 0 and fechatur >= ?mfechades and " + ;
	"turnos.codesp = ?mcodesp and codmedsoli = prestadores.id and " + ;
	"fechatur <= ?mfechahas and " + ;
	"tipoturno < 9 and " + ;
	"afiliado = afiliacion.registracio and codent = afi_codentidad and " + ;
	"afiliacion.registracio = registracio.reg_nroregistrac " + ;
	"order by codreserva, fechatur", "mwktodos2")

mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, cast(1 as integer) as confirmado, cast(fechatomado as date) as ftom, " + ;
	"nombre, reg_nombrepac, afiliado,codmedsoli,codmed,codent,fechatomado,feccancela  as fechaconfirma " + ;
	"from turnoscancel as turnos, registracio, afiliacion, prestadores " + ;
	"where afiliado > 0 and fechatur <= ?mfechahas and fechatur >= ?mfechades and " + ;
	"turnos.codesp = ?mcodesp and codmedsoli = prestadores.id and " + ;
	"codcancela  = 6 and " + ;
	"afiliado = afiliacion.registracio and codent = afi_codentidad and " + ;
	"afiliacion.registracio = registracio.reg_nroregistrac " + ;
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
	"fechatur < ?mfechaDES and " + ;
	"fechatur > ?mfechacorte and " + ;
	"tipoturno < 9  " + ;
	"group by codreserva", "mwkfuera2")
select * from mwkfuera1;
	union all ;
	select * from mwkfuera2;
	into cursor mwkfuera

select *,1 as tur from mwktodos1 where codreserva not in (select codreserva from mwkfuera) ;
	union all ;
	select *,1 as tur from mwktodos2 where codreserva not in (select codreserva from mwkfuera) ;
		union all ;
		select *,0 as tur from mwktodos3 where codreserva not in (select codreserva from mwkfuera) ;
		into cursor mwktodos

select reg_nombrepac as np,ttod(fechatomado) as ft,confirmado  ;
	from mwktodos ;
	into cursor mwkfaltas01

select np,ft,  ;
	sum(iif(confirmado = 0 , 1, 0)) as falto  ;
	from mwkfaltas01 group by np,ft having falto>0 ;
	into cursor mwkfaltas

select mwkmedicos.nombre as profesional,mwktodos.nombre as solcitante, reg_nombrepac, ;
	confirmado ,tur,fechatur,codreserva,codmedsoli  ,codent,ent_descrient,ftom ;
	,ttod(fechaconfirma) as Fechacon ;
	from mwktodos;
	left join mwkmedicos on mwktodos.codmed = mwkmedicos.id;
	left join mwkentidades on mwktodos.codent = ent_codent;
	order by reg_nombrepac, ftom, fechatur desc;
	into cursor mwktodoss

select *,sum(iif(confirmado = 0 , 1, 0)) as falto,  ;
 		sum(iif(confirmado = 1 , 1, 0)) as vino, ;
 		sum(iif(tur = 0 , 1, 0)) as canc, ;
 		sum(1) as total from mwktodoss;
	group by reg_nombrepac having canc=0 and falto>1 	into cursor mwkdetfaltas

select mwktodoss.*,dtos(mwktodoss.ftom) as fto ,dtos(mwktodoss.fechatur) as ft from mwktodoss,mwkdetfaltas; 
		where  mwkdetfaltas.reg_nombrepac =mwktodoss.reg_nombrepac ;
		order by mwktodoss.reg_nombrepac, mwktodoss.ftom, mwktodoss.fechatur ;
		into cursor mwkdetcancel

create cursor faltas ;
	(paciente c(50), profesional c(50), solicitante c(50), entidad c(50), reserva D;
	, presen n(2), ausen n(2),aband n(2),codres c(200))
select mwkdetfaltas
select mwktodoss
go top
mcodres= ftom
mmcodres= codreserva
mprof= profesional
msolic = solcitante
mpaciente = reg_nombrepac
ment = ent_descrient
presentes = 0
ausentes = 0
abandono = 0
lvino = .f.
do while !eof()
	do while mcodres= ftom and !eof()
		mmcodres= mmcodres+ iif(mmcodres= codreserva,""," "+codreserva)
		if confirmado =1
			lvino = .t.
		endif
		presentes =presentes +iif(confirmado =1 ,1,0)
		ausentes =ausentes +iif(confirmado =0 ,1,0)
		abandono = abandono + iif(confirmado =0 and !lvino ,1,0)
		skip
	enddo
	insert into faltas(paciente , profesional , solicitante , entidad, reserva ;
		, presen , ausen,aband,codres) values (mpaciente , mprof,msolic,ment ,mcodres,presentes ;
		,ausentes ,abandono,mmcodres )

	mcodres= ftom
	mmcodres= codreserva
	mprof= profesional
	msolic = solcitante
	mpaciente = reg_nombrepac
	ment = ent_descrient
	presentes = 0
	ausentes = 0
	abandono = 0
	lvino = .f.

enddo


brow
