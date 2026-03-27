****
** actualizo la tabla de equipo tratante Investigacion
****

Parameter mopc,musuid, mnreg,mcodent, mfdes,mfhas,mperfil,meviaem
miduser = mwkusuario.codigovax
muserid = mwkusuario.idusuario
mfechahora = sp_busco_fecha_serv("DT")
Do Case
Case mopc = 1	&& agrego permis0
	mfecpas = Ctod('01/01/1900')
	mret = SQLExec(mcon1, "insert into ZabInvET  (IET_protocolo , IET_fechadesde, IET_fechahasta, IET_nroregis, IET_perfil, IET_usuarioid ,IET_avisoxmail) " + ;
		"values(?mcodent,?mfdes, ?mfhas, ?mnreg,?mperfil,?musuid,?meviaem)")

Case mopc = 2	&& quito permiso
	mfecpas = sp_busco_fecha_serv('DD')
	mret = SQLExec(mcon1,"select  id,IET_fechadesde,IET_fechahasta,IET_nroregis,IET_perfil "+;
		" ,IET_usuarioid from  ZabInvET   "+;
		" where IET_usuarioid = ?musuid and IET_nroregis = ?mnreg and IET_protocolo = ?mcodent and IET_fecpasiva = '1900-01-01' " ,"mwkprotinvid" )
	mid = mwkprotinvid.Id
	mret = SQLExec(mcon1, "update ZabInvET   set FecHorDbUpd = ?mfechahora , UserDbUpd = ?muserid , "+;
		"   IET_fecpasiva = ?mfecpas where id = ?mid ")


Endcase
