Lparameters mcidvale,mccprest
If myip= '172.16.1.7'
	Set Step On
Endif
If Vartype(mccprest)#"C"
	mccprest= ""
Else
	mccprest = " and ExamCode = "+mccprest
Endif
nintento = 0
Do While nintento <2
	mret = SQLExec(mcon1,"Select * from Dbo.MWL Where  StudyUId = '" + mcidvale + "' " + mccprest , 'mwkctrwl')

	If mret <= 0
		mierr = Error()
		mimsg =  Transform(nintento)+ "-"+Message()
		mimsg1 = Message(1)
		miprg = Program()
		miline =  Lineno()
		nintento = nintento +1
		Do sp_desconexion
		Do sp_conexion With mwkexe.nomexe
	Else
		Return Reccount('mwkctrwl')>0
	Endif
Enddo
Do Log_errores With mierr ,mimsg ,mimsg1 ,miprg ,miline
Return .F.
