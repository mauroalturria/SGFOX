Lparameters mOpcion, mid, mfechorate, mpesokg, macostado, ;
	mlong, mpc,	mproto

mIdUsua = mwkUsuario.idusuario
mfechoy = sp_busco_fecha_serv('DT')

Do Case 
	Case mOpcion = 1 && actualizaciones completas
		If mid = 0 
			mret = Sqlexec(mcon1, "Insert into TabAmbPedia (" + ;
				"Ap_fechahoraate, Ap_pesokg, , Ap_acostado, " + ;
				"Ap_longitud, Ap_pc, " + ;
				"Ap_fechamov, Ap_protocolo, Ap_hce, Ap_idusuario " + ;
				") Values (" + ;
				"?mfechorate, ?mpesokg, ?macostado, " + ;
				"?mlong, ?mpc, " + ;
				"?mfechoy, ?mProto, ?mHce, ?mIdUsua)")
		Else
			mret = Sqlexec(mcon1, "Update TabAmbPedia Set " + ;
				"Ap_pesokg = ?mpesokg, Ap_acostado = ?macostado, " + ;
				"Ap_longitud = ?mlong, Ap_pc = ?mpc, " + ;
				"Ap_fechamov = ?mfechoy, Ap_idusuario = ?mIdUsua " + ;
				"Where Id = ?mId ")
		Endif 	

	Case mOpcion = 2 && solo datos
		If mid = 0 
			mret = Sqlexec(mcon1, "Insert into TabAmbPedia (" + ;
				"Ap_fechahoraate, Ap_pesokg, Ap_acostado, " + ;
				"Ap_longitud, Ap_pc, " + ;
				"Ap_fechamov, Ap_protocolo, Ap_idusuario " + ;
				") Values (" + ;
				"?mfechorate, ?mpesokg, ?macostado, " + ;
				"?mlong, ?mpc, " + ;
				"?mfechoy, ?mProto, ?mIdUsua " + ;
				")")
		Else
			mret = Sqlexec(mcon1, "Update TabAmbPedia Set " + ;
				"Ap_pesokg = ?mpesokg, Ap_acostado = ?macostado, " + ;
				"Ap_longitud = ?mlong, Ap_pc = ?mpc, " + ;
				"Ap_fechamov = ?mfechoy, Ap_idusuario = ?mIdUsua " + ;
				"Where Id = ?mId ")
		Endif 	

Endcase

If mret<=0 
	Messagebox("ERROR AL ACTUALIZAR PEDIATRIA",48,"VALIDACION")
	Return .f.
Endif 	