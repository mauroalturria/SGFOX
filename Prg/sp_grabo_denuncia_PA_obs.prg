Parameters tnid,tnObserva,tnestado

mdtF= sp_busco_fecha_serv("DT")
mid = tnid
mobserva = tnObserva
mestado = tnestado
mfechoy = sp_busco_fecha_serv("DT")
midusu = IIF(LEFT(mwkusuario.nomape,1)='*',Iif(Used('mwkusuarios'),mwkusuarios.codigovax ,mwkusuario.codigovax),mwkusuario.codigovax)

lcSql ="INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
	" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )"
tcCursor = ''
If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
ELSE
	Messagebox("SE ACTUALIZÓ LA INFORMACIÓN",64,"Control de Ingreso")
Endif
