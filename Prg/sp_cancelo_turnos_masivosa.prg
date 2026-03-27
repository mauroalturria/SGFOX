***
***   Dado un Profesional, Fdesde, Fhasta, Diasem, Hdesde, Hhasta , Cancelo todos los turnos
***

Parameter mtipo, mcodmed, mfecdes, mfechas, mdiasem, mhora1, mhora2, morigen, mmotivo

If vartype(mmotivo) # "N"
	mmotivo = 0
Endif

mret = sqlexec(mcon1, "select * from turnos " + ;
	"where fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
	"codmed = ?mcodmed", "mwktodos")

msql = "select * from mwktodos "
mindes = 0
minhas = 0
mfeccan		= sp_busco_fecha_serv('DT')
If mdiasem < 8 or mhora1 > 0 or mhora2 > 0
	msql = msql + 'where 1 = 1 '
	If mdiasem < 8
		msql = msql + " and dow(fechatur) = mdiasem "
	Endif

	If mhora1 > 0
		mindes = int(mhora1/100)*60 + mod(mhora1, 100)
		msql = msql + " and round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) >= mhora1 "
	Endif

	If mhora2 > 0
		minhas = int(mhora2/100)*60 + mod(mhora2, 100)
		msql = msql + " and round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) < mhora2 "
	Endif
Endif

msql = msql + " order by fechatur, horatur into cursor mwkphorarios "
&msql

Do while !eof('mwkphorarios')

	midtur      = mwkphorarios.id
	mcodres 	= mwkphorarios.codreserva
	mfectur 	= mwkphorarios.fechatur
	mafili 		= round(mwkphorarios.afiliado, 0)
	mcodent		= mwkphorarios.codent
	mcodesp		= mwkphorarios.codesp
	mcodmed		= mwkphorarios.codmed
	msolici		= mwkphorarios.codmedsoli
	mcodpres	= mwkphorarios.codprest
	mreserva	= mwkphorarios.codreserva
	mcodserv	= mwkphorarios.codserv
	mdiasem		= mwkphorarios.diasem
	mtomado		= mwkphorarios.fechatomado
	mfectur		= mwkphorarios.fechatur
	mhortur		= mwkphorarios.horatur
	mdonde		= mwkphorarios.solicigia
	mttomado	= mwkphorarios.tipotomado
	mturno		= mwkphorarios.tipoturno
	musuari		= alltrim(mwkphorarios.usuario)
	musuari1	= alltrim(midusu)

	If mtipo = 1
		musuari2    = left(alltrim(midusu), 3) + "_MASIVA"
		mobserva 	= "CANC.MASIVA"+ " | " + alltrim(nvl(mwkphorarios.observa,""))
		midcancel 	= 5
	Else
		musuari2    = left(alltrim(midusu), 3) + "_ANUAGE"
		mobserva 	= "AAM"+ " | " + alltrim(nvl(mwkphorarios.observa,""))
		midcancel 	= 7
	Endif
	mUsuSec		= nvl(mwkphorarios.UsuarioSector,0)

	If mafili > 0

		mret = sqlexec(mcon1,"update turnos set afiliado = 0, usuario = '', codprest = 0, " + ;
			"codmedsoli = 0, solicigia = 0, codreserva = '', codent = 0, " + ;
			"codserv = 0, codesp = '' , tipoturno = 9, tipotomado = 0, " + ;
			"usuarioobserva = ?musuari2, fechatomado = ?mfeccan, UsuarioSector = 0 " + ;
			"where fechatur = ?mfectur and codmed = ?mcodmed and id = ?midtur")

	Else
		mret = sqlexec(mcon1, "update turnos set tipoturno = 9, " + ;
			"usuarioobserva = ?musuari2, fechatomado = ?mfeccan " + ;
			"where fechatur = ?mfectur and horatur = ?mhortur and " + ;
			"codmed = ?mcodmed and id = ?midtur")

	Endif
	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
		Do prg_cancelo
	Endif
	If mafili > 1
		mhhmmTur	= val(left(ttoc(mhortur,2),2)+substr(ttoc(mhortur,2),4,2))
		mret = sqlexec(mcon1, "insert into turnoscancel(afiliado, codcancela, codent, codesp, " + ;
			"codmed, codmedsoli, codprest, codreserva, diasem, feccancela, fechatomado, " + ;
			"fechatur, hhmmtur, horatur, solicigia, tipotomado, tipoturno, usuario, usucancela, "+;
			"observa, codserv,UsuarioSector ) " + ;
			"values(?mafili, ?midcancel, ?mcodent, ?mcodesp, " + ;
			"?mcodmed, ?msolici, ?mcodpres, ?mreserva, ?mdiasem, ?mfeccan, ?mtomado, " + ;
			"?mfectur, ?mhhmmTur, ?mhortur, ?mdonde, ?mttomado, ?mturno, ?musuari, ?musuari1,"+;
			" ?mobserva, ?mcodserv, ?mususec )")

		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS CANCELADOS, AVISAR A SISTEMAS",16, "Validacion")
			Do prg_cancelo
		Endif
	Endif

	Skip 1 in mwkphorarios
Enddo
minutos = minhas - mindes
Select mwkhoras
Scan
	mfechaturant= fechatur
	mncodmedant	= mcodmed
	mcantpac	= iif( minutos > 0, minutos, minfran )

	mcm 		=  iif (morigen = 1, 0, iif (morigen = 2, 29, 2))  
		&&& 0-> cancelacion por el medico 2-> Canc x probl.tecnicos 29-> Canc.Agenda

	mret = sqlexec(mcon1,'insert into turnosreprog (cantidadpac,codmed,codmedrepro,fecharep,fechaturant,'+;
		'fechaturnva,usuario,motivo) values' +;
		' (?mcantpac,?mncodmedant,?mcm,?mfeccan,?mfechaturant,?mfechaturant,?midusu,?mmotivo)')

	If mret < 0
		=aerr(eros)
		Messagebox(eros(3))
		Messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS', 48,'Validación')
		Cancel
	Endif

Endscan
