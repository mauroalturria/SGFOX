PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , motrasdescrip , mnromalforma

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEMalforma 
		( MAL_nroadmisionRN , MAL_nroregistraRN , MAL_tiporegistro , MAL_fechaHora , MAL_idevol , MAL_usuario ,  MAL_otrasdescrip ,MAL_nromalforma ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?motrasdescrip  , ?mnromalforma) 
		
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEMalforma 
		Set MAL_nroadmisionRN  = ?mnroadmisionRN , 
		MAL_nroregistraRN  = ?mnroregistraRN , 
		MAL_tiporegistro  = ?mtiporegistro , 
		MAL_fechaHora  = ?mfechaHora , 
		MAL_idevol  = ?midevol , 
		MAL_usuario  = ?musuario , 
		MAL_otrasdescrip  = ?motrasdescrip ,
		MAL_nromalforma = ?mnromalforma
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF




*!*	PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , matresiaeso , monfalocele , mgastrosq ,;
*!*	 matresiaduo , mcloaca , manomiembro , mhidrocefa , mmeningo , mmdown , mpolidaci , morofaci , mmacrocefalo , msindacti , mhipospadia ,;
*!*	  mtriso13 , mtriso18 , mcardiopatias , mmar , mgenitouri , mmielomeningo , moculares , motras , motrasdescrip 

*!*	if mid = 0

*!*		TEXT To lcsql Textmerge Noshow Pretext 7
*!*			Insert into user.ZabNeoIEMalforma 
*!*			( MAL_nroadmisionRN , MAL_nroregistraRN , MAL_tiporegistro , MAL_fechaHora , MAL_idevol , MAL_usuario , MAL_atresiaeso , MAL_onfalocele ,;
*!*			 MAL_gastrosq , MAL_atresiaduo , MAL_cloaca , MAL_anomiembro , MAL_hidrocefa , MAL_meningo , MAL_down , MAL_polidaci , MAL_orofaci ,;
*!*			  MAL_macrocefalo , MAL_sindacti , MAL_hipospadia , MAL_triso13 , MAL_triso18 , MAL_cardiopatias , MAL_mar , MAL_genitouri ,;
*!*			   MAL_mielomeningo , MAL_oculares , MAL_otras , MAL_otrasdescrip  ) 
*!*			 Values 
*!*			( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?matresiaeso , ?monfalocele , ?mgastrosq ,;
*!*			 ?matresiaduo , ?mcloaca , ?manomiembro , ?mhidrocefa , ?mmeningo , ?mmdown , ?mpolidaci , ?morofaci , ?mmacrocefalo , ?msindacti , ;
*!*			 ?mhipospadia , ?mtriso13 , ?mtriso18 , ?mcardiopatias , ?mmar , ?mgenitouri , ?mmielomeningo , ?moculares , ?motras , ?motrasdescrip  ) 
*!*		ENDTEXT

*!*	else

*!*		TEXT To lcsql Textmerge Noshow Pretext 7
*!*			Update user.ZabNeoIEMalforma 
*!*			Set MAL_nroadmisionRN  = ?mnroadmisionRN , 
*!*			MAL_nroregistraRN  = ?mnroregistraRN , 
*!*			MAL_tiporegistro  = ?mtiporegistro , 
*!*			MAL_fechaHora  = ?mfechaHora , 
*!*			MAL_idevol  = ?midevol , 
*!*			MAL_usuario  = ?musuario , 
*!*			MAL_atresiaeso  = ?matresiaeso , 
*!*			MAL_onfalocele  = ?monfalocele , 
*!*			MAL_gastrosq  = ?mgastrosq , 
*!*			MAL_atresiaduo  = ?matresiaduo , 
*!*			MAL_cloaca  = ?mcloaca , 
*!*			MAL_anomiembro  = ?manomiembro , 
*!*			MAL_hidrocefa  = ?mhidrocefa , 
*!*			MAL_meningo  = ?mmeningo , 
*!*			MAL_down  = ?mmdown , 
*!*			MAL_polidaci  = ?mpolidaci , 
*!*			MAL_orofaci  = ?morofaci , 
*!*			MAL_macrocefalo  = ?mmacrocefalo , 
*!*			MAL_sindacti  = ?msindacti , 
*!*			MAL_hipospadia  = ?mhipospadia , 
*!*			MAL_triso13  = ?mtriso13 , 
*!*			MAL_triso18  = ?mtriso18 , 
*!*			MAL_cardiopatias  = ?mcardiopatias , 
*!*			MAL_mar  = ?mmar , 
*!*			MAL_genitouri  = ?mgenitouri , 
*!*			MAL_mielomeningo  = ?mmielomeningo , 
*!*			MAL_oculares  = ?moculares , 
*!*			MAL_otras  = ?motras , 
*!*			MAL_otrasdescrip  = ?motrasdescrip 
*!*			where ID = ?mid 
*!*		ENDTEXT

*!*	endif

*!*	If !Prg_EjecutoSql(lcSql,"mwk")
*!*		Messagebox("ERROR AL GUARDAR",16,"ERROR")
*!*		Return .f.
*!*	ENDIF
