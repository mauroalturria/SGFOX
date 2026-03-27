**
* Sistema : Sanatorio Güemes
* Módulo  : MONITOR I ( Seteos del Sistema )
* Fecha   : 08-01-2008
* Observ. : Auditoria, Control, Reimpresion de Vales
****

lparameters miparam
public mxcentromedico 

if vartype(miparam)="C"
	mxcentromedico = VAL(transf(miparam))
else
	mxcentromedico = 1
Endif

public mcon1,midusu,mpassw,mcodvax,mcon1,mresplog,myip,miform,zzimpre,zzdesti
public mfechalis,murgencia,mversion,mhabita,mtfhoy,mcantexe,CPRINTER,lbloqueotimer,mxambito
mxambito = 1

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
Set Enginebehavior 70
_screen.keypreview = .t.
do seteos_ip
myip = IPAddress()
dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
if !file(dirfonts)
*	copy file Pf_i2of5.ttf to &dirfonts
endif
do seteos_public
public vec_vale(31,4), dat_vale(30), item_vale(31,4), dat_fac(20), mversion, msel_datos(25,4),;
	vec_valem(31,4), dat_valem(30), item_valem(31,4), dat_facm(20), det_fac(40,8),xusuariologin,dat_cose(40,20),item_cose(40,20)
dime vec_vale(31,4), dat_vale(30), item_vale(31,4), dat_fac(20), msel_datos(25,4),;
	vec_valem(31,4), dat_valem(30), item_valem(31,4), dat_facm(20), det_fac(40,8),dat_cose(40,20),item_cose(40,20)
mresplog = 0
modify windows screen title "Monitor"
_screen.windowstate = 2
cfondo = iif(_screen.width<=800,"\qepd1a1\exe\solo_marca_MV.jpg","\qepd1a1\exe\solo_marca2_MV.jpg")
modify windows screen;
	fill file &cfondo

do form frmloguin1 with 'MONITOR1'

if mresplog = 0
	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(sys(16,0))+"\inicio\ini.txt"
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

	if !directory("C:\temp\informes")
		mkdir "C:\temp\informes"
	endif
*!*		set step on
*!*		zzimpre = "3"   && Matricial
*!*		zzdesti = 8  && Destino 13

	lcFileAux = "c:\Qepd1a1\Exe\monitor.txt"
	if file(lcFileAux)
		lcPrinter = alltrim(filetostr(lcFileAux))
*		lcPrinter = "MP-4200TH"
		if !empty(lcPrinter)
			set printer to name (lcPrinter)
		endif
	endif
	do form frmmoval03 with mwkusuario.idusuario,mwkusuario.codigovax

	do monitor1menu.mpr
	read events

endif

* Por No definiciones documentadas en el arch. ERR, al compilar
procedure Lmenu
	return
procedure dat_vale1
	return
procedure item_vale1
	return
procedure afindhwnd
	return
