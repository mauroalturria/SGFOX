* Sp_Busco_Tablas_Calidad
* Fecha: Julio 2016 - Fabián

*mConsulta = "select *, Cast(0 as int) as logico from tabexe where fecpasiva = '1900-01-01' order by descrip"
mConsulta = "select * from tabexe where fecpasiva = '1900-01-01' order by descrip"
If !prg_ejecutosql(mConsulta,"mwkTabExe")
Return .F.
Endif


Consulta = "Select * From TabExeGrupo Where TEG_Fechabaja = '1900-01-01'"
If !prg_ejecutosql(Consulta,"mwkTabExegrupo")
	Return .F.
Endif

Return .f.