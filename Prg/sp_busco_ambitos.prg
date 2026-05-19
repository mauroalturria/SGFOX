*
* Ambitos
*
Lparameters mtipo

If vartype(mtipo)<>"N"
	mtipo = 1
Endif

If mtipo = 1 && Sólo ambitos

	Use In Select("mwkambito")
	mret = SQLExec(mcon1,"select * from TabAmbito", "mwkambito")
	If mret < 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA AMBITOS"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Else         && Relación de ambito y parámetros
 
	Use In Select("mwkconfigura")
	mret = SQLExec(mcon1,"select TabAmbito.ambito, tabconfigura.* "+;
		" from tabconfigura"+;
		" join TabAmbito on TabAmbito.id = tabconfigura.tbc_centro","mwkconfigura")

	If mret < 0
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN CONSULTA DE CENTROS y AMBITOS"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endif

Return .T.
