****
** Busco Listado
****

Parameter mnroSP 
if mnroSP>0
	mret = sqlexec(mcon1, "SELECT Dato,NroListado,Secuencia FROM SPListados " + ;
		" where NroListado = ?mnroSP" + ;
		" order by Secuencia ", "mwklistado")
else
	mret = sqlexec(mcon1, "SELECT Dato,NroListado,Secuencia FROM SPListados " + ;
		" where Secuencia = 0 " + ;
		" order by NroListado desc ", "mwklistado")
endif
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
endif