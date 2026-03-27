***
***   Actualizacion de turnos cancelados
***

Parameters mobserva,mbloq,mvacexcl
*mvacexcl vacunas excusivas queda el codigo de prestacion
mcodres 	= mwkphorarios.codreserva
mfectur 	= mwkphorarios.fechatur
mcodmed		= mwkphorarios.codmed
mcodpres	= mwkphorarios.codprest
mobserva	= Left(mobserva,255)
mafibloq = mbloq
mcodprestn = Iif(mvacexcl,mcodpres,0)
mccpoamb = ''
mcicpoamb = ''
mvicpoamb = ''
lesrossi = .F.
Do sp_busco_estados With 105 ," and tipo = 5  ","mwkservrossi"
If !Empty(mwkservrossi.Descrip)
	clesrossi =	"INLIST(mwkphorarios.codserv,"+Alltrim(mwkservrossi.Descrip)+")"
	lesrossi = Evaluate(clesrossi )
Endif
lesmk =  (mwkphorarios.usuario = 'TURNOSMARKEY')
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcicpoamb = "  ,codambito "
	mvicpoamb = "  ,?mxambito "
ENDIF

mret = SQLExec(mcon1, "select turnos.*,liberable from turnos,tabtipoturno "+;
	" where &mccpoamb turnos.tipoturno = tabtipoturno.tipoturno and  codmed = ?mcodmed and fechatur = ?mfectur and " + ;
	"codreserva = ?mcodres and codprest = ?mcodpres" , "mwkphorariosz")

If mret < 0
	Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
	If Used("mwkserver1")
		mClientName	= mwkserver1.ClientName
		mDevice		= mwkserver1.Device
		mIPaddress	= mwkserver1.IPaddress
		mMemoria	= mwkserver1.Memoria
		mName 		= mwkserver1.Name
		mClientName	= Iif(Empty(mClientName),Left(Sys(0),At("#",Sys(0))-1),mClientName)
		mName 		= Iif(Empty(mName ),Substr(Sys(0),At("#",Sys(0))+1),mName )
		mProcessId	= mwkserver1.ProcessID
		If Used("mwkusuario")
			mcodvax	= mwkusuario.codigovax
			midusu  = mwkusuario.idusuario
		Else
			mcodvax	= 0
			midusu = ''
		Endif
		mfechas		= sp_busco_fecha_serv('DT')
		mprg 		= "sp_upgrate_turnos_cancel"
		mret = SQLExec(mcon1,"insert into TabCtrlServer (TCS_ClientName,TCS_Device,TCS_Estado"+;
			",TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId,TCS_Usuario,TCS_program )"+;
			" values  (?mClientName,?mDevice,0,?mfechas,?mIPaddress,?mMemoria,?mName"+;
			",?mProcessId, ?mcodvax,?mprg)")
		Use In mwkserver1
	Endif
	Do sp_desconexion With "error"
	Cancel
Endif

Do While !Eof('mwkphorariosz')

	mafili 		= Round(mwkphorariosz.afiliado, 0)
	midcancel 	= mwkmotivo.Id
	midtur		= mwkphorariosz.Id
	mcodent		= mwkphorariosz.codent
	mcodesp		= mwkphorariosz.codesp
	msolici		= mwkphorariosz.codmedsoli
	mdiasem		= mwkphorariosz.diasem
	mfeccan		= sp_busco_fecha_serv('DT')
	mtomado		= mwkphorariosz.fechatomado
	mfgenera	= mwkphorariosz.fechagenera
	mhortur		= mwkphorariosz.horatur
	mdonde		= mwkphorariosz.solicigia
	mttomado	= mwkphorariosz.tipotomado
	mturno		= mwkphorariosz.tipoturno
	mturnonew 	= Iif(mwkphorariosz.liberable= 1 And mfectur <=Ctod("03/09/2022"),17, mturno)
	musugen		= mwkphorariosz.usuariogenera
	musugen		= Iif(Vartype(musugen)="U",mwkphorariosz.usuario,musugen)
	musuari		= Alltrim(mwkphorariosz.usuario)
	musuari1	= Alltrim(Iif(Empty(midusu),musuari,midusu))
	mhhmmTur	= Val(Left(Ttoc(mhortur ,2),2)+Substr(Ttoc(mhortur ,2),4,2))
	mususec		= mwkphorariosz.UsuarioSector
