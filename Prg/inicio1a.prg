lparameters cservidor, cbase
_screen.visible = .f.
_screen.caption = "Sanatorio Güemes - Lanzador de Aplicaciones"

Set Path To SCX, LIB, MNU, PRG, EXE, BMP, REP

if !yaactiva()
	do seteos_launcher
	borratemp()
	do form launcher02
	read events
	_vfp.autoyield = .t.   && displaya bien los refrescos en actualziaciones
endif

return
*--------------------------------------------------------
* FUNCTION IsActive(tcCaption)
*--------------------------------------------------------
* Verifica si una aplicación ya está activa
* USO: ? IsActive("Calculadora")
*--------------------------------------------------------
function isactive(tccaption)
	declare integer FindWindow in WIN32API ;
		string cNULL, ;
		string cWinName
	return findwindow(0, tccaption) # 0
endfunc

*--------------------------------------------------------
* FUNCTION YaActiva()
*--------------------------------------------------------
* Ejemplo de uso de IsActive:
* Comprueba que la aplicación no se esta ejecutando
* Invoca a IsActive() descripta anteriormente
*--------------------------------------------------------
function yaactiva()
	local llret, lccaption
	llret = .f.
	lccaption = _screen.caption
	*--- Renombra temporariamente el caption de la app
	_screen.caption = "_" + lccaption
	if isactive(lccaption)
		*--- Si ya esta activo
		messagebox(lccaption+chr(13)+"ya está activo"+chr(13)+"Seleccionelo de la barra de Windows",16,"Aviso")
		llret = .t.
	endif
	_screen.caption = lccaption
	return llret
endfunc

*--------------------------------------------------------
* FUNCTION BorraTemp()
*--------------------------------------------------------
* Borra los temporales del disco C
*--------------------------------------------------------
function borratemp()
	dimen mima[1]
	local cfiles,ncantfiles ,i ,cfil
	if directory('c:\tmp')
		cfiles = 'c:\tmp\*.*'
		adir(mima,cfiles)
		ncantfiles = alen(mima,1)
		for i=1 to ncantfiles
			on error borraerror(error(),message())
			cfil = 'c:\tmp\' + mima(i,1)
			delete file (cfil )
			on error 			&& devuelve el control del error al sistema
		endfor
	endif
	if directory('c:\windows\temp')
		cfiles = 'c:\windows\temp\*.*'
		adir(mima,cfiles)
		ncantfiles = alen(mima,1)
		for i=1 to ncantfiles
			on error borraerror(error(),message())
			cfil = 'c:\windows\temp\'  + mima(i,1)
			delete file (cfil )
			on error 			&& devuelve el control del error al sistema
		endfor
	endif
endfunc

function borraerror()
	lparameters  nerror, mess1
	*!*		IF nERROR # 2030
	*!*			MESSAGEBOX("ERROR - " + str(nerror)+" - " + mess1 ,48,"Aviso")
	*!*		ENDIF
endfunc
