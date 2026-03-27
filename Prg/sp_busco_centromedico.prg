Parameters lcm
lmdisconnec = .F.
Use In Select('mwkcm')
If !Used("mwkserver1")  AND mxambito =1
	Do sp_conexion
	lmdisconnec = .T.
Endif
mret = SQLExec(mcon1,"select * from tabestados "+;
	" where propietario = 1 and tipo = 5 and estado = ?lcm "  , "mwkcm")
If lmdisconnec
	Do sp_desconexion
Endif

If mret<=0
	Messagebox("ERROR EN LA LECTURA DE TABESTADOS. CURSOR : " + mCursor,26,"ERROR")
*	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return ''
Else
	Return Alltrim(mwkcm.Descrip)
Endif

