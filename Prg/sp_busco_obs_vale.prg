Lparameters mCodPun

mret = Sqlexec(mcon1, "Select * from TabValObs " + ;
	"where TabValObs.TVO_CodPun = ?mCodPun","mwkCodPun")
	
If mret =< 0
	Messagebox("ERROR DE LECTURA DE OBS. VALE",48,"VALIDACION")
	Return .f.
Endif 	