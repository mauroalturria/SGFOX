***NECESITA EL CURSOR mwkbuspacie1 o alguno que tenga los telefonos
Lparameters mcursor,mcursortel
If Vartype(mtelbaja)="U"
	Public mtelbaja
Endif
mtelbaja =''
If Vartype(mcursor)<>"C"
	mcursor = 'mwkbuspacie1'
Endif
If Vartype(mcursortel)<>"C"
	mcursortel = 'mwkpactelef2'
Endif

Local nReg
Local cNumtel
Local lcambiotel
lcambiotel = .F.
If !Used("mwktipotel")
	mret = SQLExec(mcon1,"SELECT ID, TT_categoria, TT_descrTipo FROM Zabtipotel " + ;
	" where TT_fecpasiva ='1900-01-01' ", "mwktipotel")
Endif
Dimension mTiposTel[30,2]
Store '' To mTiposTel

Select mwktipotel
midv = 0
Scan
	midv = midv + 1
	mTiposTel[mwktipotel.id ,1 ] = mwktipotel.TT_descrTipo
	mTiposTel[mwktipotel.id ,2] = mwktipotel.Id
Endscan
mRegistracio  = 0
Use In Select("mwkpactelef1")

** Creamos el cursor local
Create Cursor mwkpactelef1 ( tipo C(10),numero C(20), NumId N(10),telefono C(50),observa C(50),nTipo N(1),Sit C(1),idrec N(10) )

** Traemos los datos de la tabla de telefonos y cargamos en el cursor.
** Cuando hacemos una Registracion o Pre-registracion, no se ejecuta este paso.
** TRT_Registracio = ?mregistracio"+;
**	" and TRT_Pasiva = ?mfnull","mwkbtelefs")
mtelef = ''
If Used(mcursor)
	Select &mcursor
	If !Empty(Field('reg_nroregistrac'))
		mRegistracio = reg_nroregistrac
		mret = SQLExec(mcon1,"select reg_telefonos from Registracio where Registracio = ?mRegistracio ","mwknewtel")
		mtelef = Nvl(mwknewtel.reg_telefonos,'')

	Else
		If !Empty(Field('pac_codhci'))

			mRegistracio = pac_codhci
			mtelef = Nvl(pac_telefresponsab,'')

		Endif
	Endif

	If !Used('mwkregtel')
		Do sp_busco_telefono With mRegistracio
		Select * From mwkbtelefs Into Cursor mwkregtel
	Endif

** Verificamos si el telefono ya esta cargado en la tabla del paciente.
** Si hay un telefono y no esta en la lista de telefonos, agregarlos.
** Es por si hay que editar telefonos con guiones u otro caracter.

	cNumtel = Alltrim(mtelef )

	nReg = 0

	Select mwkregtel
	Locate For Alltrim(trt_numero) == cNumtel

	If !Found()
** Agregamos telefono del paciente. Seguramente hay que editar.
		nReg = nReg + 1
		Insert Into mwkpactelef1 (telefono,numero,nTipo,tipo,observa,NumId,Sit,idrec) Values ( ;
		Alltrim(mtelef),mtelef, 1 ,'', '', -1, ' ',nReg )
	Endif

** Volcamos al cursor temporal.
	Select mwkregtel

	Scan All

		ctelprov = Alltrim(mwkregtel.trt_numero)
		lcambiotel = (lcambiotel  Or Left(ctelprov ,1)="0")
		ctelprov = Iif(Left(ctelprov ,1)="0",Substr(ctelprov,2),ctelprov)
		cNumtel = Alltrim(mTiposTel[IIF(mwkregtel.trt_tipo=0,1,mwkregtel.trt_tipo),1])+"-"+ctelprov
		If !Empty(Nvl(mwkregtel.trt_observacion,Space(50)))
			cNumtel = cNumtel + " ("+Alltrim(Left(Nvl(mwkregtel.trt_observacion,Space(50)),20))+")"
		Endif
		nReg = nReg + 1
		Insert Into mwkpactelef1 (telefono,numero,nTipo,tipo,observa,NumId,Sit,idrec) Values ( ;
		cNumtel,ctelprov, mwkregtel.trt_tipo , mTiposTel[IIF(mwkregtel.trt_tipo=0,1,mwkregtel.trt_tipo),1], ;
		NVL(mwkregtel.trt_observacion,Space(50)),mwkregtel.Id, ' ',nReg )
		Select mwkregtel
	Endscan
&&& GUARDAMOS TELEFONOS FUERA DE USO
	If Used('MWKREGTELPAS')
		Select mwkregtelpas
		Scan All
			mtelbaja = mtelbaja +Chr(13)+Alltrim(Nvl(telefonos,''))+" Observ.: "+Alltrim(Nvl(trt_observacion,''))
		Endscan
	Endif
Endif

**Cerramos el cursor
Use In Select("mwkregtel")

Use In Select(mcursortel)
Select telefono,idrec,numero,nTipo,NumId,observa From mwkpactelef1 Where Sit <> 'D' Order By nTipo Into Cursor &mcursortel

Delete From mwkpactelef1 Where nTipo = 6
Select mwkpactelef1
Go Top

Select &mcursortel
Go Top
Return lcambiotel

