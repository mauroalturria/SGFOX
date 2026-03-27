*
* Busqueda datos en ValesAsist contando con fecha y nro. protocolo
*
Lparameters mfecha,mproto

If used('mwkvalpro')
	Use in mwkvalpro
Endif

mret = sqlexec(mcon1,"select * from valesasist"+;
	" where VAL_fechasolicitud = ?mfecha"+;
	" and VAL_nroprotocolo = ?mproto","mwkvalpro")

If mret < 0
	=aerror(merror)
	Messagebox("EN CONSULTA MAESTRO DE VALES"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
Endif

