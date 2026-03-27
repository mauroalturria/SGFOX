do sp_conexion
select vista4
scan
	if !empty(solucion)
		mid = id
		mSoluciones = strtran(Soluciones,"01/2007","01/2008")
		mSoluciones = strtran(mSoluciones,"02/2007","02/2008")
		mSoluciones = strtran(mSoluciones,"03/2007","03/2008")
		mSoluciones = strtran(mSoluciones,"04/2007","04/2008")
		mSoluciones = strtran(mSoluciones,"05/2007","05/2008")
		mSoluciones = strtran(mSoluciones,"06/2007","06/2008")
		mSoluciones = strtran(mSoluciones,"07/2007","01/2008")
		mSoluciones = strtran(mSoluciones,"08/2007","02/2008")
		mSoluciones = strtran(mSoluciones,"09/2007","03/2008")
		mSoluciones = strtran(mSoluciones,"10/2007","04/2008")
		mSoluciones = strtran(mSoluciones,"11/2007","05/2008")
		mSoluciones = strtran(mSoluciones,"12/2007","06/2008")
		mret = sqlexec(mcon1, "update  TabReclamos set Soluciones = ?mSoluciones where id = ?mid ")
		if mret<1
			=aerr(eros)
			messagebox(eros(3))
			set step on
		endif
	endif
endscan
do sp_desconexion


