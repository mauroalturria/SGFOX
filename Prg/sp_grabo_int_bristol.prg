*
* Graba protocolo de la atencion
*
Parameters  mtipomov,mcursor,mcodigoent

mfHoy   = prg_dtoc(sp_busco_fecha_serv('DT'))
mfecorden = Left(mfHoy  ,10)
musua 	= Alltrim(mwkusuario.idusuario)
If mwkusuario.idusuario = "CFUNES"
	Set Step On
Endif
mfechaingr = prg_dtoc(Ctot(Dtoc(&mcursor->pac_fechaadmision)+" "+Ttoc(&mcursor->pac_horaadmision,2)))
If !Isnull(&mcursor->PAC_fechaalta)
	mfechaegr = prg_dtoc(Ctot(Dtoc(&mcursor->pac_fechaalta)+" "+Ttoc(&mcursor->pac_horaalta,2)))
	mmotivoegreso = Nvl(&mcursor->PAC_motivoalta,0)
Else
	mfechaegr = '2100-01-01 00:00:00'
	mmotivoegreso = 0
Endif
msector = Alltrim(&mcursor->PAC_sectorinternac)
If !Used('mwkSecagrup')
	mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
		",TSA_FechaDesde,TSA_FechaHasta "+;
		" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+;
		" AND TSA_Tipo = 3 ORDER BY sector, TSA_FechaHasta ", "mwkSecagrup")
Endif
Select mwkSecagrup
Locate For sector = msector
If Found()
	msector = Alltrim(mwkSecagrup.sectoragrup)
Endif
mcodadm	= &mcursor->PAC_codadmision
ctipomov = Iif(mtipomov=1,"I",Iif(mtipomov=2,"E",Iif(mtipomov=3,"M","N" ) ) )

mdiagno = Alltrim(Iif(Inlist(mtipomov,1,3), &mcursor->PAC_descripdiagn,''))  &&&&mcursor->PAC_diagegreso
mnroreg = &mcursor->PAC_codhce
mctexto = Alltrim(mnroreg )
mbusco1 = "where registracio.REG_nrohclinica = ?mctexto and "
Do sp_busco_nombre_paciente_1 With mbusco1, 1, ''
Select * From mwkbuspacie Where ENT_codent = mcodigoent;
	into Cursor mwkbuspacie1
mnrodoc = Round(mwkbuspacie1.REG_numdocumento,0)
mtipodoc = Round(Val(mwkbuspacie1.REG_tipodocumento),0)
mnroafil = Alltrim(Chrtran(prg_saca_char(mwkbuspacie1.AFI_nroafiliado)," ",""))
mapel = Alltrim(Left(mwkbuspacie1.reg_nombrepac,At(",",mwkbuspacie1.reg_nombrepac)-1))
mnombre = Alltrim(Substr(mwkbuspacie1.reg_nombrepac,At(",",mwkbuspacie1.reg_nombrepac)+1))
msex = Alltrim(mwkbuspacie1.reg_sexo)
mfecnac = Left(prg_dtoc(mwkbuspacie1.REG_fecnacimiento),10)
If mcodigoent=948
	mret = SQLExec(mcon1,"select * from SQLUser.PadCabe "+;
		" left join padotrosdatos on padotrosdatos.idpadcabe=padcabe.id "+;
		" where Padcabe.NroAfiliado = ?mnroafil and Padcabe.entidad = 948 "+;
		" order by padotrosdatos.FechaDesde desc","mwkctrlpad")
	If mret < 0
		=Aerror(merror)
		Messagebox("EN CONSULTA PADRONES"+Chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		mcodigoent = 11
	Else
		menttipo = Val(mwkctrlpad.contenido)
		If menttipo >0
			mcodigoent = menttipo
		Else
			mcodigoent = Iif(Alltrim(mwkctrlpad.contenido)='GASMBA',19,;
				iif(Alltrim(mwkctrlpad.contenido)='GASTRO',11,11 ) )
		Endif
	Endif
Endif
mret = SQLExec(mcon1, "insert into Bristol.SG_INTERNACION (" + ;
	"OS_ID,NROAFIL,TIPODOC,NRODOC,APELLIDO,NOMBRE,SEXO,FECHANAC "+;
	",FECHORAING,DIAGNOSTICO,FECHORAEGR,FECHAORDEN,LUGARINTERNAC"+;
	",CODADMISION,TIPOMOV,USUARIO,FECHAHORA, Motivoegreso ) "+;
	"values(" + ;
	"?mcodigoent,?mnroafil ,?mtipodoc , ?mnrodoc , ?mapel  " + ;
	",?mnombre, ?msex, ?mfecnac, ?mfechaingr, ?mdiagno,?mfechaegr,?mfecorden "+;
	",?msector,?mcodadm,?ctipomov,?musua, ?mfHoy, ?mmotivoegreso )")
If mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	mret = SQLExec(mcon1, "insert into Bristol.SG_INTBAK (" + ;
		"OS_ID,NROAFIL,TIPODOC,NRODOC,APELLIDO,NOMBRE,SEXO,FECHANAC "+;
		",FECHORAING,DIAGNOSTICO,FECHORAEGR,FECHAORDEN,LUGARINTERNAC"+;
		",CODADMISION,TIPOMOV,USUARIO,FECHAHORA, Motivoegreso ) "+;
		"values(" + ;
		"?mcodigoent,?mnroafil ,?mtipodoc , ?mnrodoc , ?mapel  " + ;
		",?mnombre, ?msex, ?mfecnac, ?mfechaingr, ?mdiagno,?mfechaegr,?mfecorden "+;
		",?msector,?mcodadm,?ctipomov,?musua, ?mfHoy, ?mmotivoegreso )")
	If mret<1

		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
Endif
