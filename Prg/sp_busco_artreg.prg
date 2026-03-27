*---------------------------------------------------------------------------------------------------------------------------------------*
* REGISTRO ART
* mtipo  = "T"otal "P"arcial - solo activos = 01/01/1900
* mTipo2 = AMB - INT
*---------------------------------------------------------------------------------------------------------------------------------------*
Lparameters mtipo, mTipo2

	*Set Step On


	If Vartype(mtipo) <> "C"
		mtipo = "T"
	Endif

	If Vartype(mTipo2) <> "C"
		mbtipo = " TAR_tipo IN ('AMB','GUA')"
		mtipo2 = ''
		else
		mbtipo = " TAR_tipo = ?mtipo2 "
	Endif

	mwhere = ""

	If mtipo <> "T"
		mfnull = Ctod("01/01/1900")
		mwhere = " where TAR_finpro = ?mfnull"
	Endif

	Use In Select("mwkregistro")

	If mTipo2='INT'

		mret = SQLExec(mcon1,"select REG_nombrepac, ENT_descrient, TDI_Desc as TCP_Desc, TAR_proxate, TAR_inipro, TAR_finpro, TabArtReg.id as lid, TAR_codart,"+;
		    " TAR_evolint, TAR_registracio, TDI_DiagCod as TCP_DiagCod, TAR_Admision, TAR_HabCama, TAR_TipoAlta"+;
			" from TabArtReg"+;
			" join registracio on REG_nroregistrac = TAR_registracio"+;
			" join TabDgIntPreven on TabDgIntPreven.TDI_DiagCod = TabArtReg.TAR_codart "+;
			" join entidades on ENT_codent = TAR_entidad and ENT_fecpas is null and "+mbtipo  + mwhere +;
			" ", "mwkregistro")
			
			*" group by TAR_registracio, TCP_DiagCod"

	Else

		mret = SQLExec(mcon1,"select REG_nombrepac, ENT_descrient, TAR_siniestro, TAR_proxate, TAR_inipro, TAR_finpro, TabArtReg.id as lid"+;
			" from TabArtReg"+;
			" join registracio on REG_nroregistrac = TAR_registracio"+;
			" join entidades on ENT_codent = TAR_entidad and ENT_fecpas is null and  " +mbtipo + mwhere, "mwkregistro")

	Endif

	If mret < 0
		mltabla = "REGISTRO ART"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	Use In Select("mwkregistrob")

	If mTipo2='INT'

		Select 0 as egreso, REG_nombrepac,;
			ENT_descrient,;
			TCP_Desc,;
			TAR_proxate,;
			TAR_inipro,;
			IIF(TAR_finpro=Ctod("01/01/1900"),{//},TAR_finpro) As TAR_finpro,;
			IIF(TAR_finpro=Ctod("01/01/1900"),{//},TAR_finpro) As TAR_finprorg,;
			lid, TAR_codart, TAR_evolint, TAR_evolint as TAR_evolint2, ;
			TAR_registracio, TCP_DiagCod, TAR_Admision, TAR_HabCama, NVL(TAR_TipoAlta,0) as TAR_TipoAlta ;
			from mwkregistro;
			INTO Cursor mwkregistrob
	Else
		Select REG_nombrepac,;
			ENT_descrient,;
			TAR_siniestro,;
			TAR_proxate,;
			TAR_inipro,;
			IIF(TAR_finpro=Ctod("01/01/1900"),{//},TAR_finpro) As TAR_finpro,;
			IIF(TAR_finpro=Ctod("01/01/1900"),{//},TAR_finpro) As TAR_finprorg,;
			lid;
			from mwkregistro;
			INTO Cursor mwkregistrob
	Endif

	Use In Select("mwkregistro")
	Use Dbf('mwkregistrob') In 0 Again Alias mwkregistro
	Use In Select("mwkregistrob")

Return .T.
