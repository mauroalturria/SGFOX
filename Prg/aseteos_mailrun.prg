lParameters lcMails, lcTitulo, lcCuerpo, lcProgram1

*!*	Colocar en un bat
*!*	start mail_run.exe "gfittipaldi@silver-cross.com.ar" "asunto" "body" "C:\DesaGuemes\Exe\admision.exe"

_Screen.Caption = 'Mail Run'
Do seteos With lcProgram1

If File(lcProgram1)
	?"INICIA PROGRAMA"
	xmfechaI = Ttoc(sp_busco_fecha_serv('DT'))

	loWSH = CREATEOBJECT("Wscript.Shell")
	loWSH.Run (lcProgram1 , 1, .T.) && 2=Run Minimizado; 3=Run Maximizado
	RELEASE loWSH

	xmfechaF = Ttoc(sp_busco_fecha_serv('DT'))
	
	lcCuerpo = lcCuerpo + Chr(10) + "" + ;
		'El programa ' + lcProgram1 + Chr(10) + ' inicio : ' + xmfechaI + ;
		Chr(10) + ' termino : ' + xmfechaF 

	?"FIN PROGRAMA"
Else
	lcCuerpo = lcCuerpo + Chr(10) + "" + 'El Archivo del programa no existe ' + lcProgram1
	?"SIN PROGRAMA"
Endif 

?"ENVIO MAIL"
?lcMails
?lcTitulo
?lcCuerpo
?lcProgram1


If !Send_Mail(lcMails, lcTitulo, lcCuerpo)
*!*		WAIT WIND "No envio el mail"	
*!*	Else
*!*		WAIT WIND "Envio el mail" Nowait 	
Endif 
?"FIN MAIL"



?"CIERRE"



*-------------------------------------------------------------------
Function Send_Mail
Parameters lcMails, lcTitulo, lcCuerpo
*-------------------------------------------------------------------
If Parameters() = 0
	lcMails  = 'calvarez@sg.com.ar'
	lcTitulo  = 'Prueba'
	lcCuerpo = 'Cuerpo'
Endif

*!*	Local OleVism as VISM.VisMCtrl.1
*!*	OleVism = Createobject("VISM.VisMCtrl.1")

lcCuerpo = strtran(lcCuerpo,'"',"-")
lcCuerpo = strtran(lcCuerpo,"'","-") + chr(10)

*Local OleVism as Visual Of c:\desaguemes\lib\lib_cubito.vcx
OleVism = Newobject("Visual","c:\desaguemes\lib\lib_cubito.vcx")
OleVism = OleVism.OleVism

OleVism.mserver   = allt(mwktabcfg.oleserver)
OleVism.namespace = allt(mwktabcfg.olespaces) 
OleVism.code = "D SEND^%ZMAIL("+ '"' + lcMails + '","' + lcTitulo + '","'+ lcCuerpo +'","","" )'

OleVism.execflag = 1

mOk	  = OleVism.p0
mresp = OleVism.p2

OleVism.mserver = ""

*---------------------------------------------------------
Procedure Seteos
Lparameters lcProgram1
*---------------------------------------------------------
public mcon1, midusu, mpassw,mcon1,myip,mcon3

set ansi on
set bell off
set cent on
set compatible off
set conf on
set date to french
set decimal to 2
set dele on
set exact on
set exclu off
set fdow to 1
set hours to 24
set near on
set notify off
set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep, ;
	xfrx,xfrx\xfrxlib,xfrx\gdip,xfrx\localization,;
	xfrx\nogdip,xfrx\prevdemo
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
do seteos_ip
myip = IPAddress()


*Set Enginebehavior 70

?"SETEO DEFAULT"
lcDir = Addbs(JUSTPATH(lcProgram1))
Set Default To &lcDir

?"FIN SETEO DEFAULT"
*!*	public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(13)
*!*	dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(20,4),dat_cose(13)
*!*	mresplog = 0

do sp_busco_server_namespaces
do sp_conexion

?"BUSQUEDA SERVER"


