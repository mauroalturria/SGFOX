lparameters miambito
**  Seteos del sistema
public mcon1, midusu, mpassw,myip,mxambito,mxcentromedico 
mxcentromedico =1


if vartype(miambito)#"U"
	mxambito = val(transf(miambito))
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
	set path to Scx, Lib, Mnu, Prg, exe, Bmp, Rep
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


	modify windows screen ;
		title "Consultorios"
	if file ("\qepd1a1\solo_marca.jpg")
		modify windows screen;
			fill file "\qepd1a1\solo_marca.jpg"
	endif
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
	create cursor mwkexe (nomexe c(20),VERSIONACTUAL c(10), launcher c(200),versionminima c(10))
	insert into mwkexe values ("MEDICOS","","\\172.16.5.46//C:/C/medicos.exe","")

	do form frmficha01
	read events
else
	messagebox("AMBITO NO DEFINIDO")
endif
