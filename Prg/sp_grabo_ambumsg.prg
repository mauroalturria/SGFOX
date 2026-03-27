*!*
*!*	Grabo AmbMsg
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
	mret = SqlExec(mcon1, "Insert into TabAmbMsg " + ;
		"(TAM_FechaH,TAM_CodMed,TAM_Estado,TAM_Mensaje,TAM_Protocolo,TAM_Usuario)" + ;
		"Values " + ;
		"(?mfecha,?mCodMed,?mEstado,?mMsg,?mProto,?musuario)")

Case mOpcion = 2 && CAMBIO DE ESTADO
	mret = SqlExec(mcon1, "Update TabAmbMsg " + ;
		"Set TAM_Estado = ?mEstado Where Id = ?mId" )

Case mOpcion = 3 && CAMBIO DE ESTADO/visto
	mret = SqlExec(mcon1, "Update TabAmbMsg " + ;
		"Set TAM_Estado = ?mEstado, TAM_Mensaje= ?mMsg Where Id = ?mId" )
Endcase

If mret < 0
	Messagebox("EN ACTUALIZACION DEL MAESTRO DE MENSAJES"+chr(10)+;
	"AMBULATORIOS - AVISE A SISTEMAS",16,"ERROR")
Endif
