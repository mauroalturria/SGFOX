Parameters lcTipo

Local lOk
Local nCuenta
Local lReturn

*!*	Clear
*!*	Set Step On
*!*	mcon1 = Sqlconnect("172.16.1.209")
*!*	MyIp = '172.16.1.9'
*!*	lcTipo = 'TODOS'
*!*	lcTipo = 'HO'

lOk = .T.
nCuenta = 0
lReturn = .F.

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

lcSql = "select Top 1 * from Tabturnum where tun_ipsvr = ?lcIpSvr AND TUN_FECPASIVA = '1900-01-01' "
If !prg_EjecutoSql(lcSql,"MwkIpLst")
	Return
Endif

Private mcGrupo
mcGrupo = Alltrim(MwkIpLst.tun_grupo)

lbcmdhdo = .F.


If !File("c:\Qepd1a1\Exe\hdo.txt")

	lcSql = "SELECT a.*, b.cmdnombre, c.NOMFRM  "+;
		"FROM TabPermisosFrmCmd a "+;
		"INNER JOIN TabCmdFrm b on b.ID = a.codcmd and b.cmdnombre = 'CMDHDO' "+;
		"INNER JOIN TabFrm c on c.ID = a.codfrm and c.NOMFRM = 'FRMTURNO05' "+;
		"where a.codusuario = ?mwkUsuario.ID "

	If !prg_EjecutoSql(lcSql,"MwkPERM")
		Return
	Endif

	If Used("MwkPERM")
		If Reccount("MwkPERM")>0
			lbcmdhdo = .T.
		Endif
	Endif

	Use In Select("MwkPERM")

Else
	lbcmdhdo = .T.
Endif


*set step on

*lcIpSvr = '172.16.1.256'
ldFecNull = Ctod("01/01/1900")
ltfechoy  = sp_busco_fecha_serv('DT')
lnIdRegLock = 1

*!* ---------------------------------------------------------------------------
lbCancela = .F.

Wait Window "Intentando llamar desde la IP : " +MyIp+ ". Aguarde ... " Nowait

Do While .T.

	nCuenta = nCuenta + 1

	If !Buscar_TLog(lcTipo)
*return .f.
		lOk = .F.
		Exit
	Endif

	If Reccount("mwkTurallamar") = 0
		Messagebox("NO HAY MAS NUMEROS",48,"VALIDACION")
		Return
		lOk = .F.
		Exit
	Endif

*!* ---------------------------------------------------------------------------
*!*	BLOQUEO REGISTRO
*!* ---------------------------------------------------------------------------

	lcSql = "Update TabTurNum Set TUN_IpBloqueo = ?MyIp " + ;
		"Where TUN_IpBloqueo is Null And Id = ?lnIdRegLock "

	If !prg_EjecutoSql(lcSql,"",)
*return .f.
		lOk = .F.
		Exit
	Endif

	lcSql = "Select TUN_IpBloqueo from TabTurNum Where TUN_IpBloqueo = ?MyIp  And Id = ?lnIdRegLock "
	If !prg_EjecutoSql(lcSql,"mwkTurNumBloq")
*return .f.
		lOk = .F.
		Exit
	Endif

	If Reccount("mwkTurNumBloq")>0
		Select mwkTurNumBloq
		Go Top
		Exit
	Endif


*   Excedió la cantidad de re intentos.
	If nCuenta > 10

		lcSql = "Select TUN_IpBloqueo from TabTurNum Where Id = ?lnIdRegLock "
		If !prg_EjecutoSql(lcSql,"mwkTurNumBloq2")
*return .f.
			lOk = .F.
			Exit
		Endif

		Select mwkTurNumBloq2
		Go Top

		Messagebox("La siguiente IP tiene bloqueado el llamador : " + Chr(10) + mwkTurNumBloq2.TUN_IpBloqueo + Chr(10) + "Intente mas tarde o Avise a Sistemas.",16,"Llamador" )

		Use In Select("mwkTurNumBloq2")

		lOk = .F.
		Exit

	Endif


