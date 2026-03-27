*
* Buscar relaciones Entidades (archivos) y Destinatarios
*
Lparameters mentidad

Use In Select("mwkentrel")
mfnull = CTOD("01/01/1900")

mret = SQLExec(mcon1,"select * from TabCensosRel"+;
" where TCR_identidad = ?mentidad and TCR_fechapasiva = ?mfnull","mwkentrel")

If mret < 0
	MTABLA = "RELACION ENTIDAD/DESTINOS"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Use In Select("mwkinfarch")
mret = SQLExec(mcon1,"select * from TabCensosArch"+;
" where TCA_identidad = ?mentidad and TCA_fechapasiva = ?mfnull","mwkinfarch")

If mret < 0
	MTABLA = "CENSOS ARCHIVOS A INFORMAR"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
