parameters lcIpSVR, lcTipo


*!*	lcIpSVR = "'172.16.1.9'"
*!*	lcTipo = 'SECTOR'
*!*	lcTipo = 'CORDOBA'
*!*	lcTipo = 'I'

Local lbResu
lbResu = .f.

Private ldFecNull

ldFecNull = ctod("01/01/1900")
ltfechoy  = sp_busco_fecha_serv('DT')
lnIdRegLock = 1
lbCancela = .f.

Private lcUni
lcUni = ''

lcIpTra = IPs_Grupo(lcTipo)

DO CASE
	CASE lcTipo = 'SECTOR' Or Len(lcTipo) = 1
		lcIpTra = lcIpSVR
		lcUni = Letras_Prioridad(lcIpSVR)

	Otherwise
*		lcIpTra = IPs_Grupo(lcTipo)
		lcUni = Letras_Prioridad(lcIpTra)
		&& GRUPOS

ENDCASE

do while .t.

	*!*	REVISO SI HAY INFORMACION
    if !Buscar_TLog(lcTipo, lcUni, lcIpTra )
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

if !Buscar_TLog(lcTipo, lcUni, lcIpTra)
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
lcIpLlaSVR = mwkTurallamar.tnl_ipserver
*!* ---------------------------------------------------------------------------

lcSql = "Select * from tabstpuesto where puesto = ?myIp"

if !prg_EjecutoSql(lcSql,"mwkPuesto")
    return
endif

lcConsultorio = alltrim(mwkPuesto.Nroconsultorio)


lcSql = "Insert into TabLlamador (LLA_ipMaquina, LLA_IpServer, LLA_FechaSol, LLA_consultorio, LLA_espec, " + ;
	    "LLA_NroRegistrac, LLA_fechaPant, LLA_NumeroLlamado) values " + ;
	    "(?MyIp, ?lcIpLlaSVR , ?ltfechoy, ?lcConsultorio , '', 1, ?mFecNull, ?lcNumeroFin  )"

	if !prg_EjecutoSql(lcSql,"")
	    return
	Endif
	



lcSql = "Select top 1 Id from tabLlamador where LLA_ipMaquina = ?myIp and LLA_FechaSol = ?ltfechoy"
if !prg_EjecutoSql(lcSql,"mwkIdLlama")
    return
endif

lnIdLlama = mwkIdLlama.id
lnCodigoVax = mwkUsuario.codigovax

lcSql = "Update tabTurnerolog Set TNL_IdLlama = ?lnIdLlama, TNL_CodigoVax = ?lnCodigoVax Where Id = "+TRANSFORM(mwkTurallamar.Id)
if !prg_EjecutoSql(lcSql,"mwkTurallamar")
    return .f.
Endif

Select mwkllaGrupo
Scan All For Alltrim(mwkllaGrupo.TUN_ipsvr) <> lcIpLlaSVR 

	lcSql = "Insert into TabLlamador (LLA_ipMaquina, LLA_IpServer, LLA_FechaSol, LLA_consultorio, LLA_espec, " + ;
	    "LLA_NroRegistrac, LLA_fechaPant, LLA_NumeroLlamado) values " + ;
	    "(?MyIp, ?mwkllaGrupo.TUN_ipsvr , ?ltfechoy, ?lcConsultorio , '', 1, ?mFecNull, ?lcNumeroFin  )"

	if !prg_EjecutoSql(lcSql,"")
	    return
	endif

	Select mwkllaGrupo
Endscan 

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
    "Tipo de Turno -> " + lcTipoTurno  , 64,"AVISO")


*!*	messagebox("DEBE LLAMAR A : " + lcNumero + chr(13) + ;
*!*	    "Tipo de Turno -> " + lcTipoTurno  + chr(13) + ;
*!*	    "Documento -> " + lcDocumento , 64,"AVISO")

return .t.



