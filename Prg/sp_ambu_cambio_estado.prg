*
* Actualizacion Tabambulatorio estado
*
Lparameters mprotocolo, mestado

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif 

mret = sqlexec(mcon1,"update tabambulatorio set codestado=?mestado"+;
	" where protocolo=?mprotocolo and nrovale = 0 " + mccpoamb )

If mret < 0
	Messagebox("EN ACTUALZIACION DE ESTADO EN AMBULATORIOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
