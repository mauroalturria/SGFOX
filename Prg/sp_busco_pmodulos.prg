****
** Busco Condiciones de Pago
****

mret = sqlexec(mcon3, "SELECT ID,Descripcion,Detalle,Plantilla,Valor,FechaUA "+;
		"FROM TabPModu" , "mwkmod")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
