****
** Busco modulos
****
lparameters mbusco
if vartype(mbusco)#"C"
	mbusco = ''
endif
mret = sqlexec(mcon1, "SELECT * FROM TabPModulo &mbusco order by descripcion ", "mwkmod")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif