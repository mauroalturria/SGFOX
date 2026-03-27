* 081128 Se agrega el campo FechaInternac
*!*	081210 mfechas se agrega parametro
parameters msql_pac, mfecdes, mfechas
mwhere = ''
if type("mfechas") # "D"
*	 SELECT ID , Categoria , Descripcion , FecPasiva FROM SQLUser . TabQuirAux
	if type("mNroReg") <> "N"
		mwhere = " where FechaQuirof = ?mfecdes "+;
			else
		mwhere = " where FechaQuirof >= ?mfecdes And Nroregistrac = ?mNroReg "+;
			endif
	else
		if mfechas = mfecdes
			mfechas = mfechas + 1
		endif
		mwhere =" where FechaQuirof >= ?mfecdes And FechaQuirof < ?mfechas"
	endif


	mret = sqlexec(mcon1, " SELECT tabquirofano.ID , Anestesista ,Ayudante as Instrumentista , BiopsiaIntraOp "+;
		", BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , Edad , EstComen  , "+;
		" TabQuirofano.Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , HoraEstDesp  , "+;
		" HoraFin , HoraInic , Instrumen as Ayudante , MateComen , Material , NroProtocolo  , NroQuirofano , "+;
		" Nroregistrac , OperCod , Operacion , PacNombre , Rayos,quirofano,descrip,codmed, "+;
		" cirujano,ent_descrient,diagnostico,ent_codent,descrip,laboratorio,AnestesiaTipo,MatInstancia, "+;
		" FechaInternac,AnestesistaCod,AnestesiaTipo,AyudanteCod as InstrumentistaCod,codent, HemoOk,MatCondicional,"+;
		" MatInstancia,mateok,Telefono,torre,MateProvee "+;
		" FROM TabQuirofano "+;
		" left join tabprotquir on tabprotquir.quirofano = tabquirofano.id "+;
		" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
		" left join registracio on registracio.reg_nroregistrac = TabQuirofano.Nroregistrac "+;
		" left join afiliacion on registracio.reg_nroregistrac = afiliacion.registracio "+;
		" left join entidades on entidades.ENT_codent = afiliacion.AFI_codentidad "+;
		"", "mwkpquir")
	if mret<1
		=aerr(eros)
		messagebox(eros(2))
	endif
	msql_pac = "select  * from mwkpquir into cursor mwkpquir1 "