* Llamo al servicio para que avise cancelación del turno
 	If lesrossi  And lesmk 
 		DO prg_mkeges_canapr With "C",midtur 
 	Endif

	mret = SQLExec(mcon1, "update turnos set tipoturno = 9 " + ;
		"where &mccpoamb fechatur = ?mfectur and " + ;
		"horatur = ?mhortur and codmed = ?mcodmed and codreserva = ?mcodres ")

	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
		Do sp_desconexion With "error"
		Cancel
	Endif
	mret = SQLExec(mcon1, "insert into turnos(afiliado, codesp, codmed, codprest, codserv,"+;
		" codent,confirmado, codreserva, diasem, fechatur, hhmmTur, horatur, nrovale, "+;
		" tipotomado, tipoturno, solicigia, usuario, observa, fechagenera,usuariogenera,UsuarioSector "+;
		"&mcicpoamb,ambcentro) " + ;
		"values(?mafibloq , '', ?mcodmed, ?mcodprestn , 0, 0, 0,'', ?mdiasem, ?mfectur, ?mhhmmTur, ?mhortur, 0, 0, " + ;
		"?mturnonew, 0, ?musuari1, ' ',?mfgenera,?musugen,0 &mvicpoamb,?mxcentromedico)")
	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
		Do sp_desconexion With "error"
		Cancel
	Endif

	mret = SQLExec(mcon1,"update turnos set afiliado = ?mafibloq , usuario = '', codprest = 0, " + ;
		"codmedsoli = 0, solicigia = 0, codreserva = '',  tipotomado = 0, " + ;
		"codent = 0, codserv = 0, codesp = '',UsuarioSector = 0 " + ;
		"where &mccpoamb fechatur = ?mfectur and codreserva = ?mcodres and tipoturno = 9")

	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS, AVISAR A SISTEMAS",16, "Validacion")
		Do sp_desconexion With "error"
		Cancel
	Endif

	mret = SQLExec(mcon1, "insert into turnoscancel(afiliado, codcancela, codent, codesp,"+;
		" codmed, codmedsoli, codprest, codreserva, diasem, feccancela, fechatomado, " + ;
		"fechatur, hhmmTur, horatur, solicigia, tipotomado, tipoturno, usuario, usucancela, "+;
		"observa,UsuarioSector,idturnos  &mcicpoamb,ambcentro ) " + ;
		"values(?mafili, ?midcancel, ?mcodent, ?mcodesp, ?mcodmed, ?msolici, ?mcodpres, " + ;
		"?mcodres, ?mdiasem, ?mfeccan, ?mtomado, ?mfectur, ?mhhmmTur, ?mhortur, ?mdonde, " + ;
		"?mttomado, ?mturno, ?musuari, ?musuari1, ?mobserva,?mususec,?midtur &mvicpoamb,?mxcentromedico)")

	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION DEL ARCHIVO DE TURNOS CANCELADOS, AVISAR A SISTEMAS",16, "Validacion")
		Do sp_desconexion With "error"
		Cancel
	Endif
 
* Modificado 2022-03-02
	If  midtur > 0
		Do  prg_osana_turno_cancel With midtur
	Endif
* ---------------------------------
* Llamo a servicio de cancelación de Markey / 2022-08-30
* 20/05/2025. se quitó la limitación 
	If midtur > 0 &&And mxambito = 1
		Do prg_markey_cancelacion With midtur
	Endif


	Select mwkphorariosz

	Skip 1 In mwkphorariosz
Enddo
