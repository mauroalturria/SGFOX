Parameters tnOpcion, tnCursor, tcWhere

If Vartype(tcWhere) # "C"
	tcWhere = ""
Endif

ldNull  = Ctod("01/01/1900")

*			"TQP_ATBSN, TQP_PROFSN, TQP_TRANSN, TQP_IMGCARV " +
Use In Select(tnCursor)
Do Case
Case tnOpcion = 1
	lcSql = "SELECT * FROM TabQuiroProto " + tcWhere

Case tnOpcion = 2

	lcSql = "SELECT TabEstados.Descrip, Tabpreregmed.matriculas as MatriCirue, " + ;
		"(Case when Nvl(TQP_CodMed ,0) <= 9999 then Cast(Prestadores.matriculas as char(20)) else Cast(TabMedExterno.matricula as Char(20)) end ) as MatriCiru," + ;
		"Tabpreregmed.Nombre as NombreCirue,Cast({fn concat(trim(Nvl(TabMedExterno.nombre,'')), Trim(Nvl(Prestadores.Nombre,'')))} as char(60)) as NombreCiru, " + ;
		"TabQuiroProto.*, " + ;
		"nvl(aCie.Descrip,'') as DiagPreO, nvl(aCie1.Descrip,'') as DiagProO, " + ;
		"nvl(TQP_Herida,0) as TQP_Herida1, " + ;
		"nvl(Insu.descrip,'') as TQP_ATBProf1, " + ;
		"nvl(TQP_ATBPDocis,0) as TQP_ATBPDocis1, " + ;
		"nvl(TQP_ProfTrom,0) as TQP_ProfTrom1, " + ;
		"nvl(Prest1.PRE_descriprest ,'') as TQP_TransHemo1, " + ;
		"nvl(TQP_TransHDocis,0) as TQP_TransHDocis1, " + ;
		"nvl(TQP_Asa,0) as TQP_Asa1, " + ;
		"nvl(TQP_AntiSepsia,0) as TQP_Ase1,TQP_CodMed, " + ;
		"nvl(TQP_lado,0) as TQP_lado, nvl(TQP_torrelap,0) as TQP_torrelap, " +;
		"nvl(u1.Nomape,'') as NomApeVax, Nvl(u2.Nomape,'') as NomApeNoCir, " + ;
		"cast(case when Nvl(TQP_FecAlta,'')='' then '' else TQP_FecAlta end as char(10)) as TQP_FecAlta_1, "+ ;
		"cast(case when Nvl(TQP_FecNoCir,'')='' then '' else TQP_FecNoCir end as char(10)) as TQP_FecNoCir_1 "+ ;
	 	" ,nvl(TQP_chklistqx,0) as TQP_chklistqx FROM TabQuiroProto " + ;
		"Inner join TabQuirofano on TQP_Quirofano = TabQuirofano.Id " + ;
		"Inner join TabEstados on TabEstados.SubEstado = TQP_Tipo and TabEstados.Propietario = 22 and TabEstados.tipo = 4 and TabEstados.Estado = 0 " + ;
		"Left join TabCie10 as aCie on TabQuiroProto.TQP_DiagPreO = aCie.Id " + ;
		"Left join TabCie10 as aCie1 on TabQuiroProto.TQP_DiagPostO = aCie1.Id " + ;
		"Left join Prestacions as Prest1 on TabQuiroProto.TQP_TransHemo = Prest1.Pre_CodPrest " + ;
		"Left join TabEstados as Insu  on Insu.SubEstado = TQP_ATBProf and Insu.Propietario = 22 and Insu.tipo = 11 " + ;
		"left join Prestadores on Prestadores.Id = TQP_CodMed " + ;
		"left join TabMedExterno on TabMedExterno.Id = TQP_CodMed " + ;
		"left join Tabpreregmed on Tabpreregmed.CodMed = TQP_CodMed " + ;
		"left join TabUsuario as u1 on TabQuiroProto.TQP_CodigoVax = u1.CodigoVax " + ;
		"left join TabUsuario as u2 on TabQuiroProto.TQP_VaxNoCir = u2.CodigoVax " + ;
		"Where TQP_FecPasiva = ?ldNull " + tcWhere

Case tnOpcion = 3
	lcSql = "SELECT top 1 Id FROM TabQuiroProto Where TQP_FecPasiva = ?ldNull " + tcWhere


Otherwise


Endcase

*			"Left join Insumos as Insu on TabQuiroProto.TQP_ATBProf = Insu.INSUMOS " + ;

If !Prg_EjecutoSql(lcSql,tnCursor,.F.)
	Return .F.
Endif
