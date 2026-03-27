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
	" TabProtQuir.* "+;
	"from TabProtQuir ,coberturas ,entidades, sectores,pacientes  " + ;
	"left join  tabusuario on pacientes.PAC_operadm = tabusuario.codigovax " +;
	"left join  afiliacion on " +;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	coberturas.cob_codentidad = afiliacion.AFI_codentidad " + ;
	"where cob_pacientes = PAC_codadmision and cob_codentidad   = ENT_codent "+;
	"and pac_codadmision = Codadmision and " + ;
	"PAC_sectorinternac = sec_codsector &mbusco1 " + ;
	"", "mwkpacint01")
	
mret = sqlexec(mcon1, "select PAC_nombrepaciente, PAC_edad, sec_codsector, " + ;
	"sec_descripsec, PAC_habitacion, PAC_cama, ENT_descrient, " + ;
	"PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, " + ;
	"PAC_horaadmision, PAC_codhci, HIS_codcontrato as COB_codcontrato , " + ;
	"PAC_codhce, AFI_nroafiliado, PAC_descripdiagn, PAC_operadm , PAC_operalta , " + ;
	"PAC_fechaalta,PAC_categoria, pac_domicilio,ENT_codent,idusuario, " + ;
	" TabProtQuir.* "+;
	" from TabProtQuir ,histambgua ,entidades ,pacientes  " + ;
	" left join sectores on pacientes.PAC_sectorinternac = sec_codsector " +;
	" left join  afiliacion on " +;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	histambgua.HIS_codentidad = afiliacion.AFI_codentidad " + ;
	" left join  tabusuario on pacientes.PAC_operadm = tabusuario.codigovax " +;
	" where PAC_codhci = his_nroregistrac and  HIS_codentidad  = ENT_codent "+;
	" and PAC_codadmision 	= Codadmision and his_codadmision = PAC_codadmision and " + ;
	" TipoPac>1 &mbusco1 " + ;
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
	padr(alltrim(nvl(PAC_descripdiagn,''))+alltrim(nvl(descripdiagn,'')),50) as PAC_descripdiagn  ;
	,nvl(MedicoAdmision,space(30)) as MedicoAdmision, iif(isnull(FirmaConsentimiento) or FirmaConsentimiento,"NO","si") as FC ,ENT_descrient, Observa  ;
	, PAC_codadmision, sec_codsector , nvl(sec_descripsec,space(50)) as sec_descripsec, PAC_sexo, PAC_edad, PAC_fechaadmision, PAC_codhce;
	,  nvl(PAC_categoria,"      ") as PAC_categoria, iif(isnull(mwkpacint0.fecpasiva),'  ','PE') as PAC_excl, ;
	iif(isnull(PAC_fechaalta),"          ",dtoc(PAC_fechaalta)) as PAC_fechaalta, AFI_nroafiliado,;
	tabusuario1.idusuario as operadmi, ;
	PAC_operadm , PAC_codhci,  TipoPac ,COB_codcontrato, pac_domicilio,ENT_codent  ;
	,tabusuario2.idusuario as operalta ;
	from mwkpacint0 ;
	left join  mwkusuariosall as tabusuario1 on PAC_operadm 	= tabusuario1.codigovax;
	left join  mwkusuariosall as tabusuario2 on PAC_operalta 	= tabusuario2.codigovax;
	group by PAC_codadmision order by PAC_nombrepaciente into cursor mwkpacint
msql_pac = "select  * from mwkpacint order by PAC_fechaadmision DESC,PAC_horaadmision DESC into cursor mwkpacint1 "
