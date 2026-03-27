*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
mret = SQLExec(mcon1,"SELECT id, nombre,codesp,codespe,cast(matriculas as integer) as matricula  FROM prestadores  " + ;
    " union  SELECT ID , nombre,'    ' as codesp,gerenciadora  as codespe,matricula  FROM TabMedExterno " + ;
    " where gerenciadora = 0 " +;
    "ORDER BY nombre", "mwkMedicogua" )

*!*	select * from gua8000 where protocolo in ;
*!*		(select protocolo from gua8000 where tipoest = 0 and sector = '1' ) ;
*!*		and tipoest>0 into cursor abiertos
select * from gua8000 where protocolo in ;
    (select protocolo from gua8000 where tipoest > 0 ) ;
    and tipoest=0  into cursor cerrados
select gua8000.*,mwkMedicogua.nombre as profesional,space(40) as medcierre,datetime() as fechacie;
    from gua8000 left join  mwkMedicogua on mwkMedicogua.id = codmed ;
    into cursor abiertos

select cerrados
scan
    mproto = protocolo
    mfechaate = fechahoraate
    mcodmed = codmed
    mcodcie = codmedcie9
    mcie9 = codcie9
    mestado = codestado
    select * from gua8000 where mproto = protocolo and tipoest>0 into cursor ver

    update gua8000 set codmedcie9 = mcodcie,codcie9 = mcie9,codestado = mestado ;
        where protocolo = mproto and tipoest>0 and codmed>1

    update gua8000 set codmedcie9 = mcodcie,codcie9 = mcie9,codestado = mestado ;
        ,fechahoraate = mfechaate ,codmed = mcodmed ;
        where protocolo = mproto and tipoest>0 and codmed=1

    select cerrados
endscan
select abiertos
use dbf('abiertos') in 0 again alias prot_open
select prot_open
scan
    mproto = protocolo
    select * from gua8000 where mproto = protocolo and tipoest>0 into cursor ver
    mret = sqlexec(mcon1, "SELECT * FROM TabGuaEvol "+;
        "left join TabGuaEvolmed on TabGuaEvol.EG_protocolo = TabGuaEvolmed.EGM_proto " + ;
        " where EG_protocolo = ?mproto  "+;
        "", "mwkEvolReg01")


    select mwkEvolReg01.*,nombre from mwkEvolReg01,mwkMedicogua ;
        where nvl(EGM_codmed,1) = mwkMedicogua.id ;
        order by EGM_fechah into cursor mwkEvolReg

    use in mwkEvolReg01

    select * from mwkEvolReg where alltrim(EGM_evol)#'No Responde' into cursor mwkEvolProt
    select mwkEvolProt
    go bottom
    do while !bof()
        if left(egm_evol,43) # 'Evolución Posterior al CIERRE del Protocolo'
            exit
        endif
        skip -1
    enddo
    select prot_open
    replace medcierre  with mwkEvolProt.nombre,fechacie with mwkEvolProt.EGM_fechaH
endscan
set step on

select proto
scan
    mproto = protocolo
    mret = sqlexec(mcon1, "SELECT * FROM TabGuaEvol "+;
        "left join TabGuaEvolmed on TabGuaEvol.EG_protocolo = TabGuaEvolmed.EGM_proto " + ;
        " where EG_protocolo = ?mproto  "+;
        "", "mwkEvolReg01")

    select mwkEvolReg01.* from mwkEvolReg01;
        order by EGM_fechah into cursor mwkEvolReg

    use in mwkEvolReg01

    select * from mwkEvolReg where alltrim(EGM_evol)#'No Responde' into cursor mwkEvolProt
    select mwkEvolProt
    go bottom
    select proto
    replace fechahora with mwkEvolProt.EGM_fechaH
