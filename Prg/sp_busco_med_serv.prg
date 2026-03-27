****
**  busco los medicos a partir de un servicio en medpresta
****

parameter mcodserv
mfecnul = ctod("01/01/1900")
mfechas= sp_busco_fecha_serv('DD')+ 1
mret = sqlexec(mcon1, "select prestadores.id, prestadores.nombre, tabmensaje.mensaje " + ;
	"from medpresta, prestadores " + ;
	"left outer join tabmensaje on prestadores.id = tabmensaje.codmed " + ;
	"and tabmensaje.fecbaja = ?mfecnul  " + ;
	"where (fecpasivap = ?mfecnul or fecpasivap > ?mfechas)  and  medpresta.codmed = prestadores.id and " + ;
	"(prestadores.estado = 1 or fecpasiva > ?mfecturno) " + ;
	"and medpresta.codserv = ?mcodserv " + ;
	"group by medpresta.codmed order by nombre", "mwkmedserv")


if mret < 1
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",48,"Validacion")
	cancel
endif
