***
***   Dado un Profesional, Fdesde, Fhasta, Diasem, Hdesde, Hhasta , Cancelo todos los turnos
***

parameter mcodmed, mfecdes

select id from mwkturno where canc = 1 into cursor mwkturnocancel

mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif

select mwkturnocancel

scan
	mid = mwkturnocancel.id

	mret = sqlexec(mcon1, "select * from turnos " + ;
		"where id = ?mid", "mwktodos")
	if mwktodos.afiliado>1
		midtur      = mwktodos.id
		mcodres 	= mwktodos.codreserva
		mfectur 	= mwktodos.fechatur
		mafili 		= round(mwktodos.afiliado, 0)
		mcodent		= mwktodos.codent
		mcodesp		= mwktodos.codesp
		mcodmed		= mwktodos.codmed
		msolici		= mwktodos.codmedsoli
		mcodpres	= mwktodos.codprest
		mreserva	= mwktodos.codreserva
		mcodserv	= mwktodos.codserv
		mdiasem		= mwktodos.diasem
		mtomado		= mwktodos.fechatomado
		mfectur		= mwktodos.fechatur
		mhortur		= mwktodos.horatur
		mdonde		= mwktodos.solicigia
		mttomado	= mwktodos.tipotomado
		mturno		= mwktodos.tipoturno
		musuari		= alltrim(mwktodos.usuario)
		musuari1	= alltrim(midusu)
	endif
	mfeccan		= sp_busco_fecha_serv('DT')
	musuari		= alltrim(mwktodos.usuario)
	musuari1	= alltrim(midusu)
	musuari2    = left(alltrim(midusu), 3) + "_ANULA"
	mobserva 	= "ANULACION"+ " | " + alltrim(nvl(mwktodos.observa,""))
	mUsuSec		= nvl(mwktodos.UsuarioSector,0)
	mafiliado  	= mwktodos.afiliado
	musucan		= mwkusuario.codigovax
	if mafiliado > 1
		mret = sqlexec(mcon1, "insert into turnosaudit (codigo,afiliado, turnoid, fechatomado, usuario &mcicpoamb) "+;
			"values ( 9, ?mafiliado, ?mid, ?mfeccan, ?musucan &mvicpoamb) ")
		musuari2    = left(alltrim(midusu), 3) + "_ANUAGE"
		mobserva 	= "ATAM"+ " | " + alltrim(nvl(mwktodos.observa,""))
		midcancel 	= 27
		mhhmmTur	= val(left(ttoc(mhortur,2),2)+substr(ttoc(mhortur,2),4,2))
		mret = sqlexec(mcon1, "insert into turnoscancel(afiliado, codcancela, codent, codesp, " + ;
			"codmed, codmedsoli, codprest, codreserva, diasem, feccancela, fechatomado, " + ;
			"fechatur, hhmmtur, horatur, solicigia, tipotomado, tipoturno, usuario, usucancela, "+;
			"observa, codserv,UsuarioSector,idturnos &mcicpoamb ) " + ;
			"values(?mafili, ?midcancel, ?mcodent, ?mcodesp, " + ;
			"?mcodmed, ?msolici, ?mcodpres, ?mreserva, ?mdiasem, ?mfeccan, ?mtomado, " + ;
			"?mfectur, ?mhhmmTur, ?mhortur, ?mdonde, ?mttomado, ?mturno, ?musuari, ?musuari1,"+;
			" ?mobserva, ?mcodserv, ?mususec,?midtur &mvicpoamb)")

		if mret < 0
			messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS CANCELADOS, AVISAR A SISTEMAS",16, "Validacion")
			do prg_cancelo
		endif
	endif

	mret = sqlexec(mcon1,"update turnos set afiliado = 0, usuario = '', codprest = 0, " + ;
		"codmedsoli = 0, solicigia = 0, codreserva = '', codent = 0, " + ;
		"codserv = 0, codesp = '' , tipoturno = 9, tipotomado = 0, " + ;
		"usuarioobserva = ?musuari2, fechatomado = ?mfeccan, UsuarioSector = 0 " + ;
		"where id = ?mid ")

	if mret < 0
		messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
		do prg_cancelo
	endif
endscan
