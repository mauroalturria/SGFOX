*
* Busco Archivos anexos asociados al envio de Censos Pacientes Internados
*
Lparameters mcodent

Use In Select("mwkcensoarch")

mfnull = Ctod("01/01/1900")

mret = SQLExec(mcon1,"select * from TabCensosArch"+;
	" where TCA_identidad = ?mcodent"+;
	" and TCA_fechapasiva = ?mfnull","mwkcensoarch")

If mret < 0
	MTABLA = "CENSOS ARCHIVOS ASOCIADOS"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
