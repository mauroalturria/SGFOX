****
**  Seteos del sistema
****

Public mcon1, mcon1, mcon4, midusu,myip,mxambito 
mxambito = 1


public vec_vale(31,3), dat_vale(30), item_vale(31,3)
dimension vec_vale(31,3), dat_vale(30), item_vale(31,3)
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
set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
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

	DO sp_conexion
 	do form frmnutri17a		&&& Planilla nocturna y feriados nutri_pla.exe
*	do form frmnutri17b		&&& Planilla nocturna y feriados nutri_pla_gua.exe
*	do form frmnutri09a		&&& Desayunos o merienda			desayunos.exe
*	do form frmnutri09b		&&& controla desayunos  desayunos_crtl.exe
	DO sp_desconexion WITH "fin"

