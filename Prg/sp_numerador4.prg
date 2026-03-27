parameters lcTipo
*!*	Clear
*!*	Set Step On
*!*	mcon1 = Sqlconnect("172.16.1.225")
*!*	MyIp = '172.16.1.9'

lcSql = "select * from TabLlamaIp where LLA_Ippuesto = ?MyIp "
if !prg_EjecutoSql(lcSql,"MwkIpLla")
    return
endif

if reccount("MwkIpLla") = 0
    messagebox("NO ESTA CONFIGURADO EL LLAMADOR",48,"VALIDACION")
    return .f.
endif

select MwkIpLla
go top
lcIpSvr = MwkIpLla.Lla_ipserver

*set step on

*lcIpSvr = '172.16.1.256'
ldFecNull = ctod("01/01/1900")
ltfechoy  = sp_busco_fecha_serv('DT')
lnIdRegLock = 1

*!* ---------------------------------------------------------------------------
lbCancela = .f.

do while .t.

    if !Buscar_TLog(lcTipo)
        return .f.
    endif

    if reccount("mwkTurallamar") = 0
        messagebox("NO HAY MAS NUMEROS",48,"VALIDACION")
        return
    endif

*!* ---------------------------------------------------------------------------
*!*	BLOQUEO REGISTRO
*!* ---------------------------------------------------------------------------

    lcSql = "Update TabTurNum Set TUN_IpBloqueo = ?MyIp " + ;
        "Where TUN_IpBloqueo is Null And Id = ?lnIdRegLock "

    if !prg_EjecutoSql(lcSql,"",)
        return .f.
    endif

    lcSql = "Select TUN_IpBloqueo from TabTurNum Where TUN_IpBloqueo = ?MyIp  And Id = ?lnIdRegLock "
    if !prg_EjecutoSql(lcSql,"mwkTurNumBloq")
        return .f.
    endif

    if reccount("mwkTurNumBloq")>0
        select mwkTurNumBloq
        go top
        exit
    endif

enddo

lbNoHay = .f.

if !Buscar_TLog(lcTipo)
    return .f.
endif

if reccount("mwkTurallamar") = 0
    lcSql = "Update TabTurNum Set TUN_IpBloqueo = Null Where TUN_IpBloqueo = ?MyIp  And Id = ?lnIdRegLock "
    if !prg_EjecutoSql(lcSql,"",)
        return .f.
    endif

    messagebox("NO HAY MAS NUMEROS",48,"VALIDACION")
    return .t.
endif

select mwkTurallamar
go top

*!* ---------------------------------------------------------------------------
ltfechoy    = sp_busco_fecha_serv('DT')
mFecNull    = ctod('01/01/1900')
lcLetra     = alltrim(mwkTurallamar.TNL_Tipo)
lcNumero    = alltrim(mwkTurallamar.TNL_Numerador)
lcNumeroFin = lcLetra + "-" + lcNumero
lcTipoTurno = alltrim(mwkTurallamar.tnl_tipo)
lcDocumento = alltrim(str(nvl(mwkTurallamar.TNL_numdocumento,0),16,0))
*!* ---------------------------------------------------------------------------

lcSql = "Select * from tabstpuesto where puesto = ?myIp"

if !prg_EjecutoSql(lcSql,"mwkPuesto")
    return
endif

lcConsultorio = alltrim(mwkPuesto.Nroconsultorio)

lcSql = "Insert into TabLlamador (LLA_ipMaquina, LLA_IpServer, LLA_FechaSol, LLA_consultorio, LLA_espec, " + ;
    "LLA_NroRegistrac, LLA_fechaPant, LLA_NumeroLlamado) values " + ;
    "(?MyIp, ?lcIpSvr , ?ltfechoy, ?lcConsultorio , '', 1, ?mFecNull, ?lcNumeroFin  )"

if !prg_EjecutoSql(lcSql,"")
    return
endif

lcSql = "Select top 1 Id from tabLlamador where LLA_ipMaquina = ?myIp and LLA_FechaSol = ?ltfechoy"
if !prg_EjecutoSql(lcSql,"mwkIdLlama")
    return
endif

lnIdLlama = mwkIdLlama.id
lnCodigoVax = mwkUsuario.codigovax

lcSql = "Update tabTurnerolog Set TNL_IdLlama = ?lnIdLlama, TNL_CodigoVax = ?lnCodigoVax Where Id = ?mwkTurallamar.Id "
if !prg_EjecutoSql(lcSql,"mwkTurallamar")
    return .f.
endif

use in select("mwkIdLlama")
use in select("mwkTurallamar")
use in select("mwkPuesto")
use in select("mwkTurNumBloq")
use in select("MwkIpLla")

lcSql = "Update TabTurNum Set TUN_IpBloqueo = Null Where TUN_IpBloqueo = ?MyIp  And Id = ?lnIdRegLock "
if !prg_EjecutoSql(lcSql,"",)
    return .f.
endif

messagebox("DEBE LLAMAR A : " + lcNumero + chr(13) + ;
    "Tipo de Turno -> " + lcTipoTurno  + chr(13) + ;
    "Documento -> " + lcDocumento , 64,"AVISO")

return .t.



*************************************************************************************************************************
function Buscar_TLog
    parameters lcTipo
*************************************************************************************************************************

    do while .t.

        if vartype(lcTipo) <> "L" and lcTipo <> 'TODOS'

            lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and Tnl_Tipo = ?lcTipo " + ;
                "Order By TNL_FechaHoraIng"

            if !prg_EjecutoSql(lcSql,"mwkTurallamar")
                return .f.
            endif

*!*			If Reccount("mwkTurallamar") > 0
*!*				Exit
*!*			Endif

            exit

        endif
*!* ---------------------------------------------------------------------------
&& PRIORIDAD
*!* ---------------------------------------------------------------------------
        lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and tnl_tipo = 'P' " + ;
            " Order By TNL_FechaHoraIng"

        if !prg_EjecutoSql(lcSql,"mwkTurallamar")
            return .f.
        endif

        if reccount("mwkTurallamar") > 0
            if int((ltfechoy - mwkTurallamar.TNL_FechaHoraIng) / 60) > 2
                exit
            endif
        endif

*!* ---------------------------------------------------------------------------
&& ADMISIONES 20 MINUTOS DE ESPERA
*!* ---------------------------------------------------------------------------

        lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and tnl_tipo = 'A' " + ;
            "Order By TNL_FechaHoraIng"
        if !prg_EjecutoSql(lcSql,"mwkTurallamar")
            return .f.
        endif

        if reccount("mwkTurallamar") > 0
            if int((ltfechoy - mwkTurallamar.TNL_FechaHoraIng) / 60) > 20
                exit
            endif
        endif

*!* ---------------------------------------------------------------------------
&& GENERAL POR HORA
*!* ---------------------------------------------------------------------------

        lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer = ?lcIpSvr and TNL_IdLlama is null and tnl_tipo <> 'F' " + ;
            "Order By TNL_FechaHoraIng"
        if !prg_EjecutoSql(lcSql,"mwkTurallamar")
            return .f.
        endif

        if reccount("mwkTurallamar") > 0
            exit
        endif

        exit
    enddo
