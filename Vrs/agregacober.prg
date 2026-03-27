Do sp_conexion
Select pruebacar
Set Step On

Scan
	mivale = pruebacar.rc_nrovale

	Requery('valeslabo')
	If Reccount('valeslabo')>0
		miobs = Nvl(valeslabo.VAL_observaciones,'')
		mnroreg = valeslabo.PAC_codhci
		mnroadm = valeslabo.pac_codadmision
		Requery('coberhc')
		If Reccount('coberhc')>0
			If Inlist(coberhc.cob_codentidad,945,948)
				Set Step On
			Endif
*!*				mcob=coberhc.COB_CondicImpositiva
*!*				miobs = "("+mcob+")"+Alltrim(miobs)
*!*				mRet = SQLExec(mcon1,"update Valesasist set VAL_observaciones =?miobs WHERE   VAL_codvaleasist = ?mivale ")
		Else
			Set Step On
		Endif
	Else
		Set Step On
	Endif
Endscan
Do sp_desconexion
