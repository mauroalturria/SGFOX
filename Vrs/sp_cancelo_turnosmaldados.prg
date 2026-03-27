***
***   Dado un Profesional, Fdesde, Fhasta, Diasem, Hdesde, Hhasta , Cancelo todos los turnos
***
Parameter mtipo, mcodmed, mfecdes, mfechas, mdiasem, mhora1, mhora2, morigen, mmotivo
DO sp_conexion
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
mret = SQLExec(mcon1, "select turnos.*,nombre,pre_descriprest from turnos,prestacions,prestadores " + ;
	"where  codmed = prestadores.id and  codprest = pre_codprest and fechatur >= {fn curdate()} and " + ;
	"afiliado>2 and confirmado = 0 and  tipoturno= 9 "+;
	" order by HORATUR ", "mwktodos")
 
SET STEP ON 

msql    = "select * from mwktodos "
mindes  = 0
minhas  = 0
mfeccan	= sp_busco_fecha_serv('DT')
  

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

	 
		musuari2  = Left(Alltrim(midusu), 3) + "_MANUAL"
		mobserva  = "CANC.MANUAL"+ " | " + Alltrim(Nvl(mwkphorarioscm.observa,""))
		midcancel = 5
	 
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
			"observa, codserv,UsuarioSector,idturnos,nrovale,confirmado &mcicpoamb) " + ;
			"values(?mafili, ?midcancel, ?mcodent, ?mcodesp, " + ;
			"?mcodmed, ?msolici, ?mcodpres, ?mreserva, ?mdiasem, ?mfeccan, ?mtomado, " + ;
			"?mfectur, ?mhhmmTur, ?mhortur, ?mdonde, ?mttomado, ?mturno, ?musuari, ?musuari1,"+;
			" ?mobserva, ?mcodserv, ?mususec,?midtur,?mnrovale,?mconfirmado &mvicpoamb)")

		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS CANCELADOS, AVISAR A SISTEMAS",16, "Validacion")
			Do prg_cancelo
		Endif
	Endif

	Select mwkphorarioscm

	Skip 1 In mwkphorarioscm
Enddo
minutos = minhas - mindes
 
Do  prg_osana_cancelacion_masiva_2
Use In Select("mwkhorasb")

Use In Select("mwktotcan")
Use In Select("mwkphorariosc")
DO sp_desconexion