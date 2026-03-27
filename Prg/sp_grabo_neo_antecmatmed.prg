PARAMETERS mid, madmisionRN , mregistacionRN , minsulina , mstodemg , mlabetalol , mmadpulmonar , mhtiro , mantidepre , mnomantidepre ,;
 manticonvu , mcorticoide , motramedicacion , midevol , mfechasys, musuario

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoAntecMatMed 
		( AMM_admisionRN , AMM_registacionRN , AMM_insulina , AMM_stodemg , AMM_labetalol , AMM_madpulmonar , AMM_htiro , AMM_antidepre , AMM_nomantidepre , AMM_anticonvu , AMM_corticoide , AMM_otramedicacion , AMM_idevol , AMM_fechahora , AMM_usuario) 
		 Values 
		( ?madmisionRN , ?mregistacionRN , ?minsulina , ?mstodemg , ?mlabetalol , ?mmadpulmonar , ?mhtiro , ?mantidepre , ?mnomantidepre , ?manticonvu , ?mcorticoide , ?motramedicacion , ?midevol , ?mfechasys , ?musuario ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoAntecMatMed 
		Set AMM_admisionRN  = ?madmisionRN , 
		AMM_registacionRN  = ?mregistacionRN , 
		AMM_insulina  = ?minsulina , 
		AMM_stodemg  = ?mstodemg , 
		AMM_labetalol  = ?mlabetalol , 
		AMM_madpulmonar  = ?mmadpulmonar , 
		AMM_htiro  = ?mhtiro , 
		AMM_antidepre  = ?mantidepre , 
		AMM_nomantidepre  = ?mnomantidepre , 
		AMM_anticonvu  = ?manticonvu , 
		AMM_corticoide  = ?mcorticoide , 
		AMM_otramedicacion  = ?motramedicacion ,
		AMM_idevol = ?midevol ,
		AMM_fechahora = ?mfechasys ,
		AMM_usuario = ?musuario
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
