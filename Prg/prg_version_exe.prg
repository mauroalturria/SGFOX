*
* Versión de ejecutable
*
LPARAMETERS cunidad
mversi = '0.0.0'
IF VARTYPE(cunidad)#"C"
	cunidad = 'C'
endif
If used("mwkexe")
	miexe  = justfname(Alltrim(mwkexe.launcher))
	mvarch = ALLTRIM(cunidad)+":\qepd1a1\exe\"+miexe
	nfiles = Agetfileversion(laver,mvarch)
	mversi = Iif(nfiles>0,laver[4],0)
	miexe = mwkexe.nomexe
	mret = sqlexec(mcon1, "select nomexe,versionactual,launcher,versionminima " + ;
		"from tabexe " + ;
		"where nomexe = ?miexe ", "mwknexe")
Endif

Return mversi

