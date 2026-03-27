*!*	sp_actualizo_tabpqobs  observaciones de pre QX
parameters tnId, tncodmed,tnestado,tnorigen,tnobserva,tncodigovax

tnfechah = sp_busco_fecha_serv("DT")
tnpasivado  = tnfechah
if vartype(tnobserva )#"C"
	tnobserva  = ''
ENDIF
jj= 0
		ajj = jj+1+int(len(alltrim(tnobserva  ))/250)
		for i = jj+1 to ajj
			clin = "linea" + padl(i,3,"0")
			public &clin
		next
		mtnobserva  = prg_concat(alltrim(tnobserva),jj+1)
		if vartype(mtnobserva)#"C"
			mtnobserva  = "''"
		endif

mfecnul = ctod("01/01/1900")
lcSql = "Insert into TabPQobs" + ;
	" (PQO_codmed , PQO_estado , PQO_fechaobs , PQO_observa , PQO_origen , PQO_referencia , PQO_usuario  ) " + ;
	" Values " + ;
	" (?tncodmed, ?tnestado, ?tnfechah ,"+mtnobserva+", ?tnorigen, ?tnId, ?tncodigovax) "


if !Prg_EjecutoSql(lcSql,'',.f.)
	return .f.
endif

