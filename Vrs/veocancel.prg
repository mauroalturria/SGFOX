*****
** recupero de turnoscancel a turnos
*****
public mcon1
do sp_conexion

mfecha  = ctot('01/09/2006')
mret = sqlexec(mcon1,"select reg_nombrepac,turnoscancel.* from turnoscancel,registracio "+;
			" where feccancela >= ?mfecha "+;
			" and codcancela <> 5 and afiliado=reg_nroregistrac ", "mwkhay")

	sele mwkhay
	brow	
	set step on
	scan
	
		midturno 	= left(mwkhay.codreserva, 7)
	mnrohc		= mwkhay.afiliado
		midusu		= mwkhay.usuario
		mhtomado	= mwkhay.fechatomado
		mcodprest	= mwkhay.codprest
		mcodsoli	= mwkhay.codmedsoli
		msolicigia  = mwkhay.solicigia
		mcreserva	= mwkhay.codreserva
		mcodent		= mwkhay.codent
		mcodserv	= mwkhay.codserv
		mcodespe	= mwkhay.codesp
		mtiptur		= mwkhay.tipoturno
		mtomado  	= 1
		mhoratur	= mwkhay.horatur
	
		mret = sqlexec(mcon1,"update turnos set afiliado = ?mnrohc, usuario = ?midusu, " + ;
						"fechatomado = ?mhtomado, codprest = ?mcodprest, tipoturno =  ?mtiptur, " + ;
						"codmedsoli = ?mcodsoli, solicigia = ?msolicigia, codreserva = ?mcreserva, " + ;
						"codent = ?mcodent, codserv = ?mcodserv, codesp = ?mcodespe, tipotomado = ?mtomado " + ;
						"where id = ?midturno and horatur= ?mhoratur ")
	
	endscan
	sele mwkhay
	scan
		midcance = id
		mid 	= left(mwkhay.codreserva, 7)
		mcreserva	= mwkhay.codreserva
		mhoratur	= mwkhay.horatur
	
		mret = sqlexec(mcon1,"select * from turnos  " + ;
						"where id = ?mid and horatur= ?mhoratur and codreserva = ?mcreserva ","mwkcontrol")
		if reccount("mwkcontrol")>0
			mret = sqlexec(mcon1,"delete from turnoscancel  " + ;
						"where id = ?midcance and horatur= ?mhoratur and codreserva = ?mcreserva ","mwkcontrol")
		endif

	endscan
do sp_desconexion