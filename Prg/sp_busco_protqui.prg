
Parameters mNroRegis

*!*	mret = sqlexec(mcon1,"select pac_FechaAdmision,codadmision,Observa,idusuario,CON_descricont,ent_descrient,afi_nroAfiliado,"+;
*!*		"CON_descricont,pac_codhci,pac_codhce,pac_nombrepaciente,ent_codent, CodMedicoAdm,FirmaConsentimiento,MedicoAdmision,TipoPac,"+;
*!*		"codcie10diagn, descripdiagn,Urgencia, HIS_codentidad, HIS_codcontrato"+;
*!*		" from TabProtQuir ,histambgua ,entidades ,pacientes" + ;
*!*		" left join  afiliacion on pacientes.PAC_codhci = afiliacion.registracio and" + ;
*!*		" histambgua.HIS_codentidad = afiliacion.AFI_codentidad" + ;
*!*		" left join tabusuario on pacientes.PAC_operadm = tabusuario.codigovax" +;
*!*		" left join contratos on histambgua.HIS_codcontrato = contratos.CON_codcont" +;
*!*		" where his_nroregistrac = ?mNroRegis and Pac_codadmision = HIS_codadmision and  "+;
*!*		" HIS_codentidad  = ENT_codent and HIS_codadmision 	= Codadmision and " + ;
*!*		" his_codadmision = PAC_codadmision and TipoPac = 2 " + ;
*!*		" group by PAC_codadmision", "mwkpquir")

mret = SQLExec(mcon1,"select cast(CASE WHEN pacientes.pac_centromedico is null THEN 'SG ' "+;
	" ELSE CASE WHEN pacientes.pac_centromedico = 1 THEN 'SG ' ELSE "+;
	" CASE WHEN pacientes.pac_centromedico  = 3 THEN 'CPC' ELSE 'SG ' "+;
	" END END END As CHARACTER(3)) as paccentromedico ,"+;
	"pac_FechaAdmision,codadmision,Observa,idusuario,CON_descricont,ENT_descrient,ENT_nroprestadorexterno,afi_nroAfiliado,"+;
	"CON_descricont,pac_codhci,pac_codhce,pac_nombrepaciente,ent_codent, CodMedicoAdm,FirmaConsentimiento,MedicoAdmision,TipoPac,"+;
	"codcie10diagn, descripdiagn,Urgencia, HIS_codentidad, HIS_codcontrato,HIS_CondicImpositiva, PAC_horaadmision"+;
	" from TabProtQuir"+;
	" Join histambgua on his_nroregistrac = ?mNroRegis and HIS_codadmision = TabProtQuir.Codadmision"+;
	" Join Pacientes on pac_codadmision = his_codadmision"+;
	" Join entidades on ENT_codent = HIS_codentidad"+;
	" left join afiliacion on pacientes.PAC_codhci = afiliacion.registracio and histambgua.HIS_codentidad = afiliacion.AFI_codentidad" +;
	" left join tabusuario on pacientes.PAC_operadm = tabusuario.codigovax" +;
	" left join contratos  on histambgua.HIS_codcontrato = contratos.CON_codcont" +;
	" where TabProtQuir.TipoPac = 2", "mwkpquir")
&&	" group by PAC_codadmision", "mwkpquir")

If mret < 0
	=Aerror(eros)
	Messagebox(eros(3))
Endif


