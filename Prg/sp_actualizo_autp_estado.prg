**********
* Actualiza Subestado de Autorizaciones
*********
parameters mEstadoActual,mid,mSubEstadoActual
mret = sqlexec(mcon1,"update AutPrevias set APV_Estado = ?mEstadoActual,"+;
	"APV_subEstadopend = ?mSubEstadoActual  where id = ?mid")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

