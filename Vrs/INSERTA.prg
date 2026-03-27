mdtf    = sp_busco_fecha_serv('DT')
select arreglo
mfecnul = ctod("01/01/1900")

scan
    mpaciente =alltrim(po_admision)
    midusu = pac_operalta
    mdtf = ctot(dtoc(pac_fechaalta)+" " +ttoc(pac_horaalta,2))
    mestado=13
    mobserva = ' x ALTA ADMISION'
    mret=sqlexec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where PO_admision = ?mpaciente and PO_FechaCierre = ?mfecnul  ","mwkrreg")
    mid = mwkrreg.id
    miobser = nvl(mwkrreg.po_observac,'')+iif(empty(mobserva),'',chr(10)+ttoc(mdtf)+"-"+TRANSF(MIDUSU)+;
        " finalizado->"+mobserva)
    mret =sqlexec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
        " values ( ?mestado,?mdtf,?mid, ?mobserva,?midusu )")
endSCAN
