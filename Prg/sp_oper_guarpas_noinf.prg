*
* Detalle de Guardias Pasivas No informadas para un fecha especifica
*
Lparameters mfecha

mfecha1 = dtos(mfecha)
mfecha  = left(mfecha1,4)+'-'+substr(mfecha1,5,2)+'-'+right(mfecha1,2)

Use in select("mwkctrl1")
Use in select("mwkctrl2")
Use in select("mwkctrl3")

MsqlCon = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver; Server=190.228.29.63; UID=cuiddom; PWD=cuiddom01; Database=guarpas")
*MsqlCon = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver; Server=localhost; UID=root; PWD=mysql01; Database=guarpas")

If MsqlCon > 0

	=SQLSETPROP(MsqlCon,"Transactions",2)
	=SQLSETPROP(MsqlCon,"Asynchronous",.F.)

*!* 1)CTRL ESPECIALIDADES (devuelve aquellas que no tienen asigando referente)

	mret = sqlexec(MsqlCon,"SELECT tblgpuser.idespe, tblgpespe.detalle "+;
		" FROM tblgpuser"+;
		" Join tblgpcargo on tblgpcargo.codigo = tblgpuser.idcarg"+;
		" Join tblgpespe on tblgpespe.codigo = tblgpuser.idespe"+;
		" where tblgpuser.idespe in ('ANES','CCVI','CARD','CIRC','CIRG','CGPE','CIRT','CIVP','CLIN' ,'GUAR','FARM',"+;
		" 'GAST','GINE','HEMD','DIAG','INFE','KINE','LABO','HEMO','NEFR','NEON','NEUM','NEUC','NECI','NEUR','OBST',"+;
		" 'OFTA','TRAU','OTOR','PEDI','SALM','UCIA','UROL','NUTR','CIRP','ENDC','HEMA','DIAB','DERM','ENFE')"+;
		" and tblgpuser.idespe not in (select tblgprefer.idespe from tblgprefer where tblgprefer.fecha = ?mfecha and estado = 'A')"+;
		" group by tblgpuser.idespe order by tblgpuser.idespe","mwkctrl1")

	If mret < 0
		MTABLA = "CONTROL DE ASIGNACION REFERENTES WEB"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

*!* 2)CTRL PEDIATRIA (igual a cero s/asignar)

	mret = sqlexec(MsqlCon,"SELECT idjefe, idespe, idsubespe"+;
		" FROM tblgprefer "+;
		" WHERE tblgprefer.fecha = ?mfecha "+;
		" and idespe = 'PEDI' "+;
		" and idsubespe in(1,2,3) and estado = 'A'","mwkctrl2")  && 1:UTIP 2:PISO 3:GUARDIA


	If mret < 0
		MTABLA = "CONTROL DE ASIGNACION REFERENTES WEB - PEDIATRIA"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

*!* 3)CTRL DIRECCION, LEGALES, AUDITORIA - DR. CASTAGNETO

	mret = sqlexec(MsqlCon,"SELECT apenom,detalle FROM tblgpuser"+;
		" Join tblgpcargo on tblgpcargo.codigo = tblgpuser.idcarg"+;
		" where tblgpuser.idcarg in (35,38,39,19) "+;
		" and tblgpuser.id not in (select tblgprefer.iduser from tblgprefer "+;
		" where tblgprefer.fecha = ?mfecha and estado = 'A')"+;
		" and tblgpuser.idusuario <> '' and tblgpuser.idespe = ''","mwkctrl3")

	If mret < 0
		MTABLA = "CONTROL DE ASIGNACION REFERENTES WEB - DIRECCION - AUDITORIA"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Else
	MTABLA = "ERROR EN CONEXION A TABLAS GUARDIAS PASIVAS WEB"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
