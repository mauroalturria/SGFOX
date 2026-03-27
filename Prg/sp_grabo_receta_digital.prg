Parameters mnreg,morigrec,musu,mevolrec
mfechora = sp_busco_fecha_serv("DT")

lcSql = "Insert into ZabRegReceta( RP_fechaHora , RP_indicacion , RP_nroregistrac , RP_usuario  )"+;
	" values (?mfechora ,?mevolrec, ?mnreg, ?musu  )"

tcCursor = ''
If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
