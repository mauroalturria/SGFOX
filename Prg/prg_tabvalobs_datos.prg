Lparameters mCodPun,qvalor


mret = SQLExec(mcon1, "Select * from TabValObs " + ;
	"where TabValObs.TVO_CodPun = ?mCodPun","mwkCodPun")

If mret =< 0
	Messagebox("ERROR DE LECTURA DE OBS. VALE",48,"VALIDACION")
	Return .F.
ENDIF
SELECT mwkCodPun
GO bottom
Do Case
Case qvalor = 1
	Return mwkCodPun.TVO_FechaEstudio
Case qvalor = 2
	Return mwkCodPun.TVO_Obser
Case qvalor = 3
	Return mwkCodPun.TVO_SubEstado
Endcase

