*PARAMETERS mid, minicioparto , mvia , mtrabparto , minstru , mpresenta , mliqAmnio , mmonintraparto , msigSftofetalag , manomacordon ,;
 mcausacesarea , mligaduras , mtiponac , mordennac , mobserva , mplugardenac , mregistracionRN , madmisionRN , midevol , mfechasys , usuario

Parameters mid, minicioparto , mvia , mtrabparto , minstru , mpresenta , mliqamnio , mmonintraparto , msigSftofetalag , manomacordon ,;
 mcausacesarea , mligaduras , mtiponac , mordennac , mobserva , mregistracionRN , madmisionRN , midevol , mfechasys , usuario,;
		mSignosDPPNI , mRupturamembra , mMonocorial , mEdadGestacio , mCorioamniotis , mTipoCorion)




if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoAntecDatosParto 
		( NDP_inicioparto , NDP_via , NDP_trabparto , NDP_instru , NDP_presenta , NDP_liqAmnio , NDP_monintraparto , NDP_sigSftofetalag , NDP_anomacordon , NDP_causacesarea , NDP_ligaduras , NDP_tiponac , NDP_ordennac , NDP_observa , NDP_nroregistraRN , NDP_nroadmisionRN , NDP_idevol , NDP_fechahora , NDP_usuario , NDP_dppni , NDP_rupmembrana , NDP_monocorial , NDP_edadgesta , NDP_corioamnionitis , NDP_corion) 
		 Values 
		( ?minicioparto , ?mvia , ?mtrabparto , ?minstru , ?mpresenta , ?mliqAmnio , ?mmonintraparto , ?msigSftofetalag , ?manomacordon , ?mcausacesarea , ?mligaduras , ?mtiponac , ?mordennac , ?mobserva , ?mregistracionRN , ?madmisionRN , ?midevol , ?mfechasys , ?musuario , ?mSignosDPPNI , ?mRupturamembra , ?mMonocorial , ?mEdadGestacio , ?mCorioamniotis , ?mTipoCorion) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoAntecDatosParto 
		Set NDP_inicioparto  = ?minicioparto , 
		NDP_via  = ?mvia , 
		NDP_trabparto  = ?mtrabparto , 
		NDP_instru  = ?minstru , 
		NDP_presenta  = ?mpresenta , 
		NDP_liqAmnio  = ?mliqAmnio , 
		NDP_monintraparto  = ?mmonintraparto , 
		NDP_sigSftofetalag  = ?msigSftofetalag , 
		NDP_anomacordon  = ?manomacordon , 
		NDP_causacesarea  = ?mcausacesarea , 
		NDP_ligaduras  = ?mligaduras , 
		NDP_tiponac  = ?mtiponac , 
		NDP_ordennac  = ?mordennac , 
		NDP_observa  = ?mobserva ,
		NDP_nroadmisionRN = ?madmisionRN ,
		NDP_nroregistraRN = ?mregistracionRN ,
		NDP_idevol = ?midevol ,
		NDP_fechahora = ?fechasys ,
		NDP_usuario = ?musuario ,
		NDP_dppni = ?mSignosDPPNI ,
		NDP_rupmembrana = ?mRupturamembra ,
		NDP_monocorial = ?mMonocorial ,
		NDP_edadgesta = ?mEdadGestacio ,
		NDP_corioamnionitis = ?mCorioamniotis , 
		NDP_corion = ?mTipoCorion 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
