Lparameters mprotocolo, mbusco

mret= sqlexec(mcon1,"select ID, tpestado, tpfecharetiro, tpobserva, " + ;
	"tpprotocolo, tpregistrac, tpusuario " + ;
	"FROM TabProtocolo " +;
	"where tpprotocolo = ?mprotocolo " + mbusco ,"mwkprot1")

If mret <= 0
	Aerror(eros)
	Messagebox("ERROR DE LECTURA DE PROTOCOLO",48,"VALIDACION")
	Return .f.
Endif 		