endscan
set step on
*!*	select prot_open
*!*	do sp_conexion
*!*	mret = SQLExec(mcon1,"SELECT id, nombre,codesp,codespe  FROM prestadores  " + ;
*!*		" union  SELECT ID , nombre,'    ' as codesp,gerenciadora  as codespe  FROM TabMedExterno " + ;
*!*		" where gerenciadora = 0 ", "mwkMedicogua" )
*!*	open database c:\desguemescar\presu
*!*	proto = ''
*!*	use guardia in 0
*!*	select gua8000
*!*	scan
*!*		if tipoest>0
*!*			mnroreg = gua8000.nroregistr
*!*			mfecha1 = ttod(gua8000.fechahoraing)
*!*			mfecha2 = ttod(gua8000.fechahoraing + 12*3600)
*!*		*	mihora = ttod(fechahorai + 12*3600)
*!*			mret = sqlexec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision  "+;
*!*				" FROM pacientes "+ ;
*!*				" where  PAC_codhci = ?mnroreg and PAC_fechaadmision >=?mfecha1 " +;
*!*				" and PAC_fechaadmision <=?mfecha2 ","mwkbuspacie")
*!*			if mret < 0
*!*				=aerr(eros)
*!*				messagebox(eros(3))
*!*			endif
*!*			if reccount( "mwkbuspacie")>0
*!*				proto = gua8000.protocolo
*!*				requery ('guardia')
*!*				select * from guardia where tipoest = 0 into cursor controlo
*!*	*			browse last
*!*				if reccount('controlo') = 0
*!*					update guardia set codcie9 = 92,codestado = 3,codmedcie9 = codmed
*!*				else
*!*					if reccount('guardia')>1
*!*						select guardia
*!*						browse last
*!*					else
*!*						if reccount('controlo') # reccount('guardia')
*!*							set step on
*!*						endif
*!*					endif
*!*				endif
*!*			mhc  = PAC_codadmision
*!*			select prot_open
*!*			replace interna with mhc
*!*			endif
*!*		endif
*!*		select gua8000
*!*	endscan

do sp_conexion
select admision
set step on
scan
    mnroreg = alltrim(admision)
    mret = sqlexec(mcon1, "select COB_codentidad,afiliacion.AFI_nroafiliado, pac_codhce "+ ;
        " FROM pacientes,coberturas,afiliacion "+ ;
        " where  PAC_codadmision  = COB_PACIENTES and PAC_codhci = afiliacion.registracio " +;
        " and 	PAC_codadmision  =?mnroreg  and afi_codentidad = COB_codentidad "+;
        " ","mwkbuspacie")
    if mret < 0
        set step on
        =aerr(eros)
        messagebox(eros(3))
    endif
    if reccount( "mwkbuspacie")>0
        mnroafi = AFI_nroafiliado
        mosoc = COB_codentidad
        mhclin = pac_codhce
        select  admision
        replace afiliado with mnroafi ,codent with mosoc,hclin with mhclin
    endif
endscan
do sp_desconexion


do sp_conexion


select  hcli
go top
scan
    mnrohclin = hclin
    mret = sqlexec(mcon1, "select REG_SEXO "+;
        " FROM Registracio "+ ;
        " where  REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")
    if reccount( "mwkbuspacie")>0
        mSEX = REG_SEXO
        select  hcli
        replace SEXO with MSEX
    endif
endscan


do sp_desconexion

do sp_conexion
select  hclin
scan
    mosoc = entid
    mctexto = alltrim(h_clinica)
    mret = sqlexec(mcon1,"select afiliacion.AFI_nroafiliado, REG_nrohclinica, REG_nombrepac" + ;
        " FROM afiliacion, registracio " + ;
        " where REG_nrohclinica= ?mctexto and afi_codentidad = ?mosoc "+;
        " and registracio.REG_nroregistrac = afiliacion.registracio " , "mwkbuspacie")
    if reccount( "mwkbuspacie")>0
        mnroafi = AFI_nroafiliado
        select  hclin
        replace afiliado with mnroafi
    endif
endscan
do sp_desconexion
select distinct hc from hcli into cursor hclinica
do sp_conexion
dime docu(10)
docu(1) = "LE"
docu(2) = "LC"
docu(3) = "CI"
docu(4) = "DNI"
docu(5) = "PAS"
docu(6) = "LM"
docu(7) = "LF"
docu(8) = ""
docu(9) = "OTR"
select  hclinica
scan
    mnrohc = hc
    mret = sqlexec(mcon1,"select REG_nrohclinica, REG_tipodocumento, REG_numdocumento" + ;
        ",AFI_nroafiliado, AFI_codentidad, AFI_fechabaja "+;
        " FROM afiliacion, registracio  " + ;
        " where REG_nrohclinica= ?mnrohc and AFI_codentidad in (945,948,484,682) "+;
        " and registracio.REG_nroregistrac = afiliacion.registracio order by AFI_codentidad desc " , "mwkbuspacie")
    if reccount( "mwkbuspacie")>0
        select  mwkbuspacie
        mnroafi = AFI_nroafiliado
        menti = AFI_codentidad
        mcdoc = docu(val(REG_tipodocumento))
        mndoc = REG_numdocumento
        update hcli set tdoc = mcdoc ,nrodoc = mndoc ;
            ,afiliado = mnroafi,codent = menti where hc = mnrohc
    endif
    select  hclinica
