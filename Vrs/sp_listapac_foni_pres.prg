****
** listado de ausentismo de foniatria
****

parameter mfechades, mfechahas, mcodesp
*do sp_conexion
 mfechades= ctod("01/01/2008")
* mfechahas= ctod("31/10/2006")
 mfechacorte = date()   &&&ctod("01/02/2007")
 mcodesp = "FONI"
mret =sqlexec(mcon1,"SELECT ent_descrient, ent_codent FROM entidades ","MWKEntidades")


mret = Sqlexec(mcon1,"SELECT nombre, id " + ;
	"FROM Prestadores, Medpresta " + ;
	"WHERE medpresta.codmed = prestadores.id " + ;
	"group by nombre " + ;
	"ORDER BY Nombre", "mwkmedicos")


*!*	mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
*!*		"reg_nombrepac, afiliado,codmedsoli,codmed,CODENT,fechatomado,fechaconfirma " + ;
*!*		"from turnoshis as turnos, registracio " + ;
*!*		"where fechatur >= ?mfechades and " + ;
*!*		"turnos.codesp = ?mcodesp and " + ;
*!*		"afiliado = reg_nroregistrac and confirmado =1 " + ;
*!*		"group by codreserva, fechatur", "mwktodos1")

mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
	"reg_nombrepac, reg_nrohclinica,afiliado,codmedsoli,codmed,CODENT,fechatomado,fechaconfirma " + ;
	"from turnos, registracio " + ;
	"where fechatur >= ?mfechades and " + ;
	"turnos.codesp = ?mcodesp and " + ;
	"afiliado = reg_nroregistrac " + ;
	"group by codreserva, fechatur", "mwktodos2")

if mret<0
	=aerr(eros)
	messagebox(eros(3))
	set step on
endif
&&	"fechatur <= ?mfechahas " + 
&& and confirmado =1 

	select * from mwktodos2;
		into cursor mwktodos

*!*	select * from mwktodos1;
*!*		union all ;
*!*		select * from mwktodos2;
*!*		into cursor mwktodos

*!*	select * from mwktodos where fechatur >= mfechacorte into cursor futuro
*!*		afiliado not in (select afiliado from mwktodos where fechatur >= mfechacorte );
*!*		into cursor mwkcuales
*!*	select * from mwktodos where ;
*!*		afiliado in (select afiliado from mwktodos where fechatur >= mfechacorte ) and ;
*!*		afiliado not in (select afiliado from mwktodos where fechatur >= mfechacorte );
*!*		into cursor mwkcuales

select * from mwktodos where fechatur >= mfechacorte into cursor futuro

select * from mwktodos where ;
	afiliado in (select afiliado from futuro ) and ;
	fechatur < mfechacorte and confirmado =1 ;
	into cursor anteriores
select count(*) as turnos_fut,afiliado,reg_nombrepac ,reg_nrohclinica from futuro group by afiliado into cursor cuantoshay
select count(*) as turnos_pres,afiliado,reg_nrohclinica from anteriores group by afiliado into cursor cuantoshubo
select * from cuantoshay left join cuantoshubo ;
on cuantoshubo.afiliado = cuantoshay .afiliado ;
into cursor turnos_foni

 