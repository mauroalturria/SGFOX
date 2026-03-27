Parameters tnOpcion, tnId, tcCurDat, tbSiImage

Do Case
	Case tnOpcion = 1
		If tnId = 0
			
			If &tcCurDat..TQP_Tipo = 4
				mCiruIni = "Previo al inicio del procedimiento se explica el mismo al paciente y/o familiar y se firma consentimiento informado." + Chr(10)
			Else
				mCiruIni = ""
			Endif 	
		
			lcSql = " Insert into TabQuiroProto (TQP_CodMed, TQP_Tipo, TQP_FecPasiva, TQP_Quirofano, " + ;
				"TQP_IOPAP, TQP_IOPCONG, TQP_IOPBAC, TQP_Gasas, TQP_ATBSN, TQP_PROFSN, TQP_TRANSN, TQP_TipoAnes, " + ;
				"TQP_Urgencia, TQP_Ip, TQP_NroRegistrac, TQP_DescPato, TQP_DescCiru, TQP_chklistqx ) " + ;
				" Values (?&tcCurDat..TQP_CodMed, ?&tcCurDat..TQP_Tipo, ?&tcCurDat..TQP_FecPasiva, ?&tcCurDat..TQP_Quirofano, " + ;
				"0, 0, 0, 1, 0, 0, 0, 0, 0, ?MyIp, ?&tcCurDat..TQP_NroRegistrac, '', ?mCiruIni,0 )"
		Else
			lcSql = " Update TabQuiroProto " + ;
				"Set TQP_CodMed = ?&tcCurDat..TQP_CodMed, " + ;
				"TQP_Tipo = ?&tcCurDat..TQP_Tipo, " + ;
				"TQP_FecPasiva = ?&tcCurDat..TQP_FecPasiva, " + ;
				"TQP_Quirofano = ?&tcCurDat..TQP_Quirofano " + ;
				"Where Id = ?tnId "
		Endif 
	Case tnOpcion = 2
			lcSql = " Update TabQuiroProto " + ;
				"Set " + ;
				"TQP_FecPasiva = ?&tcCurDat..TQP_FecPasiva, " + ;
				"TQP_VaxPasiva = ?&tcCurDat..TQP_VaxPasiva " + ;
				"Where Id = ?tnId "


	Case tnOpcion = 3
	
*!*		Set Step On
*!*			lcArchi = "c:\temp\imagen\imgqp.dbf"
*!*			Select TQP_IMGCARV_NUE as informe ;
*!*				From &tcCurDat ;
*!*				Into table &lcArchi
*!*			
*!*			Use In Select("imgqp")	
*!*		
*!*			LL = fopen(lcArchi,12)
*!*			fseek(LL,43)
*!*			fwrite(LL,'G')
*!*			fclose(LL)
*!*			use in 0 (lcArchi) alias __DATA
*!*			Select __DATA
*!*			Go top

	
			lcSql = " Update TabQuiroProto " + ;
				"Set TQP_HoraIni = ?&tcCurDat..TQP_HoraIni, " + ;
				"TQP_HoraFin = ?&tcCurDat..TQP_HoraFin, " + ;
				"Tqp_diagpreo = ?&tcCurDat..Tqp_diagpreo, " + ;
				"TQP_DiagPostO = ?&tcCurDat..TQP_DiagPostO, " + ;
				"TQP_Herida = ?&tcCurDat..TQP_Herida1, " + ;
				"TQP_ATBProf = ?&tcCurDat..TQP_ATBProf, " + ;
				"TQP_ATBPDocis = ?&tcCurDat..TQP_ATBPDocis1, " + ;
				"TQP_ProfTrom = ?&tcCurDat..TQP_ProfTrom1, " + ;
				"TQP_TransHemo = ?&tcCurDat..TQP_TransHemo, " + ;
				"TQP_TransHDocis = ?&tcCurDat..TQP_TransHDocis1, " + ;
				"TQP_Asa = ?&tcCurDat..TQP_Asa1, " + ;
				"TQP_AntiSepsia = ?&tcCurDat..TQP_Ase1, " + ;
				"TQP_DescCiru = ?&tcCurDat..TQP_DescCiru, " + ;
				"TQP_IOPAP = ?&tcCurDat..TQP_IOPAP, " + ;
				"TQP_IOPCONG = ?&tcCurDat..TQP_IOPCONG, " + ;
				"TQP_IOPBAC = ?&tcCurDat..TQP_IOPBAC, " + ;
				"TQP_Gasas = ?&tcCurDat..TQP_Gasas, " + ;
				"TQP_ATBSN = ?&tcCurDat..TQP_ATBSN, " + ;
				"TQP_PROFSN = ?&tcCurDat..TQP_PROFSN, " + ;
				"TQP_Ip = ?myip,"+;
				"TQP_TRANSN = ?&tcCurDat..TQP_TRANSN, " 
				if tbSiImage
					lcSql = lcSql + "TQP_IMGCARV = ?&tcCurDat..TQP_IMGCARV_NUE , " 
				Endif 	
				lcSql = lcSql + "TQP_TipoAnes = ?&tcCurDat..TQP_TipoAnes, " + ;
				"TQP_Aortico = ?&tcCurDat..TQP_Aortico, " + ;
				"TQP_Bomba = ?&tcCurDat..TQP_Bomba, " + ;
				"TQP_HipoTermia = ?&tcCurDat..TQP_HipoTermia, " + ;
				"TQP_AnatoPat = ?&tcCurDat..TQP_AnatoPat, " + ;				
				"tqp_estado = ?&tcCurDat..tqp_estado, " + ;
				"TQP_Urgencia = ?&tcCurDat..TQP_Urgencia, " + ;				
				"TQP_chklistqx = ?&tcCurDat..TQP_chklistqx " +;
				"Where Id = ?tnId "
				
