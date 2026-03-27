*
* Habilitación médicos de guardia
* Hereda de Medicos
*
Public mcon1, midusu, mpassw,myip,mxambito ,mxcentromedico 
mxcentromedico =1
mxambito = 1

public fecha_inicio_ejecutable

Public vec_vale(31,3), dat_vale(30), item_vale(31,3)
Dimension vec_vale(31,3), dat_vale(30), item_vale(31,3)
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
Set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
Set optimize on
Set point to ","
Set safety off
Set separator to "."
Set status off
Set status bar off
Set talk off
Set sysmenu off
Do seteos_ip
myip = IPAddress()
_Screen.windowstate = 2
Modify windows screen ;
	title "Habilitación Profesionales de Guardia"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify windows screen;
	fill file &cfondo
Do sp_busco_server_namespaces
On error =aerr(eros)
mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
mcadcon = filetostr(mfile)
On error

set ENGINEBEHAVIOR 70
If type('mcadcon') = "C"
	mDatabase 	= mline(mcadcon,3)
	mDatabase 	=alltrim(substr(mDatabase,at("=",mDatabase)+1))
	If !empty('mDatabase')
		Select mwktabcfg
		Replace olespaces with mDatabase
	Endif
Endif
	create cursor mwkexe (nomexe c(20),launcher c(50))
	insert into mwkexe VALUES ("MEDICOSG",'\\172.16.5.46//C://medicosg.exe')

Do form frmmedicos06
Read events

Procedure Dat_cose
Return

Procedure Dat_fac
Return

Procedure Item_cose
Return

Procedure Lmenu
Return
