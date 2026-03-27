***
***   Dado un Profesional, Fdesde, Fhasta, Diasem, Hdesde, Hhasta , Cancelo todos los turnos
***
Parameter mtipo, mfecdes, mfechas, mdiasem, mhora1, mhora2, morigen, mmotivo

*set step on

If vartype(mmotivo) # "N"
	mmotivo = 0
Endif


mccpoamb = ''	
mcicpoamb = ''
mvicpoamb = ''
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
endif

mret = sqlexec(mcon1, "select * from turnos " + ;
	"where &mccpoamb fechatur >= ?mfecdes and fechatur <= ?mfechas and  afiliado > 0 and hhmmtur>=1200 " , "mwktodos")
Select * From mwkphorarios Where afiliado > 0 Into Cursor mwkphorariosmsg
msql    = "select * from mwktodos "
mindes  = 0
minhas  = 0
mfeccan	= sp_busco_fecha_serv('DT')

If mdiasem < 8 or mhora1 > 0 or mhora2 > 0
	msql = msql + 'where 1 = 1 '
	If mdiasem < 8
		msql = msql + " and dow(fechatur) = mdiasem "
	Endif

	If mhora1 > 0
		mindes = int(mhora1/100)*60 + mod(mhora1, 100)
		msql   = msql + " and round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) >= mhora1 "
	Endif

	If mhora2 > 0
		minhas = int(mhora2/100)*60 + mod(mhora2, 100)
		msql   = msql + " and round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) < mhora2 "
	Endif
Endif

msql = msql + " order by fechatur,codmed, horatur into cursor mwkphorarios "
*****&msql
SELECT mwkphorarios
GO top
Do while !Eof('mwkphorarios')

	midtur      = mwkphorarios.Id
	mcodres 	= mwkphorarios.codreserva
	mfectur 	= mwkphorarios.fechatur
	mafili 		= Round(mwkphorarios.afiliado, 0)
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
	musuari		= Alltrim(mwkphorarios.usuario)
	musuari1	= Alltrim(midusu)
	mconfirmado = mwkphorarios.confirmado
	mnrovale	= mwkphorarios.nrovale

		musuari2  = left(alltrim(midusu), 3) + "_FERIADO"
		mobserva  = "CANC.FERIADO"+ " | " + alltrim(nvl(mwkphorarios.observa,""))
		midcancel = 5

	mUsuSec		= nvl(mwkphorarios.UsuarioSector,0)

	If mafili > 0

		mret = sqlexec(mcon1,"update turnos set afiliado = 0, usuario = '', codprest = 0, " + ;
			"codmedsoli = 0, solicigia = 0, codreserva = '', codent = 0, " + ;
			"codserv = 0, codesp = '' , tipoturno = 9, tipotomado = 0, " + ;
			"usuarioobserva = ?musuari2, fechatomado = ?mfeccan, UsuarioSector = 0 " + ;
			"where &mccpoamb fechatur = ?mfectur and codmed = ?mcodmed and id = ?midtur")

	Else
		mret = sqlexec(mcon1, "update turnos set tipoturno = 9, " + ;
			"usuarioobserva = ?musuari2, fechatomado = ?mfeccan " + ;
			"where &mccpoamb fechatur = ?mfectur and horatur = ?mhortur and " + ;
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
			"observa, codserv,UsuarioSector,idturnos &mcicpoamb) " + ;
			"values(?mafili, ?midcancel, ?mcodent, ?mcodesp, " + ;
			"?mcodmed, ?msolici, ?mcodpres, ?mreserva, ?mdiasem, ?mfeccan, ?mtomado, " + ;
			"?mfectur, ?mhhmmTur, ?mhortur, ?mdonde, ?mttomado, ?mturno, ?musuari, ?musuari1,"+;
			" ?mobserva, ?mcodserv, ?mususec,?midtur &mvicpoamb)")

		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS CANCELADOS, AVISAR A SISTEMAS",16, "Validacion")
			Do prg_cancelo
		Endif
	Endif

	Skip 1 in mwkphorarios
Enddo
minutos = minhas - mindes

Use in select("mwkphorariosc")
Select * from mwkphorarios where tipoturno <> 9 and afiliado > 1 group by horatur, afiliado into cursor mwkphorariosc

*set step on

Use in select("mwktotcan")


&& En caso de tener la misma fecha con distintas franjas
Use in select("mwkhorasb")
Select * from mwkhoras group by fechatur into cursor mwkhorasb

*!*	select mwkhorasb
*!*	Go top

*!*	Scan all

*!*		mfechaturant = fechatur
*!*		mncodmedant	 = mcodmed
*!*		mcantpac	 = iif(minutos > 0, minutos, minfran)
*!*		mcm 		 = iif(morigen = 1, 0, iif (morigen = 2, 29, 2))

*!*	*!*	 0-> Canc. x el medico
*!*	*!*	 2-> Canc. x probl. técnicos
*!*	*!*	29-> Canc. Agenda

*!*		mpaccancel = 0

*!*	*!*		If mcm = 0  &&& no se porque hacia esta restriccion...
*!*		
*!*	*!*			Select count(*) as lpaccan from mwkphorariosc;
*!*	*!*				where fechatur = mfechaturant  ;
*!*	*!*				into cursor mwktotcan
*!*	*!*				
*!*	*!*			If used("mwktotcan")
*!*	*!*				mpaccancel = nvl(mwktotcan.lpaccan,0)
*!*	*!*			Endif

*!*	*!*			Select * from mwkphorariosc;
*!*	*!*				where fechatur = mfechaturant  ;
*!*	*!*				into cursor mwktotcan			
*!*	*!*				
*!*	*!*			If used("mwktotcan")
*!*	*!*				mpaccancel = reccount("mwktotcan")			
*!*	*!*			Endif
*!*	*!*			
*!*	*!*			Use in select("mwktotcan")
*!*			
*!*	*!*		Endif

*!*	*!*		mret = sqlexec(mcon1,'insert into turnosreprog (cantidadpac,codmed,codmedrepro,fecharep,fechaturant,'+;
*!*	*!*			'fechaturnva,usuario,motivo, paccancel &mcicpoamb) values' +;
*!*	*!*			' (?mcantpac,?mncodmedant,?mcm,?mfeccan,?mfechaturant,?mfechaturant,?midusu,?mmotivo,?mpaccancel &mvicpoamb)')

*!*	*!*		If mret < 0
*!*	*!*			=aerror(eros)
*!*	*!*			Messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS'+;
*!*	*!*				chr(10)+eros(3), 48,'Validación')
*!*	*!*			Cancel
*!*	*!*		Endif

*!*		Select mwkhorasb

*!*	Endscan

Use in select("mwkhorasb")

Use in select("mwktotcan")
Use in select("mwkphorariosc")
