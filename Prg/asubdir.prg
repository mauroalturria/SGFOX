*-----------------------------------------------------------------
* FUNCTION ASubDir(taArray, tcRoot)
*-----------------------------------------------------------------
* Devuelve en un array pasado por referencia todos los nombres de
* archivos del directorio "tcRoot" y de todos sus subdirectorios.
* Los nombres son de la forma: [Unidad]:\[Directorio]\[Archivo]
* RETORNO: Cantidad de archivos en el array. Si no encontró ningún
*    archivo o el directorio "tcRoot" no existe, retorna 0 (cero)
* EJEMPLO DE USO:
    DIMENSION laMiArray[1]
    lnC = ASubDir(@laMiArray, "C:\Mis Documentos")
    FOR lnI = 1 to lnC
       ? laMiArray[lnI]
    ENDFOR
*-----------------------------------------------------------------
FUNCTION asubdir(taarray, tcroot)
IF EMPTY(tcroot)
	tcroot = SYS(5) + CURDIR()
ENDIF
DIMENSION taarray[1]
=arecur(@taarray, tcroot)
IF ALEN(taarray) > 1
	DIMENSION taarray[ALEN(taArray) - 1]
	RETURN ALEN(taarray)
ELSE
	RETURN 0
ENDIF
ENDFUNC
*-----------------------------------------------------------------
* FUNCTION ARecur(taArray, tcRoot)
*-----------------------------------------------------------------
* Funcion recursiva llamada por ASubDir
*-----------------------------------------------------------------
FUNCTION arecur(taarray, tcroot)
PRIVATE lni, lncant, laaux
tcroot = ADDBS(tcroot)
lncant = ADIR(laaux, tcroot+"*.*", "D")
FOR lni = 1 TO lncant
	IF "D" $ laaux[lnI, 5]
		IF laaux[lnI, 1] == "." OR laaux[lnI, 1] == ".."
			LOOP
		ELSE
			lcsubdir = tcroot + laaux[lnI, 1]
			=arecur(@taarray, lcsubdir)
			LOOP
		ENDIF
	ENDIF
	taarray[ALEN(taArray)] = tcroot + laaux[lnI, 1]
	DIMENSION taarray[ALEN(taArray) + 1]
ENDFOR
RETURN
ENDFUNC
*-----------------------------------------------------------------