*************************************************************************************************************************
function Buscar_TLog
parameters lcTipo, lcUni, lcIpSvr
*************************************************************************************************************************

    do while .t.
	
	        if vartype(lcTipo) <> "L" and lcTipo <> 'TODOS' and lcTipo <> 'SECTOR' and lcTipo <> 'CORDOBA'


	            lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer in ( "  + lcIpSvr + ") and TNL_IdLlama is null and Tnl_Tipo = ?lcTipo " + ;
	                "Order By TNL_FechaHoraIng"

	            if !prg_EjecutoSql(lcSql,"mwkTurallamar")
	                return .f.
	            endif

	*!*			If Reccount("mwkTurallamar") > 0
	*!*				Exit
	*!*			Endif

	            exit

		   Endif      


*!* ---------------------------------------------------------------------------
&& PRIORIDAD
*!* ---------------------------------------------------------------------------

	If !Empty(lcUni)
        lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer in ( "  + lcIpSvr + ")  and TNL_IdLlama is null and tnl_tipo in ( " + lcUni + " )" + ;
            " Order By TNL_FechaHoraIng"

        if !prg_EjecutoSql(lcSql,"mwkTurallamar")
            return .f.
        endif

        if reccount("mwkTurallamar") > 0
            if int((ltfechoy - mwkTurallamar.TNL_FechaHoraIng) / 60) > 2
                exit
            endif
        endif
	Endif 
*!* ---------------------------------------------------------------------------
&& GENERAL POR HORA
*!* ---------------------------------------------------------------------------

        lcSql = "select Top 1 * from tabTurnerolog Where TNL_IpServer in ( "  + lcIpSvr + ")  and TNL_IdLlama is null " + ;
            "Order By TNL_FechaHoraIng"
        if !prg_EjecutoSql(lcSql,"mwkTurallamar")
            return .f.
        endif

        if reccount("mwkTurallamar") > 0
            exit
        endif

        exit
    enddo


*!*------------------------------------------------------------------------------------------------------------------------------
*!*	BUSCANDO LETRAS CON PRIORIDAD PARA EL IPSVR
*!*------------------------------------------------------------------------------------------------------------------------------
Function Letras_Prioridad
lParameters lcIpSvr 
*!*------------------------------------------------------------------------------------------------------------------------------
Local lcUni
lcUni = ''

lcSql = "Select * from tabTurNum where tun_ipsvr in ( " + lcIpSvr + " ) and Tun_Tipo = 1 and tun_fecpasiva = ?ldFecNull "

if !prg_EjecutoSql(lcSql,"mwkPriori")
    return
Endif

Select mwkPriori
Scan All
	lcUni = lcUni + Iif(Empty(lcUni), "'" +  Alltrim(mwkPriori.Tun_Letra) + "'" , ", '" + Alltrim(mwkPriori.Tun_Letra) + "'")
	Select mwkPriori
Endscan 

Return (lcUni)

*!*------------------------------------------------------------------------------------------------------------------------------
Function IPs_Grupo
parameters tcGrupo
*!*------------------------------------------------------------------------------------------------------------------------------

Local lcResu

lcResu = ""
ldfecNull = Ctod("01/01/1900")

lcsql = "Select DISTINCT TUN_ipsvr From tabturnum Where tun_grupo = ?tcGrupo And TUN_FecPasiva = ?ldfecNull "


If !Prg_EjecutoSql(lcSql,"mwkllaGrupo")
	Return .f.
Endif  

Select mwkllaGrupo
Scan All
	lcResu  = lcResu + Iif(Empty(lcResu), "'" + Alltrim(mwkllaGrupo.TUN_ipsvr) + "'" , ", '" + Alltrim(mwkllaGrupo.TUN_ipsvr) + "'")
	Select mwkllaGrupo
Endscan 

Return (lcResu)
		
*!*------------------------------------------------------------------------------------------------------------------------------
*!*------------------------------------------------------------------------------------------------------------------------------
*!*------------------------------------------------------------------------------------------------------------------------------
*!*------------------------------------------------------------------------------------------------------------------------------
*!*------------------------------------------------------------------------------------------------------------------------------
