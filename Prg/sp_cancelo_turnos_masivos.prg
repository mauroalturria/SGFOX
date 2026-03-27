***
***   Dado un Profesional, Fdesde, Fhasta, Diasem, Hdesde, Hhasta , Cancelo todos los turnos
***
Parameter mtipo, mcodmed, mfecdes, mfechas, mdiasem, mhora1, mhora2, morigen, mmotivo

If Vartype(mmotivo) # "N"
	mmotivo = 0
Endif
	Do sp_busco_estados With 7,' and tipo = 77 ','mwkactiva'
	Select mwkactiva
	fechaactiva = Ctod(Alltrim(mwkactiva.Descrip))
	If Vartype(fechaactiva)<>"D"
		fechaactiva = sp_busco_fecha_serv("DD")
	Endif


mccpoamb = ''
mcicpoamb = ''
mvicpoamb = ''
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
Endif

mret = SQLExec(mcon1, "select * from turnos " + ;
	"where &mccpoamb fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
	"codmed = ?mcodmed", "mwktodos")

msql    = "select * from mwktodos "
mindes  = 0
minhas  = 0
mfeccan	= sp_busco_fecha_serv('DT')

If mdiasem < 8 Or mhora1 > 0 Or mhora2 > 0
	msql = msql + 'where 1=1  ' &&TRANSFORM(codmed,"@L 9999")+DTOS(fechatur) in (select TRANSFORM(codmed,"@L 9999")+DTOS(fechatur) from MWkphorarios )
	If mdiasem < 8
		msql = msql + " and dow(fechatur) = mdiasem "
	Endif

	If mhora1 > 0
		mindes = Int(mhora1/100)*60 + Mod(mhora1, 100)
		msql   = msql + " and round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) >= mhora1 "
	Endif

	If mhora2 > 0
		minhas = Int(mhora2/100)*60 + Mod(mhora2, 100)
		msql   = msql + " and round(val(strtran(left(ttoc(horatur,2), 5), ':', '')), 0) < mhora2 "
	Endif
Else
*msql = msql + ' where transform(codmed,"@L 9999")+dtos(fechatur) in (select transform(codmed,"@L 9999")+dtos(fechatur) from MWkphorarios )' '
Endif

msql = msql + " order by fechatur, horatur into cursor mwkphorarioscm "
&msql

* Argregado para envío de mensajeria 2021/11/15
Select * From mwkphorarioscm Where afiliado > 0 Into Cursor mwkphorariosmsg
* --------------------------------------------------------------------

