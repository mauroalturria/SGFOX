****
**  Seteos del sistema
****

Public block_ent,mxcentromedico 
block_ent = ''


do prg_var_public
mxcentromedico =1
mxambito = 1
lcTitle = 'Control V6'
lcNomExe = 'QUIROFANO'

Do prg_set
Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle 
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.icon = 'CONV.ICO'
Endwith 	

&& no me acuerdo donde se usa..... ya veremos
*!*	create cursor registra ;
*!*		(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(1), domici c(50), tel c(20), ;
*!*		cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))


*!*	modify windows screen;
*!*		title "QUIROFANO"
*!*	cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
*!*	modify windows screen;
*!*		fill file &cfondo

*!*	------------------------------------------------------
*!*	Login
*!*	------------------------------------------------------
mresplog = 0
do form frmloguin1 with 'QUIROFANO'

if mresplog <> 0
	Cancel 
Endif 	
*!*	------------------------------------------------------
If !prg_sistemas_abiertos(lcTitle, lcNomExe)
	Cancel 
Endif  

Do sp_busco_server_namespaces
Do prg_setDatabase
Do seteos_configuracion

procedure MF2 
procedure AFECHAS 
procedure EROS 


