Lparameters mCodVale

Local cResult
***Local aValores
Local nIn
Local oIn

cResult = "N"

mret = SQLExec(mcon1,"select VAL_motivourgencia " +;
	"from ValesAsist " + ;
	"Where Val_CodValeAsist = ?mCodVale","mwkIsValParaAlta")

If mret < 0
	Messagebox("ERROR EN LA LECTURA DE VALESASIST - MOTIVO_URGENCIA",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
Else

	Go Top In mwkIsValParaAlta

	Alines(aValores,mwkIsValParaAlta.Val_MotivoUrgencia,.F.,Chr(10))

*!*		For nIn = 1 To Len(aValores)
*!*			If Alltrim(aValores[nIn]) = "MA"
*!*				cResult = "S"
*!*				Exit
*!*			Endif
*!*		Next

	For Each oIn In aValores
		If Alltrim(oIn) = "MA"
			cResult = "S"
			Exit
		Endif
	Next
Endif


Use In Select("mwkIsValParaAlta")

Return cResult
