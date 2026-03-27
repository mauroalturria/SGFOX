****
**  Seteos del sistema
****
 

Do prg_var_public

Do prg_set
Set ENGINEBEHAVIOR 70


Do seteos_ip && aca se asigna la MyIp
Do prg_copia_fonts
Do prg_creo_Dirs
Do seteos_public
mxambito = 1
mresplog = 0

modify windows screen;
	title "CALIDAD"
if file ("\qepd1a1\solo_marca.jpg")
	modify windows screen;
		fill file "\qepd1a1\solo_marca.jpg"
endif
myip = IPAddress()



do form frmloguin1 with 'CALIDAD'

if mresplog = 0
	do sp_busco_server_namespaces
	on error =aerr(eros)
	mfile = justpath(SYS(16,0))+"\inicio\ini.txt"
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
	do seteos_configuracion

	if !used("mwkserver1")
*		DO sp_conexion
	ENDIF
*!*		do CALIDAD.mpr
*!*		read events
endif

