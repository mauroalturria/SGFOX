*
* Conecta a Motor MySQL
*
Lparameters mserver, muid, mpwd, mdatabase

mconM = Sqlstringconnect("Driver=MySQL ODBC 3.51 Driver;"+;
	"Server = " + mserver + ";" +;
	"UID = " + muid + ";" +;
	"PWD = " + mpwd +";" +;
	"Database = " + mdatabase)

If mconM < 0
	MTABLA = "CONECCION MYSQL"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Else
	=SQLSetprop(mconM,"Transactions",2)
	=SQLSetprop(mconM,"Asynchronous",.F.)
Endif

Return .T.
