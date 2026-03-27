*!*	 
*!*	Grabo GuaMsg
*!*	 
Parameter mOpcion, mId, mEstado, mCodMed, mProto, mMsg,musuario 

if vartype(musuario) = "U"
	musuario =  mwkusuario.IdUsuario
endif
if vartype(musuario) = "N"
	musuario =  transf(musuario)
endif

mfecha = sp_busco_fecha_serv("DT")
mfecnul = ctod("01/01/1900")

Do Case

	Case mOpcion = 1
		mret = SqlExec(mcon1, "Insert into TabGuaMsg " + ;
			"(TGM_FechaH, TGM_CodMed, TGM_Estado, TGM_Mensaje, TGM_Protocolo, TGM_Usuario ) " + ;
			"Values " + ;
			"(?mfecha, ?mCodMed, ?mEstado, ?mMsg, ?mProto, ?musuario ) ") 
			

	Case mOpcion = 2 && CAMBIO DE ESTADO
		mret = SqlExec(mcon1, "Update TabGuaMsg " + ;
			"Set TGM_Estado = ?mEstado Where Id = ?mId" )
		
EndCase
 
If mret < 0
	MessageBox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	cancel
endif 