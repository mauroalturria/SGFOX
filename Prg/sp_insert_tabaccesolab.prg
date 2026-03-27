****
** grabo un movimiento cuando Accede a Infhos
****

parameter mtausuario,mqueusu,mnroregis,msesion

if vartype(mqueusu) # "N"
	mqueusu = 0
endif
if vartype(msesion) # "C"
	msesion = .null.
endif
if vartype(mnroregis) # "N"
	mtaregIngre = mwkTCS.id
else
	mtaregIngre = mnroregis
endif
mtafecha 	= sp_busco_fecha_serv('DT')
mret = sqlexec(mcon1, "insert into tabAccesoLab( Activo, FechaHora, RegistroIngreso, Sesion , Usuario,IdUsuario ) "+;
	"values( 0, ?mtafecha , ?mtaregIngre, ?msesion, ?mtausuario, ?mqueusu )")
	
If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE ACCESO",48,"VALIDACION")
* 	Return .f.
Endif  	
	
mret = sqlexec(mcon1, "select max(id) as idacceso from tabAccesoLab where Activo=0 and FechaHora = ?mtafecha "+;
	" and RegistroIngreso = ?mtaregIngre and Usuario = ?mtausuario and IdUsuario = ?mqueusu  ","mwkctrlacclab")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  