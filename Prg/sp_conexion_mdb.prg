*!*		If !sp_conexion_mdb() && GMDB
*!*			Return .f.
*!*		Endif 

*!*		If !sp_desconexion_mdb()&& GMDB
*!*			Return .f.
*!*		Endif 

Parameters tbShow

If Parameters() < 1
	tbShow = .t.
Endif 	
lcStringConnect = "Driver={MariaDB ODBC 3.1 Driver};Server= 172.16.50.111;Port=3306;Database=CATALOGO-DEV;Uid=root;Pwd=kodokan;"

If VarType(GMDB)="U"
	Public GMDB
Endif 

GMDB = Sqlstringconnect(lcStringConnect)

If tbShow And GMDB <= 0
	Messagebox("ERROR AL CONECTARSE AL SERVIDOR DE DATOS",16,"ERROR")
	Return .F.
Endif 


Return .T.