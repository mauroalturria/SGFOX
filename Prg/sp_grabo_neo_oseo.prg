PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , mclavicula , mbarlow , mclickcadera ,;
 mpiebot , mparabraq , mdatosoesto 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEOseo 
		( OSE_nroadmisionRN , OSE_nroregistraRN , OSE_tiporegistro , OSE_fechaHora , OSE_idevol , OSE_usuario , OSE_clavicula , OSE_barlow , OSE_clickcadera , OSE_piebot , OSE_parabraq , OSE_datosoesto  ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?mclavicula , ?mbarlow , ?mclickcadera , ?mpiebot , ?mparabraq , ?mdatosoesto  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEOseo 
		Set OSE_nroadmisionRN  = ?mnroadmisionRN , 
		OSE_nroregistraRN  = ?mnroregistraRN , 
		OSE_tiporegistro  = ?mtiporegistro , 
		OSE_fechaHora  = ?mfechaHora , 
		OSE_idevol  = ?midevol , 
		OSE_usuario  = ?musuario , 
		OSE_clavicula  = ?mclavicula , 
		OSE_barlow  = ?mbarlow , 
		OSE_clickcadera  = ?mclickcadera , 
		OSE_piebot  = ?mpiebot , 
		OSE_parabraq  = ?mparabraq , 
		OSE_datosoesto  = ?mdatosoesto 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
