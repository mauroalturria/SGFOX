parameters mPropietario, mform,mtema,manio,mnivel,marchivo
*!*		mPropietario = 38
mwhere = ''
miresp = ''
mAias = alias()
if vartype(mtema) = "C"
	mwhere = mwhere+ " and tema = ?mtema "
endif
if vartype(manio) = "N"
	mwhere = mwhere+ " and anio = ?manio "
endif
if vartype(mnivel) = "N"
	mwhere = mwhere+ " and Subnivel = ?mnivel"
endif
mDirTempDoc = "C:\TEMPDOC\"
mDirTemp = "C:\TEMP\"

mret = sqlexec(mcon1,"select documento, tipo, Formulario"+;
	" from TabDocGral "+;
	" where propietario = ?mpropietario and Formulario = ?mform "+mwhere, "mwkTabDocGral")

if mret > 0 and reccount("mwkTabDocGral")>0
	if used('__DATA')
		use in __DATA
	endif
	if used ('archivos')
		use in archivOS
	endif
	if file("C:\temp\informes\archivos.dbf")
		erase ("C:\temp\informes\archivos.dbf")
	endif
	if file("C:\temp\informes\archivos.fpt")
		erase ("C:\temp\informes\archivos.fpt")
	endif
	select mwkTabDocGral
	copy to "C:\temp\informes\archivos"
	SELECT documento as firma FROM mwkTabDocGral INTO CURSOR mwkfirma
	use in mwkTabDocGral
	LL = fopen("C:\temp\informes\archivos.dbf",12)
	fseek(LL,43)
	fwrite(LL,'M')
	fclose(LL)
	mcimagen = alltrim(mform)
	use "C:\temp\informes\archivos.dbf" alias mwkTabDocGral IN 0
	select mwkTabDocGral
	mtipo  = tipo
	march  = documento
	miresp = ''
	mArchDir = ''
	if vartype(marchivo) = "C"
		marchivo = ALLTRIM(marchivo)+ALLTRIM(mtipo)
		midocu =  marchivo
	else
		midocu = "C:\tempdoc\"+mcimagen
	endif	
	do prg_saveBinnb with march,midocu,miresp,mtipo
	mArchDir = miresp
	if used('__DATA')
		use in __DATA
	endif
	if used ('archivos')
		use in archivos
	endif

	if used('mwkTabDocGral')
		use in mwkTabDocGral
	endif
	if file("C:\temp\informes\archivos.dbf")
		erase ("C:\temp\informes\archivos.dbf")
	endif
	if file("C:\temp\informes\archivos.fpt")
		erase ("C:\temp\informes\archivos.fpt")
	endif
endif

return miresp
