*!*	Clear
*!*	mcon1 = Sqlconnect("172.16.1.225")
*!*	MyIp = '172.16.1.9'



lcSql = "select * from TabLlamaIp where LLA_Ippuesto = ?MyIp "
If !prg_EjecutoSql(lcSql,"MwkIpLla")
	Return 
Endif 

If Reccount("MwkIpLla") = 0
	Messagebox("NO ESTA CONFIGURADO EL LLAMADOR",48,"VALIDACION")
	Return .f.
Endif 

Select MwkIpLla
Go Top 
lcIpSvr = MwkIpLla.Lla_ipserver

*set step on

*lcIpSvr = '172.16.1.256'
*!* --------------------------------------------------------------------------- 
lbCancela = .f.
Do While .t.
	
*	Do Form frmCancela With "Buscando Paciente..." To lbCancela

	lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null Order By TNL_FechaHoraIng"
	If !Prg_EjecutoSql(lcSql,"mwkTurallamar") 
		Return .f.
	Endif 	
	If Reccount("mwkTurallamar") = 0
		Messagebox("NO HAY MAS NUMEROS",48,"VALIDACION")
		Return 
	Endif 

	lcSql = "Update TabTurNum Set TUN_IpBloqueo = ?MyIp Where TUN_IpSVR = ?lcIpSvr and TUN_IpBloqueo is Null "
	If !Prg_EjecutoSql(lcSql,"",) 
		Return .f.
	Endif 

	lcSql = "Select TUN_IpBloqueo from TabTurNum Where TUN_IpSVR = ?lcIpSvr and TUN_IpBloqueo = ?MyIp "
	If !Prg_EjecutoSql(lcSql,"mwkTurNumBloq") 
		Return .f.
	Endif 
	
	If Reccount("mwkTurNumBloq")>0
		Select mwkTurNumBloq
		Go top
		Exit
	Endif	
	
	
	
*!*		If lbCancela
*!*			Return .f.
*!*		Endif 

Enddo

*!*	lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null Order By TNL_FechaHoraIng"
*!*	If !Prg_EjecutoSql(lcSql,"mwkTurallamar") 
*!*		Return .f.
*!*	Endif 
	lbNoHay = .f.

	lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null Order By TNL_FechaHoraIng"
	If !Prg_EjecutoSql(lcSql,"mwkTurallamar") 
		Return .f.
	Endif 	
	If Reccount("mwkTurallamar") > 0

		*!* --------------------------------------------------------------------------- 
		ltfechoy  = sp_busco_fecha_serv('DT')
		mFecNull  = Ctod('01/01/1900')
		lcNumeroFin = Alltrim(mwkTurallamar.TNL_Numerador)
		lcTipoTurno = Alltrim(mwkTurallamar.TNL_Tipo)
		lcDocumento = Alltrim(Str(Nvl(mwkTurallamar.TNL_numdocumento,0),16,0))
		*!* --------------------------------------------------------------------------- 

		lcSql = "Select * from tabstpuesto where puesto = ?myIp"

		If !prg_EjecutoSql(lcSql,"mwkPuesto")
			Return 
		Endif 

		lcConsultorio = Alltrim(mwkPuesto.Nroconsultorio)

		lcSql = "Insert into TabLlamador (LLA_ipMaquina, LLA_IpServer, LLA_FechaSol, LLA_consultorio, LLA_espec, " + ;
			"LLA_NroRegistrac, LLA_fechaPant, LLA_NumeroLlamado) values " + ;
			"(?MyIp, ?lcIpSvr , ?ltfechoy, ?lcConsultorio , '', 1, ?mFecNull, ?lcNumeroFin  )"
					
		If !prg_EjecutoSql(lcSql,"")
			Return 
		Endif 

		lcSql = "Select top 1 Id from tabLlamador where LLA_ipMaquina = ?myIp and LLA_FechaSol = ?ltfechoy"
		If !prg_EjecutoSql(lcSql,"mwkIdLlama")
			Return 
		Endif 

		lnIdLlama = mwkIdLlama.Id
		lnCodigoVax = mwkUsuario.codigovax

		lcSql = "Update tabTurnerolog Set TNL_IdLlama = ?lnIdLlama, TNL_CodigoVax = ?lnCodigoVax Where Id = ?mwkTurallamar.Id "
		If !Prg_EjecutoSql(lcSql,"mwkTurallamar") 
			Return .f.
		Endif 

		Use In Select("mwkIdLlama")
		Use In Select("mwkTurallamar")
		Use In Select("mwkPuesto")
		Use In Select("mwkTurNumBloq")
		Use In Select("MwkIpLla")

		lcSql = "Update TabTurNum Set TUN_IpBloqueo = Null Where TUN_IpSVR = ?lcIpSvr and TUN_IpBloqueo = ?MyIp "
		If !Prg_EjecutoSql(lcSql,"",) 
			Return .f.
		Endif 

		Messagebox("DEBE LLAMAR A : " + lcNumeroFin + Chr(13) + ;
			"Tipo de Turno -> " + lcTipoTurno  + Chr(13) + ;
			"Documento -> " + lcDocumento , 64,"AVISO")

	Else 
		lbNoHay = .t.

		lcSql = "Update TabTurNum Set TUN_IpBloqueo = Null Where TUN_IpSVR = ?lcIpSvr and TUN_IpBloqueo = ?MyIp "
		If !Prg_EjecutoSql(lcSql,"",) 
			Return .f.
		Endif 

	Endif 

If lbNoHay
	Messagebox("NO HAY MAS NUMEROS",48,"VALIDACION")
Endif 


