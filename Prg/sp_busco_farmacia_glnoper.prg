*
* Busqueda de GLN y OPERADOR - propietario Farmacia
*
Lparameters msubestado, mestado

Use in select("mwkglnoper")

mret = sqlexec(mcon1,"select * from Tabestados"+;
" where propietario = 31 and estado=?mestado and subestado=?msubestado","mwkglnoper")

If mret < 0
	Messagebox("ERROR EN CONSULTA OPERADOR/GLN TRAZABILIDAD",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
