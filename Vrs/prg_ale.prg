****
*	do sp_conexion
	susp

	do while !eof('mwktodos')

		mid = mwktodos.id
		mcm = mwktodos.codmed
		mft = mwktodos.fechatur
		mht = mwktodos.horatur
		mtt = mwktodos.tipoturno
	
		mret = sqlexec(mcon1,'update turnos set tipoturno = ?mtt ' + ;
							'where id = ?mid and codmed = ?mcm and ' + ;
								'fechatur = ?mft and horatur = ?mht')
								
		skip 1 in mwktodos
	
	enddo