Parameters mbusco1, mNomCur

If Vartype(mNomCur)# "C"
	mNomCur = "mwkpacamb"
Endif

mbusco1 = Upper(Iif(Vartype(mbusco1)#"C",'',mbusco1))
If Empty(FIELD('ENT_nroprestadorexterno','mwkentidad2'))
	Use In Select('mwkentidad2')
	mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_capita,ENT_tipo,ENT_nroprestadorexterno,ENT_codagrup  from entidades " + ;
		"where ENT_fecpas is null " + ;
		"order by ENT_descrient", "mwkentidad2")
Endif
If !Empty(mbusco1) And Not ("WHERE" $ mbusco1)
	mbusco1 = "WHERE " + mbusco1
Endif
If !Used('mwkMedrpzte')
	Do sp_busco_medrempzt_amb With Ctod("01/01/1900"),'mwkMedamb' && MWKMEDRPZT
	Do sp_busco_medrempzt With 1,,,,"INT"
	Select Id, nombre, codesp, codespe, matricula,codambitomed  From mwkMedamb ;
		UNION All Select Id, nombre,codesp,codespe,matricula ,1 As codambitomed ;
		FROM mwkMedicogua Where Id Not In (Select Id From mwkMedamb  );
		INTO Cursor mwkMedrpzte
Endif
If !Used('mwkserv')
	Do sp_servicio With 4
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and Tabambulatorio.codambito = ?mxambito "
Endif
Use In Select("tabestadosac")
Use In Select("Servicios")
Use In Select("mwkpacac")
Do sp_busco_estados With 26 , " order by descrip  ","Servicios"
Do sp_busco_estados With 28 , " order by descrip  ","tabestadosac"
Do sp_busco_estados With 23 ," order by descrip  ","tabsubestadosac"  &&& sub estados administrativos

msql =  "select " + ;
	"REGISTRACIO.REG_nroregistrac, REGISTRACIO.REG_nombrepac, REGISTRACIO.REG_email,  " + ;
	"REGISTRACIO.REG_nrohclinica, REGISTRACIO.REG_sexo, REGISTRACIO.REG_fecnacimiento, " + ;
	"Registracio.REG_numdocumento, REGISTRACIO.REG_telefonos,tabambulatorio.codent,"+;
	"TabAutPrevias.*,CAST(1 as integer) as tipopac,tabambulatorio.centromedico, " + ;
	"tabbacteriotipomuestra.ID as IdTipoMuestra, NVL(tabbacteriotipomuestra.BAC_codigomuestra,SPACE(5)) as CodTipoMuestra "+;
	", NVL(tabbacteriotipomuestra.BAC_descripmuestra,SPACE(50)) as  DescriTMuestra " +;
	"from TabAutPrevias " + ;
	"inner join registracio on TabAutPrevias.APV_registracio = REGISTRACIO.REG_nroregistrac " + ;
	"inner join tabambulatorio on TabAutPrevias.APV_protocolo = tabambulatorio.protocolo " + mccpoamb + ;
	"left join tabbacteriotipomuestra on TabAutPrevias.APV_codmuestra = tabbacteriotipomuestra.id " +;
	mbusco1 +  ;
	" group by TabAutPrevias.id "
mret = SQLExec(mcon1,msql,"mwkpacacambp")
If mret <= 0
	Messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

msql =  "select " + ;
	"REGISTRACIO.REG_nroregistrac, REGISTRACIO.REG_nombrepac, REGISTRACIO.REG_email,  " + ;
	"REGISTRACIO.REG_nrohclinica, REGISTRACIO.REG_sexo, REGISTRACIO.REG_fecnacimiento, " + ;
	"Registracio.REG_numdocumento, REGISTRACIO.REG_telefonos,tabambulatorio.codent,"+;
	"TabAutPrevias.*,CAST(1 as integer) as tipopac,tabambulatorio.centromedico, " + ;
	"tabbacteriotipomuestra.ID as IdTipoMuestra, NVL(tabbacteriotipomuestra.BAC_codigomuestra,SPACE(5)) as CodTipoMuestra"+;
	" , NVL(tabbacteriotipomuestra.BAC_descripmuestra,SPACE(50)) as  DescriTMuestra " +;
	"from TabAutPrevias " + ;
	"inner join registracio on TabAutPrevias.APV_registracio = REGISTRACIO.REG_nroregistrac " + ;
	"inner join tabambulatoriohis as tabambulatorio on TabAutPrevias.APV_protocolo = tabambulatorio.protocolo " + mccpoamb + ;
	"left join tabbacteriotipomuestra on TabAutPrevias.APV_codmuestra = tabbacteriotipomuestra.id " +;
	mbusco1 +  ;
	" group by TabAutPrevias.id "
mret = SQLExec(mcon1,msql,"mwkpacacambv")
If mret <= 0
	Messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

If Reccount( "mwkpacacambv")>0
	Select * From mwkpacacambp Union All ;
		SELECT * From mwkpacacambv;
		INTO Cursor mwkpacacamb
Else
	Select * From mwkpacacambp Into Cursor mwkpacacamb
Endif

msql =  "select " + ;
	"REGISTRACIO.REG_nroregistrac, REGISTRACIO.REG_nombrepac, REGISTRACIO.REG_email,  " + ;
	"REGISTRACIO.REG_nrohclinica, REGISTRACIO.REG_sexo, REGISTRACIO.REG_fecnacimiento, " + ;
	"Registracio.REG_numdocumento, REGISTRACIO.REG_telefonos,guardia.codent,"+;
	"TabAutPrevias.*,CAST(0 as integer) as  tipopac,tabambulatorio.centromedico, " + ;
	"tabbacteriotipomuestra.ID as IdTipoMuestra, NVL(tabbacteriotipomuestra.BAC_codigomuestra,SPACE(5)) as CodTipoMuestra"+;
	" , NVL(tabbacteriotipomuestra.BAC_descripmuestra,SPACE(50)) as  DescriTMuestra " +;
	"from TabAutPrevias " + ;
	"inner join registracio on TabAutPrevias.APV_registracio = REGISTRACIO.REG_nroregistrac " + ;
	"inner join guardia on TabAutPrevias.APV_protocolo = guardia.protocolo " +  ;
	"left join tabbacteriotipomuestra on TabAutPrevias.APV_codmuestra = tabbacteriotipomuestra.id " +;
	" left join tabambulatorio on TabAutPrevias.APV_protocolo = tabambulatorio.protocolo "+;
	mbusco1 +  ;
	" group by TabAutPrevias.id "
mret = SQLExec(mcon1,msql,"mwkpacacgua")
If mret <= 0
	Messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
Select * From mwkpacacamb Union All;
	SELECT * From mwkpacacgua ;
	into Cursor mwkpacac
*!*	mitiempo2 = SECONDS()
*!*	IF myip='172.16.1.7'
*!*		MESSAGEBOX(transform(mitiempo2 -mitiempo))
*!*	ENDIF
Select mwkpacac.*,nombre,'' As medrempl,tabestadosac.Descrip,matricula,tabestadosac.estado,;
	Servicios.Descrip As SER_descriprubro,ser_descripserv, ENT_descrient,ENT_nroprestadorexterno,ENT_codagrup,tabsubestadosac.Descrip As dessubestado ;
	,tabsubestadosac.tipo As tipocp,tabsubestadosac.subestado As subestadocp;
	from mwkpacac;
	left Join mwkserv On APV_servicio = ser_codserv;
	left Join Servicios On  APV_servicio=subestado  ;
	left Join mwkMedrpzte On  APV_CodMedicoSolic = mwkMedrpzte.Id;
	left Join tabestadosac On tabestadosac.subestado = APV_Estado ;
	left Join tabsubestadosac On tabsubestadosac.estado = APV_subestadopend  ;
	left Join mwkentidad2 On mwkpacac.codent = mwkentidad2.ent_codent ;
	GROUP By mwkpacac.Id;
	into  Cursor &mNomCur

Use In Select("tabestadosac")
Use In Select("Servicios")
Use In Select("tabsubestadosac")
