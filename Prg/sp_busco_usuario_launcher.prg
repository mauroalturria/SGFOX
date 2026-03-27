****
** busco usuario para Lanzador
****
lparameters miusulaucher
ldisconnec = .f.
if !used("mwkserver1")
	do sp_conexion
	ldisconnec = .t.
endif

mfecpas = ctod('01/01/1900')
if type('miusulaucher')#'C'
	miusupc = upper(sys(0))
	miusulaucher = alltrim(substr(miusupc,at("#",miusupc )+1,20))
*	messagebox(miusupc +"   _   " +miusulaucher )
endif
mret = sqlexec(mcon1, 'select * from tabusuario  where fecpasiva = ?mfecpas '+;
	' and idusuario = ?miusulaucher ', 'mwkusuLauncher')
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
if ldisconnec 
	do sp_desconexion 
endif
