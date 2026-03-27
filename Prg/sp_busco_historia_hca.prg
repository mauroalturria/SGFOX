*
* Solicitud de HC
*

Lparameters mtipo, mestado

If vartype(mtipo) <> "C"
	mtipo = 'HCA'
Endif

If vartype(mestado) <> "N"
	mestado = 1
Endif

Use in select("mwksolicita")

mret = sqlexec(mcon1,"select REG_nombrepac, REG_nrohclinica, TLH_fechasol, HCE_descrip,  hca_estado"+;
	" from TabLGHce" +;
	" left join TabHCArchivo on hca_registrac = TLH_nroregis" +;
	" join registracio on REG_nroregistrac = TLH_nroregis" +;
	" left join TabHCEstado on TabHCEstado.hce_id = TabHCArchivo.hca_estado" +;
	" where TLH_tipo = ?mtipo and TLH_estado = ?mestado","mwksolicita")

If mret < 0
	Messagebox("CONSULTA REGISTRO HCE LEGALES SOLICITADAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Select REG_nombrepac as lpac, REG_nrohclinica as lhc, TLH_fechasol as lfsol,;
	iif( isnull(hca_estado), "S/CODBARRA",;
	iif( hca_estado = 0, "EN ARCHIVO",;
	iif( hca_estado = 1, "PREPARADO" ,;
	iif( hca_estado = 2, "EN CONSULTORIO", "FALTANTE" )))) as lesta;
	from mwksolicita into cursor mwksolicita

Return .T.

