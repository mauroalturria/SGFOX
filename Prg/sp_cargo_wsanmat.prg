*
* Cargo maestro WS Anmat Tabla Mysql - Pendientes de Transacción
*

*Set step on
*SET ENGINEBEHAVIOR 70
*Do sp_conexion

mconM = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver;"+;
	"Server=172.16.1.3;"+;
	"UID=root;"+;
	"PWD=kodokan;"+;
	"Database=trazabilidad")

If mconM > 0
	=SQLSETPROP(mconM,"Transactions",2)
	=SQLSETPROP(mconM,"Asynchronous",.F.)
Else
	MTABLA = "ANMAT CONECCION MYSQL"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mret = sqlexec(mconM,"select * from tbl_conftmp","mwkpp")

If mret < 0
	MTABLA = "ANMAT OPERACIONES NO CONFIRMADAS"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select * from mwkpp where len(alltrim(id_transaccion))<4 into cursor mwkpp2
Select mwkpp2
Go top
Scan all
	mlid = mwkpp2.id
	mret = sqlexec(mconM,"delete from tbl_conftmp where id = ?mlid")
	If mret < 0
		MTABLA = "ANMAT OPERACIONES NO CONFIRMADAS"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif
Endscan

Select * from mwkpp where len(alltrim(id_transaccion))>4 into cursor mwkpp3

Select mwkpp3
Go top
Scan all

	mlid = mwkpp3.id
	mlgt = mwkpp3.gtin
	mlse = mwkpp3.nro_serial
	mlot = mwkpp3.lote

	Use in select("mwkctrl")

	mret = sqlexec(mcon1,"select * from tabtramov"+;
		" where TTM_transcod > 0 and TTM_gtin = ?mlgt and TTM_serie = ?mlse and TTM_lote = ?mlot","mwkctrl")

	If mret < 0
		MTABLA = "ANMAT OPERACIONES NO CONFIRMADAS"
		Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	If used("mwkctrl")
		If reccount("mwkctrl")>0
			mret = sqlexec(mconM,"delete from tbl_conftmp where id = ?mlid")
			If mret < 0
				MTABLA = "ANMAT OPERACIONES NO CONFIRMADAS"
				Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
				Return .F.
			Endif
		Endif
	Endif
	Select mwkpp3

Endscan

=sqldisconnect(mconM)

*Close databases

Return .T.

*!*	*!*	Id
*!*	*!*	FECHA EVENTO
*!*	*!*	FECHA TRANSAC.
*!*	*!*	GTIN
*!*	*!*	LOTE
*!*	*!*	NRO SERIAL
*!*	*!*	NOMBRE
*!*	*!*	DETALLE
*!*	*!*	GLN ORIGEN
*!*	*!*	RAZON SOCIAL ORIGEN
*!*	*!*	FACTURA	11
*!*	*!*	REMITO	12
*!*	*!*	VENCIMIENTO	13
*!*	*!*	ESTADO