Enddo


lbNoHay = .F.

If lOk

	If !Buscar_TLog(lcTipo)
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

	lcSql = "Update tabTurnerolog Set TNL_IdLlama = ?lnIdLlama, TNL_CodigoVax = ?lnCodigoVax Where Id = "+Transform(mwkTurallamar.Id)
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

Endif

* Return .T.
Return lOk



*************************************************************************************************************************
Function Buscar_TLog
Parameters lcTipo
*************************************************************************************************************************

Do While .T.

	If Vartype(lcTipo) <> "L" And lcTipo <> 'TODOS'

		lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and " + ;
			"Tnl_Tipo = ?lcTipo " + ;
			"Order By TNL_FechaHoraIng"

		If !prg_EjecutoSql(lcSql,"mwkTurallamar")
			Return .F.
		Endif

*!*


*!*			If Reccount("mwkTurallamar") > 0
*!*				Exit
*!*			Endif

		Exit

	Endif
*!* ---------------------------------------------------------------------------
&& PRIORIDAD
*!* ---------------------------------------------------------------------------
	lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and " + ;
		" Trim(Tnl_Tipo) in (select Trim(TUN_LETRA) from TabTurNum where TUN_grupo = ?mcGrupo AND TUN_prioridad = 1 ) " + ;
		" Order By TNL_FechaHoraIng"

	If !prg_EjecutoSql(lcSql,"mwkTurallamar")
		Return .F.
	Endif

*!*	        tnl_tipo = 'P' " + ;

	If Reccount("mwkTurallamar") > 0
		If Int((ltfechoy - mwkTurallamar.TNL_FechaHoraIng) / 60) > 2
			Exit
		Endif
	Endif

*!* ---------------------------------------------------------------------------
&& ADMISIONES 20 MINUTOS DE ESPERA
*!* ---------------------------------------------------------------------------

	lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and " + ;
		" Trim(Tnl_Tipo) in (select Trim(TUN_LETRA) from TabTurNum where TUN_grupo = ?mcGrupo AND TUN_CONFIRMA = 1 ) " + ;
		"Order By TNL_FechaHoraIng"

	If !prg_EjecutoSql(lcSql,"mwkTurallamar")
		Return .F.
	Endif

*!*	        	"tnl_tipo = 'A' " + ;

	If Reccount("mwkTurallamar") > 0
		If Int((ltfechoy - mwkTurallamar.TNL_FechaHoraIng) / 60) > 20
			Exit
		Endif
	Endif

*!* ---------------------------------------------------------------------------
&& GENERAL POR HORA
*!* ---------------------------------------------------------------------------


	If lbcmdhdo
		lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and " + ;
			" trim(Tnl_Tipo) NOT in " + ;
			"(select Trim(TUN_LETRA) from TabTurNum where TUN_grupo = ?mcGrupo AND TUN_INDIVIDUAL = 1 ) " + ;
			"Order By TNL_FechaHoraIng"

	Else
		lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and " + ;
			" trim(Tnl_Tipo) NOT in " + ;
			"(select Trim(TUN_LETRA) from TabTurNum where TUN_grupo = ?mcGrupo AND TUN_INDIVIDUAL = 1 and Trim(TUN_LETRA) != 'HO' ) " + ;
			"Order By TNL_FechaHoraIng"
	Endif

*!*	        lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and " + ;
*!*	        " trim(Tnl_Tipo) NOT in (select Trim(TUN_LETRA) from TabTurNum where TUN_grupo = ?mcGrupo AND TUN_INDIVIDUAL = 1) " + ;
*!*	            "Order By TNL_FechaHoraIng"

	If !prg_EjecutoSql(lcSql,"mwkTurallamar")
		Return .F.
	Endif


*!*	        tnl_tipo <> 'F' " + ;

	If Reccount("mwkTurallamar") > 0
		Exit
	Endif

	Exit
Enddo
