Parameters midevol,mnroadmision,mfechaing,mfechahasta

Create Cursor mwkEvoFull (Fecha T,Medico c(40),Texto m,Tipo N(1)) && Tipo 1 = Evolución por texto / Tipo 2 = Evolución por Aspectos

* Busco Evolución Carmen

mnroadm = mnroadmision
*	mnroadm = '407607-0'
mresplog = ''

If Vartype(mfechaing)="C"
	mfechaing = Ctod(mfeching)
Endif

mfechahasta = mfechahasta + 1

*mDias = mfechahasta - mfechaing


*idevol,xctipo,mevol,lorden,xncantreg,copciones,mtipousu
*Do sp_busco_evolucion_int_idevol With mnroadm ,"EM",mresplog ,1,30,''

Do sp_busco_evolucion_int_idevol With midevol,'EM'

If Vartype(mfechaing)#"D"
	mDia = Ttod(mfechaing)
Else
	mDia = mfechaing
Endif

mTextoEvol = ""

Do While mDia < mfechahasta

	Select mwkEvolMed

	If Used('mwkEvolmed')
		If Reccount('mwkEvolMed')>0
			Select * From mwkEvolMed Where Ttod(mwkEvolMed.eim_fechah) = mDia Into Cursor mwkevolmed_temp 
			If Reccount('mwkEvolMed_temp')>0
				Go Top In "mwkEvolMed_temp"
				Scan All
					mfechaevo = mwkevolmed_temp.eim_fechah
					mmedicoevo = Alltrim(mwkevolmed_temp.nombre)
					mtextoevo = Alltrim(mwkevolmed_temp.eim_evol)
					Insert Into mwkEvoFull (Fecha,Medico,Texto,Tipo) Values (mfechaevo,mmedicoevo,mtextoevo,1)
*					mTextoEvol = "--- Fecha/Hora: " + Dtoc(mwkEvolMed_temp.eim_fechah) + " --- Médico: " + Alltrim(mwkEvolMed_temp.nombre) + Chr(13)
*					mTextoEvol = mTextoEvol + mwkEvolMed_temp.eim_evol + Chr(13) + Chr(13) + Chr(13)
				Endscan
			Endif
		Endif
	Else
*mcAspectos =  Llamo a sp_busco_evol_neo_aspecto para que lo arme en forma normal sin las evoluciones de texo
		Return mcAspectos
	Endif


* Busco Evolución por aspecto según fechas

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


			mFecAspi = Datetime(Year(mDia),Month(mDia),Day(mDia),0,0,0)
			mFecAspf = Datetime(Year(mDia),Month(mDia),Day(mDia),23,59,59)

			lcSql =	"Select " + mPrefijo + "_fechahora, " + mPrefijo + "_usuario, * From " +;
				mTabla + " join tabusuario on " + mTabla + "." + mPrefijo + "_usuario = tabusuario.idCodMed and tabusuario.fecpasiva = '1900-01-01'" +;
				" where " + mPrefijo + "_idevol = ?midevol and (" + mPrefijo + "_fechaHora between ?mFecAspi and ?mFecAspf ) and " +;
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
				mFechaEvo = mcCursor + '.' + mPrefijo + '_fechahora'
				mDato0 = sp_armo_datos_evolucion_neo_2(mPesta,midevol,&mFechaEvo)
				If !Empty(mDato0)
					mFecEvo = mcCursor + '.' + mPrefijo + '_fechahora'
					mDocEvo = mcCursor + '.nomape'
*					mDato = Chr(13) + '--- Fecha: ' + Dtoc(&mFecEvo) + ' - Hora: ' + Left(Ttoc(&mFecEvo,2),5) + ' - Médico: ' + &mDocEvo + Chr(13) + mDato0
*					mcEvol = mcEvol + mDato
*					mTextoEvol = mTextoEvol + mcEvol
					mfechaevo = ''
					mmedicoevo = ''
					mtextoevo = ''
					mfechaevo = &mFecEvo
					mmedicoevo = &mDocEvo
					mtextoevo = mDato0
					Insert Into mwkEvoFull (Fecha,Medico,Texto,Tipo) Values (mfechaevo,mmedicoevo,mtextoevo,2)
				Endif
			Endscan

*!*				If mPesta = 4 && Cardio
*!*				SCAN FOR BETWEEN(order_amt,950,1000)
*!*				BETWEEN(eTestValue, eLowValue, eHighValue)


*!*					lcSql = "select * from ZabNeoVarios inner join tabestados on ZabNeoVarios.VAR_idtipodroga = tabestados.id where var_idevol = ?midevol "+;
*!*						"And var_medcardio = 1 And var_tiporegistro = 'E' and (VAR_fecHorAlta <= ?mFechaEvo and var_fechorpasiva =  '2100-01-01 00:00:0') order by "+;
*!*						"var_fecHorAlta desc"
*!*					If !Prg_EjecutoSql(lcSql,"mwkNeoEMedicaCardio_1")
*!*						Return .F.
*!*					Endif
*!*				Endif

		Endif

	Endfor

	mDia = mDia + 1

Enddo


* Armo el Archivo de texto
Select * From mwkEvoFull Order By Fecha Desc Into Cursor mwkEvoFull0 
Use In Select('mwkEvoFull')
Select mwkEvoFull0
Go Top In 'mwkEvoFull0'
mTextoEvol = ''
*!*	Scan All
*!*		mTextoEvol = mTextoEvol + Chr(13) + '- - - - - - - - - - - - Fecha: ' + Ttoc(mwkEvoFull0.Fecha) + ' - - - - - - - Médico: ' + mwkEvoFull0.Medico + Chr(13) + Chr(13)
*!*		mTextoEvol = mTextoEvol + mwkEvoFull0.Texto + Chr(13)+Chr(13)
*!*	Endscan


* Agrupo por fecha

Select * From mwkEvoFull0 Group By Fecha Order By Fecha Desc Into Cursor mwkEvoFull1 

Select mwkEvoFull1

Scan All
	mFecha = mwkEvoFull1.Fecha
	mTextoEvol = mTextoEvol + Chr(13) + '- - - - - - - - - - - - Fecha: ' + Ttoc(mwkEvoFull1.Fecha) + ' - - - - - - - Médico: ' + mwkEvoFull1.Medico + Chr(13) + Chr(13)
	Select * From mwkEvoFull0 Where mwkEvoFull0.Fecha = mFecha Order By mwkEvoFull0.Tipo Into Cursor mwkEvoFull2 
	Select mwkEvoFull2
	Scan All
		mTextoEvol = mTextoEvol + Chr(13) + mwkEvoFull2.Texto + Chr(13)
	Endscan
	Select mwkEvoFull1
Endscan

Return mTextoEvol



