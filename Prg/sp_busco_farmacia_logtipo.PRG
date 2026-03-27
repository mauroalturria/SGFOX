*
* Busqueda de LOG de movimientos por tipo de movimiento
*
Lparameters mpartida, mtipo

Use in select("mwklogtp")

mret = sqlexec(mcon1,"select * from TabFarmLog"+;
	" where TFL_partida = ?mpartida and TFL_motivo like '%"+mtipo+"%'","mwklogtp")

If mret < 0
	Messagebox("CONSULTA LOG DE MOVIMIENTOS CITOSTATICOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
