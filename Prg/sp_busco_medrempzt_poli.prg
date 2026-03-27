****
** Busco medicos Ambulatorios + reemplazantes
****
lparameters mfecturno,micursor

if vartype(mfecturno) # "D"
	mfecturno = ttod(MWKFecServ.fechaHora)
endif

if vartype(micursor) # "C"
	micursor= 'mpkMedrpzt'
endif

mfecnul   = ctod("01/01/1900")

if used(micursor)
	use in &micursor
endif
mret = sqlexec(mcon3,'select CodAmbito , CodMed from tabprofambito '+;
	'where codambito = ?mxambito group by codmed ','mpkprofambito')
mwheres = ''

mret = sqlexec(mcon3, "SELECT prestadores.id, nombre, codesp, codespe, cast(matriculas as integer) as matricula " + ;
	" FROM prestadores " + ;
	" WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecturno) and dambula = 1 and " +;
	" (fecpasiva = ?mfecnul or fecpasiva > ?mfecturno) " + ;
	" union  " + ;
	"SELECT TabMedExterno.ID , nombre,'    ' as codesp, gerenciadora as codespe, matricula " + ;
	" FROM TabMedExterno " + ;
	" where fechaIngreso >= ?mfecturno and gerenciadora not in (0,222,373) " + ;
	" union " + ;
	"SELECT prestadores.id, nombre, codesp, codespe, cast(matriculas as integer) as matricula " + ;
	" FROM prestadores "+;
	" inner join TabProfFiltro on (Prestadores.id = TabProfFiltro.TPF_codmed and TabProfFiltro.tpf_filtro = 2) " + ;
	" ORDER BY nombre ", micursor)


if mret <= 0
	do Log_errores with error(), message(), message(1), program(), lineno()
	messagebox("ERROR DE LECTURA",48,"VALIDACION")
	return .f.
endif
