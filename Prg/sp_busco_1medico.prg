parameters mMatricula

if !used("mwkmedicoexterno")
	mret = sqlexec(mcon1,"select id as codmedt, nombre, matricula, TipoMat, codesp " + ;
		"from tabmedexterno " + ;
		"where gerenciadora = 0 ", "mwkmedicoexterno" )
Endif 	
if !used("mwkmedicoprest")
	mret = sqlexec(mcon1,"select id as codmedt, nombre, matriculas, MatProv, codesp  " + ;
		"from prestadores ", "mwkmedicoprest" )
Endif 	

select codmedt, nombre, codesp, matricula ;
	from mwkmedicoexterno ;
	where Matricula = mMatricula ;
Union ;
select codmedt, nombre, codesp, val(matriculas) as matricula ;
	from mwkmedicoprest ;
	where val(Matriculas) = mMatricula ;
	into cursor mwk1medico

