*
* Registro de LOG en TABPROTOCOLO - ENTREGA A FACTURACION -
*
Lparameters mvalor,mobserv,mfecha,mproto,mregis,musuar

mret = sqlexec(mcon1,"INSERT INTO TabProtocolo (tpestado,tpobserva,tpfecharetiro,"+;
	"tpprotocolo,tpregistrac,tpusuario) values (?mvalor,?mobserv,?mfecha,?mproto,"+;
	"?mregis,?musuar)")

If mret < 0
	Messagebox("EN REGISTRO DE MOVIMIENTO, ENTREGA A FACTURACION"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
