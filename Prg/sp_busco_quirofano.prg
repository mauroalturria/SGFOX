* 081128 Se agrega el campo FechaInternac
*!*	081210 mfechas se agrega parametro
*!*	100707 agrego parametro mbusco
*!*	08/05/2025 agrego consulta de Items pendientes de conforme cuando la bolsa ya ha sido conformada.
Parameters msql_pac, mfecdes, mfechas, mbusco,lesHD

If Vartype(lesHD)<>"N"
	lesHD = 0
Endif

If lesHD = 0
	mfilq = ' and TQS_Prog = 1 '
Else
	mfilq = ''
Endif

If Vartype(mfecdes) <> "D" .And. Vartype(mfechas) <> "D"
	mwhere = ""
Else
	If Type("mfechas") # "D"
		If Type("mNroReg") <> "N"
			mwhere = " FechaQuirof = ?mfecdes "
		Else
			mwhere = " FechaQuirof >= ?mfecdes And Nroregistrac = ?mNroReg "
		Endif
	Else
		If mfechas = mfecdes
			mwhere = " FechaQuirof = ?mfecdes "
		Else
			mwhere = " FechaQuirof >= ?mfecdes And FechaQuirof < ?mfechas "
		Endif
	Endif
Endif

If Type("mbusco") # "C"
	mbusco = ""
Endif
If !Used('mwkMedrpzt')
	Do sp_busco_medrempzt With Ctot("01/01/2015"),,,,"QUI"
	Select * From mwkmedicogua Into Cursor mwkMedrpzt
Endif
ldNull = Ctod("01/01/1900")


mwhere = Iif (Empty(mwhere )," where FechaPasiva = ?ldNull ",' where FechaPasiva = ?ldNull and ') + mwhere &&& " where FechaPasiva = '01-01-1900' and "
*	 SELECT ID , Categoria , Descripcion , FecPasiva FROM SQLUser . TabQuirAux

mret = SQLExec(mcon1, " SELECT tabquirofano.ID , Anestesista ,Ayudante as Instrumentista ,"+;
	" BiopsiaIntraOp , BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , "+;
	" Edad , EstComen  , TabQuirofano.Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , "+;
	" HoraEstDesp  , HoraFin,HoraIngre, HoraIngquirof ,HoraIndAnes ,HoraFinAnes ,HoraEgre , HoraInic , Instrumen as Ayudante ,  MateComen , Material , "+;
	" NroProtocolo  , NroQuirofano , Nroregistrac , OperCod , Operacion , PacNombre , Rayos,"+;
	" quirofano ,tabEstados.descrip,codmed,cirujano,ent_descrient,diagnostico,ent_codent,laboratorio,"+;
	" AnestesiaTipo,MatInstancia, FechaInternac,AnestesistaCod,AnestesiaTipo,"+;
	" AyudanteCod as InstrumentistaCod,codent, HemoOk,MatCondicional,mateok,TabQuirofano.Telefono,"+;
	" torre,mateprovee,pacverif,estmaterial,anestesistanom, "+;
	" CamaSolic, CamaSector,verificado, ProgrOrigen, TipoPacte, CpasFechaCpa ,"+;
	" CpasMatAdq ,CpasObserva ,CpasProvSG ,CpasProveed ,CpasNroProv, "+;
	" AnesComen,  AnesFecVerif, AnesVerif, Servicio, bpresta.Nombre as nomanest1,  "+;
	" TabQuirofano.CodEsp,registracio.reg_fecnacimiento,registracio.REG_nrohclinica"+;
	",tabusuario.nomape,TabQuirofano.FechaHora, Codadmision, TQC_HoraLlega, TQC_HoraIngQX, TQC_HoraSalida, " + ;
	"TQC_HoraIniAnesMed, TQC_HoraFinAnesMed, TQC_NroQuiro, tabquirofano.TQC_FecHorCita, " + ;
	"PRESTACIONS.PRE_duracion, Nvl(tabprotquir.TipoPac,0) as TipoPac, tabquirofano.aislaInfecto, registracio.Reg_Sexo, tabquirofano.AlergiaLatex, " + ;
	"TabQuirofano.TQC_codadmision, tabprotquir.codadmision as tqp_admision,tabEstados.estado as tipoest,Registracio.REG_nombrepac " +;
	" FROM TabQuirofano " + ;
	" left join tabprotquir on tabprotquir.quirofano = tabquirofano.id "+;
	" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
	" left join entidades on entidades.ENT_codent = TabQuirofano.codent "+;
	" left join prestadores bpresta on bpresta.ID = TabQuirofano.anestesistacod "+;
	" left join registracio on TabQuirofano.Nroregistrac = registracio.reg_nroregistrac "+;
	" left join tabusuario on TabQuirofano.usuario = tabusuario.codigovax "+;
	" left join PRESTACIONS on PRESTACIONS.Pre_CodPrest = TabQuirofano.OperCod "+;
	" inner join tabquirosala on tabquirofano.nroquirofano = tabquirosala.id " + mfilq  +;
	mwhere + mbusco , "mwkpquir00")

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif

