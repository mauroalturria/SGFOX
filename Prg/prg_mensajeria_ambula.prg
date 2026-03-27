Lparameters phc,pcodmed,pentidad,pnroafiliado,pprotocolo,hayac,ntipo,dx

*********************************************************
* Nueva Versión 2025-10-06
* Fabián
* Se quita el envío de whatsapp
* Generación de orden práctica con/sin protocolo
* El envío de mail lo hago desde la web
*********************************************************

lexe = ""
lpexe = "" 
lcsub = ""

If Used('mwkexe')
	lexe = Upper(Alltrim(mwkexe.nomexe))
Endif

Do Case
Case lexe = "AMBULATORIO"
	lpexe = "AMB"
Case lexe = "GUARDIA"
	lpexe = "GUA"
Otherwise
	lpexe = ""
Endcase

Do Case
Case ntipo = 0
	maltacomp = "0"
	lcsub = "bc"
	lcarchweb = 'practicas_vfp_bc_new.php'
Case ntipo = 1
	maltacomp = "1"
	lcsub = "ac"
	lcarchweb = 'practicas_vfp_ac.php'
Case ntipo = 2
	lcsub = "acsa"
	maltacomp = "1"
	lcarchweb = 'practicas_vfp_ac.php'
Case ntipo = 3
	lcsub = "acsaant"
	maltacomp = "1"
	lcarchweb = 'practicas_vfp_ac.php'
Endcase

Do sp_busco_estados With 57, " and tipo = 86 and estado = 1  ","mwkOrdenWeb"

If !Reccount('mwkOrdenWeb')>0
	Return .F.
Endif

Select mwkOrdenWeb

lcURL = Alltrim(mwkOrdenWeb.Descrip)

ldFecha = Date()  && o cualquier otra fecha
lcFecha = Transform(Year(ldFecha), "@L 9999") + "-" + ;
	TRANSFORM(Month(ldFecha), "@L 99") + "-" + ;
	TRANSFORM(Day(ldFecha), "@L 99")


lcHC 		= Alltrim(phc)

lcSql = "select REG_nroregistrac from REGISTRACIO where REG_nrohclinica = '"+lcHC+"'"
If !Prg_EjecutoSql(lcSql,"mwkOWReg")
	Exit
Endif

If !Reccount("mwkOWReg")>0
	Return .F.
Endif

lcReg		= Transform(mwkOWReg.REG_nroregistrac)
lcProto		= Alltrim(pprotocolo)
lcAmbito	= Transform(mxambito)
lcExe		= lpexe
lcDx            = Transform(dx)

lcParametros = lcarchweb + "?fecha=" + lcFecha + "&reg=" + lcReg + "&prot=" + lcProto + "&dx=" + lcDX + "&ambito=" + lcAmbito + "&exe=" + lcExe

lclink = lcURL + lcParametros

Use In Select("mwkOrdenWeb")

Try
	loHTTP = Createobject("WinHttp.WinHttpRequest.5.1")
	loHTTP.Open("GET", lclink, .F.)
	loHTTP.Send()
	lcResponseText = Alltrim(loHTTP.ResponseText)
Catch To loError
	Messagebox( "Error: " + loError.Message,16,"Error al enviar orden de práctica médica por correo")
Endtry

loHTTP = Null
Release loHTTP
