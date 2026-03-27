** Marcelo Torres, 12/11/2015
** Grabamos el log de Cuidados 

PARAMETERS mForm,nVale

nIdCuidado = mForm.pidcuidado

*!*	** Buscamos fecha de modificacion mas alta.
*!*	mret = SQLExec(mcon1,"select TCS_fecmov from TabCuiDomSoli where ID = ?nIdCuidado","mwkctrlf")

*!*	If mret < 0
*!*		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*		Messagebox("EN LA CONSULTA TABLA TABCUIDOMSOLI - LOG." +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
*!*		Return .F.
*!*	Endif

*!*	mFec = Dtot({//})
*!*	If Used("mwkctrlf")
*!*		If Reccount("mwkctrlf")>0
*!*			mFec = mwkctrlf.TCS_fecmov
*!*		Endif
*!*	Endif

*!*	If !Empty(mFec)

** Hacemos el log de las indicaciones
mret = SQLEXEC(mcon1,"insert into TabCuiDomIndiLg (" + ;
       "tcil_cantidad,tcil_codinsumo,tcil_codpuntero,tcil_codvale,tcil_desde,tcil_dosis,tcil_frecuencia,tcil_hasta," + ;
       "tcil_idsolic,tcil_indicacion,tcil_pasivado,tcil_usuario) " + ;
       "select " + ;
       "tci_cantidad,tci_codinsumo,tci_codpuntero,tci_codvale,tci_desde,tci_dosis,tci_frecuencia,tci_hasta," + ;
       "tci_idsolic,tci_indicacion,tci_pasivado,tci_usuario from TabCuiDomIndi " + ;
       "where tci_idsolic = ?nIdCuidado and TCI_pasivado = '1900-01-01'")

If mret < 0
   MTABLA = "CUIDADOS DOMICILIARIOS INDICACIONES - LOG"
   Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
   Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
   Return .F.
ENDIF

RETURN .t.

