PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , mquiro 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEQuiro 
		( QUI_nroadmisionRN , QUI_nroregistraRN , QUI_tiporegistro , QUI_fechaHora , QUI_idevol , QUI_usuario , QUI_quiro  ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?mquiro  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEQuiro 
		Set QUI_nroadmisionRN  = ?mnroadmisionRN , 
		QUI_nroregistraRN  = ?mnroregistraRN , 
		QUI_tiporegistro  = ?mtiporegistro , 
		QUI_fechaHora  = ?mfechaHora , 
		QUI_idevol  = ?midevol , 
		QUI_usuario  = ?musuario , 
		QUI_quiro  = ?mquiro 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
