*!*	Proceso de Carga de TabHistOcup
*!*	-----------------------------------------------------------

if used("mwkcama0")
    use in mwkcama0
endif

*!*	HABITACIONES DE SECTORES DE INTERNACION
*!*	-----------------------------------------------------------
mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
    "hab_habilitada, pac_nombrepaciente, pac_sexo, pac_edad, " + ;
    "pac_descripdiagn, pac_categoria, pin_codentidad, " + ;
    "sec_habitsala, Sec_CodSector, Sec_DescripSec " + ;
    "from habitacions " + ;
    "Inner Join Sectores on habitacions.hab_sectores = Sectores.Sec_CodSector and Sec_Internacion = 1 " + ;
    "left outer join pacientes on habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
    "left outer join pacinternad on pacinternad.pin_codadmision = pacientes.pac_codadmision " + ;
    "order by hab_codhabitacion, hab_codcama", "mwkcama0")

if mret <= 0
    messagebox("ERROR EN LA LECTURA DE LOS DATOS",48,"VALIDACION")
    return .f.
endif

mFecha = sp_busco_fecha_serv('DT')
mHora  = hour(mFecha)*100

select count(*) as Cant, hab_codhabitacion, Sec_CodSector, Sec_DescripSec, sec_habitsala ;
    from mwkcama0 ;
    group by hab_codhabitacion, Sec_CodSector, sec_habitsala, Sec_DescripSec ;
    into cursor mwkHabitaciones

select distinct Sec_CodSector, Sec_DescripSec  ;
    from mwkHabitaciones ;
    into cursor mwkSectores

select mwkSectores
scan all &&for "TORRE 16" $ Sec_DescripSec

    mTotalCamaLibre = 0
    mTotalOcupadas = 0
    mTotalInd = 0
    mTotalBloq = 0
    mTotalCamas = 0
    mcanthab = 0


    select mwkHabitaciones
    scan all for mwkHabitaciones.Sec_CodSector = mwkSectores.Sec_CodSector

        mcanthab = mcanthab + 1
        mCamas = 0
        mCamaInd = 0
        mCamaBloq = 0
        mCamaLibre = 0
        mOcupadas = 0

        select * ;
            from mwkcama0 ;
            where mwkcama0.hab_codhabitacion = mwkHabitaciones.hab_codhabitacion and ;
            mwkcama0.Sec_CodSector = mwkHabitaciones.Sec_CodSector ;
            into cursor mwkcamas

        select hab_codhabitacion ;
            from mwkcama0 ;
            where pac_categoria = "A" and inlist(hab_codcama,"01","02") group by hab_codhabitacion;
            into cursor mwkcamasais
        mCantxHab = _tally

        select mwkcamas
        scan all
        	mihab = hab_codhabitacion
        	select * from mwkcamasais where hab_codhabitacion=mihab into cursor mwkhabAis
        	select mwkcamas
        	if left(hab_codpaciente,3) = "IND" or (hab_codpaciente='0' and reccount('mwkhabAis')>0)  
                mCamas = mCamas + 1
                mCamaInd = mCamaInd + 1
            else
                if pac_categoria = "A" or pac_categoria = "I"
                    if mCantxHab = 1
                        mCamas = mCamas + 1
                        mOcupadas = mOcupadas  + 1
                    else
                        mCamas = mCamas + 1
                        mOcupadas = mOcupadas  + 1
                    endif
                else
                    if hab_codpaciente = "BLOQUEO" &&Or hab_codpaciente = "RESERV"
                        mCamaBloq = mCamaBloq  + 1
                    else
                        if empty(hab_codpaciente) or isnull(hab_codpaciente) or alltrim(hab_codpaciente) = "0"
                            mCamaLibre = mCamaLibre + 1
                        else
                            mOcupadas = mOcupadas  + 1
                        endif
                        mCamas = mCamas + 1
                    endif
                endif
            endif

            select mwkcamas
        endscan
        use in mwkcamas

*!*			? " Cantidad de camas de la habitacion " + str(mCamas)
*!*			? " Cantidad de camas libres de la habitacion " + str(mCamaLibre)
*!*			? " Cantidad de camas Ocupadas de la habitacion " + str(mOcupadas)

        mTotalCamas = mTotalCamas + mCamas
        mTotalCamaLibre = mTotalCamaLibre + mCamaLibre
        mTotalInd = mTotalInd + mCamaInd
        mTotalBloq = mTotalBloq + mCamaBloq
        mTotalOcupadas = mTotalOcupadas + mOcupadas
        select mwkHabitaciones
    endscan

*!*		? Replicate("-",40)
*!*		? " Cantidad de habitaciones "  + str(mcanthab)

*!*		? Replicate("-",40)
*!*		? " Cantidad de camas del sector " + str(mTotalCamas)
*!*		? " Cantidad de camas Libre del sector " + str(mTotalCamaLibre)
*!*		? " Cantidad de camas Ocupadas del sector " + str(mTotalOcupadas)

*!*		? Replicate("- * -",40)
    do sp_cargo_hab_Lib_ocup with mTotalCamaLibre, mTotalOcupadas, ttod(mFecha), mHora, mwkSectores.Sec_CodSector,mTotalInd ,mTotalBloq 

    select mwkSectores
endscan

use in mwkSectores
use in mwkcama0
use in mwkHabitaciones
