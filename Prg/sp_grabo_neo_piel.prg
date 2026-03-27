PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , mpielcolor , motrospiel , mplesion ,;
 mpnevos , mangiomas , mmaculas , malopesicas , mcefalohemato , mcaput 

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEPiel 
		( PIE_nroadmisionRN , PIE_nroregistraRN , PIE_tiporegistro , PIE_fechaHora , PIE_idevol , PIE_usuario , PIE_pielcolor , PIE_otrospiel , PIE_plesion , PIE_pnevos , PIE_angiomas , PIE_maculas , PIE_alopesicas , PIE_cefalohemato , PIE_caput  ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?mpielcolor , ?motrospiel , ?mplesion , ?mpnevos , ?mangiomas , ?mmaculas , ?malopesicas , ?mcefalohemato , ?mcaput  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEPiel 
		Set PIE_nroadmisionRN  = ?mnroadmisionRN , 
		PIE_nroregistraRN  = ?mnroregistraRN , 
		PIE_tiporegistro  = ?mtiporegistro , 
		PIE_fechaHora  = ?mfechaHora , 
		PIE_idevol  = ?midevol , 
		PIE_usuario  = ?musuario , 
		PIE_pielcolor  = ?mpielcolor , 
		PIE_otrospiel  = ?motrospiel , 
		PIE_plesion  = ?mplesion , 
		PIE_pnevos  = ?mpnevos , 
		PIE_angiomas  = ?mangiomas , 
		PIE_maculas  = ?mmaculas , 
		PIE_alopesicas  = ?malopesicas , 
		PIE_cefalohemato  = ?mcefalohemato , 
		PIE_caput  = ?mcaput 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
