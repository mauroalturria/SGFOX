**
**  Seteos
*
Public mcon1,midusu,mpassw,mcodvax,mcon1,mresplog,myip,miform,zzimpre,zzdesti
public mfechalis,murgencia,mversion,mhabita,mtfhoy,mcantexe,CPRINTER,lbloqueotimer,mhojas,mxambito 
mxambito = 1

Set ansi on
Set bell off
Set cent on
Set compatible off
Set conf on
Set date to french
Set decimal to 2
Set dele on
Set exact on
Set exclu off
Set fdow to 1
Set hours to 24
Set near on
Set notify off
Set path to scx, lib, mnu, prg, exe, bmp, rep
Set optimize on
Set point to ","
Set safety off
Set separator to "."
Set status off
Set status bar off
Set talk off
Set sysmenu off
_Screen.keypreview = .t.
Set Enginebehavior 70


Do seteos_ip
myip = IPAddress()
dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
If !file(dirfonts)
	*Copy file Pf_i2of5.ttf to &dirfonts
Endif
Do seteos_public
Public vec_vale(31,4), dat_vale(30), item_vale(31,4), dat_fac(20), mversion, msel_datos(25,4),;
	vec_valem(31,4), dat_valem(30), item_valem(31,4), dat_facm(20), det_fac(40,8),xusuariologin,dat_cose(40,20),item_cose(40,20)
Dime vec_vale(31,4), dat_vale(30), item_vale(31,4), dat_fac(20), msel_datos(25,4),;
	 vec_valem(31,4), dat_valem(26), item_valem(31,4), dat_facm(20), det_fac(40,8),dat_cose(40,20),item_cose(40,20)
mresplog = 0
Modify windows screen title "Monitor de Vales"
_Screen.WindowState = 2
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify windows screen;
	fill file &cfondo

	
Do form frmloguin1 with 'MONITOR1'
*Do form frmloguin4 with 'MONITOR1'

	Do sp_busco_server_namespaces
	On error =aerr(eros)
	mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
	mcadcon = filetostr(mfile)
	On error
	If type('mcadcon') = "C"
		mDatabase 	= mline(mcadcon,3)
		mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
		If !empty('mDatabase')
			Select mwktabcfg
			Replace olespaces with mDatabase
		Endif
	Endif
	
	If !directory("C:\temp\informes")
		Mkdir "C:\temp\informes"
	Endif

	zzimpre = 1  && Matricial
	zzdesti = 9 && Destino 13

	Do sp_conexion
	mretorno = .f.
	do sp_busco_monitor1_destinos with zzdesti
    Do sp_desconexion
    
