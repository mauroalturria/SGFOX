Parameters registracio


Do sp_busco_estados With 7,' and Estado = 1 and Tipo  = 111 ','mwkcnxdb'

If Used('mwkcnxdb')
	If Reccount("mwkcnxdb")>0
	Else
*	Messagebox("Problema con la conexión a la base",16,"Error 2")
		Return .F.
	Endif
Else
*	Messagebox("Problemas con la conexión a la base de datos",16,"Error 1")
	Return .F.
Endif

Select mwkcnxdb

Scan All
	Do Case
	Case mwkcnxdb.subestado = 1
		miServidor = Alltrim(mwkcnxdb.Descrip)
	Case mwkcnxdb.subestado = 2
		miBase = Alltrim(mwkcnxdb.Descrip)
	Case mwkcnxdb.subestado = 3
		miUsuario = Alltrim(mwkcnxdb.Descrip)
	Case mwkcnxdb.subestado = 4
		miClave = Alltrim(mwkcnxdb.Descrip)
	Otherwise
		Return .F.
	Endcase
Endscan

Use In Select("mwkcnxdb")

lstring = "DRIVER={InterSystems ODBC};SERVER="+miServidor+";PORT=1972;DATABASE="+miBase+";UID="+miUsuario+";PWD="+miClave+";"

nConn = Sqlstringconnect(lstring)

If nConn  < 1
	Return .F.
	*Messagebox( "Error al conectar a la base de datos: " + Message(),16,"Error en conexión")
Endif

If Vartype(registracio)="N"
	mreg = registracio
Else
	mreg = 0
Endif

If mreg = 0
	SQLDisconnect(nConn)
	Return .F.
Endif

ldevuelvo = .F.

Sql = "select * from MDB.ZabHomoloVale where Registracion = " + Transform(mreg)

valor = SQLExec(nConn,Sql,"mwkHomoloVale")

If valor < 1
*	Messagebox("Problemas con la conexión a tabla de homologación",16,"Error 3")
	SQLDisconnect(nConn)
	Return .F.
Endif

If Used("mwkHomoloVale")
	If Reccount("mwkHomoloVale")>0
		ldevuelvo = .T.
	Endif
Endif

SQLDisconnect(nConn)

Return ldevuelvo

