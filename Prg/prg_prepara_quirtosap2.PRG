Parameters tnID

If Vartype(tnID) # "N"
	Return .F.
Endif

*Set Step On

Private g_codvax
*g_codvax = 55615
g_codvax = mwkUsuario.codigovax
*!*	lnId = mwkquiro2.id

*!*	TEXT To lcsql Textmerge Noshow Pretext 7
*!*		Select Cast(1 as int) AS psele, Nvl(nroprotocolo,0) as nroprotocolo, TQC_nrovaleq, TQC_NroValeQS, TQC_NroValeQFS, pre_descriprest
*!*			from TabQuirofano
*!*			inner join prestacions on prestacions.id = TabQuirofano.OperCod
*!*			Where id = <<tnID>>
*!*	ENDTEXT

*!*	If !Prg_EjecutoSql(lcSql,"mwkProtocolos")
*!*		Return .F.
*!*	Endif



	Text To lcsql Textmerge Noshow Pretext 7
	SELECT Cast(0 as int) as psele, 
		TabQuiroProto.TQP_Estado, TabQuiroProto.Id as IdProto, TabQuiroProto.TQP_HoraIni, TabQuiroProto.TQP_URGENCIA,
		Pacientes.Pac_Codadmision as Codadmision, 
		TABQUIROFANO.PacNombre, TABQUIROFANO.NroProtocolo, Nvl(TABQUIROFANO.TQC_NroValeQ,0) as TQC_NroValeQ, 
		TABQUIROFANO.TQC_HoraLlega,TABQUIROFANO.TQC_HoraIngQX, TABQUIROFANO.TQC_HoraSalida,
		Pacientes.PAC_Tipopac, Pacientes.Pac_FechaAdmision, Pacientes.Pac_FechaAlta,
		TabQuiroSala.TQS_sala, fechaquirof, Cast(case when TabQuiroSala.TQS_Prog = 0 then 'INTERFAZ' else tabEstados.Descrip end AS CHAR(50)) as EstadoQ, 
		TabQuiroSala.TQS_habilitado, HoraIngre, HoraIngquirof, CodMed,
		TABQUIROFANO.id as IdQuiro, Nvl(TQC_NroValeQS,0) as TQC_NroValeQS, Nvl(TQC_NroValeQFS,0) as TQC_NroValeQFS,
		reg_nrohclinica, Reg_Sexo, Edad, TQC_HoraLlega, TQC_HoraIngQX, TQC_HoraIniAnesMed, TQP_HoraIni, TQP_HoraFin, TQC_HoraFinAnesMed, TQC_HoraSalida, 
		ent_codent, ent_descrient, camasolic, Nroquirofano, SER_descripserv, Quirofano,
		TQC_NroQuiro, Diagnostico, Operacion, nroregistrac, Cast(case when Nvl(TQC_CodAdmision,'') = "" then Nvl(tabprotquir.Codadmision,'') else Nvl(TQC_CodAdmision,'') end as char(20)) as Admision,
		Cast(Case When VALESQUIROF.VALESQUIROF > 0 then 1 else 0 end as integer) as ExisteValeQ, Prestacions.Pre_Descriprest, Nvl(TABQUIROFANO.Verificado,0) as Verificado, 
		TabQuiroProto.tqp_estado, TABQUIROFANO.id 
		FROM TABQUIROFANO
		left join Registracio on Registracio.Reg_NroRegistrac = TABQUIROFANO.Nroregistrac
		left join Servicios on Servicios.SER_codserv = TABQUIROFANO.Servicio
		left join Entidades on Entidades.Ent_CodEnt = TABQUIROFANO.CodEnt
		left join tabprotquir on tabprotquir.quirofano = tabquirofano.id 
		left join tabEstados on tabEstados.id = TabQuirofano.estado
		left join VALESQUIROF on VALESQUIROF.VALESQUIROF = TABQUIROFANO.NroProtocolo 
		left join Prestacions on Prestacions.Pre_CodPrest = TABQUIROFANO.OperCod
		inner JOIN TabQuiroProto ON TabQuiroProto.TQP_Quirofano = TABQUIROFANO.Id and TQP_FecPasiva = '1900-01-01' and TabQuiroProto.TQP_Estado = 3
		inner JOIN TabQuiroSala ON TabQuiroSala.ID = TABQUIROFANO.NroQuirofano
		inner JOIN Pacientes on Pacientes.pac_codhci = TABQUIROFANO.Nroregistrac and 
			((TABQUIROFANO.fechaquirof between Pacientes.pac_fechaadmision and Pacientes.pac_fechaalta) or 
				(Pacientes.pac_fechaadmision <= TABQUIROFANO.fechaquirof and Pacientes.pac_fechaalta is null))
		WHERE TABQUIROFANO.id = <<tnID>>
		Group by NroProtocolo
		Order by NroProtocolo
	Endtext 

