****
**  Seteos del sistema - Informes
****

Public mcon1, midusu, mpassw, msql_reg, mcon1,mconc

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

*****
mresplog = 0
public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(22), mversion, msel_datos(25,4),det_fac(40,8), msel_datos(25,4),det_fac(40,8),dat_cose(13)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(22), msel_datos(25,4),det_fac(40,8), msel_datos(25,4),det_fac(40,8),dat_cose(13)

modify windows screen ;
	title "Consultas" 
if file ("\qepd1a1\solo_marca.jpg")
	modify windows screen;
  		fill file "\qepd1a1\solo_marca.jpg"
endif
 
	do form frmloguin1 with 'CONSULTAS'

	if mresplog = 0

		do sp_busco_server_namespaces
		on error =aerr(eros)
		mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
		mcadcon = filetostr(mfile)
		on error
		if type('mcadcon') = "C"
			mDatabase 	= mline(mcadcon,3)
			mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
			if !empty('mDatabase')
				select mwktabcfg
				replace olespaces with mDatabase 	
			endif	
		endif	

*!*			do consultasmenu.mpr
*!*			read event
	endif	