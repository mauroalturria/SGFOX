j=0
use in select('turnosmar')
midircopia = "C:\turnos\"
mifecha = ctod("01/03/2013")
cfiles = midircopia+ "*.TXT"
adir(mima,cfiles)
ncantfiles = alen(mima,1)
on error =aerr(eros)
for i=1 to ncantfiles
    marchivo = midircopia+ mima(i,1)
    mexporta = sp_getshortpath(marchivo)
    wait windows (marchivo) nowait
*mexporta = 'turno_0106.txt'
    create cursor turnos (TELEFONO n(10) ,RTA c(20), CONFIRMA c(20) ,CANCELA c(20)  ,;
        NOMBRE c(50), HCLIN c(20), N_REF n(10), FECHA_TURNO D  ,;
        TIPO_TEL c(20) ,FECHA_LLAMADO D, TURNO c(20) )
    select turnos
    go bottom
    append from (mexporta) delimited with tab
    alter table turnos   add column fecnac D
    alter table turnos  add column sexo c(1)
    alter table turnos  add column domic c(50)
    alter table turnos  add column provincia c(50)
    alter table turnos  add column localidad c(50)
    alter table turnos  add column codpos c(5)
    alter table turnos  add column codent n(5)
    alter table turnos  add column apeynom c(50)
    alter table turnos  add column estado c(20)
    alter table turnos  add column especial c(50)
    cfilexls = "turno_Mar"

    select turnos
    scan
        mifecha = turnos.FECHA_TURN
        mihc = turnos.hclin
        requery('turnos_tel')
        select turnos
        wait windows transform(recno()) nowait
        if reccount('turnos_tel')= 0
            requery('turnos_telc')
            select turnos
            if reccount('turnos_telc')= 0
                nref = turnos.n_ref
                requery('turnos_telid')
                if reccount('turnos_telid')= 0
                    select turnos
                    replace estado with 'NOAN'
                else
                    select turnos
                    replace apeynom with turnos_telid.REG_nombrepac;
                        ,fecnac  with turnos_telid.REG_fecnacimiento, sexo with alltrim(turnos_telid.reg_sexo),;
                        domic with nvl(turnos_telid.REG_domicilio,''),provincia with nvl(turnos_telid.REG_provincia,'');
                        ,localidad with nvl(turnos_telid.REG_localidad,''), codpos with transform(nvl(turnos_telid.REG_cpostal,0));
                        , codent with turnos_telid.codent,estado with iif(turnos_telid.confirmado=1,"PRE_","AUS_")+"REP"+dtoc(turnos_telid.fechatur);
                        ,especial with iif(isnull(turnos_telid.ESP_descripcion),turnos_telid.codesp,turnos_telid.ESP_descripcion)
                endif
            else
                replace estado with iif(turnos_telc.coDcancela =5,"CMAS",;
                    iif(turnos_telc.codcancela =2,"PACTE",;
                    iif(turnos_telc.codcancela =6,"3AUS",;
                    iif(turnos_telc.codcancela =36,"A1T",;
                    iif(turnos_telc.codcancela =28,"CAM",;
                    iif(turnos_telc.codcancela =30,"CxO",;
                    iif(turnos_telc.codcancela =42,"TMC",;
                    iif(turnos_telc.codcancela =49,"IVR","OTRO")))))))),;
                    fecnac with turnos_telc.REG_fecnacimiento, sexo with alltrim(turnos_telc.reg_sexo),;
                    domic with nvl(turnos_telc.REG_domicilio,''),provincia with nvl(turnos_telc.REG_provincia,'');
                    ,localidad with nvl(turnos_telc.REG_localidad,''), codpos with transform(nvl(turnos_telc.REG_cpostal,0));
                    , codent with turnos_telc.codent;
                    ,apeynom with turnos_telc.REG_nombrepac;
                    ,especial with iif(isnull(turnos_telc.ESP_descripcion),turnos_telc.codesp,turnos_telc.ESP_descripcion)
            endif

        else
            select turnos
            replace apeynom with turnos_tel.REG_nombrepac;
                ,fecnac  with turnos_tel.REG_fecnacimiento, sexo with alltrim(turnos_tel.reg_sexo),;
                domic with nvl(turnos_tel.REG_domicilio,''),provincia with nvl(turnos_tel.REG_provincia,'');
                ,localidad with nvl(turnos_tel.REG_localidad,''), codpos with transform(nvl(turnos_tel.REG_cpostal,0));
                , codent with turnos_tel.codent,estado with iif(turnos_tel.confirmado=1,"PRES","AUS");
                ,especial with iif(isnull(turnos_tel.ESP_descripcion),turnos_tel.codesp,turnos_tel.ESP_descripcion)
        endif
    endscan
    if used('turnosmar')
        select * from turnosmar union all select * from turnos into cursor turnosmar
    else
        select * from turnos into cursor turnosmar
    endif
    use in turnos

