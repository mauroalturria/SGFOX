*
* Certificacion VP Entrega de materiales
*
Lparameters mnropre, msector, mresponsable, mlfechr

Use In Select("mwkvpent")

mret = SQLExec(mcon1,"select * from TabFarmVPEntega where TET_IdPre = ?mnropre and TET_Sector = ?msector","mwkvpent")

If mret < 0
	mltabla = "TABLA CERTIFICACION VP ENTREGAS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If Used("mwkvpent")
	If Reccount("mwkvpent") > 0

*!*			If Messagebox("PREPARACION____: " + Transform(mnropre) + Chr(13) +;
*!*					"SECTOR __________: " + msector + Chr(13)+;
*!*					"REGISTRADA EL___: " + Ttoc(mwkvpent.TET_FecEnt) + Chr(13)+;
*!*					"RESPONSABLE____: " + Alltrim(mwkvpent.TET_Responsable )+Chr(13)+;
*!*					"REPROCESA ?",4+32+256,"REGISTRO PREVIO") = 6

			Select * From mwkvpent Where TET_IdPre = 0 Into Cursor mwkvpent

*!*		Endif

	Else

		mret = SQLExec(mcon1,"insert into TabFarmVPEntega (TET_IdPre, TET_Sector, TET_Responsable, TET_FecEnt)"+;
			" values (?mnropre, ?msector, ?mresponsable, ?mlfechr)")

		If mret < 0
			mltabla = "REGISTRO DE CERTIFICACION VP ENTREGAS"
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			Return .F.
		Endif

	Endif

Endif

Return .T.
