Parameters mNroEvol

Create Cursor mwkNeoCursores (tabla c(30), nomcursor c(30), prefijo c(3))

Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoAntecMaterno","mwkNeoAntecMaterno","NAM")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoAntecMatPlus","mwkNeoAntecMatEnf","AMP")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoAntecMatCom","mwkNeoAntecMatCom","AMC")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoAntecMatMed","mwkNeoAntecMatMed","AMM")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoAntecDatosParto","mwkNeoAntecDatosParto","NDP")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoAntecApgar","mwkNeoAntecApgar","NAA")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoAntecNacimiento","mwkNeoAntecNacimiento","NAN")
*Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoAntecNac","mwkNeoAntecNac","ZN")

Select mwkNeoCursores
Go Top
Scan All
	mTabla = Alltrim(mwkNeoCursores.tabla)
	mCursor = Alltrim(mwkNeoCursores.nomcursor)
	mPrefijo = Alltrim(mwkNeoCursores.prefijo)

	lcSQL = "Select top 1 * from " + mTabla + " where " + mPrefijo + "_idevol = " + Str(mNroEvol) + " Order by id desc"
	If !Prg_EjecutoSql(lcSQL,mCursor)
		Return .F.
	Endif

	Select &mCursor
	If Reccount(mCursor) = 0
		Append Blank In &mCursor
	Endif
	
	Select mwkNeoCursores
Endscan

*!*	* --------------------------------------------------------------------------

*!*	* Cursores de Ingreso

*!*	* Consultas where tipo I = ingreso E = evolución

*!*	* --------------------------------------------------------------------------

Use In "mwkNeoCursores"

Create Cursor mwkNeoCursores (tabla c(30), nomcursor c(30), prefijo c(3))

Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEAbdomen","Abdomen","ABD")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEAntro","Antro","ANT")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEAspecto","Aspecto","ASP")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIECardio","Cardio","CAR")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEHemato","Hemato","HEM")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEInfecto","Infecto","INF")
*insert into mwkNeoCursores (tabla,nomcursor,prefijo) values ("ZabNeoIEMalforma","Malforma","MAL")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEMetabolico","Metabo","MET")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIENeuro","Neuro","NEU")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIENutri","Nutri","NUT")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEOftalmo","Oftalmo","OFT")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEOseo","Oseo","OSE")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEPiel","Piel","PIE")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIEQuiro","Quiro","QUI")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoIERespira","Respira","RES")
Insert Into mwkNeoCursores (tabla,nomcursor,prefijo) Values ("ZabNeoVarios","Varios","VAR")

Select mwkNeoCursores
Go Top
Scan All
	mTabla = Alltrim(mwkNeoCursores.tabla)
	mCursor = "mwkNeoI" + Alltrim(mwkNeoCursores.nomcursor)
	mPrefijo = Alltrim(mwkNeoCursores.prefijo)

	lcSQL = "Select Top 1 * from " + mTabla + " where " + mPrefijo + "_idevol = " + Str(mNroEvol) + " And " + mPrefijo + "_tiporegistro = 'I'" + " Order by id desc"
	If !Prg_EjecutoSql(lcSQL,mCursor)
		Return .F.
	Endif

	Select &mCursor
	If Reccount(mCursor) = 0
		Append Blank In &mCursor
	Endif

	Select mwkNeoCursores
Endscan

* Cargo Cursores de Cardio

lcSql = "select * from ZabNeoVarios where var_idevol = ?mNroEvol and var_medcardio = 1 and var_tiporegistro = 'I' order by var_fechahora desc"

If !Prg_EjecutoSql(lcSql,"mwkNeoIMedicaCardio")
	Return .F.
Endif

* Cargo Cursores de Malformaciones

lcSql = "select * from ZabNeoIEMalforma join tabestados on ZabNeoIEMalforma.MAL_nromalforma = tabestados.id "+;
" where ZabNeoIEMalforma.MAL_idevol = ?mNroEvol and mal_tiporegistro = 'I' order by mal_fechahora desc"

If !Prg_EjecutoSql(lcSql,"mwkNeoMalforma")
	Return .F.
Endif

* Cargo Cursores de Infecto

* Accesos
	lcSQL = "select * from ZabNeoVarios join TabEstados on ZabNeoVarios.Var_tipoacceso = Tabestados.Subestado"+;
		" where ZabNeoVarios.var_idevol = ?mNroEvol and zabNeoVarios.var_accesos = 1 and ZabNeoVarios.var_tiporegistro = 'I' and tabestados.propietario = 25"+;
		" and tabestados.estado = 1 and tabestados.tipo = 37 order by ZabNeoVarios.var_fechahora desc"

	If !Prg_EjecutoSql(lcSQL,"mwkNeoIAcceso")
		Return .F.
	Endif

* Cultivo
lcSql = "select * from ZabNeoVarios where var_idevol = ?mNroEvol and var_cultivos = 1 and var_tiporegistro = 'I' order by var_fechahora desc"

If !Prg_EjecutoSql(lcSql,"mwkNeoICultivo")
	Return .F.
Endif

* Cargo Cursor de Lugar de Nacimiento
Do sp_busco_estados With 25,' and tipo = 41 order by subestado','mwkLugNac'

Return .t.