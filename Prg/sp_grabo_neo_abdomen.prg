Parameter mid, mnroadmisionrn, mnroregistrarn, mtiporegistro, mfechahora, midevol, musuario, msondagng, mruidogas, mtiporg, mcantrg,  ;
	mexamenabdo, mestudiosabdo, mmedicaabdo, mdatosabdo, msuccion

If mid = 0
	TEXT TO lcsql TEXTMERGE NOSHOW PRETEXT 7
		Insert into ZabNeoIEAbdomen
		( ABD_nroadmisionRN , ABD_nroregistraRN , ABD_tiporegistro , ABD_fechaHora , ABD_idevol , ABD_usuario , ABD_sondagng , ABD_ruidogas ,
ABD_tiporg , ABD_cantrg , ABD_examenabdo , ABD_estudiosabdo , ABD_medicaabdo , ABD_datosabdo , ABD_succion)
		 Values
		( ?mnroadmisionRN , ?mnroregistraRN , ?mtiporegistro , ?mfechaHora , ?midevol , ?musuario , ?msondagng , ?mruidogas , ?mtiporg ,
?mcantrg , ?mexamenabdo , ?mestudiosabdo , ?mmedicaabdo , ?mdatosabdo , ?msuccion)
	ENDTEXT
Else
	TEXT TO lcsql TEXTMERGE NOSHOW PRETEXT 7
		Update ZabNeoIEAbdomen
		Set ABD_nroadmisionRN  = ?mnroadmisionRN ,
		ABD_nroregistraRN  = ?mnroregistraRN ,
		ABD_tiporegistro  = ?mtiporegistro ,
		ABD_fechaHora  = ?mfechaHora ,
		ABD_idevol  = ?midevol ,
		ABD_usuario  = ?musuario ,
		ABD_sondagng  = ?msondagng ,
		ABD_ruidogas  = ?mruidogas ,
		ABD_tiporg  = ?mtiporg ,
		ABD_cantrg  = ?mcantrg ,
		ABD_examenabdo  = ?mexamenabdo ,
		ABD_estudiosabdo  = ?mestudiosabdo ,
		ABD_medicaabdo  = ?mmedicaabdo ,
		ABD_datosabdo  = ?mdatosabdo ,
		ABD_succion = ?msuccion 
		where ID = ?mid
	ENDTEXT
Endif

If  !prg_ejecutosql(lcsql, "mwk")
	Messagebox("ERROR AL GUARDAR", 16, "ERROR")
	Return .F.
Endif
