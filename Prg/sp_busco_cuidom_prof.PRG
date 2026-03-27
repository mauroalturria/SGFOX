*
* Cuidados Domiciliarios Profesionales / Prestadores
*
Lparameters mverpas

If Vartype(mverpas) <> "N"
	mverpas = 0
Endif

mfnull = Ctod("01/01/1900")

Use In Select("mwkcdprof")
Use In Select("mwkp1")
Use In Select("mwkp2")
Use In Select("mwkp3")

&& Profesionales

mret = SQLExec(mcon1,"Select Prestadores.nombre as lnombre,"+;
	" Especialid.ESP_descripcion as ldesc,"++;
	" TabCuiDomProf.TDP_direccion,"+;
	" TabCuiDomProf.TDP_localidad,"+;
	" TabCuiDomProf.TDP_pasivado,"+;
	" TabCuiDomProf.TDP_telpar,"+;
	" TabCuiDomProf.TDP_telcel,"+;
	" TabCuiDomProf.TDP_email,"+;
	" TabCuiDomProf.id as lid,"+;
	" TabCuiDomProf.TDP_tipo,"+;
	" Tabloca.descrip as lloca,"+;
	" TabCuiDomProf.TDP_idmaestro,"+;
	" TabCuiDomProf.TDP_userweb,"+;
	" TabCuiDomProf.TDP_passweb"+;
	" From TabCuiDomProf" +;
	" Inner Join Prestadores" +;
	" On Prestadores.Id = TabCuiDomProf.TDP_idmaestro And Prestadores.fecpasiva = ?mfnull" +;
	" Inner Join Especialid "+;
	" On Especialid.ESP_codesp = Prestadores.codesp" +;
	" Left outer Join Tabloca "+;
	" On TabLoca.id = Prestadores.codloca"+;
	" Where TDP_tipo = 1 "+;
	IIF(mverpas = 0, " And TDP_pasivado = ?mfnull", ""),"mwkp1")

If mret < 0
	MTABLA = "PROFESIONALES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

&& Enfermeria

mret = SQLExec(mcon1,"Select TabUsuario.nomape as lnombre,"+;
	" TabUsuario.descrip as ldesc,"+;
	" TabCuiDomProf.TDP_direccion,"+;
	" TabCuiDomProf.TDP_localidad,"+;
	" TabCuiDomProf.TDP_pasivado,"+;
	" TabCuiDomProf.TDP_telpar,"+;
	" TabCuiDomProf.TDP_telcel,"+;
	" TabCuiDomProf.TDP_email,"+;
	" TabCuiDomProf.id as lid,"+;
	" TabCuiDomProf.TDP_tipo,"+;
	" 'C.A.B.A.        ' as lloca,"+;
	" TabCuiDomProf.TDP_idmaestro,"+;
	" TabCuiDomProf.TDP_userweb,"+;
	" TabCuiDomProf.TDP_passweb"+;
	" From TabCuiDomProf" +;
	" Inner Join TabUsuario "+;
	" On TabUsuario.descrip like '%ENFER%' "+;
	" And TabUsuario.fecpasiva = ?mfnull "+;
	" And Tabusuario.id = TabCuiDomProf.TDP_idmaestro" +;
	" Where TDP_tipo = 2"+;
	IIF(mverpas = 0, " And TDP_pasivado = ?mfnull", ""),"mwkp2")

If mret  < 0
	MTABLA = "ENFERMERIA"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

&& Prestadores Externos

mret = SQLExec(mcon1,"select TabCuiDomProf.TDP_prestador as lnombre,"+;
	" 'PRESTADOR EXTERNO' as ldesc,"+;
	" TabCuiDomProf.TDP_direccion,"+;
	" TabCuiDomProf.TDP_localidad,"+;
	" TabCuiDomProf.TDP_pasivado,"+;
	" TabCuiDomProf.TDP_telpar,"+;
	" TabCuiDomProf.TDP_telcel,"+;
	" TabCuiDomProf.TDP_email,"+;
	" TabCuiDomProf.id as lid,"+;
	" TabCuiDomProf.TDP_tipo,"+;
	" 'C.A.B.A.        ' as lloca,"+;
	" TabCuiDomProf.TDP_idmaestro,"+;
	" TabCuiDomProf.TDP_userweb,"+;
	" TabCuiDomProf.TDP_passweb"+;
	" From TabCuiDomProf" +;
	" Where TDP_tipo = 3"+;
	Iif(mverpas = 0, " And TDP_pasivado = ?mfnull", ""),"mwkp3")

If mret  < 0
	MTABLA = "PRESTADORES EXTERNOS"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select * From mwkp1 ;
	Union Select * From mwkp2 ;
	Union Select * From mwkp3 ;
	Into Cursor mwkcdprof

Select lnombre, LEFT(ldesc,50) as ldesc, TDP_direccion, TDP_localidad, ;
	IIF(TDP_pasivado = Ctod("01/01/1900"), {//}, TDP_pasivado) As TDP_pasivado, ;
	TDP_telpar, TDP_telcel, TDP_email, lid, TDP_tipo, lloca, TDP_idmaestro,TDP_userweb,TDP_passweb ;
	From mwkcdprof Into Cursor mwkcdprof

Use In Select("mwkp1")
Use In Select("mwkp2")
Use In Select("mwkp3")

Return .T.
