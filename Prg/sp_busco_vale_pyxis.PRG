*
* Busco el VALE en registros notificados al PYXIS
*
Lparameters mvale

Use In Select("mwkvalePyxis")
mret = SQLExec(mcon1,"select * from TabGriPyxis where TGP_vale = ?mvale","mwkvalePyxis")

If mret < 0
	mltabla = "VALES NOTIFICADOS A PYXIS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
