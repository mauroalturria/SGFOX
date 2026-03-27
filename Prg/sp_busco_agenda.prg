****
**** Utilizado par a la busqueda de turnos
****
lparameters vr_medico,vr_fectur

mitiempo = seconds()
mret = sqlexec(mcon1, "select turnos.*, fechatur, horatur, codmed, " + ;
	"codserv, turnos.codesp, turnos.diasem, turnos.tipoturno, hhmmtur,  " + ;
	"prestadores.nombre " + ;
	"from turnos, prestadores " + ;
	"where turnos.codmed = prestadores.id and " + ;
	"turnos.codmed = ?vr_medico  and " + ;
	"turnos.afiliado <> 1 and " + ;
	"turnos.fechatur = ?vr_fectur " , "mwktur")

msql = "select  " + ;
	"iif(tipoturno = 0, '  ', iif(tipoturno = 1, 'SO', iif(tipoturno = 2, 'ST', " + ;
	"iif(tipoturno = 3, 'GI', iif(tipoturno = 4, 'ES', iif(tipoturno = 5, 'PS', " + ;
	"iif(tipoturno = 6, 'RE', 'PE'))))))) as tipoturno,  " + ;
	"left(ttoc(horatur,2), 5) as hora, " + ;
	"fechatur as fecha, " + ;
	"id, codmed, diasem, fechatur, horatur, codesp " + ;
	"from mwkturnos " + ;
	"order by fechatur, horatur, medico, tipoturno  into cursor mwkturnos2"



