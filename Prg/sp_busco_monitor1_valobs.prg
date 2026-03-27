*
* Busqueda de Observaciones en TabValObs
*

Lparameters mcodpun

If used("mwkvalobsm")
	Use in mwkvalobsm
Endif

mret = sqlexec(mcon1,"select * from TabValObs " + ;
	"where exists(select 1 from TabValObs  where TVO_Codpun = ?mcodpun ) and " + ;
		"TVO_Codpun = ?mcodpun and TVO_subestado > 19 and TVO_subestado <> 179 ","mwkvalobsm")


*!*	mret = sqlexec(mcon1,"select * from TabValObs"+;
*!*		" where TVO_Codpun = ?mcodpun and TVO_subestado > 19 and TVO_subestado <> 179 ","mwkvalobsm")

If mret < 0
	Messagebox("ERROR EN BUSQUEDA, MAESTRO DE VALES OBS/ESTADOS",48,"Validacion")
	Return .f.
Endif