Do While !Eof('mwkphorarioscm')

	midtur      = mwkphorarioscm.Id
	mcodres 	= mwkphorarioscm.codreserva
	mfectur 	= mwkphorarioscm.fechatur
	mafili 		= Round(mwkphorarioscm.afiliado, 0)
	mcodent		= mwkphorarioscm.codent
	mcodesp		= mwkphorarioscm.codesp
	mcodmed		= mwkphorarioscm.codmed
	msolici		= mwkphorarioscm.codmedsoli
	mcodpres	= mwkphorarioscm.codprest
	mreserva	= mwkphorarioscm.codreserva
	mcodserv	= mwkphorarioscm.codserv
	mdiasem		= mwkphorarioscm.diasem
	mtomado		= mwkphorarioscm.fechatomado
	mfectur		= mwkphorarioscm.fechatur
	mhortur		= mwkphorarioscm.horatur
	mdonde		= mwkphorarioscm.solicigia
	mttomado	= mwkphorarioscm.tipotomado
	mturno		= mwkphorarioscm.tipoturno
	musuari		= Alltrim(mwkphorarioscm.usuario)
	musuari1	= Alltrim(midusu)
	mconfirmado = mwkphorarioscm.confirmado
	mnrovale	= mwkphorarioscm.nrovale

	If mtipo = 1
		musuari2  = Left(Alltrim(midusu), 3) + "_MASIVA"
		mobserva  = "CANC.MASIVA"+ " | " + Alltrim(Nvl(mwkphorarioscm.observa,""))
		midcancel = 5
	Else
		musuari2  = Left(Alltrim(midusu), 3) + "_ANUAGE"
		mobserva  = "AAM"+ " | " + Alltrim(Nvl(mwkphorarioscm.observa,""))
		midcancel = 7
	Endif
	mUsuSec		= Nvl(mwkphorarioscm.UsuarioSector,0)

	If mafili > 0

		mret = SQLExec(mcon1,"update turnos set afiliado = 0, usuario = '', codprest = 0, " + ;
			"codmedsoli = 0, solicigia = 0, codreserva = '', codent = 0, " + ;
			"codserv = 0, codesp = '' , tipoturno = 9, tipotomado = 0, confirmado = 0, nrovale = 0," + ;
			"usuarioobserva = ?musuari2, fechatomado = ?mfeccan, UsuarioSector = 0 " + ;
			"where &mccpoamb fechatur = ?mfectur and codmed = ?mcodmed and id = ?midtur")

	Else
		mret = SQLExec(mcon1, "update turnos set tipoturno = 9, " + ;
			"usuarioobserva = ?musuari2, fechatomado = ?mfeccan " + ;
			"where &mccpoamb fechatur = ?mfectur and horatur = ?mhortur and " + ;
			"codmed = ?mcodmed and id = ?midtur")

	Endif

	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
		Do prg_cancelo
	Endif

	If mafili > 1
		mhhmmTur	= Val(Left(Ttoc(mhortur,2),2)+Substr(Ttoc(mhortur,2),4,2))
		mret = SQLExec(mcon1, "insert into turnoscancel(afiliado, codcancela, codent, codesp, " + ;
			"codmed, codmedsoli, codprest, codreserva, diasem, feccancela, fechatomado, " + ;
			"fechatur, hhmmtur, horatur, solicigia, tipotomado, tipoturno, usuario, usucancela, "+;
			"observa, codserv,UsuarioSector,idturnos,nrovale,confirmado &mcicpoamb,ambcentro) " + ;
			"values(?mafili, ?midcancel, ?mcodent, ?mcodesp, " + ;
			"?mcodmed, ?msolici, ?mcodpres, ?mreserva, ?mdiasem, ?mfeccan, ?mtomado, " + ;
			"?mfectur, ?mhhmmTur, ?mhortur, ?mdonde, ?mttomado, ?mturno, ?musuari, ?musuari1,"+;
			" ?mobserva, ?mcodserv, ?mususec,?midtur,?mnrovale,?mconfirmado &mvicpoamb,?mxcentromedico)")

		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS CANCELADOS, AVISAR A SISTEMAS",16, "Validacion")
			Do prg_cancelo
		Endif
	Endif

	Select mwkphorarioscm

	Skip 1 In mwkphorarioscm
Enddo
minutos = minhas - mindes

Use In Select("mwkphorariosc")
Select * From mwkphorarioscm Where tipoturno <> 9 And afiliado > 1 Group By horatur, afiliado Into Cursor mwkphorariosc

*set step on

Use In Select("mwktotcan")


&& En caso de tener la misma fecha con distintas franjas
Use In Select("mwkhorasb")
Select * From mwkhoras Group By fechatur Into Cursor mwkhorasb

Select mwkhorasb
Go Top

Scan All

	mfechaturant = fechatur
	mncodmedant	 = mcodmed
	mcantpac	 = Iif(minutos > 0, minutos, minfran)
	mcm 		 = Iif(morigen = 1, 0, Iif (morigen = 2, 29, 2))

*!*	 0-> Canc. x el medico
*!*	 2-> Canc. x probl. técnicos
*!*	29-> Canc. Agenda

	mpaccancel = 0

*!*		If mcm = 0  &&& no se porque hacia esta restriccion...

*!*			Select count(*) as lpaccan from mwkphorariosc;
*!*				where fechatur = mfechaturant  ;
*!*				into cursor mwktotcan
*!*
*!*			If used("mwktotcan")
*!*				mpaccancel = nvl(mwktotcan.lpaccan,0)
*!*			Endif

	Select * From mwkphorariosc;
		where fechatur = mfechaturant  ;
		into Cursor mwktotcan

	If Used("mwktotcan")
		mpaccancel = Reccount("mwktotcan")
	Endif

	Use In Select("mwktotcan")

*!*		Endif

	mret = SQLExec(mcon1,'insert into turnosreprog (cantidadpac,codmed,codmedrepro,fecharep,fechaturant,'+;
		'fechaturnva,usuario,motivo, paccancel &mcicpoamb) values' +;
		' (?mcantpac,?mncodmedant,?mcm,?mfeccan,?mfechaturant,?mfechaturant,?midusu,?mmotivo,?mpaccancel &mvicpoamb)')

	If mret < 0
		=Aerror(eros)
		Messagebox('ERROR EN LA ACTUALIZACION, AVISAR A SISTEMAS'+;
			chr(10)+eros(3), 48,'Validación')
		Cancel
	Endif

	Select mwkhorasb

Endscan

Use In Select("mwkhorasb")

Use In Select("mwktotcan")
Use In Select("mwkphorariosc")
