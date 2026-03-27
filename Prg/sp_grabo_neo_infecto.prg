PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , minginfecto , mestcomple 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEInfecto 
		( INF_nroadmisionRN , INF_nroregistraRN , INF_tiporegistro , INF_fechaHora , INF_idevol , INF_usuario , INF_inginfecto , INF_estcomple  ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?minginfecto , ?mestcomple  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEInfecto 
		Set INF_nroadmisionRN  = ?mnroadmisionRN , 
		INF_nroregistraRN  = ?mnroregistraRN , 
		INF_tiporegistro  = ?mtiporegistro , 
		INF_fechaHora  = ?mfechaHora , 
		INF_idevol  = ?midevol , 
		INF_usuario  = ?musuario , 
		INF_inginfecto  = ?minginfecto , 
		INF_estcomple  = ?mestcomple 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF