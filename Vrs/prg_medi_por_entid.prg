******
** XLS de entidades, medico, afiliado y nombre del afiliado
******

do sp_conexion

mfec1 = ctod('01/01/2003')
mfec2 = ctod('31/01/2003')

mret = sqlexec(mcon1, 'select ent_descrient, nombre, afi_nroafiliado, reg_nombrepac ' + ;
                      'from entidades, prestadores, turnoshis, afiliacion, registracio ' + ;
                 		'where afiliado = registracio.registracio and ' + ;
                 		'afiliado = afiliacion.registracio and ' + ;
                   		'codent = afi_codentidad and ' + ;
						'codent = ent_codent and ' + ;
                        'codmed = prestadores.id and ' + ;
                        'afiliado > 0 and tipoturno < 9 and confirmado = 1 and ' + ;
                        'fechatur >= ?mfec1 and fechatur <= ?mfec2 and ' + ;
                        'codent in(484, 945, 948, 972, 973, 974, 975) ' + ;
                        'order by ent_descrient', 'mwktodos')

copy to Enero2003 type xls
                       
**  (945, 974, 972, 973, 484, 483, 975, 948)
                       
= sqldisconnect(mcon1)