endscan
do sp_desconexion


do sp_conexion
select distinct hc from hcli into cursor hclinica
dime docu(10)
docu(1) = "LE"
docu(2) = "LC"
docu(3) = "CI"
docu(4) = "DNI"
docu(5) = "PAS"
docu(6) = "LM"
docu(7) = "LF"
docu(8) = ""
docu(9) = "OTR"
select  hclinica
set step on
scan
    mnrohc = hc
    mret = sqlexec(mcon1,"select REG_nrohclinica, REG_tipodocumento, REG_numdocumento" + ;
        ",REG_nombrepac,REG_sexo, REG_fecnacimiento,reg_telefonos,cuil "+;
        " FROM registracio left join padcabe on REG_numdocumento = documento  " + ;
        " where REG_nrohclinica= ?mnrohc  " , "mwkbuspacie")
    if reccount( "mwkbuspacie")>0
        select  mwkbuspacie
        mncuil = iif(isnull(cuil),REG_numdocumento,cuil)
        mnomb = REG_nombrepac
        msex = REG_sexo
        mfecnac = REG_fecnacimiento
        mtel = reg_telefonos
        mcdoc = docu(val(REG_tipodocumento))
        mndoc = REG_numdocumento
        update hcli set tdoc = mcdoc ,nrodoc = mndoc, fecnac = mfecnac ;
            ,cuil = mncuil ,nombre = mnomb , sex = msex, tele = mtel where hc = mnrohc
    endif
    select  hclinica
endscan
do sp_desconexion

do sp_conexion

select  admis
set step on
scan
    mnrohc = hcli
    mret = sqlexec(mcon1,"select REG_sexo, REG_tipodocumento, REG_numdocumento" + ;
        ",REG_nombrepac "+;
        " FROM registracio where REG_nrohclinica = ?mnrohc " + ;
        " " , "mwkbuspacie")
    if reccount( "mwkbuspacie")>0
        select  mwkbuspacie
        msex = REG_sexo
        mnom = REG_nombrepac
        select admis
        replace sexo with msex
    endif
    select admis
endscan
do sp_desconexion


select  moros
scan
    mnrohc = docu
    mret = sqlexec(mcon1,"select REG_nrohclinica, REG_tipodocumento, REG_numdocumento" + ;
        ",REG_nombrepac "+;
        " FROM registracio where REG_numdocumento = ?mnrohc " + ;
        " " , "mwkbuspacie")
    if reccount( "mwkbuspacie")>0
        select  mwkbuspacie
        mnhcli = REG_nrohclinica
        mnom = REG_nombrepac
        select moros
        replace hcli with mnhcli,nombre with mnom
    endif
    select moros
endscan
do sp_desconexion

select  admis2
set step on
scan
    locate for sexo = "X"
    if !found()
        exit
    endif
    mnrohc = alltrim(hcli)
    mret = sqlexec(mcon1, "select REG_SEXO  "+;
        " FROM registracio "+ ;
        " where  REG_nrohclinica = ?hcli " +;
        " ","mwkbuspacie")
    if reccount( "mwkbuspacie")>0
        select  mwkbuspacie
        msex = REG_sexo
        update admis2 set sexo = msex where hcli = mnrohc
    endif
    select  admis2
    go top
endscan
do sp_desconexion

mfe = ctod("29/02/2012")
select hcli
go top
scan
    select hcli
*!*		requery ('gua_pac_s')
*!*		mcgua = reccount('gua_pac_s')
    select hcli
    mcamb = 0
    if f_admis>mfe
        requery ('turnopaccr')
        mcamb = reccount('turnopaccr')
    endif
    select hcli
    if fini<=mfe
        requery ('turnopaccrh')
        mcamb = mcamb +reccount('turnopaccrh')
    endif
    select hcli
    replace cons_amb with mcamb &&,cons_gua with mcgua
