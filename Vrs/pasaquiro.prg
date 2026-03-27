Select vista3
mihora = datetime()
mfecnul = ctod("01/01/1900")
mid = 1
Do while id< 183595
	midr= id
	nini = mid
	nfal = midr-1
	If mid<midr
		For hh = nini to nfal 
			mret = sqlexec(mcon1,"INSERT INTO TabQuirofano1(fechaquirof) values (?mfecnul)")
			mid = mid + 1
		Next
	Endif
	mret = sqlexec(mcon1,"INSERT INTO TabQuirofano1(AnesComen, AnesFecVerif, AnesVerif, AnestesiaTipo, Anestesista, AnestesistaCod, AnestesistaNom, Ayudante, AyudanteCod, BiopsiaIntraOp,"+;
		"  BiopsioDiferida, CamaSector, CamaSolic, Cardiologo, Cirujano, CirujanoOk, CirujanoTE, TQC_CodAdmision, CodEnt, CodEsp, CodMed, Comentario,"+;
		"  CpasFechaCpa, CpasMatAdq, CpasNroProv, CpasObserva, CpasProvSG, CpasProveed, Diagnostico, DuracEst, Edad, EstComen, EstMaterial, Estado,"+;
		"  TQC_FecHorCita, FechaHora, FechaInternac, FechaPasiva, FechaQuirof, HemoAcenest, HemoComen, HemoOk, Hemonopaso, Hemoterapia, HoraEgre, HoraEst,"+;
		"  HoraEstDesp, HoraFin, HoraFinAnes, TQC_HoraFinAnesMed, HoraIndAnes, HoraIngre, TQC_HoraIniAnesMed, HoraInic, TQC_HoraLlega, TQC_HoraSalida,"+;
		"  Instrumen, TQC_IP, Laboratorio, MatCondicional, MatInstancia, MateComen, MateOk, MateProvee, Material, NroCirugia,"+;
		" NroProtocolo, TQC_NroQuiro, NroQuirofano, TQC_NroValeA, TQC_NroValeQ, Nroregistrac, OperCod, Operacion, PacNombre, PacVerif, ProgrOrigen, Rayos,"+;
		"  Servicio, Telefono, TipoPacte, Torre, Usuario, Verificado, aislaInfecto) "+;
		" SELECT AnesComen, AnesFecVerif, AnesVerif, AnestesiaTipo, Anestesista, AnestesistaCod, AnestesistaNom, Ayudante, AyudanteCod, BiopsiaIntraOp,"+;
		"  BiopsioDiferida, CamaSector, CamaSolic, Cardiologo, Cirujano, CirujanoOk, CirujanoTE, TQC_CodAdmision, CodEnt, CodEsp, CodMed, Comentario,"+;
		"  CpasFechaCpa, CpasMatAdq, CpasNroProv, CpasObserva, CpasProvSG, CpasProveed, Diagnostico, DuracEst, Edad, EstComen, EstMaterial, Estado,"+;
		"  TQC_FecHorCita, FechaHora, FechaInternac, FechaPasiva, FechaQuirof, HemoAcenest, HemoComen, HemoOk, Hemonopaso, Hemoterapia, HoraEgre, HoraEst,"+;
		"  HoraEstDesp, HoraFin, HoraFinAnes, TQC_HoraFinAnesMed, HoraIndAnes, HoraIngre, TQC_HoraIniAnesMed, HoraInic, TQC_HoraLlega, TQC_HoraSalida,"+;
		"  Instrumen, TQC_IP, Laboratorio, MatCondicional, MatInstancia, MateComen, MateOk, MateProvee, Material, NroCirugia,"+;
		" NroProtocolo, TQC_NroQuiro, NroQuirofano, TQC_NroValeA, TQC_NroValeQ, Nroregistrac, OperCod, Operacion, PacNombre, PacVerif, ProgrOrigen, Rayos,"+;
		"  Servicio, Telefono, TipoPacte, Torre, Usuario, Verificado, aislaInfecto FROM Tabquirofano where id = ?midr ","curquiro")
		mid = mid + 1

	Select vista3
	Skip

Enddo

mihora2 = datetime()
hora = (mihora2-mihora)/3600
messagebox(transform(hora))
