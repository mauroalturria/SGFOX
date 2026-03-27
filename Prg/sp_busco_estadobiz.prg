*
*
*

Lparameters mbusca

If vartype(mbusca) # "C"
	mbusca = " and tabpestado.tipo < 2"
Endif

mret = sqlexec(mcon1, "select cast(0 as integer ) as elegido , descripcion,id"+;
	" from TabPestado where descripcion <> '' " + mbusca+ " order by descripcion", "mwkEstado")

If mret < 0
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validación")
Endif
