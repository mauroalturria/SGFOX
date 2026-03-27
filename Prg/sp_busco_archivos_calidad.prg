*
* Archivos Externos, módulo Calidad
*
Lparameters mform,mtipo,marchivo,loveo,mifile
*Do sp_busco_archivos_calidad with 'frmcalidad09',0,miarchivo,1 -> como estaba 0 no lo muestra
If Vartype(loveo)<>"N"
	loveo=1
Endif
If Type('mform') # "C"
	mform = 'frmcalidad09'
Endif
If Type('mtipo') # "N"
	mtipo = 0
Endif
If Type('marchivo') # "N"
	marchivo = 0
Endif
If !Empty(mform)
	mbusform = 'and formulario = ?mform '
Else
	mbusform = ''
Endif
If mtipo > 0
	If Used('mwkarchext')
		Use In mwkarchext
	Endif
	mret = SQLExec(mcon1,"select descripcion,id as larchivo,tipo as ltipo"+;
		" from TabDocGral where propietario = ?mtipo "+mbusform +;
		" order by tema desc,subnivel,descripcion ","mwkarchext")
Else
	If Used('mwkarchext1')
		Use In mwkarchext1
	Endif
*	documento as lvideo, tipo as ltipo
	mret = SQLExec(mcon1,"select documento,tipo"+;
		" from TabDocGral where id=?marchivo","mwkarchext1")
	If mret > 0
		Wait Windows Nowait "Cargando Documentación..."
		If Used('__DATA')
			Use In __DATA
		Endif
		If Used ('archivos')
			Use In archivOS
		Endif
		If File("C:\temp\informes\archivos.dbf")
			Erase ("C:\temp\informes\archivos.dbf")
		Endif
		If File("C:\temp\informes\archivos.fpt")
			Erase ("C:\temp\informes\archivos.fpt")
		Endif
		Select mwkarchext1
		Copy To "C:\temp\informes\archivos"
		Use In mwkarchext1
		LL = Fopen("C:\temp\informes\archivos.dbf",12)
		Fseek(LL,43)
		Fwrite(LL,'M')
		Fclose(LL)
		miresp = ''
		For mi = 1 To 100
			mcimagen = "arch"+Alltrim(Str(mi))
			mfile = "C:\temp\informes\"+mcimagen
			If !File(mfile)
				Exit
			Endif
		Endfor
		Use "C:\temp\informes\archivos.dbf" Alias mwkarchext1
		mtipo  = tipo
		march  = documento
		miresp = ''
		mArchDir = ''
		Do prg_saveBinnb With march,"C:\temp\informes\"+mcimagen,miresp,mtipo
		mArchDir = miresp
		If Len(Alltrim(mArchDir))>0 And loveo=1
			lcUrl = Alltrim(mArchDir )
			If !prg_veo_URL(lcUrl,.T.)
				Messagebox("ERROR AL ABRIR EL DOCUMENTO",48,"VALIDACION")
			Endif
		Else
			If loveo=0
				mifile = Alltrim(mArchDir )
			Endif
		Endif
		If Used('__DATA')
			Use In __DATA
		Endif
		If Used ('archivos')
			Use In archivOS
		Endif
		If Used('mwkarchext1')
			Use In mwkarchext1
		Endif
		If File("C:\temp\informes\archivos.dbf")
			Erase ("C:\temp\informes\archivos.dbf")
		Endif
		If File("C:\temp\informes\archivos.fpt")
			Erase ("C:\temp\informes\archivos.fpt")
		Endif
		Return mArchDir
	Endif
Endif
If mret < 0
	Messagebox("EN CONSULTA DE ARCHIVOS EXTERNOS"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
Endif
