***
*** Búsqueda de código telefónicos
***
lparameters mlegajo
mfecnull=ctod("01/01/1900")
if used('mwkcodigo')
	use in mwkcodigo
endif
mret = sqlexec(mcon3, "select * from TTcodigos " + ;
	"where IDlegajo = ?mlegajo and fechabaja=?mfecnull", "mwkcodigo")

*mret = sqlexec(mcon3, "select * from codigos " + ;
*						"where legajo = ?mlegajo ", "mwkcodigo")

if mret < 0
	mret = sqlexec(mcon3, "select * from TTcodigos " + ;
		"where IDlegajo = ?mlegajo ", "mwkcodigo0")
	if mret < 0
		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validación")
		do prg_cancelo
	else
		select * from mwkcodigo0 where fechabaja =mfecnull into cursor mwkcodigo
	endif
endif
