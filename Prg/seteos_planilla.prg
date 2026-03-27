****
**  Seteos del sistema
****
lparameters mipag
Public mcon1, midusu, mpassw,mcon1,myip,mcon3,mipagina ,mxambito 
mxambito = 1

mipagina = mipag
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
set path to scx, lib, mnu, prg, exe, bmp, rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set status bar off
set talk off
set sysmenu off
_screen.keypreview = .t.
set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep, ;
	xfrx,xfrx\xfrxlib,xfrx\gdip,xfrx\localization,;
	xfrx\nogdip,xfrx\prevdemo
do seteos_ip
myip = IPAddress()


public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(13)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(20,4),dat_cose(13)

mresplog = 0
			do sp_busco_server_namespaces				&&& si no es icono web sacar REM
	do seteos_configuracion
			do sp_conexion                             &&& si no es icono web sacar REM
*!*		Esta opcion habilitada para planilla alfabetica de turnos
if !used('mwkexe')
	create cursor mwkexe (nomexe c(20),versionactual c(20), launcher c(50),versionminima c(20),idexe n (2))
	insert into mwkexe values ("MAILTURNOS","1.0.0","\\172.16.5.46//C://mail_turnos.exe","1.0.0",23)
endif

		do form frmplan16			&&&control de nutricion
		
*!*		Estas opciones habilitadas para Estadisticas
*			do form frmplan06 	&& Censos

*!*	*!*		Estas opciones habilitadas para censos
*		do form frmplan01  with 2
*		do form frmplan02
*		do form frmplan03

*!*		Esta opcion habilitada para censos_plan y alfabetico
*		do form frmplan01  with 1
*		do form frmplan01  with 3

*!*	*!*		Esta opcion habilitada para planilla
*		do form frmplan04

*!*	*!*		Esta opcion habilitada para planilla alfabetica de turnos
*!*		do form frmplan04

*!*	*!*		Esta opcion habilitada para planilla de kinesio lunes (plan_kine)
*		do form frmplan05

*!*	*!*		Esta opcion habilitada para act_planilla

*		do sp_grabo_vales_guardia.prg
*!*	*!*		Esta opcion habilitada para complementos
	
* 	do sp_busco_phordatos 

*	do form frmplan13 with 0  &&& Complementos l a v
*	do form frmplan13 with 2  &&& Complementos v
*	do form frmplan13p	with 0	&&& Preliminares l a j
*	do form frmplan13p with 2	&&& Preliminares j a v

*!*		do form frmplan15   &&& Envio Mail Mantenimiento

 	DO sp_desconexion WITH "fin"

*!*	do form frmweb 
*!*	cancel	