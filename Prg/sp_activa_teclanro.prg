*
* Teclado Numérico, verificar Estado & 1:Activar/0:Desactivar
*
Lparameters monoff
If vartype(monoff) <> "N"
	monoff = 1
Endif
= NUMLOCK(iif(monoff=1,.T.,.F.))

*!*	Versión 2 para usar con API y poder implementar con otras caracteristicas
*!* de teclado
*!*	Declare INTEGER GetKeyState IN "user32";
*!*		LONG nVirtKey
*!*	mKey = 144
*!*	mest = GetKeyState(mKey)
*!*	If mest = 0
*!*		= NUMLOCK(.T.)
*!*		Wait windows "Teclado Numérico Activado" nowait
*!*	Endif

Return
