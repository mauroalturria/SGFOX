*
* Borro maestro WS Anmat Tabla Mysql
*
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

mret = sqlexec(mconM,"delete from tbl_conftmp")

If mret < 0
	MTABLA = "ANMAT OPERACIONES NO CONFIRMADAS"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

=sqldisconnect(mconM)

Return .T.
