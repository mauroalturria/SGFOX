lparameters mnLibres, mnOcupa, mFecha, mHora, mSector,mnind,mnbloq

mret = SqlExec(mcon1, "insert into TabHistOcup ( CamasBloq , CamasIndiv,CamasLibres, CamasOcup, Fecha, Hora, Sector) " + ;
				"values (?mnbloq, ?mnind,?mnLibres, ?mnOcupa, ?mFecha, ?mHora, ?mSector)")
				
if mret <= 0
	MessageBox("ERROR AL ACTUALIZAR",48,"VALIDACION")
	set step on
	aerror(eros)
Endif 				