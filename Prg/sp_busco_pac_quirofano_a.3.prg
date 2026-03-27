****
** busco internados
****

parameters msql_pac,mfecdes, mfechas

mbusco1 	= " and pac_fechaadmision >= ?mfecdes "
if mfechas < ttod(mwkfecserv.fechahora)
	mbusco1 = mbusco1 +  " and pac_fechaadmision <= ?mfechas "
endif

if !used('mwkusuariosall')
	do sp_busco_usuarios_all
endif
mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_edad, sec_codsector, " + ;
	"sec_descripsec, PAC_habitacion, PAC_cama, ENT_descrient, " + ;
	"PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, " + ;
	"PAC_horaadmision, PAC_codhci, cob_codcontrato, " + ;
	"PAC_codhce, AFI_nroafiliado, PAC_descripdiagn, PAC_operadm , PAC_operalta , " + ;
	"PAC_fechaalta,PAC_categoria, pac_domicilio,ENT_codent,idusuario, " + ;
	" TabProtQuir.* ,tabquirofano.id as idquirofano,Cirujano,Anestesista,Ayudante," + ;
	" BiopsiaIntraOp,BiopsioDiferida,Cardiologo,Cirujanote,Comentario,DuracEst,Edad, " + ;
	" EstComen,Estado ,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,HoraInic,Instrumen," + ;
	" Material,NroProtocolo,NroQuirofano,Operacion,Rayos, " + ;
	" Diagnostico, hemocomen,fechaquirof,MateComen  ,Nroregistrac,OperCod,codmed,quirofano,"+;
	"tabquirofano.id , Tabquiroflog . FechaMod , Tabquiroflog . UsuarioQ ,laboratorio,AnestesiaTipo,MatInstancia " + ;
	"from TabProtQuir ,pacientes ,coberturas ,entidades, sectores " + ;
	"left join  tabquirofano on tabquirofano.id = quirofano " +;
	"left join Tabquiroflog "+;
	" on ( Dato = PAC_codadmision and IdTabQuirofano = TabProtQuir.id ) "+;
	"left join  tabusuario on PAC_operadm = tabusuario.codigovax " +;
	"left join  afiliacion on " +;
	"	PAC_codhci = registracio and " + ;
	"	cob_codentidad = AFI_codentidad " + ;
	"where cob_pacientes = PAC_codadmision and cob_codentidad   = ENT_codent "+;
	"and pac_codadmision = Codadmision and " + ;
	"PAC_sectorinternac = sec_codsector and TipoPac = 1 &mbusco1 " + ;
	"", "mwkpacint01")
*	"left join  tabquirofano on nroregistrac = pac_codhci "
*	"left join  registracio on registracio.registracio = pac_codhci " +;
******************************
mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_edad, sec_codsector, " + ;
	"sec_descripsec, PAC_habitacion, PAC_cama, ENT_descrient, " + ;
	"PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, " + ;
	"PAC_horaadmision, PAC_codhci, HIS_codcontrato as COB_codcontrato , " + ;
	"PAC_codhce, AFI_nroafiliado, PAC_descripdiagn, PAC_operadm , PAC_operalta , " + ;
	"PAC_fechaalta,PAC_categoria, pac_domicilio,ENT_codent,idusuario, " + ;
	" TabProtQuir.*,tabquirofano.id as idquirofano,Cirujano,Anestesista,Ayudante," + ;
	" BiopsiaIntraOp,BiopsioDiferida,Cardiologo,Cirujanote,Comentario,DuracEst,Edad, " + ;
	" EstComen,Estado ,Hemoterapia,HoraEst,HoraEstDesp,HoraFin,HoraInic,Instrumen," + ;
	" Material,NroProtocolo,NroQuirofano,Operacion,Rayos, " + ;
	" Diagnostico, hemocomen,fechaquirof,MateComen  ,Nroregistrac,OperCod,codmed,quirofano,"+;
	"tabquirofano.id , Tabquiroflog . FechaMod , Tabquiroflog . UsuarioQ ,laboratorio,AnestesiaTipo,MatInstancia " + ;
	" from TabProtQuir ,pacientes ,histambgua ,entidades  " + ;
	"left join Tabquiroflog "+;
	" on ( Dato = PAC_codadmision and IdTabQuirofano = TabProtQuir.id ) "+;
	"left join  tabquirofano on tabquirofano.id = quirofano " +;
	" left join sectores on PAC_sectorinternac = sec_codsector " +;
	" left join  afiliacion on " +;
	"	PAC_codhci = registracio and " + ;
	"	HIS_codentidad = AFI_codentidad " + ;
	" left join  tabusuario on PAC_operadm = tabusuario.codigovax " +;
	" where PAC_codhci = his_nroregistrac and  HIS_codentidad  = ENT_codent "+;
	" and PAC_codadmision 	= Codadmision and his_codadmision = PAC_codadmision and " + ;
	" TipoPac = 2 &mbusco1 " + ;
	" group by PAC_codadmision", "mwkpacint02")

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
select * from mwkpacint01 union select * from mwkpacint02 into cursor mwkpacint0

