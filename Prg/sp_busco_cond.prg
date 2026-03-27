Parameters tnRegistrac,tfecha ,tcwhere
If Vartype(tcwhere) # "C"
	tcwhere = ''
ENDIF
lcSql = " SELECT RCE_fechadesde , RCE_fechahasta , RCE_registracio , RCE_tipoCondesp , descrip "+;
	" FROM  ZabRegCondEsp "+;
	" INNER JOIN tabestados ON (RCE_tipoCondesp = tabestados.estado and propietario = 51 ) "+;
	" where RCE_registracio = ?tnRegistrac  and RCE_fechadesde <= ?tfecha and ?tfecha<RCE_fechahasta "+;
	tcwhere +" order by RCE_fechahasta desc,RCE_tipoCondesp  "

If !Prg_EjecutoSql(lcSql,"mwkdatocond",.F.)
	Return SPACE(100)
Endif
RETURN NVL(descrip,PADR("SIN CONDICION CARGADA",100))