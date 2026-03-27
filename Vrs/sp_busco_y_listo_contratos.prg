****
** Lista contratos por entidad
****

do sp_conexion


	mret = sqlexec(mcon1, "select ent_descrient, con_codcont, con_descricont, tipo " + ;
							"from entidades, contratos, entidcontr2 " + ;
							"where entidcontr2.contrato = contratos.con_codcont and " + ;
							"entidcontr2.entidad = entidades.ent_codent and " + ;
							"con_fecpasiva is null and tipo = 'GUA' and  " + ;
							"ent_fecpas is null order by ent_descrient", "mwkentcont")
							
**	"con_fecpasiva is null and (tipo = 'AMB' or (tipo is null)) and  " + ;						
							
	report form repentcont to printer prompt noconsole
							
=sqldisconnect(mcon1) 
							