** Pasamos el nro. de registracion.

Lparameters nRegistracion,mtipo,mcerti,mloborro,mdfechahasta,mnidusu
Local mret
If Vartype(mloborro)<>"N"
	mloborro=0
Endif
mFechaPasiva = sp_busco_fecha_serv("DD")
mret = 1
mFechaDesde = mFechaPasiva
If Vartype(mdfechahasta)<>"D"
	mFechaHasta = mFechaPasiva +1
Else
	mFechaHasta = mdfechahasta
Endif
musuario = IIF(VARTYPE(mnidusu)="N",mnidusu,mwkusuario.Id)
mnrocert = mcerti
mnroregistracio = nRegistracion
&&FecHorDbAdd , FecHorDbUpd , UserDbAdd , UserDbUpd , RCE_fechadesde , RCE_fechahasta , RCE_registracio , RCE_tipoCondesp , RCE_usuario
mret = SQLExec(mcon1,"select id from ZabRegCondEsp where RCE_fechahasta>?mFechaPasiva and RCE_registracio = ?mnroregistracio and "+;
" RCE_tipoCondesp = ?mtipo ","mwkctrlins")
If Reccount("mwkctrlins")>0
	mid = mwkctrlins.Id
	mret = SQLExec(mcon1,"update ZabRegCondEsp set RCE_fechahasta =?mFechaPasiva,RCE_nroCertificado = ?mnrocert ,"+;
	" FecHorDbUpd = ?mFechaPasiva, UserDbUpd=?musuario where id = ?mid")
Endif
If mloborro =0
	mret = SQLExec(mcon1,"Insert Into ZabRegCondEsp (RCE_fechadesde , RCE_fechahasta,RCE_nroCertificado , RCE_registracio , RCE_tipoCondesp , RCE_usuario ) "+;
	" Values (?mFechaDesde ,?mFechaHasta,?mnrocert  ,?mnroregistracio ,?mtipo ,?musuario )")
Endif
