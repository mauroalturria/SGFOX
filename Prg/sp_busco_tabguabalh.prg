parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ''
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntBalH'
endif


do case
	case tnOpcion = 1
		lcSql ="SELECT EB_protocolo, EB_fechaH, EB_hora, EB_tipo, EB_entsal,EB_volumen, EB_observa, EB_usuario,DESCRIP "+;
			"FROM TabGuaBalH  INNER JOIN TABESTADOS ON ( EB_tipo = ESTADO AND PROPIETARIO = 25 AND TIPO =1) " + tcWhere +;
			" ORDER BY EB_fechaH DESC "
		endcase

if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif
