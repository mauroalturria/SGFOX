
*!*	--------------------------------------------------------------
*!*	Gustavo Fittipaldi, 16/10/2013
*!*	--------------------------------------------------------------

**
**  Seteos
*
Public mcon1, midusu, mpassw, mcodvax, mcon1, mresplog,myip,miform,mintcall,mxambito
mxambito  =1

Set Ansi On
Set Bell Off
Set Cent On
Set Compatible Off
Set Conf On
Set Date To French
Set Decimal To 2
Set Dele On
Set Exact On
Set Exclu Off
Set Fdow To 1
Set Hours To 24
Set Near On
Set Notify Off
Set Path To scx, lib, mnu, prg, Exe, bmp, rep
Set Optimize On
Set Point To ","
Set Safety Off
Set Separator To "."
Set Status Off
Set Status Bar Off
Set Talk Off
Set Sysmenu Off
_Screen.KeyPreview = .T.
Do seteos_ip
myip = IPAddress()

*** para demanda insatisfecha
Create Cursor turnofiltro ;
	(medsel N(4), prestsel N(11), diasel c(7), sexsel N (1),horsel N(1))
Insert Into turnofiltro (medsel , prestsel , diasel , sexsel ,horsel) Values ;
	(1,2,'',0,0)

dirfonts = Alltrim(Getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
If !File(dirfonts)
	*Copy File Pf_i2of5.ttf To &dirfonts
Endif

Do seteos_public

Public vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(25,4),;
	det_fac(40,8),xusuariologin,dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)
Dime vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(25,4),;
	det_fac(40,8),dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)

mresplog = 0
Modify Windows Screen ;
	title "Numerador"
_Screen.WindowState = 2
cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
*!*	modify windows screen;
*!*		fill file &cfondo

Do sp_busco_server_namespaces
lcErrorAnt = On("ERROR")
On Error =Aerr(eros)
lleoini = .T.
If Used("mwkambitoini")
	If Reccount("mwkambitoini")>0
		lleoini = .F.
	Endif
Endif

mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
If lleoini
	mcadcon = Filetostr(mfile)
Else
	mcadcon = mwkambitoini.ini
Endif
On Error &lcErrorAnt
If Type('mcadcon') = "C"
	mDatabase 	= Mline(mcadcon,3)
	mDatabase 	=Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
	If !Empty('mDatabase')
		Select mwktabcfg
		Replace olespaces With mDatabase
	Endif
Endif

Do seteos_configuracion


Do Form frmnumer01
Read Events




