PARAMETERS midUsuario
mret = sqlexec(mcon1, "select IdEstado,IdUsuario from tabpDetusuario where idUsuario = ?midUsuario ", "mwkEstxUsuarioTimer")

if mret < 0
	messagebox("ERRORsp_busco_EstaxUsuaTimer de LECTURA , Reintente", 48, "Validacion")
endif