****
** actualizo numero de plan en Registracio
****

Parameter  mreg,mplan,xcodent

mplan = IIF(ISNULL(mplan),0,mplan)
mret = SQLExec(mcon1, "update Registracio  set REG_distrito = ?mplan "+;
"  where REG_nroregistrac = ?mreg ")
If mret < 0
	=Aerr(eros)
	Messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	Messagebox(eros(3))
	mret = 0
Endif
mret = SQLExec(mcon1,"select * from afiliacion  " + ;
"where afiliacion.registracio  =?mreg and " + ;
"afiliacion.AFI_codentidad =?xcodent ", 'mwkctrlafi')
If !Empty(Field('AFI_idplan' ))
	mret = SQLExec(mcon1, "update afiliacion  set AFI_idplan = ?mplan "+;
	"  where registracio  = ?mreg  and AFI_codentidad =?xcodent ")
Endif
