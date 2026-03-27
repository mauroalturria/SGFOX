PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , msoplo , mruidos , mpulperif , mcapilar ,;
 marritmia , mdescriarritmia , msistolica , mdiastolica , mmedia , mestcomple , mnotascardio , motrasdrogas , mfc , pge1 , indomet , iNO , sildena , aas

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIECardio 
		( CAR_nroadmisionRN , CAR_nroregistraRN , CAR_tiporegistro , CAR_fechaHora , CAR_idevol , CAR_usuario , CAR_soplo , CAR_ruidos , CAR_pulperif ,
		 CAR_capilar , CAR_arritmia , CAR_descriarritmia , CAR_sistolica , CAR_diastolica , CAR_media , CAR_estcomple , CAR_notascardio ,
		 CAR_otrasdrogas, CAR_freccard , CAR_pge1 , CAR_indomet , CAR_iNO , CAR_sildena , CAR_aas ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?msoplo , ?mruidos , ?mpulperif , ?mcapilar , ?marritmia ,
		 ?mdescriarritmia , ?msistolica , ?mdiastolica , ?mmedia , ?mestcomple , ?mnotascardio , ?motrasdrogas , ?mfc , ?pge1 , ?indomet , ?iNO , ?sildena , ?aas) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIECardio 
		Set CAR_nroadmisionRN  = ?mnroadmisionRN , 
		CAR_nroregistraRN  = ?mnroregistraRN , 
		CAR_tiporegistro  = ?mtiporegistro , 
		CAR_fechaHora  = ?mfechaHora , 
		CAR_idevol  = ?midevol , 
		CAR_usuario  = ?musuario , 
		CAR_soplo  = ?msoplo , 
		CAR_ruidos  = ?mruidos , 
		CAR_pulperif  = ?mpulperif , 
		CAR_capilar  = ?mcapilar , 
		CAR_arritmia  = ?marritmia , 
		CAR_descriarritmia  = ?mdescriarritmia , 
		CAR_sistolica  = ?msistolica , 
		CAR_diastolica  = ?mdiastolica , 
		CAR_media  = ?mmedia , 
		CAR_estcomple  = ?mestcomple , 
		CAR_notascardio  = ?mnotascardio , 
		CAR_otrasdrogas  = ?motrasdrogas ,
		CAR_freccard = ?mfc ,
		CAR_pge1 = ?pge1 ,
		CAR_indomet = ?indomet ,
		CAR_iNO = ?iNO ,
		CAR_sildena = ?sildena ,
		CAR_aas = ?aas
		where ID = ?mid 
	ENDTEXT
	

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF


