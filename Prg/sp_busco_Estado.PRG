*******
* Busco estados de presupuestos
*****
Lparameters mbusca, mcCursor

If vartype(mbusca) # "C"
	mbusca = " and tabpestado.tipo < 2"
Endif

If Vartype(mcCursor) # "C"
	mcCursor = "mwkEstado"
Endif 

mret = sqlexec(mcon1, "select * from TabPestado where id <> 1 " + mbusca, mcCursor)

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
	