*!*	FechaHoraDescarga, FechaHoraCarga, FechaHoraConforme
*!*			left join TabBolsasProgramacion on TabBolsasProgramacion.IdTabQuirofano = TABQUIROFANO.id


*!*			INNER JOIN TabQuiroSala ON TabQuiroSala.ID = TABQUIROFANO.NroQuirofano AND TabQuiroSala.TQS_habilitado = 1 and TabQuiroSala.TQS_Prog = 1

	If !Prg_EjecutoSql(lcSql,"mwkProtocolos1")
		Return .f.
	Endif  
	

	Text To lcsql Textmerge Noshow Pretext 7
	SELECT Cast(0 as int) as psele, 
		TabQuiroProto.TQP_Estado, TabQuiroProto.Id as IdProto, TabQuiroProto.TQP_HoraIni, TabQuiroProto.TQP_URGENCIA,
		TabProtQuir.Codadmision, 
		TABQUIROFANO.PacNombre, TABQUIROFANO.NroProtocolo, Nvl(TABQUIROFANO.TQC_NroValeQ,0) as TQC_NroValeQ, 
		TABQUIROFANO.TQC_HoraLlega, TABQUIROFANO.TQC_HoraIngQX, TABQUIROFANO.TQC_HoraSalida,
		Pacientes.PAC_Tipopac, Pacientes.Pac_FechaAdmision, Pacientes.Pac_FechaAlta,
		TabQuiroSala.TQS_sala, fechaquirof, Cast(case when TabQuiroSala.TQS_Prog = 0 then 'INTERFAZ' else tabEstados.Descrip end AS CHAR(50)) as EstadoQ, 
		TabQuiroSala.TQS_habilitado, HoraIngre, HoraIngquirof, CodMed,
		TABQUIROFANO.id as IdQuiro, Nvl(TQC_NroValeQS,0) as TQC_NroValeQS, Nvl(TQC_NroValeQFS,0) as TQC_NroValeQFS,
		reg_nrohclinica, Reg_Sexo, Edad, TQC_HoraLlega, TQC_HoraIngQX, TQC_HoraIniAnesMed, TQP_HoraIni, TQP_HoraFin, TQC_HoraFinAnesMed, TQC_HoraSalida,
		ent_codent, ent_descrient, camasolic, Nroquirofano, SER_descripserv, Quirofano,
		TQC_NroQuiro, Diagnostico, Operacion, nroregistrac, Cast(case when Nvl(TQC_CodAdmision,'') = "" then Nvl(tabprotquir.Codadmision,'') else Nvl(TQC_CodAdmision,'') end as char(20)) as Admision,
		Cast(Case When VALESQUIROF.VALESQUIROF > 0 then 1 else 0 end as integer) as ExisteValeQ, Prestacions.Pre_Descriprest, Nvl(TABQUIROFANO.Verificado,0) as Verificado,
		TabQuiroProto.tqp_estado , TABQUIROFANO.id
		FROM TABQUIROFANO
		left join Registracio on Registracio.Reg_NroRegistrac = TABQUIROFANO.Nroregistrac
		left join Entidades on Entidades.Ent_CodEnt = TABQUIROFANO.CodEnt
		left join Servicios on Servicios.SER_codserv = TABQUIROFANO.Servicio
		left join tabEstados on tabEstados.id = TabQuirofano.estado
		left join VALESQUIROF on VALESQUIROF.VALESQUIROF = TABQUIROFANO.NroProtocolo 
		left join Prestacions on Prestacions.Pre_CodPrest = TABQUIROFANO.OperCod
		INNER JOIN TabQuiroProto ON TabQuiroProto.TQP_Quirofano = TABQUIROFANO.Id and TQP_FecPasiva = '1900-01-01' and TabQuiroProto.TQP_Estado = 3
		INNER JOIN TabQuiroSala ON TabQuiroSala.ID = TABQUIROFANO.NroQuirofano
		left JOIN TabProtQuir ON TabProtQuir.Quirofano = TABQUIROFANO.Id
		left join Pacientes on Pacientes.pac_codadmision = TabProtQuir.Codadmision
		WHERE TABQUIROFANO.id = <<tnID>>
		Group by NroProtocolo
		Order by NroProtocolo

	Endtext 

	If !Prg_EjecutoSql(lcSql,"mwkProtocolos2")
		Return .f.
	Endif
	
	
	Text To lcsql Textmerge Noshow Pretext 7
	SELECT Cast(1 as int) as psele, 
		TabQuiroProto.TQP_Estado, TabQuiroProto.Id as IdProto, TabQuiroProto.TQP_HoraIni, TabQuiroProto.TQP_URGENCIA,
		Pacientes.Pac_Codadmision as Codadmision, 
		TABQUIROFANO.PacNombre, TABQUIROFANO.NroProtocolo, Nvl(TABQUIROFANO.TQC_NroValeQ,0) as TQC_NroValeQ, 
		TABQUIROFANO.TQC_HoraLlega, TABQUIROFANO.TQC_HoraIngQX, TABQUIROFANO.TQC_HoraSalida,
		Pacientes.PAC_Tipopac, Pacientes.Pac_FechaAdmision, Pacientes.Pac_FechaAlta,
		TabQuiroSala.TQS_sala, fechaquirof, Cast(case when TabQuiroSala.TQS_Prog = 0 then 'INTERFAZ' else tabEstados.Descrip end AS CHAR(50)) as EstadoQ, 
		TabQuiroSala.TQS_habilitado, HoraIngre, HoraIngquirof, CodMed,
		TABQUIROFANO.id as IdQuiro, Nvl(TQC_NroValeQS,0) as TQC_NroValeQS, Nvl(TQC_NroValeQFS,0) as TQC_NroValeQFS,
		reg_nrohclinica, Reg_Sexo, Edad, TQC_HoraLlega, TQC_HoraIngQX, TQC_HoraIniAnesMed, TQP_HoraIni, TQP_HoraFin, TQC_HoraFinAnesMed, TQC_HoraSalida, 
		ent_codent, ent_descrient, camasolic, Nroquirofano, SER_descripserv, Quirofano,
		TQC_NroQuiro, Diagnostico, Operacion, nroregistrac, Cast(case when Nvl(TQC_CodAdmision,'') = "" then Nvl(tabprotquir.Codadmision,'') else Nvl(TQC_CodAdmision,'') end as char(20)) as Admision,
		Cast(Case When VALESQUIROF.VALESQUIROF > 0 then 1 else 0 end as integer) as ExisteValeQ, Prestacions.Pre_Descriprest, Nvl(TABQUIROFANO.Verificado,0) as Verificado, 
		TabQuiroProto.tqp_estado, TABQUIROFANO.id 
		FROM TABQUIROFANO
		left join Registracio on Registracio.Reg_NroRegistrac = TABQUIROFANO.Nroregistrac
		left join Servicios on Servicios.SER_codserv = TABQUIROFANO.Servicio
		left join Entidades on Entidades.Ent_CodEnt = TABQUIROFANO.CodEnt
		left join tabprotquir on tabprotquir.quirofano = tabquirofano.id 
		left join tabEstados on tabEstados.id = TabQuirofano.estado
		left join VALESQUIROF on VALESQUIROF.VALESQUIROF = TABQUIROFANO.NroProtocolo 
		left join Prestacions on Prestacions.Pre_CodPrest = TABQUIROFANO.OperCod
		inner JOIN TabQuiroProto ON TabQuiroProto.TQP_Quirofano = TABQUIROFANO.Id and TQP_FecPasiva = '1900-01-01' and TabQuiroProto.TQP_Estado = 3
		inner JOIN TabQuiroSala ON TabQuiroSala.ID = TABQUIROFANO.NroQuirofano
		inner JOIN Pacientes on Pacientes.pac_codhci = TABQUIROFANO.Nroregistrac and 
			((TABQUIROFANO.fechaquirof between Pacientes.pac_fechaadmision and Pacientes.pac_fechaalta) or 
				(Pacientes.pac_fechaadmision <= TABQUIROFANO.fechaquirof and Pacientes.pac_fechaalta is null))
		WHERE TabQuiroSala.TQS_Prog = 0 and fechaQuirof = current_date and tqc_nrovaleq = 0
		Group by NroProtocolo
		Order by NroProtocolo
	Endtext 

