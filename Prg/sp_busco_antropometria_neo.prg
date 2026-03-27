Parameters midevol,mtipoantro

* REVISAR ESTA PARTE CON LOS DECIMALES

mTipoReg = 'I'
mref = 1

If Used("mwkdethora")
	Use In Select("mwkdethora")
Endif

Do Case

Case mtipoantro = 1

	Create Cursor mwkdethora (valor N(6,2), Fecha d, linea N(2), ref N(2))

* Averiguo Peso Nacimiento:

	lcSql =	"Select top 1 * From " +;
		"ZabNeoAntecNacimiento  join tabusuario on ZabNeoAntecNacimiento.nan_usuario = tabusuario.idCodMed and tabusuario.fecpasiva = '1900-01-01'" +;
		" where nan_idevol = ?midevol order by ZabNeoAntecNacimiento.nan_fechahora desc"

	If !Prg_EjecutoSql(lcSql,"mwkNeoIng")
		Return .F.
	Endif

	Do Case
	Case mOpcion = 1 && Peso

		mTitulo = "Peso"
		Select Ttod(NAN_fechaHora) As hora ,"PESO" As determinacion ,NAN_pesorn As valor,1 As linea, NAN_fechaHora  ;
			from mwkNeoIng Order By NAN_fechaHora Asc Into Cursor mwkdetaux1

	Case mOpcion = 2 && Talla

		mTitulo = "Talla"
		Select Ttod(NAN_fechaHora) As hora ,"TALLA" As determinacion ,NAN_tallarn As valor,2 As linea, NAN_fechaHora  ;
			from mwkNeoIng Order By NAN_fechaHora Asc Into Cursor mwkdetaux1

	Case mOpcion = 3 && PC

		mTitulo = "PC"
		Select Ttod(NAN_fechaHora) As hora ,"PC" As determinacion ,NAN_pcrn As valor,3 As linea, NAN_fechaHora  ;
			from mwkNeoIng Order By NAN_fechaHora Asc Into Cursor mwkdetaux1
	Endcase

	If Reccount("mwkdetaux1")>0
		mValor = mwkdetaux1.valor
		Insert Into mwkdethora (valor,Fecha,linea,ref) Values (mValor,mwkdetaux1.hora,mwkdetaux1.linea,mref)
	Endif

* Averiguo Peso Ingreso / Evoluciones:

	For ciclo = 1 To 2

		lcSql =	"Select * From " +;
			"ZabNeoIEAntro join tabusuario on ZabNeoIEAntro.ant_usuario = tabusuario.idCodMed and tabusuario.fecpasiva = '1900-01-01'" +;
			" where ant_idevol = ?midevol and " +;
			"ant_tiporegistro = ?mTipoReg group by ZabNeoIEAntro.ant_fechahora order by ZabNeoIEAntro.ant_fechahora desc"


		If !Prg_EjecutoSql(lcSql,"mwkNeoAntroEvolAnt")
			Return .F.
		Endif

		Do Case
		Case mOpcion = 1 && Peso

			mTitulo = "Peso"
			Select Ttod(ANT_fechaHora) As hora ,"PESO" As determinacion ,ANT_peso As valor,1 As linea, ANT_fechaHora  ;
				from mwkNeoAntroEvolAnt Order By ANT_fechaHora Asc Into Cursor mwkdetaux1

		Case mOpcion = 2 && Talla

			mTitulo = "Talla"
			Select Ttod(ANT_fechaHora) As hora ,"TALLA" As determinacion ,ANT_talla As valor,2 As linea, ANT_fechaHora  ;
				from mwkNeoAntroEvolAnt Order By ANT_fechaHora Asc Into Cursor mwkdetaux1

		Case mOpcion = 3 && PC

			mTitulo = "PC"
			Select Ttod(ANT_fechaHora) As hora ,"PC" As determinacion ,ANT_pc As valor,3 As linea, ANT_fechaHora  ;
				from mwkNeoAntroEvolAnt Order By ANT_fechaHora Asc Into Cursor mwkdetaux1
		Endcase

		Select mwkdetaux1

		Scan All
			If mwkdetaux1.valor > 0
				mref = mref + 1
				mValor = mwkdetaux1.valor
				Insert Into mwkdethora (valor,Fecha,linea,ref) Values (mValor,mwkdetaux1.hora,mwkdetaux1.linea,mref)
			Endif
			Select mwkdetaux1
		Endscan

		mTipoReg = 'E'

	Endfor

*** PARA GRILLA:

Case mtipoantro = 2

	Create Cursor mwkNeoAntro (peso N(6,2), talla N(4,2), pc N(4,2), Fecha d(10), linea N(1), ref N(2), nombre c(30))

	lcSql =	"Select top 1 * From " +;
		"ZabNeoAntecNacimiento  join tabusuario on ZabNeoAntecNacimiento.nan_usuario = tabusuario.idCodMed and tabusuario.fecpasiva = '1900-01-01'" +;
		" where nan_idevol = ?midevol order by ZabNeoAntecNacimiento.nan_fechahora desc"

	If !Prg_EjecutoSql(lcSql,"mwkNeoIng")
		Return .F.
	Endif

	If Reccount("mwkNeoIng")>0
		mV1 = mwkNeoIng.NAN_tallarn
		mV2 = mwkNeoIng.NAN_pcrn
		Insert Into mwkNeoAntro (peso,talla,pc,Fecha,linea,ref,nombre) Values (mwkNeoIng.NAN_pesorn,mV1,mV2,mwkNeoIng.NAN_fechaHora,0,mref,mwkNeoIng.nomape)
	Endif

* Averiguo Peso Ingreso / Evoluciones:

	For ciclo = 1 To 2

		lcSql =	"Select * From " +;
			"ZabNeoIEAntro join tabusuario on ZabNeoIEAntro.ant_usuario = tabusuario.idCodMed and tabusuario.fecpasiva = '1900-01-01'" +;
			" where ant_idevol = ?midevol and " +;
			"ant_tiporegistro = ?mTipoReg group by ZabNeoIEAntro.ant_fechahora order by ZabNeoIEAntro.ant_fechahora desc"


		If !Prg_EjecutoSql(lcSql,"mwkNeoAntroEvolAnt0")
			Return .F.
		Endif

		Select mwkNeoAntroEvolAnt0
		Scan All
			If mwkNeoAntroEvolAnt0.ANT_peso > 0 And mwkNeoAntroEvolAnt0.ANT_talla > 0 And mwkNeoAntroEvolAnt0.ANT_pc > 0
				mref = mref + 1
				mV1 = mwkNeoAntroEvolAnt0.ANT_talla
				mV2 = mwkNeoAntroEvolAnt0.ANT_pc
				Insert Into mwkNeoAntro (peso,talla,pc,Fecha,linea,ref,nombre) Values (mwkNeoAntroEvolAnt0.ANT_peso,mV1,mV2,mwkNeoAntroEvolAnt0.ANT_fechaHora,ciclo,mref,mwkNeoAntroEvolAnt0.nomape)
			Endif
			Select mwkNeoAntroEvolAnt0
		Endscan

		mTipoReg = 'E'

	Endfor

Endcase

Use In Select("mwkdetaux1")
Use In Select("mwkNeoAntroEvolAnt0")
Use In Select("mwkNeoIng")
