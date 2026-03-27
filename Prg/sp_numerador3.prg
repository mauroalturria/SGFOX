*!*	Clear
*!*	Set Step On
*!*	mcon1 = Sqlconnect("172.16.1.225")
*!*	MyIp = '172.16.1.9'

lcSql = "select * from TabLlamaIp where LLA_Ippuesto = ?MyIp "
If !prg_EjecutoSql(lcSql,"MwkIpLla")
	Return
Endif

If Reccount("MwkIpLla") = 0
	Messagebox("NO ESTA CONFIGURADO EL LLAMADOR",48,"VALIDACION")
	Return .F.
Endif

Select MwkIpLla
Go Top
lcIpSvr = MwkIpLla.Lla_ipserver

*set step on

*lcIpSvr = '172.16.1.256'
ldFecNull = Ctod("01/01/1900")
ltfechoy  = sp_busco_fecha_serv('DT')
lnIdRegLock = 1

*!* ---------------------------------------------------------------------------
lbCancela = .F.

Do While .T.

	If !Buscar_TLog()
		Return .F.
	Endif

	If Reccount("mwkTurallamar") = 0
		Messagebox("NO HAY MAS NUMEROS",48,"VALIDACION")
		Return
	Endif

	*!* ---------------------------------------------------------------------------
	*!*	BLOQUEO REGISTRO	
	*!* --------------------------------------------------------------------------- 		

	lcSql = "Update TabTurNum Set TUN_IpBloqueo = ?MyIp " + ;
		"Where TUN_IpBloqueo is Null And Id = ?lnIdRegLock "

	If !prg_EjecutoSql(lcSql,"",)
		Return .F.
	Endif

	lcSql = "Select TUN_IpBloqueo from TabTurNum Where TUN_IpBloqueo = ?MyIp  And Id = ?lnIdRegLock "
	If !prg_EjecutoSql(lcSql,"mwkTurNumBloq")
		Return .F.
	Endif

	If Reccount("mwkTurNumBloq")>0
		Select mwkTurNumBloq
		Go Top
		Exit
	Endif

Enddo

lbNoHay = .F.

If !Buscar_TLog()
	Return .F.
Endif

If Reccount("mwkTurallamar") = 0
	lcSql = "Update TabTurNum Set TUN_IpBloqueo = Null Where TUN_IpBloqueo = ?MyIp  And Id = ?lnIdRegLock "
	If !prg_EjecutoSql(lcSql,"",)
		Return .F.
	Endif

	Messagebox("NO HAY MAS NUMEROS",48,"VALIDACION")
	Return .T.
Endif

Select mwkTurallamar
Go Top

*!* ---------------------------------------------------------------------------
ltfechoy    = sp_busco_fecha_serv('DT')
mFecNull    = Ctod('01/01/1900')
lcLetra     = Alltrim(mwkTurallamar.TNL_Tipo)
lcNumero    = Alltrim(mwkTurallamar.TNL_Numerador)
lcNumeroFin = lcLetra + "-" + lcNumero
lcTipoTurno = Alltrim(mwkTurallamar.tnl_tipo)
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
If !prg_EjecutoSql(lcSql,"mwkTurallamar")
	Return .F.
Endif

Use In Select("mwkIdLlama")
Use In Select("mwkTurallamar")
Use In Select("mwkPuesto")
Use In Select("mwkTurNumBloq")
Use In Select("MwkIpLla")

lcSql = "Update TabTurNum Set TUN_IpBloqueo = Null Where TUN_IpBloqueo = ?MyIp  And Id = ?lnIdRegLock "
If !prg_EjecutoSql(lcSql,"",)
	Return .F.
Endif

Messagebox("DEBE LLAMAR A : " + lcNumero + Chr(13) + ;
	"Tipo de Turno -> " + lcTipoTurno  + Chr(13) + ;
	"Documento -> " + lcDocumento , 64,"AVISO")

Return .t.



*************************************************************************************************************************
Function Buscar_TLog
*************************************************************************************************************************

Do While .T.
*!* ---------------------------------------------------------------------------
&& PRIORIDAD
*!* ---------------------------------------------------------------------------
	lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and tnl_tipo = 'P' " + ;
		" Order By TNL_FechaHoraIng"

	If !prg_EjecutoSql(lcSql,"mwkTurallamar")
		Return .F.
	Endif

	If Reccount("mwkTurallamar") > 0
		If Int((ltfechoy - mwkTurallamar.TNL_FechaHoraIng) / 60) > 2
			Exit
		Endif
	Endif

*!* ---------------------------------------------------------------------------
&& ADMISIONES 20 MINUTOS DE ESPERA
*!* ---------------------------------------------------------------------------

	lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and tnl_tipo = 'A' " + ;
		"Order By TNL_FechaHoraIng"
	If !prg_EjecutoSql(lcSql,"mwkTurallamar")
		Return .F.
	Endif

	If Reccount("mwkTurallamar") > 0
		If Int((ltfechoy - mwkTurallamar.TNL_FechaHoraIng) / 60) > 20
			Exit
		Endif
	Endif

*!* ---------------------------------------------------------------------------
&& GENERAL POR HORA
*!* ---------------------------------------------------------------------------

	lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null " + ;
		"Order By TNL_FechaHoraIng"
	If !prg_EjecutoSql(lcSql,"mwkTurallamar")
		Return .F.
	Endif

	If Reccount("mwkTurallamar") > 0
		Exit
	Endif

	Exit
Enddo