*!*	FechaHoraDescarga, FechaHoraCarga, FechaHoraConforme
*!*			left join TabBolsasProgramacion on TabBolsasProgramacion.IdTabQuirofano = TABQUIROFANO.id


*!*			INNER JOIN TabQuiroSala ON TabQuiroSala.ID = TABQUIROFANO.NroQuirofano AND TabQuiroSala.TQS_habilitado = 1 and TabQuiroSala.TQS_Prog = 1

	If !Prg_EjecutoSql(lcSql,"mwkProtocolos3")
		Return .f.
	Endif  
	

	Text To lcsql Textmerge Noshow Pretext 7
	SELECT Cast(1 as int) as psele, 
		TabQuiroProto.TQP_Estado, TabQuiroProto.Id as IdProto, TabQuiroProto.TQP_HoraIni, TabQuiroProto.TQP_URGENCIA,
		TabProtQuir.Codadmision, 
		TABQUIROFANO.PacNombre, TABQUIROFANO.NroProtocolo, Nvl(TABQUIROFANO.TQC_NroValeQ,0) as TQC_NroValeQ, 
		TABQUIROFANO.TQC_HoraLlega, TABQUIROFANO.TQC_HoraIngQX, TABQUIROFANO.TQC_HoraSalida,
		Pacientes.PAC_Tipopac, Pacientes.Pac_FechaAdmision, Pacientes.Pac_FechaAlta,
		TabQuiroSala.TQS_sala, fechaquirof, Cast(case when TabQuiroSala.TQS_Prog = 0 then 'INTERFAZ' else tabEstados.Descrip end AS CHAR(50)) as EstadoQ, 
		TabQuiroSala.TQS_habilitado, HoraIngre, HoraIngquirof, CodMed,
		TABQUIROFANO.id as IdQuiro, Nvl(TQC_NroValeQS,0) as TQC_NroValeQS, Nvl(TQC_NroValeQFS,0) as TQC_NroValeQFS,
		reg_nrohclinica, Reg_Sexo, Edad, TQC_HoraLlega, TQC_HoraIngQX, TQC_HoraIniAnesMed, TQP_HoraIni, TQP_HoraFin, TQC_HoraFinAnesMed, TQC_HoraSalida,
		ent_codent, ent_descrient, camasolic, Nroquirofano, SER_descripserv, Quirofano,
		TQC_NroQuiro, Diagnostico, Operacion, nroregistrac, Cast(case when Nvl(TQC_CodAdmision,'') = "" then Nvl(tabprotquir.Codadmision,'') else Nvl(TQC_CodAdmision,'') end as char(20)) as Admision,
		Cast(Case When VALESQUIROF.VALESQUIROF > 0 then 1 else 0 end as integer) as ExisteValeQ, Prestacions.Pre_Descriprest, Nvl(TABQUIROFANO.Verificado,0) as Verificado,
		TabQuiroProto.tqp_estado , TABQUIROFANO.id
		FROM TABQUIROFANO
		left join Registracio on Registracio.Reg_NroRegistrac = TABQUIROFANO.Nroregistrac
		left join Entidades on Entidades.Ent_CodEnt = TABQUIROFANO.CodEnt
		left join Servicios on Servicios.SER_codserv = TABQUIROFANO.Servicio
		left join tabEstados on tabEstados.id = TabQuirofano.estado
		left join VALESQUIROF on VALESQUIROF.VALESQUIROF = TABQUIROFANO.NroProtocolo 
		left join Prestacions on Prestacions.Pre_CodPrest = TABQUIROFANO.OperCod
		INNER JOIN TabQuiroProto ON TabQuiroProto.TQP_Quirofano = TABQUIROFANO.Id and TQP_FecPasiva = '1900-01-01' and TabQuiroProto.TQP_Estado = 3
		INNER JOIN TabQuiroSala ON TabQuiroSala.ID = TABQUIROFANO.NroQuirofano
		left JOIN TabProtQuir ON TabProtQuir.Quirofano = TABQUIROFANO.Id
		left join Pacientes on Pacientes.pac_codadmision = TabProtQuir.Codadmision
		WHERE TabQuiroSala.TQS_Prog = 0 and fechaQuirof = current_date and tqc_nrovaleq = 0
		Group by NroProtocolo
		Order by NroProtocolo

	Endtext 

	If !Prg_EjecutoSql(lcSql,"mwkProtocolos4")
		Return .f.
	Endif  	  
	
	Select *, Nvl(Pac_FechaAdmision, Ctod("")) as Pac_FechaAdmision1, Nvl(Pac_FechaAlta, Ctod("")) as Pac_FechaAlta1, ;
		Ctot('') as FechaHoraDescarga, Ctot('') as FechaHoraCarga, Ctot('') as FechaHoraConforme, ;
		iif(tqp_estado = 3,'FINALIZADO','PENDIENTE') as Estado1 ;
		From mwkProtocolos1 ;
	Union ;
	Select *, Nvl(Pac_FechaAdmision, Ctod("")) as Pac_FechaAdmision1, Nvl(Pac_FechaAlta, Ctod("")) as Pac_FechaAlta1, ;
		Ctot('') as FechaHoraDescarga, Ctot('') as FechaHoraCarga, Ctot('') as FechaHoraConforme, ;
		iif(tqp_estado = 3,'FINALIZADO','PENDIENTE') as Estado1 ;
		From mwkProtocolos2 ;
	Union ;
	Select *, Nvl(Pac_FechaAdmision, Ctod("")) as Pac_FechaAdmision1, Nvl(Pac_FechaAlta, Ctod("")) as Pac_FechaAlta1, ;
		Ctot('') as FechaHoraDescarga, Ctot('') as FechaHoraCarga, Ctot('') as FechaHoraConforme, ;
		iif(tqp_estado = 3,'FINALIZADO','PENDIENTE') as Estado1 ;
		From mwkProtocolos3 ;
	Union ;
	Select *, Nvl(Pac_FechaAdmision, Ctod("")) as Pac_FechaAdmision1, Nvl(Pac_FechaAlta, Ctod("")) as Pac_FechaAlta1, ;
		Ctot('') as FechaHoraDescarga, Ctot('') as FechaHoraCarga, Ctot('') as FechaHoraConforme, ;
		iif(tqp_estado = 3,'FINALIZADO','PENDIENTE') as Estado1 ;
		From mwkProtocolos4 ;
	ORDER BY fechaquirof, NroProtocolo; 
	Into cursor mwkProtocolos Readwrite 
	
