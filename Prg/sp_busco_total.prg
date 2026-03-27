PARAMETERS midPres,mNum

mret = sqlexec(mcon1," select idpres from tabpauditoria "+;
	"where idPres = ?midPres ","mwkTotalRegAudi")


if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif