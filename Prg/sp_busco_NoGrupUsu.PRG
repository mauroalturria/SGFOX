*
* Busqueda de Usuarios de pertenencia al EXE requerido, que no tienen grupo asignado
*
Parameters lbusexe

melexe = lbusexe
mfecnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"select tabusuario.nomape,tabusuario.id,tabusuario.descrip " +;
	"from tabusuario,tabpermisosexe,tabexe "  +;
	"where TabUsuario.Id not in (select TabGcUsugrup.IdUsuario from TabGcUsugrup where fecactiva<>?mfecnull) and " +;
	"tabpermisosexe.codusuario = tabusuario.id  and tabpermisosexe.codexe = tabexe.id " +;
	"and tabusuario.fecpasiva = ?mfecnull and tabexe.nomexe=?melexe " +;
	"and tabpermisosexe.fecpasiva = ?mfecnull " +;
	"and tabexe.fecpasiva = ?mfecnull and tabusuario.id<10000000 " +;
	"group by tabusuario.id order by nomape","mwkGrupUsu")

If mret <= 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	Cancel
Endif
