****
**** Controlo mensajes
****
lparameters miexe,muncodigo
if vartype(muncodigo)#"N"
	muncodigo = 0
endif
nentipad = 0
*messagebox(myip)
do buscomsgini with upper(miexe),muncodigo
procedure buscomsgini
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
	if inlist(myip,"172.16.1.9","172.16.1.9,5.136.147.168","172.16.1.10")  &&"172.16.1.7",
		cldsk = alltrim(justpath(sys(16,0)))
		liniserv = .f.
	endif
	lcErrorAnt = ON("ERROR")
	on error =aerr(eros)
*	messagebox('MENSAJES INI EN '+cldsk )  &&-*/-*/
	mfile = cldsk + "\inicio\ini.txt"
	if at("EXE",upper(mfile))=0
		mfile = "..\exe\inicio\ini.txt"
	endif
*messagebox(mfile)
	mcadcon = filetostr(mfile)
*messagebox(mcadcon )
	On Error &lcErrorAnt
	if type('mcadcon') = "C"
		nlineas = alines(mimatini,mcadcon)
		lEXE = ascan(mimatini,"["+ alltrim(mieje) +"]")
		lexeini = lEXE +1
		lalerta = ascan(mimatini,"[ALERTA]", lexeini)
		nalerta = iif(lalerta >0,val(mimatini(lalerta +1 )),0)
		lmsg = ascan(mimatini,"[MSG]", lexeini)
		miniciosal = nalerta
		if nalerta >0
			cmsg = iif(lmsg > 0,mimatini( lmsg + 1 ),0)
			if !empty(cmsg )
				nentipad = val( cmsg )
				if muncodigo = nentipad or muncodigo = 0
					messagebox(cmsg, 16, "SISTEMAS")
				endif
			endif
		endif
		if nalerta <=1
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
				lalerta = ascan(mimatini,"[ALERTA]", lexeini)
				nalerta = iif(lalerta >0,val(mimatini(lalerta +1 )),0)
				lmsg = ascan(mimatini,"[MSG]", lexeini)
				if nalerta >0
					cmsg = iif(lmsg > 0,mimatini( lmsg + 1 ),0)
					if !empty(cmsg )
						nentipad = val( cmsg )
						if muncodigo = nentipad or muncodigo = 0
							messagebox(cmsg, 16, "SISTEMAS")
						endif
					endif
				endif
				if nalerta <=1
				else
					cancel
				endif
			endif
		else
			cancel
		endif

		SQLSETPROP(0,"DispLogin",3)
	endif
