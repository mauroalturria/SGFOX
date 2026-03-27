*
* Archivos Externos, módulo Calidad
*
Lparameters manio,mform,mtipo,marchivo

	If used('mwkarchext')
		Use in mwkarchext
	Endif
	mret = sqlexec(mcon1,"select descripcion,id as larchivo,tipo as ltipo"+;
		" from TabDocGral where propietario = ?mtipo and formulario = ?mform"+;
		" order by tema desc,subnivel,descripcion ","mwkarchext")
Else
	If used('mwkarchext1')
		Use in mwkarchext1
	Endif
*	documento as lvideo, tipo as ltipo
	mret = sqlexec(mcon1,"select documento,tipo"+;
		" from TabDocGral where id=?marchivo","mwkarchext1")
	If mret > 0
		Wait windows nowait "Cargando Documentación..."
		If used('__DATA')
			Use in __DATA
		Endif
		If used ('archivos')
			Use in archivOS
		Endif
		If file("C:\temp\informes\archivos.dbf")
			Erase ("C:\temp\informes\archivos.dbf")
		Endif
		If file("C:\temp\informes\archivos.fpt")
			Erase ("C:\temp\informes\archivos.fpt")
		Endif
		Select mwkarchext1
		Copy to "C:\temp\informes\archivos"
		Use in mwkarchext1
		LL = fopen("C:\temp\informes\archivos.dbf",12)
		Fseek(LL,43)
		Fwrite(LL,'M')
		Fclose(LL)
		miresp = ''
		For mi = 1 to 100
			mcimagen = "arch"+alltrim(str(mi))
			mfile = "C:\temp\informes\"+mcimagen
			If !file(mfile)
				Exit
			Endif
		Endfor
		Use "C:\temp\informes\archivos.dbf" alias mwkarchext1
		mtipo  = tipo
		march  = documento
		miresp = ''
		mArchDir = ''
		Do prg_saveBinnb with march,"C:\temp\informes\"+mcimagen,miresp,mtipo
		mArchDir = miresp
		If len(alltrim(mArchDir))>0
			Private loBrowser
			Declare INTEGER GetShortPathName IN kernel32 ;
				STRING @lpszLongPath , STRING @lpszShortPath, INTEGER @cchBuffer
			loBrowser = CreateObject("InternetExplorer.Application")
			loBrowser.Navigate(mArchDir)
			loBrowser.Visible=.T.
			Release loBrowser
		Endif
		If used('__DATA')
			Use in __DATA
		Endif
		If used ('archivos')
			Use in archivOS
		Endif
		If used('mwkarchext1')
			Use in mwkarchext1
		Endif
		If file("C:\temp\informes\archivos.dbf")
			Erase ("C:\temp\informes\archivos.dbf")
		Endif
		If file("C:\temp\informes\archivos.fpt")
			Erase ("C:\temp\informes\archivos.fpt")
		Endif
	Endif
Endif
If mret < 0
	Messagebox("EN CONSULTA DE ARCHIVOS EXTERNOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif