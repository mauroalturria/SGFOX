*
* Exportar XLSX a ...
*
* URL : formatos de exportacion 
* http://msdn.microsoft.com/en-us/library/office/bb241279(v=office.12).aspx
*
* Alternativas:
*				1 Como Save As y Append
*				2 Como SELECT del XLSX y Copy To
*

malter = 1

If malter = 1

	marchivo = "c:\TURNOS_31.07_A_mañana.xlsx"
	mexporta = "C:\temp\turnos.xls"

*-  Abrir
	oExcel = CreateObject("Excel.Application")
	oWorkbook = oExcel.Application.Workbooks.Open(marchivo)

*-  Guardar
	If val(oExcel.Version) > 11
		oWorkbook.SaveAs(mexporta, 39) && Version 5
	Else
		oWorkbook.SaveAs(mexporta)
	Endif

	oExcel.Quit
	
	Release oWorkbook, oExcel
	
*-  Exportar

	Create cursor anula (TELEFONO n(10) ,;
		RTA c(20)      ,;
		CONFIRMA c(20) ,;
		CANCELA c(20)  ,;
		NOMBRE c(50)   ,;
		HCLIN c(20)    ,;
		N_REF n(10)    ,;
		FECHA_TURNO D  ,;
		TIPO_TEL c(20) ,;
		FECHA_LLAMADO D,;
		TURNO c(20))
		
	Select anula 
	go bottom
	
	Append FROM (mexporta) TYPE XL5	
	
	Browse

Else

	Local lcXLBook As String, lnSQLHand As Integer, ;
		lcSQLCmd As String, lnSuccess As Integer, ;
		lcConnstr As String

	lcXLBook = "c:\TURNOS_31.07_A_mañana.xlsx"

*   lcXLBook = Getfile('xls, xlsx, xlsm, xlsb', 'Archivo:', 'Aceptar', 0, 'Seleccione una hoja de cálculo')

	If Empty(lcXLBook)
		Return .F.
	Endif

	If !File(lcXLBook)
		Messagebox("Archivo no encontrado", 16)
		Return .F.
	Endif

	m.oExcel = Createobject("Excel.application")

	If Vartype(oExcel,.T.)!='O'
		Messagebox("No se puede procesar el archivo porque no tiene la aplicación" ;
			+ Chr(13) + "Microsoft Excel instalada en su computador.", 16)
		m.oExcel = Null
		Release oExcel
		Return .F.
	Endif

	m.oExcel.Workbooks.Open(m.lcXLBook)
	m.oExcel.Sheets(1).Select

	Local oSheet As Object, lcSheet As String
	m.oSheet = m.oExcel.ActiveSheet
	m.lcSheet = m.oSheet.Name

	m.oExcel.Quit()
	m.oExcel = Null
	Release oSheet, oExcel

	lcConnstr = [Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=] + lcXLBook
	lnSQLHand = Sqlstringconnect( lcConnstr )

	lcSQLCmd = [Select * FROM "] + m.lcSheet + [$"]
	lnSuccess = SQLExec( lnSQLHand, lcSQLCmd, [xlResults] )

	If lnSuccess < 0
		Local Array laErr[1]
		Aerror( laErr )
		Messagebox(laErr(3), 16)
		SQLDisconnect( lnSQLHand )
		Return .F.
	Endif

	Select TELEFONO,left(RTA,20) as RTA,left(CONFIRMA,20) as CONFIRMA, left(CANCELA,20) as CANCELA, left(NOMBRE,50) as NOMBRE,;
		left(HCLIN,20) as HCLIN, N_REF,FECHA_TURNO, left(TIPO_TEL,20) as TIPO_TEL , FECHA_LLAMADO, left(TURNO,20) as TURNO;
		from xlResults into cursor xlResults

	Select xlResults
	Copy TO c:\temp\anula.dbf

	SQLDisconnect(lnSQLHand)

Endif
