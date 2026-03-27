PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , mdatos , mfondojo , mfechaproxctrl ,;
 mmedicacion 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEOftalmo 
		( OFT_nroadmisionRN , OFT_nroregistraRN , OFT_tiporegistro , OFT_fechaHora , OFT_idevol , OFT_usuario , OFT_datos , OFT_fondojo , OFT_fechaproxctrl , OFT_medicacion  ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?mdatos , ?mfondojo , ?mfechaproxctrl , ?mmedicacion  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEOftalmo 
		Set OFT_nroadmisionRN  = ?mnroadmisionRN , 
		OFT_nroregistraRN  = ?mnroregistraRN , 
		OFT_tiporegistro  = ?mtiporegistro , 
		OFT_fechaHora  = ?mfechaHora , 
		OFT_idevol  = ?midevol , 
		OFT_usuario  = ?musuario , 
		OFT_datos  = ?mdatos , 
		OFT_fondojo  = ?mfondojo , 
		OFT_fechaproxctrl  = ?mfechaproxctrl , 
		OFT_medicacion  = ?mmedicacion 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
