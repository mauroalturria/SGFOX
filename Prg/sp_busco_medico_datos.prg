***********
* Busqueda de datos de un Prestador
**********
Lparameters medid, mcCursor,mfecha,mTabUsuario,mbusco

If Vartype(medid)#"N"
	medid = 0
Endif
If Vartype(mbusco)#"C"
	mbusco = ''
Endif
mfecnull = Ctod("01/01/1900")
If Vartype(mcCursor)# "C"
	mcCursor = "mwkmeddat"
Endif
If Vartype(mTabUsuario) # "L"
	mTabUsuario = .F.
Endif

If mTabUsuario
	mret = SQLExec(mCon1,"Select * from TabUsuario where codigovax = ?medid and fecpasiva = '1900-01-01' ",mcCursor)
Else
	mcCursorusu = Alltrim(mcCursor)+"U"
	mret = SQLExec(mCon1,"Select * from TabUsuario where idcodmed = ?medid and idcodmed >1 and fecpasiva = '1900-01-01' "+mbusco,mcCursorusu)
	If medid>10000
		mret = SQLExec(mCon1,"select *,cast('' as char(1)) as sexo,matricula as matriculas,null as cuil,null as codespe,"+;
			"null as TPF_filtro, null as fecpasivap,CAST(1 as integer) as dambula   "+;
			"  from TabMedExterno where id = ?medid "+mbusco ,mcCursor)
	Else
		If medid = 0
			mret = SQLExec(mCon1,"SELECT Prestadores.id, nombre,codesp ,TPF_filtro,fecpasivap,matriculas,cuil,dambula " + ;
				" FROM Prestadores " + ;
				" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
				" WHERE (fecpasivap = ?mfecnull or fecpasivap >=?mfecha) " +mbusco+ ;
				" ORDER BY nombre", mcCursor)
		Else
			mret = SQLExec(mCon1,"select prestadores.*,TPF_filtro from prestadores  "+ ;
				" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
				" where prestadores.id = ?medid "+mbusco ,mcCursor)
		Endif
	Endif
Endif

If mret < 0
	Messagebox("EN CONSULTA DEL PROFESIONAL MEDICO",16,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
