
narch = adir(adocs,"O:\anatomia\resultados\*.pdf")
for  i = 1 to narch
	mnom = adocs(i,1)
	nroval = val(left(adocs(i,1),8))
	requery('informespdfctr')
	select informespdfctr
	if reccount()=0
		cnext =
		nuevonom = alltrim('O:\anatomia\varios\pasaje\')+ mnom
		mifile = alltrim('O:\anatomia\resultados\') + alltrim(mnom)
		cfile = sp_getshortpath(mifile)
		cdirye 	= justpath(nuevonom )
		cc = cfile +" to " +nuevonom
		messagebox("Ejecuto:" + cc)
		copy file &cc
	endif
next i