parameters tnOpcion, tcWhere, tcCursor,tcjoin

if vartype(tcWhere) # "C"
	tcWhere = ''
endif
if vartype(tcjoin) # "C"
	tcjoin = ''
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntBalH'
endif

do case
	case tnOpcion = 1
		lcSql = "SELECT BHI_entsal, BHI_fecBaja, BHI_fechaBal, BHI_fechaH, BHI_fechahC, BHI_hora, BHI_horaC, "+;
			"BHI_idevol, BHI_observa, BHI_reprocesado, BHI_tipo, BHI_usuBaja, BHI_usuario, BHI_usuarioC, "+;
			"BHI_volColocado, BHI_volumen,DESCRIP "+;
			",TabIntBalH.id as idbal "+;
			"FROM TabIntBalH INNER JOIN TABESTADOS ON ( BHI_tipo = ESTADO AND PROPIETARIO = 25 AND TIPO =1) " +tcjoin+ tcWhere +;
			" ORDER BY BHI_fechaH desc "
	case tnOpcion = 2
		lcSql = "SELECT top 20 BHI_entsal, BHI_fecBaja, BHI_fechaBal, BHI_fechaH, BHI_fechahC, BHI_hora, BHI_horaC, "+;
			"BHI_idevol, BHI_observa, BHI_reprocesado, BHI_tipo, BHI_usuBaja, BHI_usuario, BHI_usuarioC, "+;
			"BHI_volColocado, BHI_volumen,DESCRIP "+;
			",TabIntBalH.id as idbal "+;
			"FROM TabIntBalH INNER JOIN TABESTADOS ON ( BHI_tipo = ESTADO AND PROPIETARIO = 25 AND TIPO =1) " +tcjoin+ tcWhere +;
			" ORDER BY TabIntBalH.id desc "
endcase

if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
