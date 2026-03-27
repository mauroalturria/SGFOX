PARAMETERS mid, madmisionRN , mregistraRN , mpesoRN , mtallaRN , mpcRN , mmeconio , morino , mvitak , mvachepb , mprofiantio , mbarlow , meab , morifnat , midevol, ;
mfechasys , musuario ,mnFechanac ,mnHoranac, mplugarId

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoAntecNacimiento 
		( NAN_admisionRN , NAN_registracioRN , NAN_pesoRN , NAN_tallaRN , NAN_pcRN , NAN_meconio , NAN_orino , NAN_vitak , NAN_vachepb , NAN_profiantio , NAN_barlow , NAN_eab , NAN_orifnat , NAN_idevol , NAN_fechahora , NAN_usuario , NAN_fecnacimiento , NAN_horanacimiento, NAN_lugarnacid) 
		 Values 
		( ?madmisionRN , ?mregistraRN , ?mpesoRN , ?mtallaRN , ?mpcRN , ?mmeconio , ?morino , ?mvitak , ?mvachepb , ?mprofiantio , ?mbarlow , ?meab , ?morifnat , ?midevol , ?mfechasys , ?musuario , ?mnFechanac , ?mnHoranac, ?mplugarId) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoAntecNacimiento 
		Set NAN_admisionRN  = ?madmisionRN , 
		NAN_registracioRN  = ?mregistraRN , 
		NAN_pesoRN  = ?mpesoRN , 
		NAN_tallaRN  = ?mtallaRN , 
		NAN_pcRN  = ?mpcRN , 
		NAN_meconio  = ?mmeconio , 
		NAN_orino  = ?morino , 
		NAN_vitak  = ?mvitak , 
		NAN_vachepb  = ?mvachepb , 
		NAN_profiantio  = ?mprofiantio , 
		NAN_barlow  = ?mbarlow , 
		NAN_eab  = ?meab , 
		NAN_orifnat  = ?morifnat ,
		NAN_idevol = ?midevol ,
		NAN_fechahora = ?mfechasys ,
		NAN_usuario = ?musuario ,
		NAN_fecnacimiento = ?mnFechanac , 
		NAN_horanacimiento = ?mnHoranac ,
		NAN_lugarnacid = ?mplugarId 
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR")
	Return .f.
ENDIF
