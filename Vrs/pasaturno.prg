Select b_turno948
SET STEP ON
Scan
	mid = b_turno948.Id
	Requery('b_242_turno')
	midtur      = b_turno948.Id
	mcodres 	= b_turno948.codreserva
	mfectur 	= b_turno948.fechatur
	mafili 		= Round(b_turno948.afiliado, 0)
	mcodent		= b_turno948.codent
	mcodesp		= b_turno948.codesp
	mcodmed		= b_turno948.codmed
	msolici		= b_turno948.codmedsoli
	mcodpres	= b_turno948.codprest
	mreserva	= b_turno948.codreserva
	mcodserv	= b_turno948.codserv
	mdiasem		= b_turno948.diasem
	mtomado		= b_turno948.fechatomado
	mfectur		= b_turno948.fechatur
	mhortur		= b_turno948.horatur
	mdonde		= b_turno948.solicigia
	mttomado	= b_turno948.tipotomado
		mxtomado	= b_turno948.tomado
	mturno		= b_turno948.tipoturno
	musuari		= Alltrim(b_turno948.usuario)
 	msolicigia 	= b_turno948.solicigia 
	mfgenera	= b_turno948.fechagenera
	musugen		= b_turno948.usuariogenera
	 
	musuari		= Alltrim(b_turno948.usuario)
	mobserva 	=  Alltrim(Nvl(b_turno948.observa,""))
	mUsuSec		= Nvl(b_turno948.UsuarioSector,0)
	mafiliado  	= b_turno948.afiliado
	update b_242_turno set afiliado = mafili , usuario = musuari,fechatomado = mtomado, codprest = mcodpres;
		, UsuarioSector = mususec, codmedsoli = msolici, solicigia = msolicigia, codreserva = mcodres ,    ;
		 codent = mcodent, codserv = mcodserv, codesp = mcodesp, tipotomado = mttomado, Tomado = mxtomado

Endscan
