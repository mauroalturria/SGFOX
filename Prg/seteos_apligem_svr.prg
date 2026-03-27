parameters lcTerm, lcDirTerm
**
**  Seteos
*
public mcon1, midusu, mpassw, mcodvax, mcon1, mresplog,myip,miform,mintcall,mxambito ,mxcentromedico 
mxcentromedico =1
mxambito  = 1

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
Set Sysmenu To 

set sysmenu off

_screen.keypreview = .t.
do seteos_ip
myip = IPAddress()
*Set Enginebehavior 70

create cursor mwkexe (nomexe c(20),versionactual c(20), launcher c(50),versionminima c(20),idexe n (2))
	insert into mwkexe values ("APLIGEM_SVR","1.0.0","\\172.16.5.46//C://APLIGEM_SVR.exe","1.0.0",99)


If vartype(lcTerm) <> 'C'
	lcTerm = '50'
Endif
If vartype(lcDirTerm) <> 'C'
	lcDirTerm = 'O:\'
Endif

do seteos_public

public vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(25,4),;
	det_fac(40,8),xusuariologin,dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)
dime vec_vale(31,4), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(25,4),;
	det_fac(40,8),dat_cose(40,20),item_cose(40,20),dat_busca(40,8),dat_ws(30)

mresplog = 0

Modify windows screen ;
	title "Apligem SVR" 

_screen.windowstate = 2

do seteos_configuracion

On Shutdown do salir

Set Escape On


Define Window wlog From 5, 5 To 40, 80
Activate Window wlog
Public miexe
miexe = "Apligem SVR" 

?"Terminal : " + transf(lcTerm)
?"Dir : " + transf(lcDirTerm)


Do sp_conexion With miexe 

_Screen.AddObject("ElTimer","MyTimer")
_screen.ElTimer.Enabled = .t.

Read events

Define Class MyTimer As Timer
	lcFile = "C:\Qepd1a1\Exe\ApligemSVR.TXT"
	Enabled = .f.
	
	Procedure Timer
		This.Enabled = .F.
		
		Activate Window wlog
		set step on
		?" Buscando ..." 
		Do sp_busco_TabCtrlApliGem With 3,0, '', "mwkCtrlApliGem" 

		DOEVENTS FORCE 
		
		If Reccount("mwkCtrlApliGem") > 0
			
			Select mwkCtrlApliGem
			lnIdUpdate = mwkCtrlApliGem.Id
			lcAfiliado = Alltrim(mwkCtrlApliGem.APG_Afiliado)
			
			ltAhora = sp_busco_fecha_serv('DT')
			?"Afiliado -> " + lcAfiliado 
			?"    Id -> " + Transform(mwkCtrlApliGem.Id)
			?"    Pedido -> " + Transform(mwkCtrlApliGem.Apg_fechahoraped)
			?"    Ip -> " + Transform(mwkCtrlApliGem.Apg_ip)
			
			?"	Fecha-Hora_Inicio_Proceso -> " + Transform(ltAhora)
			
			oApli = Newobject("oApliGem","c:\desaguemes\prg\prg_apligem.PRG")
			oApli.lnTerm = lcTerm
			oApli.lcDirTerm = lcDirTerm
			oApli.Seteos()

			If !oApli.ValidoAfiliado(lcAfiliado)
				Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
				Return .f.
			Endif 
			mAPG_RespTxt = Alltrim(oApli.lcRespuesta)
			mAPG_RespSvr = Alltrim(oApli.lcRespuestaFull)

			?"	Respuesta -> " + mAPG_RespTxt

			Do sp_actualizo_TabCtrlApliGem With 2, lnIdUpdate, lcAfiliado, '', mAPG_RespTxt, mAPG_RespSvr   
		Else
		*	?"vacio"
		Endif 
		This.Reset
		This.Enabled = .T.
	Endproc 
		
	Procedure Init
		
		If !File(This.lcFile)
			Strtofile("2000",This.lcFile)
		Endif 
		This.Interval = Val(Filetostr(This.lcFile))
		This.Enabled = .T.
	Endproc

	Procedure Destroy

	Endproc

	Procedure Error(nerror, Cmethod, Nline)

	Endproc

enddefine


Procedure Salir
	_Screen.ElTimer.Enabled =  .f.
	_Screen.RemoveObject("ElTimer")
	Quit
	
