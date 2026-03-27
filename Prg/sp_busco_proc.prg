PARAMETERS mid,mtipo


mSql = IIF(EMPTY(mid) and EMPTY(mtipo),'',IIF(EMPTY(mid) and !EMPTY(mtipo)," where tipo = ?mtipo", +;
 IIF(!EMPTY(mid) and EMPTY(mtipo),"Where id = ?mid "," WHERE tipo = 2 and id = ?mid ")))

mret = sqlexec(mcon1,"select * from TabGcproc " + mSql + " order by CodigoProc" , "mwkTabGcprocDeno")

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif