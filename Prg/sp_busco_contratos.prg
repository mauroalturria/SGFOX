****
** Busco Contratos
****

parameter mcodent, mcont,mtipo

mfecha= ctod('01/01/1900')

Use In Select("mwkcontratos")

if vartype(mcont)#"N"	&&& es el default
	mret = sqlexec(mcon1, "select contrato, CON_descricont " + ;
		"from entidcontr2, contratos " + ;
		"where entidcontr2.contrato = contratos.CON_codcont and " + ;
		"CON_fecpasiva is null and " + ;
		"(tipo = 'AMB' or (tipo is null)) and entidad = ?mcodent " + ;
		"order by entidad, contrato", "mwkcontratos")
else
	mret = sqlexec(mcon1, "select contrato, CON_descricont,entidad " + ;
		"from entidcontr2, contratos " + ;
		"where entidcontr2.contrato = contratos.CON_codcont and " + ;
		"CON_fecpasiva is null and " + ;
		"(tipo = ?mtipo or (tipo is null)) and contrato = ?mcont " + ;
		"order by entidad, contrato", "mwkcontratos")
endif
