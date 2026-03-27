****
** busco contratos de una admision
****

parameter mcodadm, mcodhce, msql_con, msql_ent

mret = sqlexec(mcon1, "select COB_fechacomcob, CON_descricont, AFI_nroafiliado, " + ;
	"ENT_descrient,COB_codentidad,COB_CondicImpositiva " + ;
	"from coberturas, contratos, entidades, registracio, afiliacion " + ;
	"where COB_codcontrato = CON_codcont and " + ;
	"COB_codentidad = ENT_codent and " + ;
	"REG_nrohclinica = ?mcodhce and " + ;
	"REG_nroregistrac = afiliacion.registracio and " + ;
	"COB_codentidad   = AFI_codentidad and " + ;
	"COB_pacientes = ?mcodadm " + ;
	"order by COB_fechacomcob", "mwkcont")

msql_con = "select COB_fechacomcob, CON_descricont from mwkcont into cursor mwkcont1"
msql_ent = "select distinct AFI_nroafiliado, ENT_descrient from mwkcont into cursor mwkent"
