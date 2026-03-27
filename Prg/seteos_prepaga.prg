**  Seteos del sistema

Public mcon1, midusu, mpassw, mresplog

mresplog = 0

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

modify windows screen;
	title "Prepaga";
	FILL FILE "\qepd1a1\solo_marca.jpg"

	do form frmloguin1 with 'PREPAGA'

	if mresplog = 0
		do prepagamenu.mpr
		read events
	else
		quit
	endif	