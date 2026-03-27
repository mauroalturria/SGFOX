*
* Verificar si el insumo es trazable
*
Lparameters minsumo

*SET STEP ON


mretorna = Space(14)

minsumo  = Alltrim(minsumo)

Use In Select("mwktrazable")

mret = SQLExec(mcon1,"select Top 1 TGT_inscod, TGT_gTin from tabtragtin where TGT_InsCod = ?minsumo","mwktrazable")

If mret < 0
	mltabla = "CONSULTA INSUMO TRAZABLE"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla + Chr(10) + "AVISE A SISTEMAS", 16, "ERROR")
	Return mretorna
Endif

If Used("mwktrazable")
	If Reccount("mwktrazable") > 0
		mretorna = mwktrazable.TGT_gTin
	Endif
Endif

Use In Select("mwktrazable")

Return mretorna

* EJEMPLO PRUEBA
* select TGT_inscod, TGT_gTin from tabtragtin where TGT_InsCod = 'UOCRITON001'
* EOF *
