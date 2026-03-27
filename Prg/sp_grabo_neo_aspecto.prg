PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , maspecto , mtempaxilar , mtempcentral 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEAspecto 
		( ASP_nroadmisionRN , ASP_nroregistraRN , ASP_tiporegistro , ASP_fechaHora , ASP_idevol , ASP_usuario , ASP_aspecto , ASP_tempaxilar , ASP_tempcentral  ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?maspecto , ?mtempaxilar , ?mtempcentral  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEAspecto 
		Set ASP_nroadmisionRN  = ?mnroadmisionRN , 
		ASP_nroregistraRN  = ?mnroregistraRN , 
		ASP_tiporegistro  = ?mtiporegistro , 
		ASP_fechaHora  = ?mfechaHora , 
		ASP_idevol  = ?midevol , 
		ASP_usuario  = ?musuario , 
		ASP_aspecto  = ?maspecto , 
		ASP_tempaxilar  = ?mtempaxilar , 
		ASP_tempcentral  = ?mtempcentral 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
