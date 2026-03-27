*!*	Prestacions x Categoria
*!*	Parametros mCategoria
*!*	Resultado mwkPrestCat
*!*	------------------------------------------------------------------
lparameters mcategoria

do case

	case mcategoria = 0

		mret = sqlexec(mcon1, "SELECT PRESTACIONS.* " + ;
			"from prestacions " + ;
			"where pre_fechapasiva is null ", "mwkPrestTot" )

	case mcategoria = 1 && Infantiles

		mret = sqlexec(mcon1, "SELECT PRESTACIONS.* " + ;
			"from prestacions " + ;
			"where pre_fechapasiva is null and pre_descriprest like '%INFANT%' " + ;
			"or pre_descriprest like '%PEDIA%' " + ;
			"or pre_codprest in (81012200 , 25010210) ", "mwkPrestInf" )

	case mcategoria = 2 && Adultos

		mret = sqlexec(mcon1, "SELECT PRESTACIONS.* " + ;
			"from prestacions " + ;
			"where pre_fechapasiva is null and pre_descriprest not like '%INFANT%' " + ;
			"and pre_descriprest not like '%PEDIA%' " + ;
			"and pre_codprest not in (81012200 , 25010210) ", "mwkPrestAdul" )

endcase

if mret <= 0
	messagebox("Error al generar el cursor ",48 , "VALIDACION")
	cancel
endif

