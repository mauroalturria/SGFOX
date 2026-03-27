PARAMETERS mid, madmisionRN , mregistracioRN , moligoamnios , mfuma , mdesnutri , mtransfusion , mconsumosustox , mcocaina , mmarihuana ,;
 mpaco , malcohol , manfetaminas , mopioides , mchkotrassustox , motrasustoxica , motrosdatos , midevol , mifechays , usuario

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoAntecMatCom 
		( AMC_admisionRN , AMC_registracioRN , AMC_oligoamnios , AMC_fuma , AMC_desnutri , AMC_transfusion , AMC_consumosustox , AMC_cocaina , AMC_marihuana , AMC_paco , AMC_alcohol , AMC_anfetaminas , AMC_opioides , AMC_chkotrassustox , AMC_otrasustoxica , AMC_otrosdatos , AMC_idevol , AMC_fechahora ,AMC_usuario) 
		 Values 
		( ?madmisionRN , ?mregistracioRN , ?moligoamnios , ?mfuma , ?mdesnutri , ?mtransfusion , ?mconsumosustox , ?mcocaina , ?mmarihuana , ?mpaco , ?malcohol , ?manfetaminas , ?mopioides , ?mchkotrassustox , ?motrasustoxica , ?motrosdatos , ?midevol , ?mfechasys , ?musuario) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoAntecMatCom 
		Set AMC_admisionRN  = ?madmisionRN , 
		AMC_registracioRN  = ?mregistracioRN , 
		AMC_oligoamnios  = ?moligoamnios , 
		AMC_fuma  = ?mfuma , 
		AMC_desnutri  = ?mdesnutri , 
		AMC_transfusion  = ?mtransfusion , 
		AMC_consumosustox  = ?mconsumosustox , 
		AMC_cocaina  = ?mcocaina , 
		AMC_marihuana  = ?mmarihuana , 
		AMC_paco  = ?mpaco , 
		AMC_alcohol  = ?malcohol , 
		AMC_anfetaminas  = ?manfetaminas , 
		AMC_opioides  = ?mopioides , 
		AMC_chkotrassustox  = ?mchkotrassustox , 
		AMC_otrasustoxica  = ?motrasustoxica , 
		AMC_otrosdatos  = ?motrosdatos ,
		AMC_idevol = ?midevol ,
		AMC_fechahora = ?fechasys ,
		AMC_usuario = ?musuario 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF