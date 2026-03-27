parameter mid, mnroadmisionrn, mnroregistrarn, mtiporegistro, mfechahora, midevol, musuario,;
 msigdifresp, mfrecresp, mpreductal, mpreductalfio2, mpostductal, mpostductalfio2, masistresp, menfpasivo, mterapeu, mppmon,;
 mdrenaje, mtipodrena, mpermanencia, mestudios, mmedicacion, mrespotros, maltafreq
if mid = 0
	text TO lcsql TEXTMERGE NOSHOW PRETEXT 7
		Insert into ZabNeoIERespira
		( RES_nroadmisionRN , RES_nroregistraRN , RES_tiporegistro , RES_fechaHora , RES_idevol , RES_usuario , RES_sigdifresp ,  
RES_frecresp , RES_preductal , RES_preductalfio2 , RES_postductal , RES_postductalfio2 , RES_asistresp , RES_enfpasivo , RES_terapeu ,  
RES_ppmon , RES_drenaje , RES_tipodrena , RES_permanencia , RES_estudios , RES_medicacion , RES_respotros , RES_hfaltafreq)
		 Values
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?msigdifresp , ?mfrecresp , ?mpreductal ,  
?mpreductalfio2 , ?mpostductal , ?mpostductalfio2 , ?masistresp , ?menfpasivo , ?mterapeu , ?mppmon , ?mdrenaje , ?mtipodrena ,  
?mpermanencia , ?mestudios , ?mmedicacion , ?mrespotros , ?maltafreq)
	ENDTEXT
else
	text TO lcsql TEXTMERGE NOSHOW PRETEXT 7
		Update ZabNeoIERespira
		Set RES_nroadmisionRN  = ?mnroadmisionRN ,
		RES_nroregistraRN  = ?mnroregistraRN ,
		RES_tiporegistro  = ?mtiporegistro ,
		RES_fechaHora  = ?mfechaHora ,
		RES_idevol  = ?midevol ,
		RES_usuario  = ?musuario ,
		RES_sigdifresp  = ?msigdifresp ,
		RES_frecresp  = ?mfrecresp ,
		RES_preductal  = ?mpreductal ,
		RES_preductalfio2  = ?mpreductalfio2 ,
		RES_postductal  = ?mpostductal ,
		RES_postductalfio2  = ?mpostductalfio2 ,
		RES_asistresp  = ?masistresp ,
		RES_enfpasivo  = ?menfpasivo ,
		RES_terapeu  = ?mterapeu ,
		RES_ppmon  = ?mppmon ,
		RES_drenaje  = ?mdrenaje ,
		RES_tipodrena  = ?mtipodrena ,
		RES_permanencia  = ?mpermanencia ,
		RES_estudios  = ?mestudios ,
		RES_medicacion  = ?mmedicacion ,
		RES_respotros  = ?mrespotros ,
		RES_hfaltafreq = ?maltafreq
		where ID = ?mid
	ENDTEXT
endif
if  !prg_ejecutosql(lcsql, "mwk")
	messagebox("ERROR AL GUARDAR", 16, "ERROR")
	return .f.
endif
