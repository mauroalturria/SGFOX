Parameters tnIdTipo, tcBusco, tcCursor, tdFecD, tdFecH

*tnIdTipo = 10
*Set Step On

If varType(tcBusco) # "C"
	tcBusco= ''
Endif 

If varType(tcCursor) # "C"
	tcCursor = 'mwkQuiroPTipo'
Endif 

If varType(tdFecD) # "D"
	tdFecH = sp_busco_fecha_serv('DD')
 	tdFecD = tdFecH - 30
Endif 

lcSql = "select distinct TQF_Matricula, TQF_nombre " + ;
"from TabQuiroProf  " + ;
"where tqf_fecalta between ?tdFecD and ?tdFecH and " + ;
	"tqf_tipo = ?tnIdTipo and tqf_fecpasiva = '1900-01-01' and TQF_Matricula > 0  and TQF_CodMed = 0 " + tcBusco + ;
"group by TQF_Matricula " + ;
"Order by TQF_nombre " 

If !prg_ejecutosql(lcsql, tcCursor)
	Return .f.
Endif 

*!*	Select mwkQuiroPTipo
*!*	Browse 