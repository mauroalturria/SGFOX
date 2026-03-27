*---------------------------------------------------------------
* 2002 Eduardo M. Piován
* DEBUGGER Microsistemas
* debugger@co19set.com.ar
*
* Esta función, permite copiar y declarar fuentes en WINDOWS
*
* ENTRADAS:
* 			- Enviar un ARRAY POR REFERENCIA con la lista de archivos
*			  .TTF que se quieren instalar y declarar,
*			  INCLUIDO SU PATH
*			Además se pueden declarar archivos:
*				.FON .FNT .TTC .FOT .OTF .MMM .PFB .PFM
*
* NOTA: Dentro de la funcion se testea si la fuente ya fue instalada
* 
* Ejemplo de uso
* --------------
*	* Copia los archivos de la carpeta actual a un array
*	* ADIRX se puede descargar desde www.portalfox.org 
*	nCantFiles=ADIRX(arrFonts,"*.TTF",SYS(5)+CURDIR())
*	IF nCantFiles>0
*		=INSTALARFONTS( @arrFonts)
*	ENDIF
*
* DISTRIBUCION LIBRE Y GRATUITA 
*---------------------------------------------------------------
LPARAMETER arrFuentes

IF PCOUNT()#1
	RETURN .F.
ENDIF

* Aviso para el administrador de proyectos de que arrFuentes es un
* array
EXTERNAL ARRAY arrFuentes

LOCAL cWinDir,cFontDir,cFilename,x


declare integer AddFontResource;
   in gdi32 ;
   string @lpFileName


cWinDir=WINDIR()
cFontDir=cWinDir+"FONTS\"

FOR x=1 TO ALEN(arrFuentes,1)   
	* quito el camino del nombre de archivo
	cFilename=JUSTFNAME( arrFuentes(x) )
	

	* Verifico si el archivo .TTF ya fue copiado a la carpeta
	* FONTS del SO. Si es así, no hago nada
	IF !FILE(cFontDir + cFilename)
		COPY FILE ( arrFuentes(x) ) TO (cFontDir + cFilename)	
		=AddFontResource( cFontDir + cFilename )
	ENDIF
ENDFOR

RETURN



*--------------------------------------------------------
* FUNCTION WinDir()
*--------------------------------------------------------
* Retorna el directorio de Windows
* USO: ? WinDir() -> "C:\WINNT\"
*--------------------------------------------------------
FUNCTION WinDir()
    LOCAL lcPath, lnSize
    lcPath = SPACE(255)
    lnsize = 255
    DECLARE INTEGER GetWindowsDirectory IN Win32API ;
        STRING @pszSysPath,;
        INTEGER cchSysPath
    lnSize = GetWindowsDirectory(@lcPath, lnSize)
    IF lnSize <= 0
        lcPath = ""
    ELSE
        lcPath = ADDBS(SUBSTR(lcPath, 1, lnSize))
    ENDIF
    RETURN lcPath
ENDFUNC