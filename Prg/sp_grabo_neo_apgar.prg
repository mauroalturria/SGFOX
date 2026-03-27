PARAMETERS mid, madmisionRN , mregistracioRN , mapgar1fc , mapgar1fr , mapgar1to , mapgar1re , mapgar1co , mapgar1tot , mapgar5fc , mapgar5fr ,;
 mapgar5to , mapgar5re , mapgar5co , mapgar5tot , mapgar7 , mmascara , mintuba , malcaliniza , mestimula , mmasaje , mdrogas , midevol , fechasys , musuario

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoAntecApgar 
		( NAA_admisionRN , NAA_registracioRN , NAA_apgar1fc , NAA_apgar1fr , NAA_apgar1to , NAA_apgar1re , NAA_apgar1co , NAA_apgar1tot , NAA_apgar5fc , NAA_apgar5fr , NAA_apgar5to , NAA_apgar5re , NAA_apgar5co , NAA_apgar5tot , NAA_apgar7 , NAA_mascara , NAA_intuba , NAA_alcaliniza , NAA_estimula , NAA_masaje , NAA_drogas , NAA_idevol , NAA_fechahora , NAA_usuario) 
		 Values 
		( ?madmisionRN , ?mregistracioRN , ?mapgar1fc , ?mapgar1fr , ?mapgar1to , ?mapgar1re , ?mapgar1co , ?mapgar1tot , ?mapgar5fc , ?mapgar5fr , ?mapgar5to , ?mapgar5re , ?mapgar5co , ?mapgar5tot , ?mapgar7 , ?mmascara , ?mintuba , ?malcaliniza , ?mestimula , ?mmasaje , ?mdrogas , ?midevol , ?mfechasys , ?musuario) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoAntecApgar 
		Set NAA_admisionRN  = ?madmisionRN , 
		NAA_registracioRN  = ?mregistracioRN , 
		NAA_apgar1fc  = ?mapgar1fc , 
		NAA_apgar1fr  = ?mapgar1fr , 
		NAA_apgar1to  = ?mapgar1to , 
		NAA_apgar1re  = ?mapgar1re , 
		NAA_apgar1co  = ?mapgar1co , 
		NAA_apgar1tot  = ?mapgar1tot , 
		NAA_apgar5fc  = ?mapgar5fc , 
		NAA_apgar5fr  = ?mapgar5fr , 
		NAA_apgar5to  = ?mapgar5to , 
		NAA_apgar5re  = ?mapgar5re , 
		NAA_apgar5co  = ?mapgar5co , 
		NAA_apgar5tot  = ?mapgar5tot , 
		NAA_apgar7  = ?mapgar7 , 
		NAA_mascara  = ?mmascara , 
		NAA_intuba  = ?mintuba , 
		NAA_alcaliniza  = ?malcaliniza , 
		NAA_estimula  = ?mestimula , 
		NAA_masaje  = ?mmasaje , 
		NAA_drogas  = ?mdrogas ,
		NAA_idevol = ?midevol ,
		NAA_fechahora = ?mfechasys ,
		NAA_usuario = ?musuario
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
