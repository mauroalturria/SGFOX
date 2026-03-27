*
* Ficha pacientes Traumatizados
*
Lparameters mbuscar

If used('mwktrauma')
	Use in mwktrauma
Endif
If used('mwktrauma2')
	Use in mwktrauma2
Endif

mret = sqlexec(mcon1,"select * from TabFichaTraumatologica where FT_protocolo=?mbuscar","mwktrauma")

If mret < 0
	=aerror(merror)
	Messagebox("EN CONSULTA PLANILLA PACIENTE TRAUMATIZADO"+chr(10)+alltrim(merror(3))+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Else

	Select mwktrauma
	Go top
	mlid = mwktrauma.id

	mret = sqlexec(mcon1,"select * from TabFichaTrauVal2 where FT_idficha=?mlid","mwktrauma2")

	If mret < 0
		=aerror(merror)
		Messagebox("EN CONSULTA CODIGOS AIS PACIENTE TRAUMATIZADO"+chr(10)+alltrim(merror(3))+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
	Endif

Endif


