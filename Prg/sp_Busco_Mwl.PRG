Lparameters tcWhere, tcCursor

If Vartype(tcCursor)#"C"
	tcCursor = "mwkMWL"
Endif

If Vartype(tcWhere)#"C"
	tcWhere = ""
Endif
nintento = 0
Do While nintento <10
	mret = SQLExec(mcon1,"Select * from Dbo.MWL " + tcWhere, tcCursor)

	If mret <= 0
		mierr = Error()
		mimsg =  TRANSFORM(nintento)+ "-"+Message()
		mimsg1 = Message(1)
		miprg = Program()
		miline =  Lineno()
		nintento = nintento +1
		Do sp_desconexion
		Do sp_conexion With mwkexe.nomexe
	Else
		Return .T.
	Endif
Enddo
Do Log_errores With mierr ,mimsg ,mimsg1 ,miprg ,miline
Return .f.
