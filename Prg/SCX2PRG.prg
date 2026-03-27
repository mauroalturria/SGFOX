*-----------------------------------------------------------
* FUNCTION SCX2PRG(tcForm, tcFile)
*-----------------------------------------------------------
* Pasa todos los métodos de un formulario y sus controles a
* un archivo de procedimientos.
* PARAMETROS:
*    tcForm: Ruta y nombre del formulario (.SCX)
*    tcFile: Ruta y nombre del archivo a generar (.PRG)
* AUTOR: LMG
* USO: SCX2PRG("C:\FORMS\FORM1.SCX", "C:\PRGS\METODOS.PRG")
*-----------------------------------------------------------
FUNCTION SCX2PRG(tcForm, tcFile)
  tcForm = FORCEEXT(tcForm, "SCX")
  IF NOT FILE(tcForm)
        MESSAGEBOX("El archivo" + CR + tcForm ;
      + CR + "no existe.", 16, "Aviso")
    RETURN .F.
  ENDIF
  IF EMPTY(tcFile)
    *--- Por defecto genera un PRG  con el
    *--- mismo nombre que el formulario
    tcFile = tcForm
  ENDIF
  tcFile = FORCEEXT(tcFile, "PRG")
  SET TEXTMERGE TO (tcFile) NOSHOW
  SET TEXTMERGE ON
  USE (tcForm) ALIAS MiScx
  \***********************************
  \*** METODOS DEL FORMULARIO
  \*** <<UPPER(tcForm)>>
  \***********************************
  SCAN ALL
    IF NOT EMPTY(MiScx.methods)
      \*-----------------------------------------------
      \*-- <<MiScx.objname>> -- (<<MiScx.Baseclass>>)
      \*------------------------------------------------
      \<<MiScx.methods>>
    ENDIF
  ENDSCAN
  USE IN MiScx
  \***********************************
  \*** FINAL DEL ARCHIVO
  \***********************************
  SET TEXTMERGE OFF
  SET TEXTMERGE TO
  RETURN .T.
ENDFUNC