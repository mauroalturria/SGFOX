Parameters tcAfi1, tbSleep, tbResu, tcResu

Local lbResu

tcResu = ''

mAPG_FechaHoraPed = sp_busco_fecha_serv('DT')
Do sp_actualizo_TabCtrlApliGem With 1, 0, tcAfi1, mAPG_FechaHoraPed

If tbSleep
	lnProc = 0
	Do While .t.
		Do sp_busco_TabCtrlApliGem With 2,0, mAPG_FechaHoraPed, "mwkCtrlApliGem" 
		
*		Do sp_busco_TabCtrlApliGem With 1,1767, mAPG_FechaHoraPed, "mwkCtrlApliGem" 
		       
		If Isnull(mwkCtrlApliGem.APG_FechaHoraResp) And lnProc <= 4
			lnProc = lnProc + 1 
			Wait Window "Validando Afiliacion " + Transform(lnProc) + "..." Timeout 3
			Loop
		Endif 	
		
		Exit
	Enddo	

	If Isnull(mwkCtrlApliGem.APG_FechaHoraResp)
		*Messagebox("ERROR EN LA VALIDACION",48,"VALIDACION")
		Return .F.
	Endif 
	
	tcResuNoList = Upper(Alltrim(Substr(mwkCtrlApliGem.APG_RESPSVR,11,-11+At(",",mwkCtrlApliGem.APG_RESPSVR,1))))
	If tcResuNoList <> 'ERROR'
		tcResu = Upper(Alltrim(mwkCtrlApliGem.APG_RespTxt))
		tbResu = (Upper(Alltrim(mwkCtrlApliGem.APG_RespTxt)) = 'ASOCIADO HABILITADO')
	Else
		If "CONEXION" $ Upper(mwkCtrlApliGem.APG_RESPSVR)
			tbResu = .F.
			lnPos1 = At(",",mwkCtrlApliGem.APG_RESPSVR,1)
			lnPos2 = At(".",mwkCtrlApliGem.APG_RESPSVR,1)
			tcResu = tcResuNoList + ", " + Alltrim(Substr(mwkCtrlApliGem.APG_RESPSVR, lnPos1+1, lnPos2 - lnPos1-1))
		Else 
			tcResu = Upper(Alltrim(mwkCtrlApliGem.APG_RespTxt))
			tbResu = (Upper(Alltrim(mwkCtrlApliGem.APG_RespTxt)) = 'ASOCIADO HABILITADO')
		Endif 
	Endif 	
	
	lbResu = .t.	
Else
	lbResu = .t.	
	tbResu = ''
Endif 
	
Return (lbResu)