endscan

select distinct hc from hcli into cursor hclinica
do sp_conexion
select  resuman
scan
    mnrohc = hc
    mfec = fecha
    mret = sqlexec(mcon1,"select REG_SEXO,REG_fecnacimiento " + ;
        " FROM registracio  where REG_nrohclinica= ?mnrohc" , "mwkbuspacie")
    if reccount( "mwkbuspacie")>0
        select  mwkbuspacie
        MSEX = nvl(REG_SEXO ,'-')
        mfecnac = REG_fecnacimiento
        medad = prg_edad(mfecnac,resuman.fecha,"N")
        update bacte set SEXO = MSEX,fecnac=mfecnac, edad = medad where hc= mnrohc and fecha = mfec
    endif
    select  resuman
endscan
do sp_desconexion
select vales
go top
scan
    requery ('vales_real')
    select vales
    if reccount('vales_real')>0
        replace hclin with vales_real.PAC_codhce,edad with vales_real.PAC_edad, sexo with vales_real.PAC_sexo &&,cons_gua with mcgua
    endif
endscan

dime tipo(10)
tipo(1)='PART1'
tipo(2)='PART2'
tipo(3)='LABORAL'
tipo(4)='CELULAR'
tipo(5)='MENSAJES'
mfecpas = ctod("01/01/1900")
select hclinica
go top
scan
    requery ('tabregtel')
    select hclinica
    if reccount('tabregtel')>0
        mnom = tabregtel.REG_nombrepac
        mtel = tabregtel.REG_telefonos
        select tabregtel
        i = 1
        scan
            if TRT_Pasiva = mfecpas
                do case
                    case I =1
                        mtipo1 	= tipo(Tabregtel.TRT_tipo)
                        mnro1	= Tabregtel.TRT_Numero
                    case I =2
                        mtipo2	= tipo(Tabregtel.TRT_tipo)
                        mnro2	= Tabregtel.TRT_Numero
                    case I =3
                        mtipo3 	= tipo(Tabregtel.TRT_tipo)
                        mnro3	= Tabregtel.TRT_Numero
                    case I =4
                        mtipo4 	= tipo(Tabregtel.TRT_tipo)
                        mnro4	= Tabregtel.TRT_Numero
                endcase
                i=i+1
            endif
        endscan
        select hclinica
        replace nombre with mnom,tele with mtel;
            ,tipo1 with mtipo1,nro1 with mnro1,tipo2 with mtipo2,nro2 with mnro2;
            ,tipo3 with mtipo3,nro3 with mnro3,tipo4 with mtipo4,nro4 with mnro4
        mtipo1 	= ''
        mnro1	= ''
        mtipo2	= ''
        mnro2	= ''
        mtipo3 	= ''
        mnro3	= ''
        mtipo4 	= ''
        mnro4	= ''

    endif
endscan
select ficha
go top
scan
    if empty(admision)
        mnroreg = nroreg
        mfecha1 = ttod(fechaing)
        mfecha2 = ttod(fechaing+ 36*3600)
*	endif
*	mihora = ttod(fechahorai + 12*3600)
        mret = sqlexec(mcon1, "select PAC_fechaadmision, PAC_horaadmision, PAC_fechaalta, PAC_codhci, PAC_codadmision,PAC_MOTIVOALTA  "+;
            " FROM pacientes "+ ;
            " where  PAC_codhci = ?mnroreg and PAC_fechaadmision >=?mfecha1 " +;
            " and PAC_fechaadmision <=?mfecha2 ","mwkbuspacie")
        if mret < 0
            =aerr(eros)
            messagebox(eros(3))
        endif
        if reccount( "mwkbuspacie")>0
            ming = PAC_fechaadmision
            malta = PAC_fechaalta
            madmis = PAC_codadmision
            mmalta =PAC_MOTIVOALTA
            select ficha
            replace fechaadm with ming,fechaalt  with malta,admision with madmis,motivoalta with mmalta
        endif
    endif
