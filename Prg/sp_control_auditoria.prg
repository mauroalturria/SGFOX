****
** inserto datos de alta transitoria
****
parameter mafi  , mcodent,mnumdoc,mnombre,mreg,pasa

mnom = alltrim(mnombre)
mbusco1 = " where REG_nombrepac = '"+ alltrim(mnom)+"' and  "
do sp_busco_nombre_paciente_1 with mbusco1,1
select distinct reg_nrohclinica from mwkbuspacie into cursor mwkbuspa
select mwkbuspacie
if reccount("mwkbuspa")>1
    pasa = 3
endif
if mnumdoc=0
    pasa = pasa +20
else
    mbusco1 = " where REG_numdocumento = "+ str(mnumdoc)+ " and "
    do sp_busco_nombre_paciente_1 with mbusco1,1
    select distinct reg_nrohclinica from mwkbuspacie into cursor mwkbuspa
    if val(mwkbuspacie.reg_tipodocumento) = 0
        pasa = pasa +30
    else
        if reccount("mwkbuspa")>1
            pasa = pasa +10
        endif
    endif
endif
mnroafi  = mafi
mbusco1  = "afi_nroafiliado = ?mnroafi and afi_codentidad = ?mcodent and "

do sp_busco_por_tipynro with mbusco1
select * from mwkbuscopa where reg_nroregistrac # mreg into cursor mwkotroafi
if reccount("mwkotroafi")>0
    pasa = pasa +300
else
    select * from entidades where ent_codent = mcodent into cursor enti1
    if nvl(enti1.ent_codagrup,0)>0 and nvl(enti1.ent_codagrup,0) # enti1.ent_codent
        micodi  = enti1.ent_codagrup
        select * from entidades where ent_codent # mcodent and ent_codagrup = micodi  into cursor enti2
        select enti2
        mbusco1  = "afi_nroafiliado = ?mnroafi and afi_codentidad in ( "
        scan
            mbusco1 = mbusco1 + str(ent_codent,5,0)+ ", "
        endscan
        mbusco1 = substr(mbusco1 ,1,len(mbusco1 )-2) + " ) and "
        do sp_busco_por_tipynro with mbusco1

        select * from mwkbuscopa where reg_nroregistrac # mreg into cursor mwkotroafi
        if reccount("mwkotroafi")>0
            pasa = pasa +200
        endif
    endif
endif
if used ('vales')
    use in vales
endif
create cursor vales ;
    (paciente  c(50),cuenta c(10))

lseomite = .f.
msql_reg	= ''
msql_pac = ''
msql_cons = ''

mnroreg 	= mreg
mbusco1 	= "pac_codhci = ?mnroreg and "
mfecdes 	= ctod('01/01/1900')
mfechas 	= sp_busco_fecha_serv('DD')
mtfhoy = mfechas
do sp_busco_pac_alta_his_vf6 with mbusco1, , ,msql_pac
select * from mwkpacalta1 into cursor mwkpacalta

do sp_busco_consumos_paciente with mnroreg, msql_cons ,1

&msql_cons
select mwkpacalta
go top
msql_reg	= ''
msql_con	= ''
msql_ent	= ''
scan
    mpac 			= chrtran(pac_nombrepaciente,",.","  ")
    mcodadmision	= pac_codadmision
    insert into vales (paciente  ,cuenta ) values (mpac ,mcodadmision)
endscan
select mwkpacalta
go top

select * from mwkconsu group by val_codadmision into cursor mwkconsu
select mwkconsu
mhasta = reccount('mwkconsu')
go top
if reccount('mwkpacalta') > 0
    mpac 			= mwkpacalta.pac_nombrepaciente
else
    mpac 			= mnombre
endif
scan
    mtipopac = iif(mwkconsu.val_tipopaciente='AMB',mwkconsu.val_tipopaciente,mwkconsu.pac_sectorinternac)
    if  mtipopac = "GUA" or mtipopac = "AMB"
        mcodadmision = mwkconsu.val_codadmision
        lctaamb = .f.
        a = 1
        for i = 1 to 6
            if isalpha(substr(alltrim(mcodadmision),i,1))
                lctaamb = .t.
                exit
            endif
        next
        if lctaamb
            mret = sqlexec(mcon1, "select pac_nombrepaciente from pacientes " + ;
                "where   pac_codadmision = ?mcodadmision " ,"mwkpacconsu")
            mpac = chrtran(pac_nombrepaciente,",.","  ")
            insert into vales (paciente ,cuenta) values (mpac,mcodadmision )
        endif
    endif
    select mwkconsu
endscan

select distinct paciente  from vales into cursor valespac

if reccount("valespac")>1
    pasa = pasa +1000
endif
msql1 = ''
do sp_busco_entidad_afiliado1 with mreg
&msql1
nafimal = .f.
lcontrolnro  = .f.
ltodok = .t.
if used('mwkafient1')
    select mwkafient1
    scan
        if isnull(mwkafient1.ent_fecpas)
            mcodent = mwkafient1.afi_codentidad
            mafiliado = mwkafient1.afi_nroafiliado
            do case
                case inlist( mcodent, 175, 75)
                    mafiliado = chrtran(mafiliado ," -/","")
                    lcontrolnro=.t.
                case inlist( mcodent,992 ) && sancorsalud
                    mafiliado = chrtran(mafiliado ," -/","")
                    lcontrolnro = .t.
                case inlist( mcodent, 149)
                    mafiliado = chrtran(mafiliado ," -/","")
                    if len(mafiliado )=10
                        mafiliado 	= "0"+chrtran(mafiliado ," -/","")
                    endif
                    lcontrolnro=.t.
                otherwise
                    lcontrolnro=.f.
            endcase

            if lcontrolnro
                ltodok = .t.
                if mcodent # 992
                    do sp_valido_afiliado with mafiliado, mcodent, ltodok,1
                endif
            endif
            if !ltodok
                nafimal = .t.
            endif
        endif
    endscan
    if nafimal
        pasa = pasa + 2000
    endif
endif