mbusco1 	= " and pac_fechaadmision >= ?mfecdes "

mret = SQLExec(mcon1, "select " + ;
	"TabProtQuir.*, Pacientes.Pac_codhci " + ;
	"from TabProtQuir ,pacinternad, pacientes " + ;
	"where pin_codadmision = Codadmision and pac_codadmision = Codadmision "+;
	"and TipoPac = 1"+ mbusco1 , "mwkpacint01")

If mret<1
	=Aerror(eros)
	Messagebox(eros(3))
Endif

mifecha = sp_busco_fecha_serv("DD")-3
mbusco2 = " and FechaHoraQuir >= ?mifecha  "

mret = SQLExec(mcon1, "select TabProtQuir.*, Pac_codhci " + ;
	" From TabProtQuir " + ;
	" Inner Join histambgua on histambgua.his_codadmision = TabProtQuir.Codadmision " + ;
	" Inner Join Pacientes on Pacientes.PAC_codhci = histambgua.his_nroregistrac " + ;
	" and PAC_codadmision = TabProtQuir.Codadmision " + ;
	" Where Tabprotquir.TipoPac = 2 &mbusco2 " , "mwkpacint02")

If mret<1
	=Aerror(eros)
	Messagebox(eros(3))
Endif

Select * From mwkpacint01 ;
	union All ;
	select * From mwkpacint02 ;
	into Cursor mwkpacin

Do sp_busco_quiroaux With 1 ,"mwkauxinstrumen",mfecdes
Do sp_busco_quiroaux With 2 ,"mwkauxanestesis",mfecdes

* ------------- Marcelo Torres, 08/05/2025
*mfecdes, mfechas

* Set Step On

If Vartype(mfecdes) = "D" And Vartype(mfechas) = "D"

	cFecSqlDesde = Dtot(mfecdes)
	cFecSqlHasta = Dtot(mfechas+1)

	mret = SQLExec(mcon1,"select a.IdTabQuirofano,a.fechahoracarga, a.FechaHoraConforme , b.TQC_HoraSalida , b.NroProtocolo, a.CodBolsa, c.CantRecibida ,c.CantConformada , c.CantSuministrada , c.CantUtilizada " +;
		"from TabBolsasProgramacion as a " +;
		"left join TabInsumosProgramacion as c on a.ID = c.IdTabBolsasProgramacion " +;
		"left join TabQuirofano as b on a.IdTabQuirofano = b.ID " +;
		"where a.FechaHoraCarga >= ?cFecSqlDesde and a.FechaHoraCarga <= ?cFecSqlHasta and a.FechaHoraConforme is not NULL AND " +;
		"(c.CantUtilizada = -999 or c.CantRecibida = -999)","mwkBolsaPendiente")

	If mret > 0
		Select * From mwkBolsaPendiente Group By NroProtocolo Into Cursor mwkBolsaPendiente
	Else
		Messagebox("Error al intentar consultar las Bolsas con Pendientes.",16,"Pendientes")
	Endif

Endif

* ----------------------------------------
Select mwkpquir00.*,mwkMedrpzt.nombre,mwkauxinstrumen.descripcion As nominstrumen, ;
	padr(Iif(mwkpquir00.anestesista = 1,'',Iif(mwkpquir00.anestesista = 2,;
	nvl(mwkpquir00.nomanest1,''),Nvl(mwkpquir00.anestesistanom,''))) ,50) As nomanestesis, ;
	Pac_codhci ;
	from mwkpquir00 ;
	left Join mwkMedrpzt On mwkMedrpzt.Id = mwkpquir00.codmed ;
	left Join mwkauxinstrumen On mwkauxinstrumen.Id = InstrumentistaCod ;
	left Join mwkpacin On mwkpacin.Pac_codhci = Nroregistrac ;
	into Cursor mwkpquir

msql_pac = "select  * from mwkpquir into cursor mwkpquir1 "
