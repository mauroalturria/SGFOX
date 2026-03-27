****
**  Seteos del sistema - Mesa de ingresos
****
public mcon1, midusu, mpassw, mcodvax, msql_reg, mcon1, ;
	mresplog,mtfhoy,myip,miform,block_ent,mxambito
mxambito = 1
*Nombre de Variables
public  midpers, mape, mid, mob, mdt, maten, mForm,;
	midSocio,mpac,mresplog

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

set ENGINEBEHAVIOR 70
do seteos_ip
myip = IPAddress()

dirfonts = alltrim(getenv('windir'))+ '\fonts\Pf_i2of5.ttf'
if !file(dirfonts)
	*copy file Pf_i2of5.ttf to &dirfonts
endif

*****
public vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), mversion, msel_datos(20,4),dat_cose(40,20),item_cose(40,20)
dime vec_vale(31,3), dat_vale(30), item_vale(31,3), dat_fac(20), msel_datos(20,4),dat_cose(40,20),item_cose(40,20)
mresplog = 0

create cursor registra ;
	(nrohc c(10), nombre c(50), nrodoc n(13), tipdoc n(2), domici c(50), tel c(20), ;
	cpostal n(4), locali c(25), pcia c(25), fecnac d, sexo c(1))

****


_screen.windowstate = 2
modify windows screen ;
	title "Pisos"
cfondo = iif(_screen.width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
modify windows screen;
	fill file &cfondo
_screen.icon = 'FILES07.ico'
do form frmloguin1 with 'MESAINGRESOS'


mcantexe = 0
do prg_exes_activos with proper('MESAINGRESOS') + "      P.Id:"
if mcantexe>2 and (mwkusuario.sector # "SISTEMAS" )
	messagebox("NO PUEDE INGRESAR A MAS DE DOS APLICACIONES DE MESA INGRESOS"+;
		chr(13) + "DISCULPE LAS MOLESTIAS...";
		,48,"Control Sistemas")
	cancel
else

	if mresplog = 0
		do sp_busco_server_namespaces
		on error =aerr(eros)
		mfile = justpath(sys(16,0))+"\inicio\ini.txt"
		if at("EXE",mfile)=0
			mfile = "..\exe\inicio\ini.txt"
		endif
		mcadcon = filetostr(mfile)
		on error do log_errores with error(), message(), message(1), program(), lineno()
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
		if !directory("C:\temp\imagenes")
			mkdir "C:\temp\imagenes"
		endif
		if !directory("C:\temp\guardia")
			mkdir "C:\temp\guardia"
		endif
		do seteos_configuracion
		agetfileversion(miverexe, sys(16, 0))
		miexe = alltrim(mwkexe.nomexe)
		miversion = alltrim(miexe)
		miexer = justfname(alltrim(mwkexe.launcher))
		if vartype(miverexe) <> "U"
			if alen(miverexe) > 1
				if upper(miverexe(5)) = upper(miexe)
					mvarch = "c:\qepd1a1\exe\" + miexer
				else
					mvarch = "c:\qepd1a1\exe\" + miverexe(5)
				endif
			else
				mvarch = "c:\qepd1a1\exe\" + miexer
			endif
		else
			mvarch = "c:\qepd1a1\exe\" + miexer
		endif
		nfiles = agetfileversion(laver, mvarch)
		mcodvax = mwkusuario.codigovax
		if vartype(_screen.oconf) == "O"
			modify window screen title proper(miexe) + space(6) + ;
				"P.Id: " + "-" + space(10) + ;
				"Nro PC: " + substr(myip, at(".", myip, 2) + 1) + space(10) + ;
				"Usuario : " + alltrim(mwkusuario.idusuario) + space(10) + ;
				"Versión Ejecutable : " + alltrim(laver(11)) + iif(mxambito > 2, space(10) + ;
				"Policonsultorio : " + alltrim(_screen.oconf.getvalue("pNombre_Centro")), "")
		else
			modify window screen title proper(miexe) + space(6) + ;
				"P.Id: " + "-" + space(10) + ;
				"Nro PC: " + substr(myip, at(".", myip, 2) + 1) + space(10) + ;
				"Usuario : " + alltrim(mwkusuario.idusuario) + space(10) + ;
				"Versión Ejecutable : " + alltrim(laver(11))
		endif

		do sp_desconexion with "inicio mesaadmision"
		do registroocx
		do mnme.mpr
		read events
	endif
endif

procedure AFINDHWND
procedure MF2
procedure DAT_WS
procedure DET_FAC
procedure DAT_VALE1
procedure ITEM_VALE1
procedure AFECHAS
procedure EROS
procedure VDATOS

