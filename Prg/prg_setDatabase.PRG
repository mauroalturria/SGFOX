lleoini = .T.
If Used("mwkambitoini")
	If Reccount("mwkambitoini")>0
		lleoini = .F.
	Endif
Endif
mfile = Justpath(Sys(16,0))+"\inicio\ini.txt"
If lleoini
	mcadcon = Filetostr(mfile)
Else
	mcadcon = mwkambitoini.ini
Endif
If Type('mcadcon') = "C"
	mDatabase 	= Mline(mcadcon,3)
	mDatabase 	= Alltrim(Substr(mDatabase,At("=",mDatabase)+1))
	If !Empty('mDatabase')
		Select mwktabcfg
		Replace olespaces With mDatabase
	Endif
Endif