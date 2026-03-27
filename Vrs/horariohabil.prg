mdmasx = Ttod(diahoy)
lndow  = Dow(mdmasx)
lcTime = Substr(Ttoc(mdmasx),12,5)
lnTime = Val(Strtran(Left(Ttoc(diahoy,2),5),":",""))
mdmasx_aux = mdmasx

Do sp_busco_feriado && MWKFeriados
If Reccount("MWKFeriados") > 0 Or lndow = 1 && FERIADO o domingo
	lsigue = .T.
Endif
If !lsigue
	mdmasx = mdmasx + 1
	Do sp_busco_feriado With " AND MOTIVO IN (1,8,10)" && MWKFeriados
	lbMedioFeriado = (Reccount("MWKFeriados") > 0)
	Use In Select("MWKFeriados")
	mdmasx = mdmasx_aux
Endif
*!*	----------------------------------------------------------------
lcWhere = " Where th_codserv = 8000 "
If !lsigue
	Do sp_busco_horarios_run With lcWhere, "mwkHorario"
	If Reccount("mwkHorario")> 0
		Select mwkHorario
		Go Top
		If lbMedioFeriado
			Locate For th_tipodia = 3
		Else
			If lndow = 7
				Locate For th_tipodia = 4
			Endif
		Endif
		lsigue = !Between(lnTime,Val(Strtran(Left(Ttoc(th_horadesde,2),5),":","")),Val(Strtran(Left(Ttoc(th_horahasta,2),5),":","")))
	Else
		lsigue = .T.
	Endif

Endif