mret = sqlexec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT' ","mwkentex")

select * from mwkpacint0 left join mwkentex on codent = ENT_codent  into cursor mwkpacint0

&&, PAC_operadmision , idusuario
&&	"left join  tabusuario on PAC_operadmision = tabusuario.codigovax " +

select PAC_nombrepaciente, hour(PAC_horaadmision)*100+minute(PAC_horaadmision) as PAC_horaadmision;
	, nvl(PAC_habitacion,"    ")+"-"+nvl(PAC_cama,"  ") as PAC_cama,;
	iif( !empty( nvl(PAC_descripdiagn,'') ), padr( alltrim(nvl(PAC_descripdiagn,'')),50),padr( alltrim(nvl(descripdiagn,'')),50) ) as PAC_descripdiagn  ;
	,nvl(MedicoAdmision,space(30)) as MedicoAdmision, ;
	iif(!FirmaConsentimiento,"si","NO") as FC,iif(isnull(FechaMod),"        ","Cumplido") as firmo ;
	,ENT_descrient, Observa  ;
	, PAC_codadmision, sec_codsector , nvl(sec_descripsec,space(50)) as sec_descripsec, PAC_sexo, ;
	PAC_edad, PAC_fechaadmision, PAC_codhce;
	,  nvl(PAC_categoria,"      ") as PAC_categoria, iif(isnull(mwkpacint0.fecpasiva),'  ','PE') as PAC_excl, ;
	iif(isnull(PAC_fechaalta),"          ",dtoc(PAC_fechaalta)) as PAC_fechaalta, AFI_nroafiliado,;
	iif(isnull(FechaMod),space(19),ttoc(fechamod)) as FechaMod, tabusuario1.idusuario as operadmi, ;
	PAC_operadm , PAC_codhci,  TipoPac ,COB_codcontrato, pac_domicilio,ENT_codent  ;
	,tabusuario2.idusuario as operalta ,nvl(diagnostico,'') as diagnostico,nvl(Operacion,'') as Operacion,;
	nvl(Cirujano,'') as Cirujano ;
	,nvl(Ayudante,'') as Ayudante,Hemoterapia,Rayos,Cardiologo , ;
	Material ,nvl(left(comentario,100)  ,'')as comentario,nvl(NroProtocolo,0) as NroProtocolo,;
	nvl(left(HemoComen,100),'') as HemoComen,nvl(estado,0) as estado;
	,BiopsiaIntraOp,BiopsioDiferida,CirujanoTE , DuracEst , Edad , EstComen ;
	,  FechaQuirof , HoraEst,HoraEstDesp, HoraFin,HoraInic, MateComen  ;
	,NroQuirofano,Nroregistrac, OperCod,codmed,Anestesista,Instrumen,idquirofano,quirofano,laboratorio,AnestesiaTipo,MatInstancia ;
	from mwkpacint0 ;
	left join  mwkusuariosall as tabusuario1 on PAC_operadm 	= tabusuario1.codigovax;
	left join  mwkusuariosall as tabusuario2 on PAC_operalta 	= tabusuario2.codigovax;
	group by PAC_codadmision order by PAC_nombrepaciente into cursor mwkpacint
msql_pac = "select  * from mwkpacint order by PAC_fechaadmision DESC,PAC_horaadmision DESC into cursor mwkpacint1 "
