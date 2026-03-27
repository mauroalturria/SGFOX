parameters midDoc

mret = sqlexec(mcon1," SELECT TabGcvincproc.revision,TabGcvincproc.fecha,TabGcproc.codigoproc "+;
	" FROM TabGcproc "+;
	"inner  join TabGcvincproc on TabGcvincproc.iddoc = TabGcproc.id "+;
	"where  idDoc = ?midDoc","mwkGcvincproc" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
