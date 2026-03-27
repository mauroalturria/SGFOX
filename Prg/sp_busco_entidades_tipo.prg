****
** Busco Entidades con contrato por tipo
****

parameter mtipo,mbusco

if vartype(mbusco)#"C"
	mbusco= ''
endif
mfecha= ctod('01/01/1900')
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_nroprestadorexterno,ENT_codagrup from entidcontr2 " + ;
		"where ENT_fecpas is null order by ENT_descrient", "mwkentidad")
mret = sqlexec(mcon1, "select contrato, CON_descricont " + ;
		"from entidades,entidcontr2, contratos " + ;
		"where entidcontr2.contrato = contratos.CON_codcont and " + ;
		"CON_fecpasiva is null and ENT_fecpas is null and  " + ;
		"(tipo = ?mtipo or (tipo is null)) and entidad = ENT_codent " + ;
		"group by ENT_codent ", "mwkcontratos")
else
	mret = sqlexec(mcon1, "select contrato, CON_descricont,entidad " + ;
		"from entidcontr2, contratos " + ;
		"where entidcontr2.contrato = contratos.CON_codcont and " + ;
		"CON_fecpasiva is null and " + ;
		"(tipo = ?mtipo or (tipo is null)) and contrato = ?mcont " + ;
		"order by entidad, contrato", "mwkcontratos")
endif
