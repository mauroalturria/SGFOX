Select tabregctg
mfec = Datetime()
Set Step On
Scan
	mireg = rc_nroregistracio
	mimed = 1
	mfecha = Ttod(mfec)
	mest = tabregctg.RC_estado
	mobs = "Finalizado por fecha"
	mres =tabregctg.RC_hisopadoResul
	musu = 146
	Replace RC_fechaFin With mfecha
	MID = tabregctg.Id
	REQUERY('tabregctglogbaja')
	mimed = 1

	Insert Into tabregctglogbaja( RCL_estado,RCL_hisopadoResul, RCL_idRegCtg,RCL_observaciones, RCL_usuario,RCL_fechahora);
		VALUES (mest,mres ,MID,mobs ,mimed,mfecha)
	Select tabregctg
Endscan