next
select turnosmar

copy to &cfilexls  type xl5
use in turnos
use dbf('turnosmar') in 0 again alias turnos

select turnos

scan
    if codent = 0
        mifecha = turnos.FECHA_TURN
        mihc = turnos.hclin
        requery('turnos_tel_p')
        select turnos
        wait windows transform(recno()) nowait
        if reccount('turnos_tel_p')= 0
            requery('turnos_telc_p')
            select turnos
            if reccount('turnos_telc_p')= 0
                nref = turnos.n_ref
                requery('turnos_telid_p')
                if reccount('turnos_telid_p')= 0
                    select turnos
                    replace estado with 'NOAN'
                else
                    select turnos
                    replace apeynom with turnos_telid_p.nombre;
                        ,fecnac  with turnos_telid_p.fechanac, sexo with alltrim(turnos_telid_p.sexo),;
                        domic with nvl(turnos_telid_p.direccion,'');
                        , codent with turnos_telid_p.codent,estado with iif(turnos_telid_p.confirmado=1,"PRE_","AUS_")+"REP"+dtoc(turnos_telid_p.fechatur);
                        ,especial with iif(isnull(turnos_telid_p.ESP_descripcion),turnos_telid_p.codesp,turnos_telid_p.ESP_descripcion)
                endif
            else
                replace estado with iif(turnos_telc_p.coDcancela =5,"CMAS",;
                    iif(turnos_telc_p.codcancela =2,"PACTE",;
                    iif(turnos_telc_p.codcancela =6,"3AUS",;
                    iif(turnos_telc_p.codcancela =36,"A1T",;
                    iif(turnos_telc_p.codcancela =28,"CAM",;
                    iif(turnos_telc_p.codcancela =30,"CxO",;
                    iif(turnos_telc_p.codcancela =42,"TMC",;
                    iif(turnos_telc_p.codcancela =49,"IVR","OTRO")))))))),;
                    fecnac with turnos_telc_p.fechanac, sexo with alltrim(turnos_telc_p.sexo),;
                    domic with nvl(turnos_telc_p.direccion,'')         , codent with turnos_telc_p.codent;
                    ,apeynom with turnos_telc_p.nombre;
                    ,especial with iif(isnull(turnos_telc_p.ESP_descripcion),turnos_telc_p.codesp,turnos_telc_p.ESP_descripcion)
            endif

        else
            select turnos
            replace apeynom with turnos_tel_p.nombre;
                ,fecnac  with turnos_tel_p.fechanac, sexo with alltrim(turnos_tel_p.sexo),;
                domic with nvl(turnos_tel_p.direccion,'');
                , codent with turnos_tel_p.codent,estado with iif(turnos_tel_p.confirmado=1,"PRES","AUS");
                ,especial with iif(isnull(turnos_tel_p.ESP_descripcion),turnos_tel_p.codesp,turnos_tel_p.ESP_descripcion)
        endif
    endif
endscan

select control
set step on
scan
    if at("_REP",motivo)>1
        nref=control.nref
        requery('turnos_telid_ff')
        if reccount('turnos_telid_ff')> 0

            select control
            replace fecharep with nvl(turnos_telid_ff.fechaobserva,turnos_telid_ff.horatur),fechahora with turnos_telid_ff.horatur;
                ,confirma with iif(turnos_telid_ff.confirmado=1,"PRES",iif(turnos_telid_ff.tipoturno=9,"ANUL","AUS"));
                ,hclinica with nvl(turnos_telid_ff.reg_nrohclinica,"PREREGISTRA")


        endif
    endif
endscan
