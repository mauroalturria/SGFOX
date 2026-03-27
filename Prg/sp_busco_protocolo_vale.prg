*****
** Busco Protocolo - desde vales
****

parameter mvale,mdiagno
if vartype(mdiagno) # "N"
    mdiagno = 0
endif

mret = sqlexec(mcon1, "select guardia.id,guardia.protocolo,codserv,codprest,guardia.fechahoraing from guardiavale,guardia " + ;
    "where guardiavale.protocolo = guardia.protocolo and nrovale = ?mvale", "mwkvaleproto")

if mret < 0
    messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
    do sp_desconexion with "sp_busco_protocolo_vale"
    cancel
endif
if mdiagno = 1
    do sp_busco_protocolo_historia with mwkvaleproto.protocolo
    mcodmed = mwkveoproto.codmedcie9
    mdiag = mwkveoproto.codcie9
    if mcodmed<=9999
        mret = sqlexec(mcon1, 'select matriculas,nombre from prestadores where id = ?mcodmed ', 'mwkveomat')
    else
        mret = sqlexec(mcon1, 'select matricula ,nombre from TabMedExterno where id = ?mcodmed ', 'mwkveomat1')
        select transf(matricula,"9999999") as matriculas ,nombre from mwkveomat1 into cursor mwkveomat
        use in mwkveomat1
    endif
    if used('mwkCiap2ea')
        select * from mwkciap2ea where id= mwkveoproto.codcie9 into cursor mwkciap2er
        if reccount('mwkciap2er')=0
	        USE IN SELECT('mwkciap2er')
            mid= mwkveoproto.codcie9
            mret = sqlexec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
                "descrabrev , descripcion , excluye , incluye,fecanula "+;
                " from  tabciap2e where id = ?mid ", "mwkciap2er")
        endif
    endif

endif
