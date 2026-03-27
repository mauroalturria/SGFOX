****
** busco los exe
****
parameter nf,msql_exe1, msql_exe2, mcual, mcoduser,mtipo

if mcual = 1
	mret = sqlexec(mcon1, "select * from tabexe  order by nomexe ", "mwkexe11"+nf)

	msql_exe1 = "select nomexe, descrip, " + ;
		"iif(fecpasiva = ctod('01/01/1900'), { / /  }, fecpasiva) as fecpasiva, id " + ;
		",icono,launcher,titulo "+;
		"from mwkexe11"+nf+" order by nomexe into cursor mwkexe0"+nf

endif

if mcual = 0		&& para ver cuales hay y cuales faltan
	do case
		case mtipo = 1   &&& permisos para usuarios
			mfecpas = ctod('01/01/1900')
			mret = sqlexec(mcon1, "select * from tabexe " + ;
				"where tabexe.id not in(select codexe " + ;
				"from tabpermisosexe where codusuario = ?mcoduser and " + ;
				" fecpasiva = ?mfecpas) " + ;
				" and tabexe.fecpasiva = ?mfecpas " + ;
				"order by nomexe", "mwkexe11"+nf)

			mret = sqlexec(mcon1, "select tabexe.id, nomexe " + ;
				",icono,launcher,titulo "+;
				"from tabpermisosexe, tabexe " + ;
				"where codusuario  = ?mcoduser and " + ;
				"tabpermisosexe.fecpasiva = ?mfecpas and " + ;
				"tabexe.fecpasiva = ?mfecpas and " + ;
				"codexe = tabexe.id " + ;
				"order by nomexe", "mwkexe22"+nf)

			msql_exe1 = 'select nomexe,titulo, id,icono,launcher from mwkexe11'+nf+'  order by nomexe into cursor mwkexe1'+nf
			msql_exe2 = 'select nomexe,titulo, id,icono,launcher from mwkexe22'+nf+'  order by nomexe into cursor mwkexe2'+nf

		case mtipo = 2   && permisos para sectores
			mfecpas = ctod('01/01/1900')
			mret = sqlexec(mcon1, "select * from tabexe " + ;
				"where codusuario  = 0 and tabexe.id not in(select codexe " + ;
				"from tabpermisosexe where codusuario  = 0 and codigovax = ?mcoduser and " + ;
				" fecpasiva = ?mfecpas) " + ;
				" and tabexe.fecpasiva = ?mfecpas " + ;
				"order by nomexe", "mwkexe11"+nf)

			mret = sqlexec(mcon1, "select tabexe.id, nomexe " + ;
				",icono,launcher,titulo "+;
				"from tabpermisosexe, tabexe " + ;
				"where codusuario  = 0 and codigovax = ?mcoduser and " + ;
				"tabpermisosexe.fecpasiva = ?mfecpas and " + ;
				"tabexe.fecpasiva = ?mfecpas and " + ;
				"codexe = tabexe.id " + ;
				"order by nomexe", "mwkexe22"+nf)

			msql_exe1 = 'select nomexe,titulo, id,icono,launcher   from mwkexe11'+nf+'  order by nomexe into cursor mwkexe1'+nf
			msql_exe2 = 'select nomexe,titulo, id,icono,launcher   from mwkexe22'+nf+'  order by nomexe into cursor mwkexe2'+nf

	endcase
endif


if mcual = 3		&& accesos de un codigovax
	mfecpas = ctod('01/01/1900')

	mret = sqlexec(mcon1, "select tabexe.id, nomexe " + ;
		",icono,launcher,titulo "+;
		"from tabpermisosexe, tabexe,tabusuario  " + ;
		"where " + ;
		"tabpermisosexe.codusuario = tabusuario.id and "+;
		"tabpermisosexe.fecpasiva = ?mfecpas and " + ;
		" tabusuario.codigovax = ?mcoduser and " + ;
		"tabexe.fecpasiva = ?mfecpas and " + ;
		"codexe = tabexe.id " + ;
		"order by nomexe", "mwkexe22"+nf)

	msql_exe2 = 'select nomexe,titulo, id,icono,launcher from mwkexe22'+nf+'  order by nomexe into cursor mwkexe2'+nf

endif
