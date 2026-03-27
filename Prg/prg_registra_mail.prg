Parameters pidusuario,pnombre

*** PARA PROBAR ***
*!*	pidusuario = 6926
*!*	pnombre = 'MORALES ENRICA AMANDA'
*!*	Do sp_conexion
*** ----------------------- ***

Do sp_busco_estados With 57,'  and tipo = 50 and estado = 1  ','mwkURL'

lnexiste =0
If !Reccount('mwkURL')>0
	Return .F.
Endif

murl = Alltrim(mwkURL.Descrip)

parametros = Strconv('usuario='+Transform(pidusuario)+'&nombre='+Alltrim(pnombre)+'&visual=S',13)

lclink = murl + parametros

lcnavegador1 = 'C:\program files (x86)\Google\Chrome\Application\Chrome.exe'

If File(lcnavegador1)
	lcnavegador = lcnavegador1
	lnexiste=1
Endif

If lnexiste>0
	Declare Integer ShellExecute In "Shell32.dll" ;
		INTEGER HWnd, ;
		STRING lpVerb, ;
		STRING lpFile, ;
		STRING lpParameters, ;
		STRING lpDirectory, ;
		LONG nShowCmd
	=ShellExecute(0,"Open",lcnavegador ,lclink,"",0)
Else
	o = Createobject("Shell.Application")
	o.Open(lclink)
Endif




*!*	Parameters pidmedico,pnombremedico

*!*	*** PARA PROBAR ***
*!*	*!*	pidmedico = 1975
*!*	*!*	pnombremedico = 'MORALES ENRICA AMANDA'
*!*	*!*	Do sp_conexion
*!*	*** ----------------------- ***

*!*	Do sp_busco_estados With 57,'  and tipo = 50 and estado = 1  ','mwkURL'

*!*	If !Reccount('mwkURL')>0
*!*		Return .F.
*!*	Endif

*!*	murl = Alltrim(mwkURL.Descrip)

*!*	parametros = Strconv('codmed='+Transform(pidmedico)+'&medico='+Alltrim(pnombremedico),13)

*!*	lclink = murl + parametros

*!*	lcnavegador1 = 'C:\program files (x86)\Google\Chrome\Application\Chrome.exe'

*!*	If File(lcnavegador1)
*!*		lcnavegador = lcnavegador1
*!*		lnexiste=1
*!*	Endif

*!*	If lnexiste>0
*!*		Declare Integer ShellExecute In "Shell32.dll" ;
*!*			INTEGER HWnd, ;
*!*			STRING lpVerb, ;
*!*			STRING lpFile, ;
*!*			STRING lpParameters, ;
*!*			STRING lpDirectory, ;
*!*			LONG nShowCmd
*!*		=ShellExecute(0,"Open",lcnavegador ,lclink,"",0)
*!*	Else
*!*		o = Createobject("Shell.Application")
*!*		o.Open(lclink)
*!*	Endif
