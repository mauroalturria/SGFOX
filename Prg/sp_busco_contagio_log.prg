Parameters mnreg,mbusco,tcCursor

If Vartype(mbusco)<>"C"
	mbusco= ''
Endif

If Vartype(tcCursor)<>"C"
	tcCursor = 'mwkregCtgLog'
Endif

mfecnul = Ctod("01/01/1900")

lcSql = "select ZabRegContagio.*,RCL_estado , RCL_fechahora , RCL_hisopadoResul , RCL_idRegCtg , RCL_observaciones , RCL_usuario"+;
	" ,RCL_usuario->nomape "+;
	" from ZabRegContagio,ZabRegCtgLog where ZabRegContagio.id = ZabRegCtgLog.RCL_idRegCtg  and  RC_nroregistracio = ?mnreg "+;
	" and RC_fechaPasiva =?mfecnul "+mbusco

If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
