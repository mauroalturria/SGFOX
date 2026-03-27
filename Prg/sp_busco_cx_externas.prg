Parameters msql_pac, mfecdes, mfechas, mbusco

If Type("mfechas") # "D"
	mwhere = " FechaQuirof >= ?mfecdes  "
Else
	If mfechas = mfecdes
		mwhere = " FechaQuirof = ?mfecdes "
	Else
		mwhere = " FechaQuirof >= ?mfecdes And FechaQuirof < ?mfechas "
	Endif
Endif

If Type("mbusco") # "C"
	mbusco = ""
Endif
ldNull = Ctod("01/01/1900")


mwhere = Iif (Empty(mwhere )," where FechaPasiva = ?ldNull ",' where FechaPasiva = ?ldNull and ') + mwhere

mret = SQLExec(mcon1, " SELECT tabquirofano.ID , Anestesista ,Ayudante as Instrumentista ,"+;
	" BiopsiaIntraOp , BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , "+;
	" Edad , EstComen  , TabQuirofano.Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , "+;
	" HoraEstDesp  , HoraFin,HoraIngre ,HoraIndAnes ,HoraFinAnes ,HoraEgre , HoraInic , Instrumen as Ayudante ,  MateComen , Material , "+;
	" NroProtocolo  , NroQuirofano , Nroregistrac , OperCod , Operacion , PacNombre , Rayos,"+;
	" quirofano ,tabEstados.descrip,codmed,cirujano,ENT_descrient,ENT_nroprestadorexterno,diagnostico,ent_codent,laboratorio,"+;
	" AnestesiaTipo,MatInstancia, FechaInternac,AnestesistaCod,AnestesiaTipo,"+;
	" AyudanteCod as InstrumentistaCod,codent, HemoOk,MatCondicional,mateok,TabQuirofano.Telefono,"+;
	" torre,mateprovee,pacverif,estmaterial,anestesistanom, "+;
	" CamaSolic, CamaSector,verificado, ProgrOrigen, TipoPacte, CpasFechaCpa ,"+;
	" CpasMatAdq ,CpasObserva ,CpasProvSG ,CpasProveed ,CpasNroProv, "+;
	" AnesComen,  AnesFecVerif, AnesVerif, Servicio, bpresta.Nombre as nomanest1,  "+;
	" TabQuirofano.CodEsp,registracio.reg_fecnacimiento,registracio.REG_nrohclinica"+;
	",tabusuario.nomape,TabQuirofano.FechaHora, Codadmision, TQC_HoraLlega, TQC_HoraSalida, " + ;
	"TQC_HoraIniAnesMed, TQC_HoraFinAnesMed, TQC_NroQuiro, tabquirofano.TQC_FecHorCita,tabquirosala.tqs_sala, " + ;
	"PRESTACIONS.PRE_duracion, Nvl(tabprotquir.TipoPac,0) as TipoPac, tabquirofano.aislaInfecto, registracio.Reg_Sexo " +;
	",tqs_sala "+ ;
	" FROM TabQuirofano " + ;
	" inner join tabquirosala on tabquirofano.nroquirofano = tabquirosala.id and TQS_Prog = 1 " + ;
	" left join tabprotquir on tabprotquir.quirofano = tabquirofano.id "+;
	" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
	" left join entidades on entidades.ENT_codent = TabQuirofano.codent "+;
	" left join prestadores bpresta on bpresta.ID = TabQuirofano.anestesistacod "+;
	" left join registracio on TabQuirofano.Nroregistrac = registracio.reg_nroregistrac "+;
	" left join tabusuario on TabQuirofano.usuario = tabusuario.codigovax "+;
	" left join PRESTACIONS on PRESTACIONS.Pre_CodPrest = TabQuirofano.OperCod "+;
	mwhere + mbusco , "mwkpquir00")

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif


Select mwkpquir00.*,'' As nombre,'' As nominstrumen, ;
	padr(Iif(mwkpquir00.anestesista = 1,'',Iif(mwkpquir00.anestesista = 2,;
	nvl(mwkpquir00.nomanest1,''),Nvl(mwkpquir00.anestesistanom,''))) ,50) As nomanestesis;
	from mwkpquir00 ;
	into Cursor mwkpquir

msql_pac = "select  * from mwkpquir into cursor mwkpquir1 "
