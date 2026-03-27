** busco Cuentas de una admision
** Marcelo Torres, 02/10/2025. Agregué el join a entidades.
****
parameter mcodadm 
mret = sqlexec(mcon1, "select a.COB_fechacomcob, a.COB_codentidad,a.COB_CondicImpositiva,b.ent_descrient " + ;
	"from coberturas as a " + ;
	"left join entidades as b on a.COB_codentidad = b.ent_codent " +;
	"where a.COB_pacientes = ?mcodadm " + ;
	"order by a.COB_fechacomcob", "mwkctaint")
