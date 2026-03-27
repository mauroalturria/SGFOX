*
* Busqueda WS Anmat Tabla Mysql
* Previamente se llamo al método WSANMAT del FRMFARMACIA42
*
*Lparameters muser, mfecmov, mtipol

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

Use in select("mwkwsanmat")

If At("172.16.1.225",mwktabcfg.Oleserver) = 0 && El 225 es para el Curso de Capacitación
	mret = sqlexec(mconM,"select * from tbl_conftmp","mwkwsanmat")
Else
	mret = sqlexec(mconM,"select * from tbl_conftmpcurso","mwkwsanmat")
Endif

If mret < 0
	MTABLA = "ANMAT OPERACIONES NO CONFIRMADAS"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

=sqldisconnect(mconM)

Use in select("mwkgtin")
mret = sqlexe(mcon1,"select * from TabTraGTIN" ,"mwkgtin")

If mret < 0
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("Error al consultar GTIN de Producto",26,"Error")
	Return .F.
Endif

Return .T.

