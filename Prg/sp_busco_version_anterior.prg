*
* Documentos Version Anterior.
*
Lparameters mtipo,marchivo

If type('mtipo') # "N"
	mtipo = 0
Endif

If type('marchivo') # "N"
	marchivo = 0
Endif

If mtipo > 0  && traemos la info para cargar en el list.

	If used('mwkarchext')
		Use in mwkarchext
	Endif
	
*   obtenemos datos de la tabla tabgcvincproc joineado contra tabgcproc.
	mret = sqlexec(mcon1,"select b.denominacion,b.codigoproc,a.revision,a.id,a.iddoc,a.fecha,a.formato "+;
		"from Tabgcvincproc as a " + ;
		"inner join Tabgcproc as b on a.iddoc = b.id order by b.codigoproc","mwkarchext" )

	If mret < 0
		Messagebox("EN CONSULTA DE VERSIONES ANTERIORES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
		Return .F.
	endif

		Select denominacion," "+codigoproc as _codigoproc," "+allTRIM(STR(revision)) as _revision,id,iddoc,fecha,formato ;
			from mwkarchext into cursor mwkarchext

Else      &&traemos el documento para mostrarlo.

	If used('mwkarchext1')
		Use in mwkarchext1
	Endif

	mret = sqlexec(mcon1,"select documento,formato"+;
		" from Tabgcvincproc where id=?marchivo","mwkarchext1")
		
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
		
		mtipo  = mwkarchext1.formato
		march  = mwkarchext1.documento
		miresp = ''
		mArchDir = ''
		
		Do prg_saveBinnb with march,"C:\temp\informes\"+mcimagen,miresp,mtipo
		mArchDir = miresp
		If len(alltrim(mArchDir))>0
		
*!*				Private loBrowser
*!*				Declare INTEGER GetShortPathName IN kernel32 ;
*!*					STRING @lpszLongPath , STRING @lpszShortPath, INTEGER @cchBuffer
*!*				loBrowser = CreateObject("InternetExplorer.Application")
*!*				loBrowser.Navigate(mArchDir)
*!*				loBrowser.Visible=.T.
*!*				Release loBrowser

			Declare INTEGER ShellExecute IN shell32.dll ;
				INTEGER hndWin, ;
				STRING cAction, ;
				STRING cFileName, ;
				STRING cParams, ;
				STRING cDir, ;
				INTEGER nShowWin

			ShellExecute(0,"Open",mArchDir,"","",1)

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
	Messagebox("EN CONSULTA DE VERSIONES ANTERIORES"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	On error Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif


Return .T.


