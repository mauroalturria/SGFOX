Parameters midevol

For mPesta = 1 To 15

	If Used("mwkNeoGrillaEvolAnt")
		Use In "mwkNeoGrillaEvolAnt"
	Endif


	Do Case

	Case mPesta = 1 && Aspecto

*	lcSQL = "select asp_fechahora as fechahora, asp_usuario as usuario, * from zabneoieaspecto where asp_idevol = ?midevol and asp_tiporegistro = 'E' order by fechahora desc"
		mTabla = "ZabNeoIEAspecto"
		mPrefijo = "ASP"
		mTitulo = "Aspecto General"

	Case mPesta = 2 && Piel
		mTabla = "ZabNeoIEPiel"
		mPrefijo = "PIE"
		mTitulo = "Piel"

	Case mPesta = 3 && Respiratorio

*lcSQL = "select res_fechahora as fechahora, res_usuario as usuario, * from ZabNeoIERespira  where res_idevol = ?midevol and res_tiporegistro = 'E'"
		mTabla = "ZabNeoIERespira"
		mPrefijo = "RES"
		mTitulo = "Aspecto Respiratorio"

	Case mPesta = 4 && Cardiovascular
		mTabla = "ZabNeoIECardio"
		mPrefijo = "CAR"
		mTitulo = "Aspecto Cardiovascular"

	Case mPesta = 5 && Abdominal
		mTabla = "ZabNeoIEAbdomen"
		mPrefijo = "ABD"
		mTitulo = "Aspecto Abdominal"

	Case mPesta = 6 && Neurológico
		mTabla = "ZabNeoIENeuro"
		mPrefijo = "NEU"
		mTitulo = "Aspecto Neurológico"

	Case mPesta = 7 && Osteo Articular
		mTabla = "ZabNeoIEOseo"
		mPrefijo = "OSE"
		mTitulo = "Aspecto Osteo-Articular y Funcional"

	Case mPesta = 8 && Infectologico
		mTabla = "ZabNeoIEinfecto"
		mPrefijo = "INF"
		mTitulo = "Aspecto Infectológico"

	Case mPesta = 9 && Hematológico
		mTabla = "ZabNeoIEHemato"
		mPrefijo = "HEM"
		mTitulo = "Aspecto Hematológico"

	Case mPesta = 10 && Antropometria
		mTabla = "ZabNeoIEAntro"
		mPrefijo = "ANT"
		mTitulo = "Antropometria"

	Case mPesta = 11 && Oftalmo
		mTabla = "ZabNeoIEOftalmo"
		mPrefijo = "OFT"
		mTitulo = "Aspecto Oftalmológico"

	Case mPesta = 12 && Metabolico
		mTabla = "ZabNeoIEMetabolico"
		mPrefijo = "MET"
		mTitulo = "Aspecto Metabólico"

	Case mPesta = 13 && Nutricional
		mTabla = "ZabNeoIENutri"
		mPrefijo = "NUT"
		mTitulo = "Aspecto Nutricional"

	Case mPesta = 14 && Malformaciones

	Case mPesta = 15 && Quirurgico
		mTabla = "ZabNeoIEQuiro"
		mPrefijo = "QUI"
		mTitulo = "Aspecto Quirúrgico"

	Endcase


	If !mTabla = ""

		lcSql =	"Select " + mPrefijo + "_fechahora, " + mPrefijo + "_usuario, * From " +;
			mTabla + " join tabusuario on " + mTabla + "." + mPrefijo + "_usuario = tabusuario.idCodMed and tabusuario.fecpasiva = '1900-01-01'" +;
			" where " + mPrefijo + "_idevol = ?midevol and " +;
			mPrefijo + "_tiporegistro = 'E' group by " + mTabla + "." + mPrefijo + "_fechahora order by " + mPrefijo + "_fechahora desc"


		If !Prg_EjecutoSql(lcSql,"mwkNeoGrillaEvolAnt")
			Return .F.
		Endif

* Busco por Aspecto

		mcEvol = ""
		mcPesta = ""
		mcNombre = ""

		Do Case
		Case mPesta = 1
			mcPesta = "Aspecto"
		Case mPesta = 2
			mcPesta = "Piel"
		Case mPesta = 3
			mcPesta = "Respira"
		Case mPesta = 4
			mcPesta = "Cardio"
		Case mPesta = 5
			mcPesta = "Abdomen"
		Case mPesta = 6
			mcPesta = "Neuro"
		Case mPesta = 7
			mcPesta = "Oseo"
		Case mPesta = 8
			mcPesta = "Infecto"
		Case mPesta = 9
			mcPesta = "Hemato"
		Case mPesta = 10
			mcPesta = "Antro"
		Case mPesta = 11
			mcPesta = "Oftalmo"
		Case mPesta = 12
			mcPesta = "Metabo"
		Case mPesta = 13
			mcPesta = "Nutri"
		Case mPesta = 14
			mcPesta = "Malforma"
		Case mPesta = 15
			mcPesta = "Quiro"
		Otherwise
			mcPesta = "OTROS"
		Endcase

		mcCursor = "mwkNeoE" + mcPesta

		Select mwkNeoGrillaEvolAnt
		mPrefijo1 = Upper(Alltrim(Field(1,"mwkNeoGrillaEvolAnt")))
		mPrefijo = Substr(mPrefijo1,At(".",mPrefijo1)+1,3)

		Use In Select(mcCursor)
		Select * From mwkNeoGrillaEvolAnt Into Cursor &mcCursor
		Select &mcCursor
		Scan All
			mDato0 = sp_armo_datos_evolucion_neo(mPesta,midevol)
			If !Empty(mDato0)
				mFecEvo = mcCursor + '.' + mPrefijo + '_fechahora'
				mDocEvo = mcCursor + '.nomape'
				mDato = Chr(13) + '--------------------- Fecha: ' + Dtoc(&mFecEvo) + ' - Hora: ' + Left(Ttoc(&mFecEvo,2),5) + ' - Médico: ' + &mDocEvo + Chr(13) + mDato0
				mcEvol = mcEvol + mDato
			Endif
		Endscan

	Endif

Endfor

Return mcEvol
