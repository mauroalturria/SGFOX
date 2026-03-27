*********************************************************************************
* BUSCA Movimientos de la historia                                                    *
*********************************************************************************
lparameters mbusco,mbusco2

if type('mbusco2') # "C"
	mbusco2 = ''
endif

mret = sqlexec(mcon1,"SELECT TabHCIMovimientos.*,descripcion " + ;
	" FROM sdep,TabHCIMovimientos  " + ;
	" left outer join prestadores on TabHCIMovimientos .hci_codmed = prestadores.id "+;
	" WHERE hci_registrac = ?mbusco &mbusco2 and hci_codesp = sdep.codigo" +;
	" " , "mwkmovhist11" )

if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	cancel
endif


