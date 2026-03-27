PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , mhipoglu , mhiperglu , mhipocalcemia ,;
 mhipercalcemia , mhipocalemia , mhipercalemia , malcmetabo , macimetabo , malcarespi , macirespi , mosteopenia , motros , motrostrasto , ;
mhipernatremia, mhiponatremia 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEMetabolico 
		( MET_nroadmisionRN , MET_nroregistraRN , MET_tiporegistro , MET_fechaHora , MET_idevol , MET_usuario , MET_hipoglu , MET_hiperglu , MET_hipocalcemia , MET_hipercalcemia , MET_hipocalemia , MET_hipercalemia , MET_alcmetabo , MET_acimetabo , MET_alcarespi , MET_acirespi , MET_osteopenia , MET_otros , MET_otrostrasto, MET_hipernatremia, MET_hiponatremia ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?mhipoglu , ?mhiperglu , ?mhipocalcemia , ?mhipercalcemia , ?mhipocalemia , ?mhipercalemia , ?malcmetabo , ?macimetabo , ?malcarespi , ?macirespi , ?mosteopenia , ?motros , ?motrostrasto , ?mhipernatremia , ?mhiponatremia  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEMetabolico 
		Set MET_nroadmisionRN  = ?mnroadmisionRN , 
		MET_nroregistraRN  = ?mnroregistraRN , 
		MET_tiporegistro  = ?mtiporegistro , 
		MET_fechaHora  = ?mfechaHora , 
		MET_idevol  = ?midevol , 
		MET_usuario  = ?musuario , 
		MET_hipoglu  = ?mhipoglu , 
		MET_hiperglu  = ?mhiperglu , 
		MET_hipocalcemia  = ?mhipocalcemia , 
		MET_hipercalcemia  = ?mhipercalcemia , 
		MET_hipocalemia  = ?mhipocalemia , 
		MET_hipercalemia  = ?mhipercalemia , 
		MET_alcmetabo  = ?malcmetabo , 
		MET_acimetabo  = ?macimetabo , 
		MET_alcarespi  = ?malcarespi , 
		MET_acirespi  = ?macirespi , 
		MET_osteopenia  = ?mosteopenia , 
		MET_otros  = ?motros , 
		MET_otrostrasto  = ?motrostrasto ,
		MET_hipernatremia = ?mhipernatremia ,
		MET_hiponatremia = ?mhiponatremia
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
