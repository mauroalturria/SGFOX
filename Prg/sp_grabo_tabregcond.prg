** Pasamos el nro. de registracion.
** Cursor utilizado : mwkregnew
Lparameters nRegistracion
Local mret
mFechaPasiva = sp_busco_fecha_serv("DD")
mret = 1
If Used('mwkregnew')
	Select mwkregnew
	Go Top
	Scan All
		mFechaDesde = RCE_fechadesde
		mFechaHasta = RCE_fechahasta
		mtipo = RCE_tipoCondesp
		musuario = RCE_usuario
		mnrocert = RCE_nroCertificado
		mestado = mwkregnew.Estado
		mnroregistracio = nRegistracion
&&FecHorDbAdd , FecHorDbUpd , UserDbAdd , UserDbUpd , RCE_fechadesde , RCE_fechahasta , RCE_registracio , RCE_tipoCondesp , RCE_usuario
		Do Case
		Case mestado = 0 &&no hace nada
		Case mestado = 1 &&nuevo
			mret = SQLExec(mcon1,"select id from ZabRegCondEsp where RCE_fechahasta>?mFechaPasiva and RCE_registracio = ?mnroregistracio and "+;
				" RCE_tipoCondesp = ?mtipo ","mwkctrlins")
			If Reccount("mwkctrlins")>0
				mid = mwkctrlins.Id
				mret = SQLExec(mcon1,"update ZabRegCondEsp set RCE_fechahasta =?mFechaPasiva,RCE_nroCertificado = ?mnrocert ,"+;
					" FecHorDbUpd = ?mFechaPasiva, UserDbUpd=?musuario where id = ?mid")
			Endif

			mret = SQLExec(mcon1,"Insert Into ZabRegCondEsp (RCE_fechadesde , RCE_fechahasta,RCE_nroCertificado , RCE_registracio , RCE_tipoCondesp , RCE_usuario ) "+;
				" Values (?mFechaDesde ,?mFechaHasta,?mnrocert  ,?mnroregistracio ,?mtipo ,?musuario )")
		Case mestado = 2 &&Anula

			mid = mwkregnew.Id
			mret = SQLExec(mcon1,"update ZabRegCondEsp set RCE_fechahasta =?mFechaPasiva,RCE_nroCertificado = ?mnrocert , FecHorDbUpd = ?mFechaPasiva, UserDbUpd=?musuario where id = ?mid")

		Endcase
		If mret<=0
			Messagebox("ERROR EN ACTUALIZACION DE LA TABLA DE CONDICIONES",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
	Endscan
Endif
