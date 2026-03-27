
parameters mfiltrar ,musuario

mfecnul = ctod("01/01/1900")
mbusco= ''
IF mfiltrar = 1
	mbusco= " and UE_usuarioId = ?musuario and UE_fecpasiva = ?mfecnul "
endif
mret = sqlexec(mcon1," select  ENT_descrient,ENT_codent,UE_codent,UE_usuarioId,UE_fecpasiva   from entidades "+;
	" left join ZabUserEnti  on ZabUserEnti.UE_codent = entidades.ENT_codent "+;
	" where ENT_fecpas is null "+mbusco+"order by ENT_descrient ","mwkEntiUsu" )
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif





