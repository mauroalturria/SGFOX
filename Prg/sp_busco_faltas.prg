*********************************************************************************
* Ejecuta el cursor de prestaciones, trae el codigo y la descripción ordenada *
* por descripción para listar combos                                            *
*********************************************************************************

parameter mnroregis

mfecdes = sp_busco_fecha_serv('DD') - 30
mfechas = sp_busco_fecha_serv('DD')

mret = sqlexec(mcon1,"select count(afiliado) as ausentes " + ;
						"FROM Turnos " + ;
						"where afiliado = ?mnroregis and " + ;
							"fechatur >= ?mfecdes and " + ;
							"fechatur < ?mfechas and  " + ;
							"confirmado = 0 and tipoturno < 9", "mwkausente")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif