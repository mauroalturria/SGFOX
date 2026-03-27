****
** busco internados
****
Parameters mbusco1, msql_pac, lpacvip, lnevaluado

If !Used('mwkusuariosall')
	Do sp_busco_usuarios_all
Endif

lret = .T.

If Vartype(lpacvip)#"N"
	lpacvip = 0
Endif

msep = ":"
If !Used('mwkplanpre')

	Use In Select("mwkplanpre")
	mret = SQLExec(mcon1, "select * from planes where fecpasivaplan  = '1900-01-01' ", "mwkplanpre")

Endif

If Vartype(lnevaluado)#"N"
	lnevaluado = 0
Endif
mfecpas = Ctod("01/01/1900")
mret = SQLExec(mcon1,"select ID , descripcion,Abreviatura, AbreviaEnt, CodEntAg,PlanCoseg "+;
	" from Planes where   FecPasivaPlan = ?mfecpas "  , "mwkallplan")
Select Val(Alltrim(Abreviatura)) As idplan,* From mwkallplan Into Cursor mwkplant
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = 	" and sec_codsector in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) "
Endif

If lnevaluado = 0

	mret = SQLExec(mcon1, "select PAC_nombrepaciente, PAC_edad, sec_codsector, " + ;
		"sec_descripsec, PAC_habitacion, PAC_cama, ENT_descrient, ENT_capita," + ;
		"PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, PAC_horaadmision, " + ;
		"PAC_codhci, PIN_codcontrato as COB_codcontrato, PAC_codhce,PAC_denuncia, " + ;
		"AFI_nroafiliado,AFI_idplan, PAC_descripdiagn, PAC_codmedicoadm, PAC_medicoadmision,PAC_operadm, PAC_operalta, PAC_fechaalta, " + ;
		"PAC_categoria, pac_domicilio,ENT_codent,idusuario,  TPV_Estado,"+;
		"PAC_ordeninternac,ORICodAutoriz,ORINroOrden, ORIObservac, ORITipoOrden, ORIVigDesde,oridiasvigencia, " + ;
		"pac_fotocrechab,pac_fotocdni,pac_fotoccarnetos,PAC_urgenprogramad, afiliacion.registracio as lregistracion " +;
		iif(mwkexe.nomexe = 'ADMISION',",tabaltatrans.codadmision ",",' ' ")+" as altatadm ,REG_tipodocumento, REG_numdocumento "+;
		iif(Inlist(mwkexe.nomexe ,'ADMISION', 'CONSULTAS'),",  pacinternad.PIN_codadmision as lid "," ")+",SEC_circaltas,"+;
		" PAC_nombrerespons,PAC_motivoadmision  "+;
		" from entidades, sectores, pacinternad" + ;
		" left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision" +;
		" left join TabPacVip on  pacientes.PAC_codhci = TabPacVip.TPV_NroReg" + ;
		" left join tabusuario on pacientes.PAC_operadm = tabusuario.codigovax" +;
		" left join afiliacion on pacientes.PAC_codhci = afiliacion.registracio and pacinternad.pin_codentidad = afiliacion.AFI_codentidad" + ;
		" left join ordeninternac on ordeninternac.oricodadmision = pacientes.PAC_codadmision"+;
		iif(mwkexe.nomexe = 'ADMISION' , " left join tabaltatrans on codadmision = pacientes.PAC_codadmision "," ")+;
		" left outer join registracio on registracio.reg_nroregistrac = pacientes.PAC_codhci "+;
		"where pin_codentidad   = ENT_codent and PAC_fechaalta is null and PAC_sectorinternac = sec_codsector "+ mbusco1 + ;
		mwcm, "mwkpacint0")

Else

	lcmedico = Left(mwkusuario.nomape,1)

	mret = SQLExec(mcon1, "select PAC_nombrepaciente, PAC_edad, sec_codsector, " + ;
		"sec_descripsec, PAC_habitacion, PAC_cama, ENT_descrient, ENT_capita," + ;
		"PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, PAC_horaadmision, " + ;
		"PAC_codhci, PIN_codcontrato as COB_codcontrato, PAC_codhce,PAC_denuncia, " + ;
		"AFI_nroafiliado,AFI_idplan, PAC_descripdiagn, PAC_codmedicoadm, PAC_medicoadmision,PAC_operadm, PAC_operalta, PAC_fechaalta, " + ;
		"PAC_categoria, pac_domicilio,ENT_codent,idusuario, TPV_Estado,"+;
		"PAC_ordeninternac,PAC_urgenprogramad,ORICodAutoriz,ORINroOrden, ORIObservac, ORITipoOrden, ORIVigDesde,oridiasvigencia, " + ;
		"pac_fotocrechab,pac_fotocdni,pac_fotoccarnetos " +;
		iif(mwkexe.nomexe = 'ADMISION',",tabaltatrans.codadmision ",",' ' ")+" as altatadm, SEC_circaltas,"+;
		" PAC_nombrerespons,PAC_motivoadmision  "+;
		"from entidades, sectores,pacinternad " + ;
		"left join  pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " +;
		" left outer join TabPacVip on  pacientes.PAC_codhci = TabPacVip.TPV_NroReg " + ;
		"left join  tabusuario on pacientes.PAC_operadm = tabusuario.codigovax " +;
		"inner join tabauditeval on  tae_codadmision  = pin_codadmision "+;
		"left join  afiliacion on " +;
		" pacientes.PAC_codhci = afiliacion.registracio and " + ;
		" pacinternad.pin_codentidad = afiliacion.AFI_codentidad " + ;
		"left join  ordeninternac on ordeninternac.oricodadmision = pacientes.PAC_codadmision "+;
		iif(mwkexe.nomexe = 'ADMISION'," left join tabaltatrans on codadmision = pacientes.PAC_codadmision "," ")+;
		"where pin_codentidad   = ENT_codent and PAC_fechaalta is null and " + ;
		"PAC_sectorinternac = sec_codsector "+ mbusco1 + mwcm, "mwkpacint0")


Endif


If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif

Select PAC_codhci From mwkpacint0 Where Inlist(Nvl(TPV_Estado,0),1,3) Into Cursor mwkpass

mwhere = Iif( lpacvip = 0,' where !INLIST(Nvl(TPV_Estado,0),1,3) ','')

mret = SQLExec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT'  and tipoturno = 0","mwkentex")

Select *,sp_busco_diagHCI(PAC_codadmision) As diagnoint,PAC_descripdiagn As diagnoadm;
	,alertaegreso(PAC_codhci,1) As alertas,Padr(alertaegreso(PAC_codhci,2),200) As calertas;
	From mwkpacint0;  &&sp_busco_diagHCI(PAC_codadmision) as diagnoint
Left Join mwkentex On mwkentex.codent = ENT_codent;
	&mwhere Into Cursor mwkpacint0


midiahoy = sp_busco_fecha_serv("DD")
If Inlist(mwkexe.nomexe ,'ADMISION', 'CONSULTAS')

	Select PAC_nombrepaciente, sec_codsector, sec_descripsec, PAC_habitacion, ;
		PAC_cama, tipoaisla(PAC_codadmision,PAC_categoria) As  PAC_categoria , ENT_descrient, Iif(Isnull(mwkpacint0.fecpasiva),'  ','PE') As PAC_excl, ;
		tabusuario1.idusuario As operadmi, PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision,;
		substr(Ttoc(PAC_horaadmision),12,5) As PAC_horaadmision, PAC_codhce, AFI_nroafiliado, ;
		PADR(diagnoint,40)  As PAC_descripdiagn, Iif(Isnull(ORItipoorden),"N","S") As orden ;
		,Iif(Isnull(ORItipoorden),"          ",Iif(Nvl(oridiasvigencia,0)=0	,"TOTAL     ", ;
		dtoc(PAC_fechaadmision+oridiasvigencia))) As vtoori ;
		,Alltrim(pac_fotocrechab )+" "+Alltrim(pac_fotocdni) + " "+Alltrim(pac_fotoccarnetos) As DocInCompl,;
		midiahoy -PAC_fechaadmision As diasint,ENT_codent,Padr(Nvl(mwkplanpre.descripcion,''),50) As plan,calertas;
		,PAC_codmedicoadm, PAC_medicoadmision,PAC_operadm, PAC_codhci,  COB_codcontrato, pac_domicilio  ;
		,tabusuario2.idusuario As operalta, ENT_capita,TPV_Estado;
		,ORICodAutoriz,ORINroOrden, ORIObservac, ORItipoorden, ORIVigDesde,;
		pac_denuncia,pac_fotocrechab,pac_fotocdni,pac_fotoccarnetos,pac_ordeninternac,PAC_urgenprogramad,altatadm,;
		REG_tipodocumento, REG_numdocumento, lid, lregistracion, SEC_circaltas,;
		PAC_nombrerespons,PAC_motivoadmision,ORIDIASVIGENCIA,tipogermen(PAC_codadmision,PAC_categoria) As germenes,diagnoadm,alertas ;
		From mwkpacint0 ;
		left Join  mwkusuariosall As tabusuario1 On PAC_operadm  = tabusuario1.codigovax;
		left Join  mwkusuariosall As tabusuario2 On PAC_operalta = tabusuario2.codigovax;
		Left Join mwkplanpre On  mwkplanpre.Id = AFI_idplan;
		group By PAC_codadmision Order By PAC_nombrepaciente,PAC_fechaadmision,PAC_horaadmision Into Cursor mwkpacint

