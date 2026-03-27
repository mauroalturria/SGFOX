****
** busca turnos dados paa una entidad y una prestacion
****
parameter mcodent, mcodespe, mfecdes, mfechas, mbusco

*!* *!* mwhereesp = iif( !empty(mcodespe),"turnos.codesp = ?mcodespe and " ,'')
if mxambito >1
    mccpoamb = "  codambito = ?mxambito and "
else
    mccpoamb = ''
endif

mwhereesp = iif( !empty(mcodespe),"turnos.codesp in "+ mcodespe + " and " ,'')

*!* mwhereent = Iif( !Empty(mcodent) ,"turnos.codent = ?mcodent and ", '' )

mwhereent = iif( !empty(mcodent) ,"turnos.codent in "+mcodent+" and ", '' )

mret = sqlexec(mcon1, "select horatur as fecha, nombre as profesional, " 	 + ;
    "REG_nombrepac as paciente, pre_descriprest as prestacion, " + ;
    "codreserva, turnos.usuario, fechatomado, REG_telefonos, REG_numdocumento, " + ;
    "turnos.codent, turnos.codesp,codmedsoli,confirmado,TRT_Pasiva, TRT_Numero,TRT_tipo,Tabregtel.id " + ;
    "from turnos, prestadores, registracio, prestacions " + ;
    " left join Tabregtel on REG_nroregistrac = TRT_Registracio "+;
    " where  turnos.codreserva<>'' and REG_nroregistrac = afiliado and "+;
    " &mccpoamb turnos.afiliado = REG_nroregistrac and " + ;
    "turnos.codmed-10000 = prestadores.id and " + ;
    "turnos.codprest = pre_codprest and " + ;
    mwhereent + mwhereesp + mbusco + ;
    "turnos.fechatur >= ?mfecdes and " + ;
    "turnos.fechatur <= ?mfechas and " + ;
    "(turnos.tipoturno < 8 or turnos.tipoturno >=13) " + ;
    "", "mwktodosr")

mret = sqlexec(mcon1, "select horatur as fecha, prestadores.nombre as profesional, " 	 + ;
    "preregistra.nombre as paciente, pre_descriprest as prestacion, " + ;
    "codreserva, turnos.usuario, fechatomado, preregistra.telefono as REG_telefonos"+;
    ", preregistra.nrodocumento as REG_numdocumento, " + ;
    "turnos.codent, turnos.codesp,codmedsoli,confirmado,TRT_Pasiva, TRT_Numero,TRT_tipo,Tabregtel.id   " + ;
    "from turnos, prestadores, preregistra, prestacions " + ;
    " left join Tabregtel on tipoturno = TRT_Registracio "+;
    " where turnos.codreserva<>'' and preregistra.id = Turnos.afiliado and "+;
    "&mccpoamb turnos.afiliado = preregistra.id and " + ;
    "turnos.codmed -10000 = prestadores.id and " + ;
    "turnos.codprest = pre_codprest and " + ;
    mwhereent + mwhereesp + mbusco + ;
    "turnos.fechatur >= ?mfecdes and " + ;
    "turnos.fechatur <= ?mfechas and " + ;
    "(turnos.tipoturno < 8 or turnos.tipoturno >=13) and turnos.afiliado > 1 " + ;
    "", "mwktodosp")

if mret < 0
    =aerr(eros)
    do prg_error with eros,'sp_busco_turnos_por_entid_espe1'
    do prg_cancelo
endif
select * from mwktodosr;
    union all select * from mwktodosp;
    into cursor pacientes

select * from mwktodos1  order by  fecha into cursor mwktodos
use in  mwktodosr
use in mwktodosp
use in mwktodos1

i=0
mcarch = "T20140410.txt"
mnarch = fcreate(mcarch)

if mnarch > 0

    mccad = "Apellido y Nombre" + chr(9) + "H.Clinica" + chr(9) + "IDTurno" + chr(9) + "Fechahora" + chr(9) +"Telefonos" + chr(9) +  "Tipo"+ chr(9) + ;
        "Telefono" + chr(9) +  "Tipo"+ chr(9) + "Telefono" + chr(9) +  "Tipo"+ chr(9) + ;
        "Telefono"
    fputs(mnarch, mccad)

    select pacientes
    go top
    mipac = afiliado
    lpv = .t.
    do while !eof()
        do while !eof() and mipac = afiliado
            if lpv
                lpv = .f.
                mccad = REG_nombrepac + chr(9) + REG_nrohclinica+ chr(9) + transform(idtur) + chr(9) + ttoc(horatur) + chr(9) + alltrim(nvl(REG_telefonos,''))
                if !isnull(TRT_tipo) and !empty(nvl(TRT_Numero,'')) and nvl(TRT_Pasiva,ctod("01/12/2100")) = ctod("01/01/1900")
                    mccad = mccad + chr(9)+;
                        iif(TRT_tipo=1,"PART1",iif(TRT_tipo=2,"PART2",iif(TRT_tipo=3,"LABORAL",iif(TRT_tipo=4,"CELULAR",;
                        iif(TRT_tipo=5,"MENSAJES", "PART1") ) ) ) )+  chr(9) + alltrim(TRT_Numero)
                endif
            else
                if !isnull(TRT_tipo) and !empty(nvl(TRT_Numero,'')) and nvl(TRT_Pasiva,ctod("01/12/2100")) = ctod("01/01/1900")
                    mccad = mccad + chr(9)+;
                        iif(TRT_tipo=1,"PART1",iif(TRT_tipo=2,"PART2",iif(TRT_tipo=3,"LABORAL",iif(TRT_tipo=4,"CELULAR",;
                        iif(TRT_tipo=5,"MENSAJES", "PART1") ) ) ) )+  chr(9) + alltrim(TRT_Numero)
                endif
            endif
            select pacientes
            skip
        enddo
        fputs(mnarch, mccad)
        mccad = REG_nombrepac + chr(9) + REG_nrohclinica+ chr(9) + transform(idtur) + chr(9) + ttoc(horatur) + chr(9) + alltrim(nvl(REG_telefonos,''))
        if !isnull(TRT_tipo) and !empty(nvl(TRT_Numero,''))
            mccad = mccad + chr(9)+;
                iif(TRT_tipo=1,"PART1",iif(TRT_tipo=2,"PART2",iif(TRT_tipo=3,"LABORAL",iif(TRT_tipo=4,"CELULAR",;
                iif(TRT_tipo=5,"MENSAJES", "PART1") ) ) ) )+  chr(9) + alltrim(TRT_Numero)
        endif
        select pacientes
        mipac = afiliado
        if !eof()
            skip
        endif
    enddo
    if !isnull(TRT_tipo)
        mccad = mccad + chr(9)+;
            iif(TRT_tipo=1,"PART1",iif(TRT_tipo=2,"PART2",iif(TRT_tipo=3,"LABORAL",iif(TRT_tipo=4,"CELULAR",;
            iif(TRT_tipo=5,"MENSAJES", "PART1") ) ) ) )+  chr(9) + TRT_Numero
    endif
    fputs(mnarch, mccad)

    fclose(mnarch)
endif