PARAMETERS midUsuario

mret = sqlexec(mcon1, "select IdEstado,IdUsuario,Tabpestado.tipo from tabpDetusuario,Tabpestado "+;
	"where idUsuario = ?midUsuario and Tabpestado.ID = IdEstado ", "mwkEstxUsuario")
 if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif