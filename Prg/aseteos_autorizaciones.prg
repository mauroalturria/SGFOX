****
**  Seteos del sistema
****

Public mcon1, mcon1, mcon4, midusu

public mflag, mvuelvo, mregistracio, mform, msql1, mcodent, ;
	msql_reg, msql, msql_pre, mdesc, manos, mmeses, mdias, mlet
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



mresplog = 0

modify windows screen;
	title "AUTORIZACIONES"
if file ("\qepd1a1\solo_marca.jpg")
	modify windows screen;
  		fill file "\qepd1a1\solo_marca.jpg"
endif

	do form frmloguin1 with 'AUTORIZACIONES'
	if mresplog = 0
		do sp_busco_server_namespaces
		do sp_conexion
		
*!*			do autpremenu.mpr
*!*			read events
	endif	