endscan
select informes
go top
scan
    mpuntero = puntero
    requery('vale_proto')
    if reccount( 'vale_proto')>0
        select informes
        replace protocolo with vale_proto->val_nroprotocolo;
            observa with nvl(vale_proto->val_observaciones,"S/O")

    endif
endscan
select guardia
go top
scan
    mproto = proto
    requery('guardiaint')
    if reccount( 'guardiaint')>0
        select guardia
        replace admision with guardiaint->diagnostico,fechaing with guardiaint->fechahoraate;
            nroreg with guardiaint->nroregistrac
    endif
endscan
select guardia
go top
scan
    if empty(admision)
        mnroreg = nroreg
        mfechaing = fechaing
        requery('pacientesg')
        if reccount( 'pacientesg')>0
            select pacientesg
            go top
            if !isnull(PAC_fechaalta)
                mfecalta = ctot(dtoc(pacientesg->PAC_fechaalta)+" "+ttoc(pacientesg->PAC_horaalta,2))
                select guardia
                replace admision with pacientesg->pac_codadmision,fechaegr with mfecalta;
                    diagnos with pacientesg->PAC_descripdiagn,codcie with pacientesg->PAC_codcie10diagegr
            else
                replace admision with pacientesg->pac_codadmision
            endif
        endif
    else
        madmision = alltrim(admision)
        requery('pacientesgreg')
        if reccount( 'pacientesgreg')>0
            if !isnull(pacientesgreg->PAC_fechaalta)
                mfecalta = ctot(dtoc(pacientesgreg->PAC_fechaalta)+" "+ttoc(pacientesgreg->PAC_horaalta,2))
                select guardia
                replace nroreg  with pacientesgreg->pac_codhci,fechaegr with mfecalta;
                    diagnos with pacientesgreg->PAC_descripdiagegr,codcie with pacientesgreg->PAC_codcie10diagegr
            else
                select guardia
                replace nroreg  with pacientesgreg->pac_codhci
            endif
        endif

    endif
endscan

select guardia
go top
scan
    madmision = alltrim(admision)
    requery('pacientesgreg')
    if reccount( 'pacientesgreg')>0
        if !isnull(pacientesgreg->PAC_fechaalta)
            mfecalta = ctot(dtoc(pacientesgreg->PAC_fechaalta)+" "+ttoc(pacientesgreg->PAC_horaalta,2))
            mfecadm = ctot(dtoc(pacientesgreg->PAC_fechaADMISION)+" "+ttoc(pacientesgreg->PAC_horaADMISION,2))
            select guardia
            replace fechaADM with mfecaDM
        endif
    endif

endscan

PUBLIC MIREGIS
MIREGIS = 137
do while .t.
    use in select('VALESIC')
    use c:\desaguemes\valesic.dbf in 0 exclusive
    select valesic
    go MIREGIS
WAIT WINDOWS TRANSFORM(MIREGIS) NOWAIT
    do while LISTO
        skip
    enddo
    if eof()
        set step on
    endif
    mpuntero = valesic.puntero
	MIREGIS = RECNO()
    requery('tabvalobs')
    if reccount( 'tabvalobs')>0
        select tabvalobs
        go bott
        miobser = left(nvl(tabvalobs.TVO_evolucion,''),254)
        select valesic
        replace observacion with miobser ,LISTO with .t.
    else
        select valesic
        replace LISTO with .t.

    endif
enddo
PUBLIC MIREGIS
MIREGIS = 1
    use in select('VALESIC')
    use c:\desaguemes\valesic.dbf in 0 exclusive
do while !eof()
    select valesic
    go MIREGIS
WAIT WINDOWS TRANSFORM(MIREGIS) NOWAIT
    do while LISTO
        skip
    enddo
    if eof()
        set step on
    endif
    mpuntero = valesic.puntero
	MIREGIS = RECNO()
    requery('vales_realic')
    if reccount( 'vales_realic')>0
        select vales_realic
        go bott
       mifecha = nvl(vales_realic.VAL_fechaconforme,ctod("01/01/1900"))
		mihora = ttoc( nvl(vales_realic.VAL_horaconforme,ctod("01/01/1900")),2)
		micant = vales_realic.PIA_cantsolicitada
		select valesic

       replace fechaconf with mifecha,horaconf with mihora,cantidad with micant,LISTO with .t.
    else
        select valesic
        replace LISTO with .t.

    endif
enddo
