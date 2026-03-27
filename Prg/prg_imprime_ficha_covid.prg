Lparameters nroregistracion,tipoimpresion,confirma

*tipoimpresion: 1=pdf para pisos23d / 2=impresión en papel / 3=impresión en pdf
*confirma: .t.=imprime solo si tiene firma / .f.=imprime aunque no tenga firma

Local lsigo
mlmed = ''
mlmat = ''
mhayfirma = .F.
mhaymed = .F.
mregistra = nroregistracion
mconfirma = .F.

If Vartype(confirma)='L'
	mconfirma = confirma
Endif

* Busco Firma y Nombre del médico

lcSQL ='select cov_usuario,nomapenotifica from ZabFichEpnCov19 where COV_Registrac = ?mregistra order by id desc'
If !Prg_EjecutoSql(lcSQL,'mwkmedcovid')
	Return .F.
Endif
If Used('mwkmedcovid')
	Select mwkmedcovid
	mcodmed = Val(Alltrim(mwkmedcovid.cov_usuario))
	If mcodmed = 0
		musuario = Alltrim(mwkmedcovid.cov_usuario)
		lcSQL = 'select * from tabusuario where idusuario = ?musuario'
		SQLExec(mcon1,lcSQL,'mwkIdMed')
		If Used('mwkIdMed')
			Select mwkIdMed
			mcodmed = mwkIdMed.idcodmed
		Endif
	Endif
Endif

Do sp_busco_medico_dat With mcodmed
mhayfirma = File("X:\qepd1a1\digito\"+Alltrim(Transform(mcodmed))+"_firma_ms.exe")
If Used('mwkDatMed')
	mlmed = Alltrim(MwkDatMed.nombre)
	mlmat = Alltrim(MwkDatMed.matriculas)
	If !Empty(mlmed) And !Empty(mlmat)
		mhaymed = .T.
	Endif
Endif
Use In Select('mwkDatMed')
If mhayfirma
	msolfirma = "X:\qepd1a1\digito\"+Alltrim(Transform(mcodmed))+"_firma_ms.exe"
Else
	msolfirma = ''
Endif

lnimpresion = 0
If !Vartype(tipoimpresion)='N'
	lnimpresion = 1
Else
	lnimpresion = tipoimpresion
Endif

lvalor = .F.

If mconfirma
	If mhaymed And mhayfirma
		lvalor = prg_armo_impresion_covid (lnimpresion,mregistra,1,msolfirma,mlmed,mlmat)
	Else
		lvalor = prg_armo_impresion_covid (lnimpresion,mregistra,1,msolfirma,mlmed,mlmat)
	Endif
Else
	lvalor = prg_armo_impresion_covid (lnimpresion,mregistra,1,msolfirma,mlmed,mlmat)
Endif


If lvalor
	Messagebox('El archivo PDF fue creado con éxito en la siguiente carpeta'+Chr(10)+"C:\TEMPDOC",64,'Ficha Epidemiológica')
	Else
	Messagebox("No se pudo crear el archivo pdf",16,"Ficha Epidemiológica")
Endif


Use In Select('mwkcovidpac')
Use In Select('mwkmedcovid')
Use In Select('mwkIdMed')
Use In Select('mwkDatMed')




