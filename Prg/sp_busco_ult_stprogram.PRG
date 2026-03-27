Parameters tcIp

mRet = Sqlexec(mcon1,"Select Top 1 * from TabStProgram where Pg_Ip = ?tcIp Order by Id desc","mwkFechaProc")

If mRet <= 0
	Messagebox("ERROR EN LA LECTURA DE PROGRAMAS",48,"VALIDACION")
	Return .f.
Endif 
