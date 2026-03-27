PARAMETERS mid, madmisionRN , mregistacionRN , mdiabetes, mgestaprev , mhta , mpreeclampsia , meclampsia , msmehellp , mcolageno , mhipotiro , mhipertiro ,;
 mcardio , mconvulsion , menfpsiq , mtrombo , mcolestasis , minfectouri , mtto , mgermen , maedbttipo , mafosfo , midevol , mfechasys , musuario
 
if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoAntecMatPlus 
		( AMP_admisionRN , AMP_registacionRN , AMP_dbtipo , AMP_gestaprev , AMP_hta , AMP_preeclampsia , AMP_eclampsia , AMP_smehellp , AMP_colageno , AMP_hipotiro , AMP_hipertiro , AMP_cardio , AMP_convulsion , AMP_enfpsiq , AMP_trombo , AMP_colestasis , AMP_infectouri , AMP_tto , AMP_germen, AMP_diabetes,  AMP_fosfo , AMP_idevol , AMP_fechahora , AMP_usuario) 
		 Values 
		( ?madmisionRN , ?mregistacionRN , ?maedbttipo , ?mgestaprev , ?mhta , ?mpreeclampsia , ?meclampsia , ?msmehellp , ?mcolageno , ?mhipotiro , ?mhipertiro , ?mcardio , ?mconvulsion , ?menfpsiq , ?mtrombo , ?mcolestasis , ?minfectouri , ?mtto , ?mgermen , ?mdiabetes , ?mafosfo , ?midevol , ?mfechasys , ?musuario)
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoAntecMatPlus 
		Set AMP_admisionRN  = ?madmisionRN , 
		AMP_registacionRN  = ?mregistacionRN , 
		AMP_dbtipo  = ?mdbtipo , 
		AMP_gestaprev  = ?mgestaprev , 
		AMP_hta  = ?mhta , 
		AMP_preeclampsia  = ?mpreeclampsia , 
		AMP_eclampsia  = ?meclampsia , 
		AMP_smehellp  = ?msmehellp , 
		AMP_colageno  = ?mcolageno , 
		AMP_hipotiro  = ?mhipotiro , 
		AMP_hipertiro  = ?mhipertiro , 
		AMP_cardio  = ?mcardio , 
		AMP_convulsion  = ?mconvulsion , 
		AMP_enfpsiq  = ?menfpsiq , 
		AMP_trombo  = ?mtrombo , 
		AMP_colestasis  = ?mcolestasis , 
		AMP_infectouri  = ?minfectouri , 
		AMP_tto  = ?mtto , 
		AMP_germen  = ?mgermen ,
	    AMP_fosfo = ?mafosfo ,
	    AMP_diabetes = ?mdiabetes ,
	    AMP_idevol = ?midevol ,
	    AMP_fechahora = ?fechasys ,
	    AMP_usuario = ?musuario
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
