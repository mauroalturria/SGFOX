**  Seteos del sistema

set ansi on
set bell off
set cent on
set compatible off
set conf on 
set date to french
set decimal to 2
*set defaul to \\Sca_digital\SYS\datos\fundacion\congresos
set dele on
set exact on
set exclu off
set near on
set notify off
set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
set optimize on
set point to ","
set safety off
set separator to "."
set status off
set talk off
set sysmenu off

modify windows screen;
	title "CONGRESOS"

	open database \\Sca_digital\SYS\datos\fundacion\congresos\dbf\dbcongresos shared

	do form frmcongre05
	read events
