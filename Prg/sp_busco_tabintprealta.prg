Parameters tnOpcion, tcWhere, tcCursor,tcInter

If Vartype(tcWhere) # "C"
	tcWhere = ' '
Endif

If Vartype(tcInter) # "N"
	tcInter = 0
Endif
mjoin = ''
mpasivo = ''
If tcInter= 1
	mjoin = " inner join pacinternad on pin_codadmision  = pacientes.pac_codadmision "
	mpasivo = " and IPA_pasivado='1900-01-01' "

Endif
If Vartype(tcCursor) # "C"
	tcCursor= 'mwkIntprealta'
Endif
Do Case
Case tnOpcion = 1
	lcSql = "SELECT TabIntPreAlta.* "+;
		" FROM TabIntPreAlta "+ tcWhere
Case tnOpcion = 2

	lcSql =	"SELECT	TabIntFPA.*, IPA_admision , IPA_codmed , IPA_destino , IPA_fechah , IPA_observa , "+;
		" IPA_pasivado , IPA_profSegAmb , IPA_reqAmbu , IPA_reqCuiDom , IPA_reqDieta , IPA_reqEduca, "+;
		" IPA_reqSegAmb , IPA_verImplem , IPA_verPacInf , IPA_verResInf,"+;
		" prestadores.nombre,prestadores.matriculas,"+;
		" TabMedExterno.nombre as nombreE,TabMedExterno.matricula as matriculasE,pacientes.*, "+;
		" ent_codent,ent_descrient,TabIntPreAlta.id as idpa,prestadores.codesp  "+;
		" from TabIntFPA "+;
		" left join TabIntPreAlta on TabIntFPA.IFA_admision = TabIntPreAlta.IPA_admision "+;
		" inner join pacientes on pacientes.pac_codadmision = TabIntFPA.IFA_admision "+;
		mjoin +;
		" inner join coberturas on pacientes.pac_codadmision = coberturas.COB_pacientes "+;
		" inner join entidades on entidades.ent_codent = coberturas.COB_codentidad "+;
		" LEFT OUTER join prestadores on TabIntFPA.IFA_codmed = prestadores.id "+;
		" LEFT OUTER join TabMedExterno on TabIntFPA.IFA_codmed = TabMedExterno.id "+;
		" where IPA_codmed>1 and IFA_pasivado = '1900-01-01' " + tcWhere

Case tnOpcion = 3

	lcSql =	"SELECT	TabIntFPA.*, IPA_admision , IPA_codmed , IPA_destino , IPA_fechah , IPA_observa , "+;
		" IPA_pasivado , IPA_profSegAmb , IPA_reqAmbu , IPA_reqCuiDom , IPA_reqDieta , IPA_reqEduca, "+;
		" IPA_reqSegAmb , IPA_verImplem , IPA_verPacInf , IPA_verResInf,IPA_dialisis,"+;
		" prestadores.nombre,prestadores.matriculas,"+;
		" TabMedExterno.nombre as nombreE,TabMedExterno.matricula as matriculasE,pacientes.*, "+;
		" ent_codent,ent_descrient,TabIntPreAlta.id as idpa,prestadores.codesp ,PAC_fechaadmision "+;
		" from TabIntPreAlta "+;
		" left join TabIntFPA on TabIntFPA.IFA_admision = TabIntPreAlta.IPA_admision "+;
		" inner join pacientes on pacientes.pac_codadmision = TabIntPreAlta.IPA_admision "+;
		mjoin +;
		" inner join coberturas on pacientes.pac_codadmision = coberturas.COB_pacientes "+;
		" inner join entidades on entidades.ent_codent = coberturas.COB_codentidad "+;
		" LEFT OUTER join prestadores on TabIntPreAlta.IPA_codmed = prestadores.id "+;
		" LEFT OUTER join TabMedExterno on TabIntPreAlta.IPA_codmed = TabMedExterno.id "+;
		" where 1=1 " +mpasivo + tcWhere 

Otherwise
	Return .F.
Endcase
If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
