****
** Busco Derivaciones con ID en TabDerivacion
****
Parameter mbusca

mret = sqlexec(mcon1, "select tabderivacion.id, tabderivacion.codent, codint, denpolicial, " +;
	"derivadopor, diagnostico, edad, estado, tabderivacion.fechahora, notifica, " +;
	"nroafi, nroregistrac, observa, padron, sexo, traslado, usuario, " +;
	"ENT_descrient, REG_nombrepac, tabsectorint.descrip as sectorint, "+;
	"fechahoraingreso, tabderivacion.habitacion, tabderivacion.cama,REG_numdocumento as nrodocumento "+;
	"from tabderivacion, registracio, entidades, tabsectorint "+;
	"where nroregistrac = REG_nroregistrac and "+;
	"tabderivacion.codent = ENT_codent and codint = tabsectorint.id and "+;
	"tabderivacion.id = ?mbusca "+;
	"order by tabderivacion.fechahora", "mwkderiva3")

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_buscoderivaciones2-1',transf(mfecdes)
	Cancel
Endif

mret = sqlexec(mcon1, "select tabderivacion.id, tabderivacion.codent, codint,"+;
	"denpolicial, derivadopor, diagnostico, edad, estado,"+;
	"tabderivacion.fechahora, notifica, nroafi, nroregistrac,"+;
	"observa, padron, tabderivacion.sexo, traslado,"+;
	"tabderivacion.usuario, ENT_descrient, nombre as REG_nombrepac,"+;
	"tabsectorint.descrip as sectorint"+;
	",fechahoraingreso, tabderivacion.habitacion, tabderivacion.cama,preregistra.nrodocumento "+;
	"from tabderivacion,preregistra,entidades,tabsectorint " + ;
	"where nroregistrac = preregistra.id and " + ;
	"tabderivacion.codent = ENT_codent and codint = tabsectorint.id and " + ;
	"tabderivacion.id = ?mbusca " + ;
	"order by tabderivacion.fechahora", "mwkderiva4")

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_buscoderivaciones2-2',transf(mfecdes)
	Cancel
Else
	Select * from mwkderiva3 ;
		union all ;
		select * from mwkderiva4 ;
		into cursor mwkderiva
Endif