Else

	Select PAC_nombrepaciente, sec_codsector, sec_descripsec, PAC_habitacion, ;
		PAC_cama,  tipoaisla(PAC_codadmision,PAC_categoria) As  PAC_categoria, ENT_descrient,;
		Iif(Isnull(mwkpacint0.fecpasiva),'  ','PE') As PAC_excl, ;
		tabusuario1.idusuario As operadmi, PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision,;
		substr(Ttoc(PAC_horaadmision),12,5) As PAC_horaadmision, PAC_codhce, AFI_nroafiliado, ;
		PADR(diagnoint,40)  As PAC_descripdiagn, Iif(Isnull(ORItipoorden),"N","S") As orden ;
		,Iif(Isnull(ORItipoorden),"          ",Iif(Nvl(oridiasvigencia,0)=0	,"TOTAL     ", ;
		dtoc(PAC_fechaadmision+oridiasvigencia))) As vtoori ;
		,Alltrim(pac_fotocrechab )+" "+Alltrim(pac_fotocdni) + " "+Alltrim(pac_fotoccarnetos) As DocInCompl;
		,midiahoy -PAC_fechaadmision As diasint,ENT_codent,Padr(Nvl(mwkplanpre.descripcion,''),50) As plan,calertas  ;
		,PAC_codmedicoadm, PAC_medicoadmision,PAC_operadm, PAC_codhci,  COB_codcontrato, pac_domicilio;
		,tabusuario2.idusuario As operalta, ENT_capita,TPV_Estado;
		,ORICodAutoriz,ORINroOrden, ORIObservac, ORItipoorden, ORIVigDesde,;
		pac_denuncia,pac_fotocrechab,pac_fotocdni,pac_fotoccarnetos,pac_ordeninternac,PAC_urgenprogramad,altatadm, SEC_circaltas,;
		PAC_nombrerespons,PAC_motivoadmision ;
		,REG_tipodocumento, REG_numdocumento,ORIDIASVIGENCIA,tipogermen(PAC_codadmision,PAC_categoria) As germenes,diagnoadm,alertas   ;
		From mwkpacint0 ;
		left Join  mwkusuariosall As tabusuario1 On PAC_operadm  = tabusuario1.codigovax;
		left Join  mwkusuariosall As tabusuario2 On PAC_operalta = tabusuario2.codigovax;
		Left Join mwkplanpre On  mwkplanpre.Id = Nvl(AFI_idplan,0);
		group By PAC_codadmision Order By PAC_nombrepaciente,PAC_fechaadmision,PAC_horaadmision Into Cursor mwkpacint

Endif

msql_pac = "select * from mwkpacint into cursor mwkpacint1"

*,IIF(pac_fotocrechab = "S" AND pac_fotocdni = "S" AND pac_fotoccarnetos = "S" AND pac_ordeninternac = "S" ,"S","N") as DocCompl

Function tipoaisla(mcadmision,mcat)

If Used('mwkpacaisla')
	Select mwkpacaisla
	Locate For apv_codadmision = mcadmision
	If Found() And mcat='A'
		Return Padr(mwkpacaisla.codaisla,20)
	Else
		Return Padr(mcat,20)
	Endif
Else
	Return mcat
Endif
Function tipogermen(mcadmision,mcat)

If Used('mwkpacaisla')
	Select mwkpacaisla
	Locate For apv_codadmision = mcadmision
	If Found()
		Return Padr(mwkpacaisla.germenes,250)
	Else
		Return Space(250)
	Endif
Else
	Return Padr(mcat,250)
Endif

Function alertaegreso(mnroregistra,ntipo )
Local ccar(10)
ccar(1) ='Vive Solo-'
ccar(2) ='Geriátrico-'
ccar(3) ='Alta Conflictiva-'
ccar(4) ='SIN DNI físico-'
nalerta = 0
calerta = ''
mret = SQLExec(mcon1,"select *   " + ;
	" from TabRegDatos " + ;
	" where TRDA_Registracio  =?mnroregistra " , "mwkregalert")
If Used("mwkregalert")
	If !Empty(Field('TRDA_Alerta1','mwkregalert'))
		For xi= 1 To 4
			cfield = 'mwkregalert.TRDA_Alerta' +Transform(xi,"@L 9" )
			If  Nvl(&cfield,0)=1
				nalerta = nalerta +1
				calerta = calerta + ccar(xi)
			Endif
		Next xi
	Endif
Endif
If ntipo = 1
	Return nalerta
Else
	Return calerta
Endif
