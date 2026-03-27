Lparameters cservidor, cbase

If prg_modo_exe()
	_Screen.Visible = .F.
Endif

	
_Screen.Caption = "Sanatorio Güemes - Lanzador de Aplicaciones"

Public mxambito,mxcentromedico
mxambito = 1
mxcentromedico=1
On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
If !Directory("C:\temp\web")
	Mkdir "C:\temp\web"
Endif

If !Directory("C:\temp\Ambula")
	Mkdir "C:\temp\Ambula"
Endif
If !Directory("C:\temp\interna")
	Mkdir "C:\temp\interna"
Endif

If !Directory("C:\qepd1a1\exe\xfrx")
	Mkdir "C:\qepd1a1\exe\xfrx"
Endif
If !Directory("C:\tempHCE")
	Mkdir "C:\tempHCE"
Endif

If !Directory("C:\tempdoc")
	Mkdir "C:\tempdoc"
Endif

If !Directory("C:\temp\informes")
	Mkdir "C:\temp\informes"
Endif

If !Directory("C:\temp\imagenes")
	Mkdir "C:\temp\imagenes"
Endif
If !Directory("C:\temp\imagenes\firmas")
	Mkdir "C:\temp\imagenes\firmas"
Endif
If !Directory("C:\temp\guardia")
	Mkdir "C:\temp\guardia"
Endif
*do seteos_configuracion
*thisform.objetoambito(1)

If !yaactiva()
	Do seteos_launcher
	Set Enginebehavior 70
	dircopia = ' X:\anzios\pisos_hp\anziowin.def'
	dircache = ' C:\anzios\pisos_hp\anzio32d.exe'
	if file(dircache )
		dircache = ' C:\anzios\pisos_hp\anziowin.def'
		copy file &dircopia  to &dircache 
	endif
	borratemp()
	On Error Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Do Form launcher02
	Read Events
	_vfp.AutoYield = .T.   && displaya bien los refrescos en actualziaciones
Endif

Return
*--------------------------------------------------------
* FUNCTION IsActive(tcCaption)
*--------------------------------------------------------
* Verifica si una aplicación ya está activa
* USO: ? IsActive("Calculadora")
*--------------------------------------------------------
Function isactive(tccaption)
Declare Integer FindWindow In WIN32API ;
	string cNULL, ;
	string cWinName
Return FindWindow(0, tccaption) # 0
Endfunc

*--------------------------------------------------------
* FUNCTION YaActiva()
*--------------------------------------------------------
* Ejemplo de uso de IsActive:
* Comprueba que la aplicación no se esta ejecutando
* Invoca a IsActive() descripta anteriormente
*--------------------------------------------------------
Function yaactiva()
Local llret, lccaption
llret = .F.
lccaption = _Screen.Caption
*--- Renombra temporariamente el caption de la app
_Screen.Caption = "_" + lccaption
If isactive(lccaption)
*--- Si ya esta activo
	Messagebox(lccaption+Chr(13)+"ya está activo"+Chr(13)+"Seleccionelo de la barra de Windows",16,"Aviso")
	llret = .T.
Endif
_Screen.Caption = lccaption
Return llret
Endfunc

*--------------------------------------------------------
* FUNCTION BorraTemp()
*--------------------------------------------------------
* Borra los temporales del disco C
*--------------------------------------------------------
Function borratemp()
Dimen mima[1]
Local cfiles,ncantfiles ,i ,cfil
If Directory('c:\tmp')
	cfiles = 'c:\tmp\*.*'
	Adir(mima,cfiles)
	ncantfiles = Alen(mima,1)
	For i=1 To ncantfiles
		On Error borraerror(Error(),Message())
		cfil = 'c:\tmp\' + mima(i,1)
		Delete File (cfil )
		On Error 			&& devuelve el control del error al sistema
	Endfor
Endif
If Directory('c:\windows\temp')
	cfiles = 'c:\windows\temp\*.*'
	Adir(mima,cfiles)
	ncantfiles = Alen(mima,1)
	For i=1 To ncantfiles
		On Error borraerror(Error(),Message())
		cfil = 'c:\windows\temp\'  + mima(i,1)
		Delete File (cfil )
		On Error 			&& devuelve el control del error al sistema
	Endfor
Endif
Endfunc

Function borraerror()
Lparameters  nerror, mess1
*!*		IF nERROR # 2030
*!*			MESSAGEBOX("ERROR - " + str(nerror)+" - " + mess1 ,48,"Aviso")
*!*		ENDIF
Endfunc
