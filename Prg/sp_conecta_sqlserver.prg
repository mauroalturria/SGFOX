
* Si quiero probar, paso como parametro .t.
* Caso contrario, conecta al sql server
* 29/10/2025 - Parametro lSinValExe para que pueda ejecutar un sp sin validar el ejecutable.

Lparameters lPrueba, lSinValExe
If Vartype(lPrueba)<>"L"
	lPrueba = .F.
ENDIF
If Vartype(lSinValExe)<>"L"
	lSinValExe= .F.
Endif
If lPrueba

*Set Step On
	PruebaSql()

Else

* Set Step On

	Return ConexionSql(lSinValExe)

Endif


* ---------------------------------
Function ConexionSql(lSinValExe)

Local lcStringConn
Local cDriver
Local cError
Local cApp
Local oIn
Local cExe

* Si no está definido en el SETEO de la aplicación, saltamos la conexión sqlserver
If Type("mconSql") = "U"
	Public mconSql
Endif
If Type("pHabSqlServer") = "U"
	Public pHabSqlServer
Endif

cApp = ""

If !lSinValExe

*   verificar si la app está habilitada para ejecutar SqlServer
	Do sp_busco_estados With 57," and tipo = 77 and estado = 1 ", "mwkconsqlserver"

	Select mwkconsqlserver
	Scan All

		cApp = cApp + Alltrim(mwkconsqlserver.Descrip)+","

	Endscan

	Use In Select("mwkconsqlserver")

	If Len(cApp) > 0

		cApp = Substr(cApp,1,Len(cApp)-1)

		Alines( aExe, cApp,",")

		cExe = Transform(mwkexe.idexe)

		For Each oIn In aExe

			If oIn =  cExe
				pHabSqlServer = .T.
				Exit
			Endif

		Next

	Endif

	mconSql = 0

Else

*   No validamos el EXE. Conecta igual.
	pHabSqlServer = .T.

Endif


If !pHabSqlServer
	Return 0
Endif

* conectamos al servidor sqlserver
lcStringConn = ""

Do sp_busco_estados With 57," and tipo = 66 and estado = 1 ","mwkConSql"

If Used("mwkConSql")

	Select mwkConSql
	Go Top

	Scan All

		lcStringConn = Alltrim(mwkConSql.Descrip)

	Endscan

	Use In Select("mwkConSql")

Endif

If !Empty(lcStringConn)

*** ---------------- quitar!!! solo prueba
* lcStringConn = "Driver={ODBC Driver 17 for SQL Server};PORT=1433;SERVER=sqldev.serv.sca.local;DATABASE=CATALOGO_DESA;Uid=mtorres;Pwd=nee4fEw7s9KhpFGQbL4z"
*** ----------------------------------------

	mconSql = Sqlstringconnect(lcStringConn)

	If mconSql  <= 0

		mconSql = 0

		Aerror(laError)
*? "Error de conexión:", laError[2]
		Messagebox("ERROR AL CONECTAR CON EL SERVIDOR SQLSERVER" + Chr(10)+ "Mensaje de error: " + laError[2],48,"VALIDACION Sql Server")

	Endif

Else

	Messagebox("Error al obtener el CONNECTION STRING del SQL Server","Sql Server")

Endif

Return mconSql



* ---------------------------------
Procedure PruebaSql()

If ConexionSql() > 0

*Messagebox("CONECTADO AL SERVIDOR",48,"VALIDACION")

	If Used('mwkdemo')
		Use In mwkdemo
	Endif

	mRet = SQLExec(mconSql, "SELECT TOP 10 * FROM [CATALOGO_DESA].[SQLUser].[ZabAbManual] ORDER BY ID DESC", "mwkdemo")

	Select mwkdemo
	Go Top

*!*		Scan All

*!*			Messagebox("campo convertido - " + Cpconvert(850,1252,mwkdemo.zam_drogas) )

*!*		Endscan

	Browse

	If mRet < 0
		Messagebox("ERROR EN LA CONSULTA",48,"VALIDACION")
	Else

		Select * From mwkdemo

	Endif

	Do sp_desconecta_sqlserver

Else

	Messagebox("no se conectó al servidor")

Endif

**mcon1 = Null

Close Databases

Return


