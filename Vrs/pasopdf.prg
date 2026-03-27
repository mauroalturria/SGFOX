
midir	= alltrim(getdir())
midircopia = alltrim(getdir()) &&
narch = adir(adocs,midir+"*.pdf")
if narch  = 0
	messagebox(chr(10) +"NO SE ENCONTRARON DOCUMENTOS PARA INCORPORAR "+;
		+chr(10)+chr(10) +" VERIFIQUE QUE EL NOMBRE DE LA CARPETA NO TENGA ACENTOS" ,16,"Validación")
endif
set step on
for i= 1 to narch
	mnom = adocs(i,1)
	nvale = val( left( mnom, len( mnom)- 10) )
	requery('informespdfctr')
	if reccount('informespdfctr')=1
		nuevonom = alltrim(midircopia)+ mnom
		mifile = alltrim(midir) + alltrim(mnom)
		cfile = sp_getshortpath(mifile)
		cdirye 	= justpath(nuevonom )

		cc = cfile +" to " +nuevonom
*		messagebox("Ejecuto:" + cc)
		copy file &cc
*				run /2 &cc
		wait windows cfile nowait
	endif
next
