****
**  Seteos del sistema
****

Public mcon1, mcon1, mcon4, midusu,mconc,myip,miform
public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(40,20),item_cose(40,20)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(20,4),dat_cose(40,20),item_cose(40,20)

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
If !Directory("C:\temp\web")
	Mkdir "C:\temp\web"
Endif
 
If !Directory("C:\temp\Ambula")
	Mkdir "C:\temp\Ambula"
Endif
If !Directory("C:\temp\interna")
	Mkdir "C:\temp\interna"
Endif

If !Directory("C:\qepd1a1\exe\xfrx")
	Mkdir "C:\qepd1a1\exe\xfrx"
Endif
If !Directory("C:\tempHCE")
	Mkdir "C:\tempHCE"
Endif

If !Directory("C:\tempdoc")
	Mkdir "C:\tempdoc"
Endif

If !Directory("C:\temp\informes")
	Mkdir "C:\temp\informes"
Endif

If !Directory("C:\temp\imagenes")
	Mkdir "C:\temp\imagenes"
Endif
If !Directory("C:\temp\imagenes\firmas")
	Mkdir "C:\temp\imagenes\firmas"
Endif
If !Directory("C:\temp\guardia")
	Mkdir "C:\temp\guardia"
ENDIF
do seteos_configuracion
 
*!*	mresplog = 0
*!*	_SCREEN.WindowState = 2
*!*	modify windows screen;
*!*		title "LANZADOR DE APLICACIONES"
*!*		cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
*!*		modify windows screen;
*!*				fill file &cfondo 
*!*		do form launcher01 with 'APLICACIONES'
*!*		
*!*		if mresplog = 0
*!*			do admisionmenu.mpr
*!*			read events
*!*		endif	