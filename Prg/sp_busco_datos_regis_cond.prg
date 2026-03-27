Parameters tnRegistrac,tcwhere, tcCursor,lretorno

If Vartype(tcCursor) # "C"
	tcCursor= 'mwkregCond'
Endif
If Vartype(tcwhere) # "C"
	tcwhere = ''
Endif
If Vartype(lretorno) # "N"
	lretorno = 0
ENDIF
IF VARTYPE(tnRegistrac)="N"
lcSql = " SELECT ZabRegCondEsp.ID , CodAmbito , FecHorDbAdd , FecHorDbUpd , UserDbAdd , UserDbUpd , RCE_fechadesde "+;
	", RCE_fechahasta ,RCE_nroCertificado, RCE_registracio , RCE_tipoCondesp ,RCE_usuario, RCE_usuario->nomape, descrip,subestado"+;
	" FROM  ZabRegCondEsp "+;
	" INNER JOIN tabestados ON (RCE_tipoCondesp = tabestados.estado and propietario = 51) "+;
	" where RCE_registracio = ?tnRegistrac "+tcwhere +" order by RCE_fechahasta desc,RCE_tipoCondesp  "
ELSE
lcSql = " SELECT ZabRegCondEsp.ID , CodAmbito , FecHorDbAdd , FecHorDbUpd , UserDbAdd , UserDbUpd , RCE_fechadesde "+;
	", RCE_fechahasta ,RCE_nroCertificado, RCE_registracio , RCE_tipoCondesp ,RCE_usuario, RCE_usuario->nomape, tabestados.descrip,tabestados.subestado"+;
	" FROM  ZabRegCondEsp inner join pacientes on RCE_registracio =   pac_codhci "+;
	" INNER JOIN tabestados ON (RCE_tipoCondesp = tabestados.estado and propietario = 51) "+;
	" where pac_codadmision = ?tnRegistrac "+tcwhere +" order by RCE_fechahasta desc,RCE_tipoCondesp  "
endif

If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
If lretorno = 1
	Return  RCE_tipoCondesp
Endif
