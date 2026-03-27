lparameters mnroregistrac, mMyIp

mret = SqlExec(mcon1,"Select * " + ;
						"from TabLlamador " + ;
						"Where LLA_NroRegistrac = ?mnroregistrac And " + ;
						"LLA_ipMaquina = ?mMyIp and Lla_Consultorio <> 'AUS' " + ;
						"Order By id desc ","mwkLla")

If mret <= 0
	MessageBox("ERROR AL ACTUALIZAR EL LLAMADOR",48,"VALIDACION")
Endif 