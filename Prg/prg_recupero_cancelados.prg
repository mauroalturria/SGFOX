*****
** recupero de turnoscancel a turnos
*****
	if !used("mwkserver1")
		DO sp_conexion
		Ldisconnec = .t.
	ENDIF


mfecha  = ctod('06/03/2003')
mcodmed = 0

mret = sqlexec(mcon1,"select * from turnoscancel " + ;
	"where codmed = ?mcodmed and feccancela>= '2005-06-17 15:40:00' and " + ;
	"observa like 'CANC%' ", "mwkhay")
*set step on

do while !eof('mwkhay')

	midturno 	= left(mwkhay.codreserva, 7)
	mnrohc		= mwkhay.afiliado
	midusu		= mwkhay.usuario
	mhtomado	= mwkhay.fechatomado
	mcodprest	= mwkhay.codprest
	mcodsoli	= mwkhay.codmedsoli
	msolicigia  = mwkhay.solicigia
	mcreserva	= mwkhay.codreserva
	mcodent		= mwkhay.codent
	mcodserv	= 2200
	mcodespe	= mwkhay.codesp
	mtiptur		= mwkhay.tipoturno


	mret = sqlexec(mcon1,"update turnos set afiliado = ?mnrohc, usuario = ?midusu, " + ;
		"fechatomado = ?mhtomado, codprest = ?mcodprest, tipoturno =  ?mtiptur, " + ;
		"codmedsoli = ?mcodsoli, solicigia = ?msolicigia, codreserva = ?mcreserva, " + ;
		"codent = ?mcodent, codserv = ?mcodserv, codesp = ?mcodespe " + ;
		"where id = ?midturno")

	skip 1 in mwkhay
enddo
mret = sqlexec(mcon1,"update turnoscancel set codmed=0 " + ;
	"where codmed = ?mcodmed and feccancela>= '2005-06-17 15:40:00' and " + ;
	"observa like 'CANC%' ")

IF Ldisconnec
	DO sp_desconexion WITH thisform.name
ENDIF