***         "TQP_AnatoPat = ?&tcCurDat..TQP_AnatoPat, " + ;		
*!*			Use In Select("__DATA")

	Case tnOpcion = 4 && circulante
	
			lcSql = " Update TabQuiroProto " + ;
				"Set TQP_HoraIni = ?&tcCurDat..TQP_HoraIni, " + ;
				"TQP_HoraFin = ?&tcCurDat..TQP_HoraFin, " + ;
				"TQP_Ip = ?myip,"+;
				"TQP_FecNoCir = ?&tcCurDat..TQP_FecNoCir, " + ;
				"TQP_VAXNOCIR = ?&tcCurDat..TQP_VAXNOCIR, " + ;
				"tqp_estado = ?&tcCurDat..tqp_estado " + ;
				"Where Id = ?tnId "

	Case tnOpcion = 5 && cirujano

			lcSql = " Update TabQuiroProto " + ;
				"Set Tqp_diagpreo = ?&tcCurDat..Tqp_diagpreo, " + ;
				"TQP_DiagPostO = ?&tcCurDat..TQP_DiagPostO, " + ;
				"TQP_Herida = ?&tcCurDat..TQP_Herida1, " + ;
				"TQP_ATBProf = ?&tcCurDat..TQP_ATBProf, " + ;
				"TQP_ATBPDocis = ?&tcCurDat..TQP_ATBPDocis1, " + ;
				"TQP_ProfTrom = ?&tcCurDat..TQP_ProfTrom1, " + ;
				"TQP_TransHemo = ?&tcCurDat..TQP_TransHemo, " + ;
				"TQP_TransHDocis = ?&tcCurDat..TQP_TransHDocis1, " + ;
				"TQP_Asa = ?&tcCurDat..TQP_Asa1, " + ;
				"TQP_AntiSepsia = ?&tcCurDat..TQP_Ase1, " + ;
				"TQP_DescCiru = ?&tcCurDat..TQP_DescCiru, " + ;
				"TQP_IOPAP = ?&tcCurDat..TQP_IOPAP, " + ;
				"TQP_IOPCONG = ?&tcCurDat..TQP_IOPCONG, " + ;
				"TQP_IOPBAC = ?&tcCurDat..TQP_IOPBAC, " + ;
				"TQP_Gasas = ?&tcCurDat..TQP_Gasas, " + ;
				"TQP_ATBSN = ?&tcCurDat..TQP_ATBSN, " + ;
				"TQP_Ip = ?myip,"+;
				"TQP_PROFSN = ?&tcCurDat..TQP_PROFSN, " + ;
				"TQP_TRANSN = ?&tcCurDat..TQP_TRANSN, " 
				if tbSiImage
					lcSql = lcSql + "TQP_IMGCARV = ?&tcCurDat..TQP_IMGCARV_NUE , " 
				Endif 	
				lcSql = lcSql + "TQP_TipoAnes = ?&tcCurDat..TQP_TipoAnes, " + ;
				"TQP_Aortico = ?&tcCurDat..TQP_Aortico, " + ;
				"TQP_Bomba = ?&tcCurDat..TQP_Bomba, " + ;
				"TQP_HipoTermia = ?&tcCurDat..TQP_HipoTermia, " + ;
				"TQP_CodigoVax = ?&tcCurDat..TQP_CodigoVax, " + ;
				"TQP_FecAlta = ?&tcCurDat..TQP_FecAlta, " + ;
				"TQP_Urgencia = ?&tcCurDat..TQP_Urgencia, " + ;
				"TQP_Lado = ?&tcCurDat..TQP_Lado, " + ;
				"TQP_torrelap = ?&tcCurDat..TQP_torrelap, " + ;
				"TQP_chklistqx = ?&tcCurDat..TQP_chklistqx " +;
				"Where Id = ?tnId "


	Case tnOpcion = 6 && Patologo
	
			lcSql = " Update TabQuiroProto " + ;
				"Set TQP_DescPato = ?&tcCurDat..TQP_DescPato, " + ;
				"TQP_VaxPato = ?&tcCurDat..TQP_VaxPato, " + ;
				"TQP_FecPato = ?&tcCurDat..TQP_FecPato " + ;
				"Where Id = ?tnId "

		
	Otherwise
	
Endcase 

If !Prg_EjecutoSql(lcSql,"",.f.)
	Return .f.
Endif



If &tcCurDat..tqp_estado = 3 And INLIST(tnOpcion,3,4) And tnId > 0

	If !sp_Actualizo_quiro_dura(tnId)
		Return 
	Endif 
	
	lnEstadoU = 31 && FINALIZADO
	
	If Used("mwkQPPrest")
		Select mwkQPPrest
		Locate For Nvl(mwkQPPrest.Tpp_codprest,0) = 99999999 Or Nvl(mwkQPPrest.Tpp_codprest,0) = 99999998
		If Found()
			lnEstadoU = 21 && suspendido
		Endif 
	Endif 
	
	If !sp_Actualizo_quiro_Estado(&tcCurDat..TQP_Quirofano,lnEstadoU) && 20200122 Pasa a finalizado la programación
		Return 
	Endif 

	If !sp_Actualizo_quiro_Verificado(&tcCurDat..TQP_Quirofano) && 20200122 Pasa a finalizado la programación
		Return 
	Endif 

Endif 
