* -----------------------------------------
* Busco Cursores Neo (Evolución x Aspectos)
* -----------------------------------------

Parameters midevol0,mpesta0

mbuscotodo = .F.
mNroAspectos = 16 && Cantidad de aspectos que hay.

If Vartype(midevol0)#"N"
	Return .F.
Endif

If Vartype(mpesta0)#"N"
	mbuscotodo = .T.
Endif

mTexto = ""
If mbuscotodo = .T.
	For maspecto = 1 To mNroAspectos
		mBuscoTexto = BuscoCursor(midevol0,maspecto)
		mTexto = mTexto + mBuscoTexto
	Endfor
Else
	mTexto = BuscoCursor(midevol0,mpesta0)
Endif

If Len(mTexto)>0
	mTexto = Chr(13) + Chr(13) + "Evolución por Aspectos" + Chr(13) + mTexto
Endif

Return mTexto

* ----------------------------------------

Function BuscoCursor(mnidevol,mnpesta)

midevol = mnidevol
mpesta = mnpesta
mCadena = ""

mPreCursor = "mwkNeoE"

Do Case

Case mpesta = 1 && Aspecto

*	lcSQL = "select asp_fechahora as fechahora, asp_usuario as usuario, * from zabneoieaspecto where asp_idevol = ?midevol and asp_tiporegistro = 'E' order by fechahora desc"
	mTabla = "ZabNeoIEAspecto"
	mPrefijo = "ASP"
	mTitulo = "Aspecto General"
	mCursor = "Aspecto"

Case mpesta = 2 && Piel
	mTabla = "ZabNeoIEPiel"
	mPrefijo = "PIE"
	mTitulo = "Piel"
	mCursor = "Piel"

Case mpesta = 3 && Respiratorio

*lcSQL = "select res_fechahora as fechahora, res_usuario as usuario, * from ZabNeoIERespira  where res_idevol = ?midevol and res_tiporegistro = 'E'"
	mTabla = "ZabNeoIERespira"
	mPrefijo = "RES"
	mTitulo = "Aspecto Respiratorio"
	mCursor = "Respira"

Case mpesta = 4 && Cardiovascular
	mTabla = "ZabNeoIECardio"
	mPrefijo = "CAR"
	mTitulo = "Aspecto Cardiovascular"
	mCursor = "Cardio"

Case mpesta = 5 && Abdominal
	mTabla = "ZabNeoIEAbdomen"
	mPrefijo = "ABD"
	mTitulo = "Aspecto Abdominal"
	mCursor = "Abdomen"

Case mpesta = 6 && Neurológico
	mTabla = "ZabNeoIENeuro"
	mPrefijo = "NEU"
	mTitulo = "Aspecto Neurológico"
	mCursor = "Neuro"

Case mpesta = 7 && Osteo Articular
	mTabla = "ZabNeoIEOseo"
	mPrefijo = "OSE"
	mTitulo = "Aspecto Osteo-Articular y Funcional"
	mCursor = "Oseo"

Case mpesta = 8 && Infectologico
	mTabla = "ZabNeoIEinfecto"
	mPrefijo = "INF"
	mTitulo = "Aspecto Infectológico"
	mCursor = "Infecto"

Case mpesta = 9 && Hematológico
	mTabla = "ZabNeoIEHemato"
	mPrefijo = "HEM"
	mTitulo = "Aspecto Hematológico"
	mCursor = "Hemato"

Case mpesta = 10 && Antropometria
	mTabla = "ZabNeoIEAntro"
	mPrefijo = "ANT"
	mTitulo = "Antropometria"
	mCursor = "Antro"

Case mpesta = 11 && Oftalmo
	mTabla = "ZabNeoIEOftalmo"
	mPrefijo = "OFT"
	mTitulo = "Aspecto Oftalmológico"
	mCursor = "Oftalmo"

Case mpesta = 12 && Metabolico
	mTabla = "ZabNeoIEMetabolico"
	mPrefijo = "MET"
	mTitulo = "Aspecto Metabólico"
	mCursor = "Metabo"

Case mpesta = 13 && Nutricional
	mTabla = "ZabNeoIENutri"
	mPrefijo = "NUT"
	mTitulo = "Aspecto Nutricional"
	mCursor = "Nutri"

Case mpesta = 14 && Malformaciones
	Return mCadena

Case mpesta = 15 && Quirurgico
	mTabla = "ZabNeoIEQuiro"
	mPrefijo = "QUI"
	mTitulo = "Aspecto Quirúrgico"
	mCursor = "Quiro"

Otherwise
	Return mCadena
Endcase


If mpesta <1 Or mpesta>15
	Return mCadena
Endif


lcSql =	"Select " + mPrefijo + "_fechahora, " + mPrefijo + "_usuario, * From " +;
	mTabla + " join tabusuario on " + mTabla + "." + mPrefijo + "_usuario = tabusuario.idCodMed and tabusuario.fecpasiva = '1900-01-01'" +;
	" where " + mPrefijo + "_idevol = ?midevol and " +;
	mPrefijo + "_tiporegistro = 'E' group by " + mTabla + "." + mPrefijo + "_fechahora order by " + mPrefijo + "_fechahora desc"

mCursor = mPreCursor + mCursor

If !Prg_EjecutoSql(lcSql,mCursor)
	Return .F.
Endif

If Used(mCursor)
	Select &mCursor
	Scan All
		mDato0 = sp_armo_datos_evolucion_neo(mpesta,midevol)
		If !Empty(mDato0)
			mFecEvo = mCursor + '.' + mPrefijo + '_fechahora'
			mDocEvo = mCursor + '.nomape'
			mDato = Chr(13) + '---------- Fecha: ' + Dtoc(&mFecEvo) + ' - Hora: ' + Left(Ttoc(&mFecEvo,2),5) + ' --- Médico: ' + &mDocEvo + Chr(13) + mDato0
			mCadena = mCadena + mDato
		Endif
	Endscan
Endif

Use In Select(mCursor)

Return mCadena

Endfunc