*!*		Into Table (Addbs(Getenv("TEMP")) + "mwkProtocolos") 
	

*!*		Into cursor mwkProtocolos Readwrite 
	
	Select mwkProtocolos 
	Scan All For psele = 0
	
		TEXT To lcsql Textmerge Noshow Pretext 7
			Select * From TabBolsasProgramacion Where TabBolsasProgramacion.IdTabQuirofano = ?mwkProtocolos.IdQuiro
		ENDTEXT

		If !Prg_EjecutoSql(lcSql,"mwkAuxBolsa002")
			Return .F.
		Endif
		
		Select FechaHoraDescarga ;
			From mwkAuxBolsa002 ;
			Where Ttoc(nvl(FechaHoraDescarga,Ctot(''))) = Ttoc(Ctot('')) Or ;
				  Ttoc(nvl(FechaHoraDescarga,Ctot(''))) = '01/01/1900 00:00:00' ;
			Into Cursor mwkfcontrol

*!*				FechaHoraDescarga, FechaHoraCarga, FechaHoraConforme
		
		If Reccount("mwkfcontrol")=0 && estan todos completos
			Select Max(Nvl(FechaHoraCarga,Ctot(''))) as f1,  Max(Nvl(FechaHoraConforme,Ctot(''))) as f2,  Max(Nvl(FechaHoraDescarga,Ctot(''))) as f3  From mwkAuxBolsa002 Into Cursor mwkf1
		Else
			Select Max(Nvl(FechaHoraCarga,Ctot(''))) as f1,  Max(Nvl(FechaHoraConforme,Ctot(''))) as f2,  Ctot('') as f3  From mwkAuxBolsa002 Into Cursor mwkf1
		Endif 
		
		Select mwkProtocolos 
		Replace FechaHoraDescarga With mwkf1.f3, FechaHoraCarga With mwkf1.f1, FechaHoraConforme With mwkf1.f2

		Use In Select("mwkf1")
		Use In Select("mwkfcontrol")	
	
		If Nvl(mwkProtocolos.verificado,.f.)
	
			If ttoc(mwkProtocolos.FechaHoraCarga) = Ttoc(Ctot(''))
				Select mwkProtocolos
				Replace Psele With 1  
			Else
				If !(ttoc(mwkProtocolos.FechaHoraDescarga) = Ttoc(Ctot('')) )
					Select mwkProtocolos
					Replace Psele With 1  
				Endif 
			Endif 
		Endif 
				
	
		Select mwkProtocolos 
	Endscan 	
	
	
*	Index on Dtos(fechaquirof) + Transform(NroProtocolo) Tag c1

	Use In Select("mwkProtocolos1")
	Use In Select("mwkProtocolos2")	
	Use In Select("mwkProtocolos3")	
	Use In Select("mwkProtocolos4")	
	
	
	If !prg_quirtosap2()
		Return .F.
	Endif


Use In Select("mwkProtocolos")
