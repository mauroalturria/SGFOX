Lparameters mCodPun,qvalor

If Vartype(qvalor)<>"N"
	qvalor=1
Endif
*!*	 SELECT ID , CodAmbito , FecHorDbAdd , FecHorDbUpd , UserDbAdd , UserDbUpd ;
*!*	 , TFO_codpun , TFO_estado , TFO_fecestado , TFO_obser , TFO_usuarioid FROM SQLUser . Zabtflog
mret = SQLExec(mcon1, "Select Zabtflog.*, nomape from Zabtflog ,tabusuario   " + ;
"where TFO_usuarioid=tabusuario.id and  TFO_codpun = ?mCodPun order by Zabtflog.id ","mwkCodPun")

If mret =< 0
	Messagebox("ERROR DE LECTURA DE OBS. VALE",48,"VALIDACION")
	Return .F.
Endif
Select mwkCodPun
Go Bottom
Do Case
Case qvalor = 1
	GO bottom
	Return NVL(mwkCodPun.TFO_estado,0)
Case qvalor = 2
	GO bottom

	Return NVL(mwkCodPun.TFO_obser,SPACE(200))
Case qvalor = 3
	GO bottom

	Return NVL(mwkCodPun.TFO_fecestado,CTOD("  /  /  "))
Endcase

