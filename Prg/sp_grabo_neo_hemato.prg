PARAMETERS mid, mnroadmisionRN , mnroregistraRN , mtiporegistro , mfechaHora , midevol , musuario , mgrupoyfactor ,;
 mpc , mbit , mbid , mhto , motroslabo , manemia , mtransfusiones , multimatransf ,mretic, mlmt

if mid = 0

	TEXT To lcsql Textmerge Noshow Pretext 7
		Insert into ZabNeoIEHemato 
		( HEM_nroadmisionRN , HEM_nroregistraRN , HEM_tiporegistro , HEM_fechaHora , HEM_idevol , HEM_usuario ,  HEM_grupoyfactor ,
		 HEM_pc , HEM_bit , HEM_bid , HEM_hto , HEM_otroslabo , HEM_anemia , HEM_transfusiones , HEM_ultimatransf, HEM_reticulo ,HEM_lmt ) 
		 Values 
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?mgrupoyfactor ,
		 ?mpc , ?mbit , ?mbid , ?mhto , ?motroslabo , ?manemia , ?mtransfusiones , ?multimatransf, ?mretic, ?mlmt  ) 
	ENDTEXT

else

	TEXT To lcsql Textmerge Noshow Pretext 7
		Update ZabNeoIEHemato 
		Set HEM_nroadmisionRN  = ?mnroadmisionRN , 
		HEM_nroregistraRN  = ?mnroregistraRN , 
		HEM_tiporegistro  = ?mtiporegistro , 
		HEM_fechaHora  = ?mfechaHora , 
		HEM_idevol  = ?midevol , 
		HEM_usuario  = ?musuario , 
		HEM_grupoyfactor  = ?mgrupoyfactor , 
		HEM_pc  = ?mpc , 
		HEM_bit  = ?mbit , 
		HEM_bid  = ?mbid , 
		HEM_hto  = ?mhto , 
		HEM_otroslabo  = ?motroslabo , 
		HEM_anemia  = ?manemia , 
		HEM_transfusiones  = ?mtransfusiones , 
		HEM_ultimatransf  = ?multimatransf ,
		HEM_reticulo = ?mretic ,
		HEM_lmt = ?mlmt
		where ID = ?mid 
	ENDTEXT

endif

If !Prg_EjecutoSql(lcSql,"mwk")
	Messagebox("ERROR AL GUARDAR",16,"ERROR EN HEMATO")
	Return .f.
ENDIF
