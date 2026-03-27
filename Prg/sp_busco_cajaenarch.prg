PARAMETERS mcaja

mret = sqlexec(mcon1, "SELECT * from TabHciarchivo where hca_orden = ?mcaja","mwkCajaArch")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif