parameters mid
mret = sqlexec(mcon1, "SELECT idusuario ,fecalta,valor "+;
	"FROM TabPModAudit left join tabusuario on tabusuario.codigovax = TabPModAudit.usuario "+;
	" where IdModulo = ?mid  " , "mwkBuscoPrecio")

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
