Lparameters mid, mestado, mfecreti, mobs, mproto, mregi, musu 

mobs1 = prg_concat(mobs)

mret = Sqlexec(mcon1,"Update TabProtocolo Set " + ;
	"Tpestado = ?mestado, Tpfecharetiro = ?mfecreti, Tpobserva = ?mobs1, Tpprotocolo = ?mproto, " + ;
	"Tpregistrac = ?mregi, Tpusuario = ?musu " + ;
	"where id = ?mid ")

	
If mret <= 0
	Aerror(eros)
	Messagebox("ERROR AL ACTUALIZAR EL PROTOCOLO",48,"VALIDACION")
	Return .f.
Endif 	
