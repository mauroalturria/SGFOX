****
** Busco Contratos para guardia
****

Parameter mcodentid

mfecha= ctod('01/01/1900')

if used('mwkcontratos')
	select mwkcontratos
	use
endif


mret = sqlexec(mcon1, "select contrato, CON_descricont " + ;
					"from entidcontr2, contratos " + ;
					"where entidcontr2.contrato = contratos.CON_codcont and " + ;
					"CON_fecpasiva is null and " + ;
					"entidad = ?mcodentid and " + ;
  					"(tipo = 'INT' or (tipo is null)) " + ;
					"order by contrato", "mwkcontratos")
