*
* Fecha Proceso WS ANMAT busco ultima fecha procesada ó actualizo - maestros MySql
*
Lparameters mtarea, mfechad

If Vartype(mtarea) <> "C"  && Consultar
	mtarea= "C"
Endif

If Vartype(mfechad) <> "C" && Fecha del Dia en caracteres
	mfechad = Dtoc(sp_busco_fecha_serv('DD'))
Endif

mconM = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver;"+;
	"Server=172.16.1.3;"+;
	"UID=root;"+;
	"PWD=kodokan;"+;
	"Database=trazabilidad")

If mconM > 0
	=SQLSetprop(mconM,"Transactions",2)
	=SQLSetprop(mconM,"Asynchronous",.F.)
Else
	MTABLA = "ANMAT CONECCION MYSQL"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If mtarea = "C"
	Use In Select("mwkfecpro")
	mret = SQLExec(mconM,"select * from tbl_fechapro","mwkfecpro")
Else
	mret = SQLExec(mconM,"update tbl_fechapro set fechapro = ?mfechad","mwkfecpro")
Endif

If mret < 0
	mltabla = "ANMAT CONECCION MYSQL FECHA DE PROCESO PENDIENTES"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	=SQLDisconnect(mconM)
	Return .F.
Endif

=SQLDisconnect(mconM)

Return .T.


