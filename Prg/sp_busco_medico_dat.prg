*************************************************************
* Datos medicos
**************************************
Parameters mimed

If mimed>9999
	mret = SQLExec(mcon1," SELECT ID , nombre,matricula,gerenciadora,codesp, CAST(1 as integer) as codprof  FROM TabMedExterno " + ;
	" where id = ?mimed", "mwkbusmed" )
	mmatb = Transform(mwkbusmed.matricula)
	mifecnul = Ctod("01/01/1900")
	mifecha = sp_busco_fecha_serv("DD")-60
	mret =SQLExec(mcon1,'SELECT Prestadores.*, Tabproffiltro.TPF_filtro FROM prestadores '+;
	' LEFT OUTER JOIN Tabproffiltro ON Tabproffiltro.TPF_codmed = Prestadores.ID '+;
	' WHERE Prestadores.matriculas =?mmatb order by fecpasivap ','MwkDatMed')
	If Reccount('MwkDatMed')=0
		If mwkbusmed.gerenciadora = 222  &&& medicos OSDE
			mret =SQLExec(mcon1,'SELECT tabpreregmed.*, CAST(0 AS INTEGER) as TPF_filtro FROM tabpreregmed '+;
			' where matriculas = ?mmatb ','MwkDatMed')
		Else
			mret =SQLExec(mcon1,'SELECT tabpreregmed.*, CAST(6 AS INTEGER) as TPF_filtro FROM tabpreregmed '+;
			' where matriculas = ?mmatb ','MwkDatMed')
		Endif
		If Reccount('mwkbusmed')= 0
			Messagebox('PROFESIONAL PASIVO EN LA INSTITUCION NO SE IMPRIMEN SUS DATOS ',64,'VALIDACION')
		Endif
	Endif
Else
	mret =SQLExec(mcon1,'SELECT Prestadores.*, Tabproffiltro.TPF_filtro FROM prestadores '+;
	' LEFT OUTER JOIN Tabproffiltro ON Tabproffiltro.TPF_codmed = Prestadores.ID '+;
	' WHERE Prestadores.id =?mimed order by fecpasivap ','MwkDatMed')
Endif
If mret < 0
	Messagebox('ERROR DE CURSOR. Ingrese nuevamente',64,'VALIDACION')
	Do prg_cancelo
Endif
