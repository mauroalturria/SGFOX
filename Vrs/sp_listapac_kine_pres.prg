****
** listado de ausentismo de foniatria
****

parameter mfechades, mfechahas, mcodesp
do sp_conexion
 mfechades= ctod("01/11/2007")
 mfechahas= ctod("31/01/2008")
 mfechacorte = date()   &&&ctod("01/02/2007")
 mcodesp = "KINE"
mret =sqlexec(mcon1,"SELECT ent_descrient, ent_codent FROM entidades ","MWKEntidades")


mret = Sqlexec(mcon1,"SELECT nombre, id " + ;
	"FROM Prestadores, Medpresta " + ;
	"WHERE medpresta.codmed = prestadores.id " + ;
	"group by nombre " + ;
	"ORDER BY Nombre", "mwkmedicos")


mret = sqlexec(mcon1, "select fechatur, horatur, codreserva, confirmado, " + ;
	"reg_nombrepac, reg_nrohclinica,afiliado,codmedsoli,codmed,turnos.CODENT,fechatomado,fechaconfirma " + ;
	"from turnos, registracio,entidexclu " + ;
	"where fechatur >= ?mfechades and fechatur <= ?mfechahas and " + ;
	"turnos.codesp = ?mcodesp and " + ;
	"turnos.codent = entidexclu.codent and " + ;
	"afiliado = reg_nroregistrac " + ;
	"group by codreserva, fechatur", "mwktodos2")

if mret<0
	=aerr(eros)
	messagebox(eros(3))
	set step on
endif
select * from  mwktodos2,MWKEntidades where  ent_codent=codent into cursor mwktodos

select distinct reg_nombrepac, reg_nrohclinica,ent_descrient from mwktodos where confirmado = 0 into cursor mwkfalto
select distinct reg_nombrepac, reg_nrohclinica,ent_descrient from mwktodos into cursor mwkfafi
do sp_desconexion
 