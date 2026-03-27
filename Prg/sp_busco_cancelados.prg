*****
** recupero de turnoscancel a turnos
*****
parameters mfecha,mcodmed,mmot

mret = sqlexec(mcon1,"select * from turnoscancel "+;
	"where codmed = ?mcodmed and fechatur = ?mfecha "+;
	"and codcancela = ?mmot ", "mwkhay")

sele mwkhay
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
		"where id = ?midturno and horatur= ?mhoratur and afiliado = 0 ")

endscan
sele mwkhay
scan
	midcance = id
	mid 	= left(mwkhay.codreserva, 7)
	mcreserva	= mwkhay.codreserva
	mhoratur	= mwkhay.horatur
	mafi 		= mwkhay.afiliado
	mret = sqlexec(mcon1,"select * from turnos  " + ;
		"where id = ?mid and horatur= ?mhoratur and codreserva = ?mcreserva "+;
		" and afiliado = ?mafi " ,"mwkcontrol")
	if reccount("mwkcontrol")>0
		mret = sqlexec(mcon1,"delete from turnoscancel  " + ;
			"where id = ?midcance and horatur= ?mhoratur and codreserva = ?mcreserva ","mwkcontrol")
	endif

endscan
mret = sqlexec(mcon1,"select * from turnoscancel "+;
	"where codmed = ?mcodmed and fechatur = ?mfecha "+;
	"and codcancela = ?mmot ", "mwkhay")