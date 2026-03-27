PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , mevolucion , mingreso , mpeso , mpesoper ,;
 mtalla , mtallaper , mpc , mpcper 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEAntro 
		( ANT_nroadmisionRN , ANT_nroregistraRN , ANT_tiporegistro , ANT_fechaHora , ANT_idevol , ANT_usuario , ANT_evolucion , ANT_ingreso , ANT_peso , ANT_pesoper , ANT_talla , ANT_tallaper , ANT_pc , ANT_pcper  ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?mevolucion , ?mingreso , ?mpeso , ?mpesoper , ?mtalla , ?mtallaper , ?mpc , ?mpcper  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEAntro 
		Set ANT_nroadmisionRN  = ?mnroadmisionRN , 
		ANT_nroregistraRN  = ?mnroregistraRN , 
		ANT_tiporegistro  = ?mtiporegistro , 
		ANT_fechaHora  = ?mfechaHora , 
		ANT_idevol  = ?midevol , 
		ANT_usuario  = ?musuario , 
		ANT_evolucion  = ?mevolucion , 
		ANT_ingreso  = ?mingreso , 
		ANT_peso  = ?mpeso , 
		ANT_pesoper  = ?mpesoper , 
		ANT_talla  = ?mtalla , 
		ANT_tallaper  = ?mtallaper , 
		ANT_pc  = ?mpc , 
		ANT_pcper  = ?mpcper 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
