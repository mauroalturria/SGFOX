*********
*	Busqueda de usuarios autorizados
*********
parameters mCodigovax

mret = SQLEXEC(mcon1,"select * from tabpusuario "+;
	"where Codigovax = ?mCodigovax ","mwkUsuarioPres")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
