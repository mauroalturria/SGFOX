*
* Busqueda de categoria segun codigo Vax
*

Lparameters mcodvax, mcursor, mnivel

If vartype(mcursor)#"C"
	mcursor = "mwkbuscar"
Endif

If vartype(mnivel)#"N"
	mwhere = "TUC_codigovax = ?mcodvax"
Else
	mwhere = "TUC_nivel = ?mnivel"
Endif

mret = sqlexec( mcon1,"select * from TabUsuaCargo"+;
	" where "+mwhere,mcursor)

If mret < 0
	Messagebox("EN BUSQUEDA DE CATEGORIAS/CARGOS",16,"ERROR")
Endif
