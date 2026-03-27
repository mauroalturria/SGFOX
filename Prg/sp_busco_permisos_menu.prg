****
** Busco los usuarios que tienen acceso a un formulario
****

parameter midform

mfecpas = ctod('01/01/1900')

mret = sqlexec(mcon1, "select  tabusuario.* from tabusuario " + ;
	" left join  tabpermisosfrm on tabpermisosfrm.codusuario = tabusuario.id " + ;
	" where codfrm = ?midform and " + ;
	" tabpermisosfrm.fecpasiva = ?mfecpas group by tabusuario.id order by nomape "+;
	"", "mwkusuarios")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion") 
	DO sp_desconexion WITH "error"
	CANCEL
endif	