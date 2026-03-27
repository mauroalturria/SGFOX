****
**  Busco los datos anexos del Profesional
****
lparameters mlid,mtipo
msel = ''
if vartype(mtipo) #"N"
	mtipo = 1
endif
msel = " and Tipo  = ?mtipo "
mfecpas = ctod("01/01/1900")
mret = SQLExec(mcon1,"select ID , FechaBaja , FechaToma , IdMedico "+;
	", Imagen,Tipo FROM TabMedFoto where idmedico = ?mlid &msel  ","mprofFoto")
if mtipo = 1
	if used('ima')
		use in ima
	endif

	if used('__DATA')
		use in __DATA
	endif

	if used ('imagen')
		use in Imagen
	endif

	select Imagen as foto from mprofFoto;
		where tipo= 1;
		into cursor ima


	if file("C:\temp\imagenes\imagen.dbf")
		erase ("C:\temp\imagenes\imagen.dbf")
	endif
	if file("C:\temp\imagenes\imagen.fpt")
		erase ("C:\temp\imagenes\imagen.fpt")
	endif
	select ima
	copy to "C:\temp\imagenes\imagen"
	use in ima

* cambia el campo grneral de tipo memo
	LL = fopen("C:\temp\imagenes\imagen.dbf",12)
	fseek(LL,43)
	fwrite(LL,'M')
	fclose(LL)

* graba los datos campo memo en un archivo
	use "C:\temp\imagenes\imagen.dbf" alias ima
	miresp = ''

	do prg_saveBin with foto,"C:\temp\imagenes\"+alltrim(str(mlid,9,0)),miresp,'JPG'

	if used('__DATA')
		use in __DATA
	endif
	if used ('imagen')
		use in Imagen
	endif
	if used('ima')
		use in ima
	endif
endif
