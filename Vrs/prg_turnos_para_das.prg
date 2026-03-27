******
** XLS de entidades, medico, afiliado y nombre del afiliado
******

do sp_conexion

mfec1 = ctod('17/06/2003')
mfec2 = ctod('31/12/2003')

mret = sqlexec(mcon1, 'select nombre, reg_nombrepac, reg_nrohclinica, horatur, ' + ;
						'codreserva, pre_descriprest, reg_telefonos ' + ;
                      'from prestacions, prestadores, turnos, registracio ' + ;
                 		'where afiliado = registracio.registracio and ' + ;
                 		'codprest	= pre_codprest and ' + ;
                   		'codmed		= prestadores.id and ' + ;
                        'afiliado > 0 and tipoturno < 9 and ' + ;
                        'fechatur >= ?mfec1 and  ' + ;
                        'codent in(905, 910) and ' + ;
                        'turnos.codesp = "OFTA" ' + ;
                        'order by nombre, horatur', 'mwktodos')

copy to Das_1706 type xls
                       
**  (945, 974, 972, 973, 484, 483, 975, 948)
                       
= sqldisconnect(mcon1)