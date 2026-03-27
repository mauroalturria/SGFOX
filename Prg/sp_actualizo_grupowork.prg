****
** actualizo la tabla de cmd x frm
****

Parameter musuid, mnreg, mfdes,mfhas,mperfil,mopc
miduser = mwkusuario.codigovax
muserid = mwkusuario.idusuario
mfechahora = sp_busco_fecha_serv("DT")
Do Case
Case mopc = 1	&& agrego permis0
	mfecpas = Ctod('01/01/1900')
	mret = SQLExec(mcon1, "insert into ZabTeamPacConf (UserDbAdd, TP_fechadesde, TP_fechahasta, TP_nroregis, TP_perfil, TP_usuarioid) " + ;
		"values(?miduser , ?mfdes, ?mfhas, ?mnreg,?mperfil,?musuid)")

Case mopc = 2	&& quito permiso
	mfecpas = sp_busco_fecha_serv('DD')
	mret = SQLExec(mcon1,"select  id,TP_fechadesde,TP_fechahasta,TP_nroregis,TP_perfil "+;
		" ,TP_usuarioid from  ZabTeamPacConf  "+;
		" where TP_usuarioid = ?musuid and TP_nroregis = ?mnreg and TP_fechadesde = ?mfdes and TP_fechahasta = ?mfhas   " ,"mwkGrupid" )
	mid = mwkGrupid.Id
	mret = SQLExec(mcon1, "update ZabTeamPacConf  set FecHorDbUpd = ?mfechahora , UserDbUpd = ?muserid , "+;
		"   TP_fecpasiva = ?mfecpas where id = ?mid ")

Case mopc = 3	&& quito todos los cmd
	mfecpas = sp_busco_fecha_serv('DD')
	mret = SQLExec(mcon1, "update ZabTeamPacConf   set fecpasiva = ?mfecpas " + ;
		"where codfrm = ?mfrmid and codsector =?msecid ")

Endcase
