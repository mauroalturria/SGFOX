Parameters mabm ,mvirus ,mestctg ,mnreg,mperlat,mfecini,mfecfin,mid,marm,mfechiso,mesthiso,mobsvirus ,musu,mfeciniseg,lcambio

mfechora = sp_busco_fecha_serv("DT")
mfecha = Ttod(mfechora )
If Vartype(mfecini)<>"D"
	mfecini = Ttod(mfechora )
Endif
If Vartype(lcambio)<>"L"
	lcambio=.T.
Endif
If Vartype(mfecfin)<>"D"
	mfecfin = Ctod("01/01/2100")
Endif
mfecnul = Ctod("01/01/1900")
If Vartype(mperlat)#"N"
	mperlat=0
Endif
mseg  = ''
If Vartype(mfeciniseg)="D"
	mseg = " ,RC_fechaIniSegmto = ?mfeciniseg "
Endif
Do Case
	Case mabm=1
		lcSql = "select * from ZabRegContagio where RC_nroregistracio = ?mnreg and RC_fechaFin ='2100-01-01' and RC_fechaPasiva =?mfecnul and RC_virus = ?mvirus"
		tcCursor = 'mwkctgctrl'
		If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
			Return .F.
		Endif
		If mwkctgctrl.Id  = 0
			lcSql = "Insert into ZabRegContagio( RC_estado , RC_fechaFin , RC_fechaInicio , RC_fechaPasiva , RC_nroregistracio ,"+;
				" RC_periodoLatencia , RC_virus, RC_ARM,RC_hisopadoFecha,  RC_hisopadoResul  )"+;
				" values (?mestctg ,?mfecfin , ?mfecini ,?mfecnul , ?mnreg,?mperlat,?mvirus,?marm,?mfechiso,?mesthiso )"

		Else
			mid = mwkctgctrl.Id
			lcSql = "update ZabRegContagio set  RC_estado = ?mestctg,RC_fechaFin = ?mfecfin ,  RC_periodoLatencia = ?mperlat "+;
				" ,RC_ARM = ?marm,RC_hisopadoFecha = ?mfechiso,  RC_hisopadoResul = ?mesthiso "+mseg +" where id = ?mid"
		Endif

	Case mabm = 2
		If mid >1
			lcSql = "update ZabRegContagio set RC_fechaInicio =  ?mfecini ,RC_estado = ?mestctg,RC_fechaFin = ?mfecfin ,  RC_periodoLatencia = ?mperlat "+;
				" ,RC_ARM = ?marm,RC_hisopadoFecha = ?mfechiso,  RC_hisopadoResul = ?mesthiso "+mseg +" where id = ?mid"
		Else
			lcSql = "select * from ZabRegContagio where RC_nroregistracio = ?mnreg  and RC_fechaFin ='2100-01-01' and RC_fechaPasiva =?mfecnul and RC_virus = ?mvirus"
			tcCursor = 'mwkctgctrl'
			If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
				Return .F.
			Endif
			If mwkctgctrl.Id=0  Or  mid = 0
				lcSql = "Insert into ZabRegContagio( RC_estado , RC_fechaFin , RC_fechaInicio , RC_fechaPasiva , RC_nroregistracio ,"+;
					" RC_periodoLatencia , RC_virus, RC_ARM,RC_hisopadoFecha,  RC_hisopadoResul  )"+;
					" values (?mestctg ,?mfecfin , ?mfecini ,?mfecnul , ?mnreg,?mperlat,?mvirus,?marm,?mfechiso,?mesthiso )"
			Endif
		Endif
	Case mabm = 3
		lcSql = "update ZabRegContagio set RC_estado= 2, RC_fechaFin = ?mfecfin where id = ?mid"

	Case mabm = 4 &&Finalizo y creo nuevo
		lcSql = "select id,RC_estado,RC_hisopadoResul  from ZabRegContagio where RC_nroregistracio = ?mnreg and RC_virus = ?mvirus "+;
			" and RC_fechaFin = ?mfecfin  "
		tcCursor = 'mwkctgctrl'
		If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
			Return .F.
		Endif
		mid = mwkctgctrl.Id
		If mid>0
			lcSql = "update ZabRegContagio set RC_fechaFin = ?mfecha where id = ?mid"
			tcCursor = ''
			If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
				Return .F.
			Endif
			mest = mwkctgctrl.RC_estado
			mobs = "Finaliza por nueva ficha"
			mres =mwkctgctrl.RC_hisopadoResul
			lcSql = "Insert into ZabRegCtgLog( RCL_estado,RCL_hisopadoResul, RCL_idRegCtg,RCL_observaciones, RCL_usuario,RCL_fechahora  )"+;
				" values (?mest ,?mres, ?mid,?mobs  , ?musu,?mfechora )"
			tcCursor = ''
			If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
				Return .F.
			Endif
		Endif
		mid = 0
		mfecfin = Ctod("01/01/2100")
		lcSql = "Insert into ZabRegContagio( RC_estado , RC_fechaFin , RC_fechaInicio , RC_fechaPasiva , RC_nroregistracio ,"+;
			" RC_periodoLatencia , RC_virus, RC_ARM,RC_hisopadoFecha,  RC_hisopadoResul  )"+;
			" values (?mestctg ,?mfecfin , ?mfecini ,?mfecnul , ?mnreg,?mperlat,?mvirus,?marm,?mfechiso,?mesthiso )"
	Case mabm = 5
		If mid >1
			lcSql = "update ZabRegContagio set  RC_fechaFin = ?mfecfin   "+mseg +" where id = ?mid"
		Else
			If mid = 0
				lcSql = "Insert into ZabRegContagio( RC_estado , RC_fechaFin , RC_fechaInicio , RC_fechaPasiva , RC_nroregistracio ,"+;
					" RC_periodoLatencia , RC_virus, RC_ARM,RC_hisopadoFecha,  RC_hisopadoResul  )"+;
					" values (?mestctg ,?mfecfin , ?mfecini ,?mfecnul , ?mnreg,?mperlat,?mvirus,?marm,?mfechiso,?mesthiso )"
			Endif
		Endif


Endcase
tcCursor = ''

If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif

If mid=0
	lcSql = "select id from ZabRegContagio where RC_nroregistracio = ?mnreg  and RC_fechaInicio =  ?mfecini  and RC_virus = ?mvirus "+;
		" and RC_fechaFin = ?mfecfin and RC_hisopadoFecha = ?mfechiso and RC_hisopadoResul = ?mesthiso "
	tcCursor = 'mwkctgctrl'
	If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
		Return .F.
	Endif
	mid = mwkctgctrl.Id

Endif
If mid>0 And lcambio
	lcSql = "Insert into ZabRegCtgLog( RCL_estado,RCL_hisopadoResul, RCL_idRegCtg,RCL_observaciones, RCL_usuario,RCL_fechahora  )"+;
		" values (?mestctg ,?mesthiso, ?mid,?mobsvirus , ?musu,?mfechora )"
	tcCursor = ''
	If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
		Return .F.
	Endif
Endif
