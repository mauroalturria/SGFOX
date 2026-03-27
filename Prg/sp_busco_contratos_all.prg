****
** Busco Contratos para guardia
****

Parameter mcodentid
if type ('mcodentid')="N"
	mbusca = ' entidad = ?mcodentid '
else
	mbusca = ' entidad in '+ mcodentid
endif
mfecha= ctod('01/01/1900')

mret = sqlexec(mcon1, "select contrato, CON_descricont ,entidad " + ;
					"from entidcontr2, contratos " + ;
					"where entidcontr2.contrato = contratos.CON_codcont and " + ;
					"CON_fecpasiva is null and " + ;
					" &mbusca " + ;
  					"order by contrato", "mwkcontratos")

if mret <0
	mret=0
	do prg_cancelo
endif	