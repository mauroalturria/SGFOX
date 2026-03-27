PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , msensorio ,  mtono ,;
 mreflejos , mconvulneuro , mapnea , mpupilas , mfontanela , mestucompneuro , mdatosneuro 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIENeuro 
		( NEU_nroadmisionRN , NEU_nroregistraRN , NEU_tiporegistro , NEU_fechaHora , NEU_idevol , NEU_usuario , NEU_sensorio  , NEU_tono , NEU_reflejos , NEU_convulneuro , NEU_apnea , NEU_pupilas , NEU_fontanela , NEU_estucompneuro , NEU_datosneuro  ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?msensorio ,  ?mtono , ?mreflejos , ?mconvulneuro , ?mapnea , ?mpupilas , ?mfontanela , ?mestucompneuro , ?mdatosneuro  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIENeuro 
		Set NEU_nroadmisionRN  = ?mnroadmisionRN , 
		NEU_nroregistraRN  = ?mnroregistraRN , 
		NEU_tiporegistro  = ?mtiporegistro , 
		NEU_fechaHora  = ?mfechaHora , 
		NEU_idevol  = ?midevol , 
		NEU_usuario  = ?musuario , 
		NEU_sensorio  = ?msensorio , 
		NEU_tono  = ?mtono , 
		NEU_reflejos  = ?mreflejos , 
		NEU_convulneuro  = ?mconvulneuro , 
		NEU_apnea  = ?mapnea , 
		NEU_pupilas  = ?mpupilas , 
		NEU_fontanela  = ?mfontanela , 
		NEU_estucompneuro  = ?mestucompneuro , 
		NEU_datosneuro  = ?mdatosneuro 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
