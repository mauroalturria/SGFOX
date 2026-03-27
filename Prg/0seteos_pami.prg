
public mcon1, mcon1, midusu, mpassw, mcodvax, myip,mxambito

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

_screen.keypreview = .t.
_Screen.Icon = "secur02b.ico"


Set Enginebehavior 70


do seteos_ip
myip = IPAddress()
lcfile= 'https://cup.pami.org.ar/controllers/loginController.php?redirect=https://pe.pami.org.ar'
loBrowser = Createobject("InternetExplorer.Application")
			loBrowser.Navigate(lcfile)
			loBrowser.Visible=.T.
			Release loBrowser
