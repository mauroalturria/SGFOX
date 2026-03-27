*
* Cambio de Paciente en Partidas sin movimientos (por asignacion de paciente erroneo)
*
Lparameters mpartida, mregistracio

mret = sqlexec(mcon1,"update TabFarmCitosP"+;
	" set TCP_registracio = ?mregistracio"+;
	" where TCP_partida = ?mpartida")

If mret < 0
	Messagebox("ACTUALIZACION DE PACIENTE MAESTRO DE PARTIDAS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
