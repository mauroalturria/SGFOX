PARAMETERS mRevid


mSql = IIF(EMPTY(mRevid),''," where idRelac = ?mRevid")
mret = sqlexec(mcon1,"select * from TabGcproc " + mSql + " order by CodigoProc" , "mwkTabGcprocDeno")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif