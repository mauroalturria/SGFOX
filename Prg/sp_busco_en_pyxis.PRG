*
* Verificar si el insumo esta habilitado en PYXIS
*
Lparameters minsumo

mretorna = .F.

minsumo = alltrim(minsumo)

Use In Select("mwkenPyxis")

mret = SQLExec(mcon1,"select Top 1 INS_codinsumo, TMDEST_Insumo from TabMediDestino"+;
	" join insumos on INS_codpuntero = TMDEST_Insumo and INS_codinsumo = ?minsumo","mwkenPyxis")

If mret < 0
	mltabla = "CONSULTA INSUMO EN PYXIS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla + Chr(10) + "AVISE A SISTEMAS", 16, "ERROR")
	Return mretorna
Endif

If Used("mwkenPyxis")
	If Reccount("mwkenPyxis") > 0
		mretorna = .T.
	Endif
Endif

Use In Select("mwkenPyxis")

Return mretorna

* EJEMPLO PRUEBA
* select INS_codinsumo from insumos where INS_codpuntero = 18192
* EOF *