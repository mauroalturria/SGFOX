****
**** Controlo volumen de trabajo
****
lparameters miexe,muncodigo
if vartype(muncodigo)#"N"
	muncodigo = 0
endif
nentipad = 0
*messagebox(myip)
do buscovolini with upper(miexe),muncodigo
procedure buscovolini
	lparameters mieje,muncodigo
	private liniserv
	if file("X:\Qepd1a1\Exe\inicio\ini.txt")
		cldsk = "X:"+substr(justpath(sys(16,0)),3)
		liniserv = .t.
	else
		if file("H:\Qepd1a1\Exe\inicio\ini.txt")
			cldsk = "H:"+substr(justpath(sys(16,0)),3)
			liniserv = .t.
		else
			cldsk = alltrim(justpath(sys(16,0)))
			liniserv = .f.
		endif
	endif
	lcErrorAnt = on("ERROR")
	on error =aerr(eros)
*	messagebox('MENSAJES INI EN '+cldsk )  &&-*/-*/
	mfile = cldsk + "\inicio\ini.txt"
	if at("EXE",upper(mfile))=0
		mfile = "..\exe\inicio\ini.txt"
	endif
*messagebox(mfile)
	mcadcon = filetostr(mfile)
*messagebox(mcadcon )
	on error &lcErrorAnt
	if type('mcadcon') = "C"
		nlineas = alines(mimatini,mcadcon)
		lEXE = ascan(mimatini,"["+ alltrim(mieje) +"]")
		lexeini = lEXE +1
		lvolumen = ascan(mimatini,"[VOLUMEN]", lexeini)
		cvolumen = iif(lvolumen >0,mimatini(lvolumen +1 ),'C:')
*		messagebox(cvolumen)
		if lvolumen <=1
			lnoip = ascan(mimatini,"[NOIP]", lexeini)
			cnoip = iif(lnoip >0 and lnoip < lmsg,mimatini(lnoip +1 ),"")
			lnoip = lnoip +1
			do while left(alltrim(cnoip),9) # "[FINNOIP]" and !(cnoip $ myip) and !empty(cnoip)
				cnoip = iif(lnoip >0,mimatini(lnoip +1 ),"")
				lnoip = lnoip +1
			enddo
			if cnoip $ myip
				messagebox("USTED ESTA TEMPORARIAMENTE BLOQUEADO. DISCULPE", 16, "SISTEMAS")
				cancel
			endif
			lSIip = ascan(mimatini,"[SIIP]", lexeini)
			csiip = iif(lsiip >0 and lsiip < lmsg,mimatini(lsiip +1 ),"")
			lsiip = lsiip +1
			do while left(alltrim(csiip),9) # "[FINSIIP]" and !(csiip $ myip) and !empty(csiip)
				csiip = iif(lsiip >0,mimatini(lsiip +1 ),"")
				lsiip = lsiip +1
			enddo
			if csiip $ myip
				minicio = 1
				lEXE = ascan(mimatini,"[FINSIIP]", lexeini)
				lexeini = lEXE +1
				lvolumen = ascan(mimatini,"[VOLUMEN]", lexeini)
				cvolumen = iif(lvolumen >0,mimatini(lvolumen +1 ),'C:')
			endif
		endif
		zzvolumen = alltrim(cvolumen)
		SQLSETPROP(0,"DispLogin",3)
	endif
