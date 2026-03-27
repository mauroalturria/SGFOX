**
* Sistema : Sanatorio Güemes
* Módulo  : RESIDENCIAS
* Fecha   :
* Observ. : Hereda del Proyecto CIAM
****

Public mcon1,mcon1,mcon4,midusu,mconc,myip,miform,mranio,mreven,mrautores,mxambito 
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
Set path to Scx, Lib, Mnu, Prg, Exe, Bmp, Rep
Set optimize on
Set point to ","
Set safety off
Set separator to "."
Set status off
Set status bar off
Set talk off
Set sysmenu off

Set resource off

Do seteos_ip
myip = IPAddress()


dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
If !file(dirfonts)
	*Copy file Pf_i2of5.ttf to &dirfonts
Endif

Public mtfhoy,vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), mversion, msel_datos(25,4),det_fac(40,8)
Dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(23), msel_datos(25,4),det_fac(40,8)

Create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(2), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

mresplog = 0

_Screen.WindowState = 2

Modify windows screen;
	title "RESIDENCIAS"
cfondo = iif(_sCREEN.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify windows screen;
	fill file &cfondo

Do form frmloguin1 with 'RESIDENCIAS'

If mresplog = 0
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

	Do sp_conexion

*!* do sp_examenes_excel     && Paso 1
*!* do sp_examenes_orden     && Paso 2
*!* do sp_examenes_orden2    && Paso 3
*!* do sp_examenes_imprenta  && Paso 4

*!*	    mpaso = .f.
*!*	    if mpaso
*!*			if used('mwkexamen')
*!*			  use in mwkexamen
*!*			endif
*!*			mret = sqlexec(mcon1,"select * from TabResExa order by TRE_t2grupo, TRE_t2preguntanro","mwkexamen")
*!*			*mret = sqlexec(mcon1,"select * from TabResExa","mwkexamen")
*!*
*!*			if mret > 0
*!*			  select mwkexamen
*!*			  go top
*!*			  browse
*!*			  *copy to c:\util\inscripciones\examen\definctrl type xl5
*!*			  *copy to c:\util\inscripciones\examen\definctrl type SDF delimited with '|'
*!*			  use in mwkexamen
*!*			endif
*!*
*!*	    endif

	If !directory("C:\temp\informes")
		Mkdir "C:\temp\informes"
	Endif
	If !directory("C:\temp\imagenes")
		Mkdir "C:\temp\imagenes"
	Endif

	If used("mwkanieven")
		Use in mwkanieven
	Endif
	mret = sqlexec(mcon1,"select distinct(TRV_anio) as lanio,TRV_evento as levento"+;
		" from Tabresvac order by TRV_anio desc","mwkanieven")
		
	If mret > 0
	
		Select mwkanieven
		go top
		mranio = mwkanieven.lanio
		mreven = mwkanieven.levento
		mrautores = 'Residencias '+alltrim(str(mranio-1))
		
*!*		Use in mwkanieven

		Do resimenu.mpr
		Read events
		Do sp_desconexion
		
	Else
	
		Messagebox("EN BUSQUEDA DE PERIODOS DE EXAMEN"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
			
	Endif


*!*	mret=sqlexec(mcon1,"select INS_Apellido,INS_Nombre,INS_Cargo,TRV_especialidad,INS_DirCalle,INS_DirNumero,INS_Piso,INS_DirCP,INS_DirCiudad,"+;
*!*	"INS_DirPcia, INS_Telefono,INS_Celular,INS_registro,INS_recibo from TabResInscrip,TabResVac where INS_Cargo = TabResVac.Id","mwkinforme")
*!* select upper(INS_Apellido),upper(INS_Nombre),TRV_especialidad,upper(INS_DirCalle),INS_DirNumero,INS_Piso,INS_DirCP,upper(INS_DirCiudad), ;
*!*	upper(INS_DirPcia), INS_Telefono,INS_Celular,INS_registro,INS_recibo from mwkinforme into cursor mwkinforme
*!*	select mwkinforme
*!*	go top
*!*	brow
*!*	COPY TO c:\informe1.xls TYPE XL5
*!* mret = sqlexec(mcon1,"select distinct(TRE_dimension) from TabResExaF","mwkg")
*!* select mwkg
*!* go top
*!* brow

Endif

* Por No definiciones documentadas en el arch. ERR, al compilar
Procedure Lmenu
Return

Procedure pdatos
Return

Procedure Dat_Vale1
Return

Procedure Item_Vale1
Return

Procedure vvdatos
Return

Procedure VRETORNO
Return
