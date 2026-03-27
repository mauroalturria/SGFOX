Lparameters xlnreg 
mireg = xlnreg
lcSql = "select  rc.id as idcontagio, rc_estado,tbe1.Descrip as resvirus "+;
"  from zabregcontagio rc "+;
" left join tabestados as tbe1 on tbe1.propietario = 45 and tbe1.tipo = 1 and tbe1.estado = rc.rc_estado "+;
" where rc.id = (select max(rcsub.id) from ZabRegContagio rcsub "+;
             " where rcsub.RC_nroregistracio = rc.RC_nroregistracio and RC_nroregistracio =?mireg "+;
             " AND rcsub.RC_virus = rc.RC_virus AND RC_FechaPasiva = '1900-01-01' )"

tcCursor = 'mwkctgreg'
If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
Return mwkctgreg.resvirus
