Parameters v_descriMot, midm

*********************************************************
*********************************************************
mret=SQLEXEC(mcon1,"insert into motivos values(?midm,?v_descriMot)")
If mret < 0
	Messagebox("No se puede acceder a algunos Datos",0+64,"Usuario")
	Return .f.
Else
	Messagebox("Se Actualizo la tabla, avisar a sistemas ",0+64,"Usuario")
	Return .t.
Endif
