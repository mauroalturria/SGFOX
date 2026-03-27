*
* Pasivacion Censos Relaciones
*
Lparameters mentidad,mAltaPac,mCensosXlt,mAdmisionXls,mwkTabla2

mfHoy = sp_busco_fecha_serv('DD')
muser = mwkusuario.idusuario
mret = 0
mIdDestino = 0

** ----------- Pasivamos los destinatarios borrados

mret = SQLExec(mcon1,"select * from TabCensosRel where TCR_identidad = ?mEntidad and TCR_fechapasiva = '1900-01-01'","mwkCensosRelLg")

If mret < 0
	MTABLA = "CENSOS RELACION DESTINATARIOS"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN CONSULTA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select a.Tcr_iddestino,b.lid ;
	FROM mwkCensosRelLg As a ;
	left Join &mwkTabla2. As b On a.TCR_iddestino = b.lid ;
	WHERE b.lId is Null Into Cursor mwkTabla3

Select mwkTabla3
Go Top

Scan All

	mIdDestino = mwkTabla3.TCR_iddestino

	mret = SQLExec(mcon1,"update TabCensosRel set"+;
		" TCR_fechapasiva  = ?mfHoy, "+;
		" TCR_fecmov       = ?mfHoy, "+;
		" TCR_idusuario    = ?muser "+;
		" where TCR_iddestino = ?mIdDestino and TCR_identidad = ?mentidad and TCR_fechapasiva = '1900-01-01' " )

**" where TCR_identidad = ?mentidad")

	If mret < 0
		MTABLA = "CENSOS RELACION DESTINATARIOS"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endscan

** ----------- Verificamos si pasivamos los tipos de archivos a enviar.
If mAltaPac = 1
	mret = SQLExec(mcon1,"update TabCensosArch set"+;
		" TCA_fechapasiva  = ?mfHoy, "+;
		" TCA_fecmov       = ?mfHoy, "+;
		" TCA_idusuario    = ?muser "+;
		" where TCA_identidad = ?mentidad and TCA_tipo = 'ALTAPAC' ")
Endif

If mCensosXlt = 1
	mret = SQLExec(mcon1,"update TabCensosArch set"+;
		" TCA_fechapasiva  = ?mfHoy, "+;
		" TCA_fecmov       = ?mfHoy, "+;
		" TCA_idusuario    = ?muser "+;
		" where TCA_identidad = ?mentidad and TCA_tipo = 'CENSOSXLT' ")
Endif

If mAdmisionXls = 1
	mret = SQLExec(mcon1,"update TabCensosArch set"+;
		" TCA_fechapasiva  = ?mfHoy, "+;
		" TCA_fecmov       = ?mfHoy, "+;
		" TCA_idusuario    = ?muser "+;
		" where TCA_identidad = ?mentidad and TCA_tipo = 'ADMISIONXLT' ")
Endif

If mret < 0
	MTABLA = "CENSOS ARCHIVOS A INFORMAR"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.

