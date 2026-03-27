parameters mbusco

if empty(mbusco)
	mbusco = " FechaQuirof = "+prg_dtoc(sp_busco_fecha_serv("DD"))
endif

mret = sqlexec(mcon1, " SELECT tabquirofano.ID , Anestesista ,Ayudante as Instrumentista ,"+;
	" BiopsiaIntraOp , BiopsioDiferida , Cardiologo , CirujanoTE , Comentario , DuracEst , "+;
	" Edad , EstComen  , TabQuirofano.Estado , FechaQuirof , HemoComen , Hemoterapia , HoraEst , "+;
	" HoraEstDesp  , HoraFin,HoraIngre, HoraIngquirof ,HoraIndAnes ,HoraFinAnes ,HoraEgre , HoraInic , Instrumen as Ayudante ,  MateComen , Material , "+;
	" NroProtocolo  , NroQuirofano , Nroregistrac , OperCod , Operacion , PacNombre , Rayos,"+;
	" quirofano ,descrip,codmed,cirujano,ent_descrient,diagnostico,ent_codent,descrip,laboratorio,"+;
	" AnestesiaTipo,MatInstancia, FechaInternac,AnestesistaCod,AnestesiaTipo,"+;
	" AyudanteCod as InstrumentistaCod,codent, HemoOk,MatCondicional,mateok,TabQuirofano.Telefono,"+;
	" torre,mateprovee,pacverif,estmaterial,anestesistanom, "+;
	" CamaSolic, CamaSector,verificado, ProgrOrigen, TipoPacte, CpasFechaCpa ,"+;
	" CpasMatAdq ,CpasObserva ,CpasProvSG ,CpasProveed ,CpasNroProv, "+;
	" AnesComen,  AnesFecVerif, AnesVerif, Servicio, bpresta.Nombre as nomanest1,  "+;
	" TabQuirofano.CodEsp,registracio.reg_fecnacimiento,registracio.REG_nrohclinica,TQS_sala,tabEstados.estado as estadociru " + ;
	" FROM TabQuirofano " + ;
	" left join tabprotquir on tabprotquir.quirofano = tabquirofano.id "+;
	" left join tabEstados on tabEstados.id = TabQuirofano.estado "+;
	" left join entidades on entidades.ENT_codent = TabQuirofano.codent "+;
	" left join prestadores bpresta on bpresta.ID = TabQuirofano.anestesistacod "+;
	" left join registracio on TabQuirofano.Nroregistrac = registracio.reg_nroregistrac "+;
	" inner join tabquirosala on tabquirofano.nroquirofano = tabquirosala.id and TQS_Prog = 1 "+;
	" where "+  mbusco , "mwkpquirdat0")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
if used('mwkMedrpzt')
	select mwkpquirdat0.*,mwkMedrpzt.nombre ;
		from mwkpquirdat0 ;
		left join mwkMedrpzt on mwkMedrpzt.id = mwkpquirdat0.codmed ;
		into cursor mwkpquirdat
endif
