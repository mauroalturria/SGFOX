Select b_turnoscancel
Set Step On
Scan
	mid = b_turnoscancel.Idturnos
	Requery('b_242_turno')
	midtur      = b_turnoscancel.Id
	mcodres 	= b_turnoscancel.codreserva
	mfectur 	= b_turnoscancel.fechatur
	mafili 		= b_turnoscancel.afiliado
	mreserva	= b_turnoscancel.codreserva
	mhortur		= b_turnoscancel.horatur
	If 	mafili 		= b_242_turno.afiliado And mcodres 	= b_242_turno.codreserva And mhortur= b_242_turno.horatur
		Update b_242_turno Set afiliado = 0 , usuario = '',fechatomado = mtomado, codprest = 0;
			, UsuarioSector = 0, codmedsoli = 0, solicigia = 0, codreserva = '' ,    ;
			codent = 0, codserv = 0, codesp = '', tipotomado = 0, Tomado = 0,tipoturno = 9
	Else
	*	Set Step On
	Endif
Endscan
