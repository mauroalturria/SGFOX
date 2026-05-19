*!*	 NEWS  National Early Warning Score
Parameters lnFR,lnSO2,lnTemp,lnTAS,lnFC,lnConc,lnreturn,LnO2Aux,lnepoc
lnreturn = Iif(Vartype(lnreturn)#"N" ,1,lnreturn)
lnepoc= Iif(Vartype(lnepoc)#"L" ,.F.,lnepoc)
Local lnNEWS,mlobs
If Vartype(LnO2Aux)#"N"
	LnO2Aux=3
Endif
mlobs = ''
lnNEWS = 0
If lnFR*lnSO2*lnTemp*lnTAS*lnFC*lnConc*LnO2Aux  = 0
	lnNEWS = -1
Else

	Do Case
	Case lnFR >= 25
		lnNEWS = lnNEWS + 3
		mlobs = mlobs +"FR"
	Case lnFR >= 21
		lnNEWS = lnNEWS + 2
	Case lnFR >= 12
		lnNEWS = lnNEWS + 0
	Case lnFR >= 9
		lnNEWS = lnNEWS + 1
	Otherwise
		lnNEWS = lnNEWS + 3
		mlobs = mlobs +"FR"

	Endcase
	If lnepoc
		Do Case
		Case lnSO2 >= 97
			lnNEWS = lnNEWS + 3
			mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"SO2"
		Case lnSO2 >= 95
			lnNEWS = lnNEWS + 2
		Case lnSO2 = 94
			lnNEWS = lnNEWS + 1
		Case lnSO2 = 93
			lnNEWS = lnNEWS + Iif(LnO2Aux = 2,0,1)
		Case lnSO2 >= 88
			lnNEWS = lnNEWS + 0
		Case lnSO2 >= 86
			lnNEWS = lnNEWS + 1
		Case lnSO2 >= 84
			lnNEWS = lnNEWS + 2
		Otherwise
			lnNEWS = lnNEWS + 3
			mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"SO2"
		Endcase
	Else

		Do Case
		Case lnSO2 > 95
			lnNEWS = lnNEWS + 0
		Case lnSO2 >  93
			lnNEWS = lnNEWS + 1
		Case lnSO2 > 91
			lnNEWS = lnNEWS + 2
		Otherwise
			lnNEWS = lnNEWS + 3
			mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"SO2"
		Endcase
	Endif
	lnNEWS = lnNEWS + Iif(LnO2Aux= 1,2,0)
*	mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"O2"+Iif(LnO2Aux= 1,"+",+Iif(LnO2Aux= 2,"-","x"))

	Do Case
	Case lnTemp > 39
		lnNEWS = lnNEWS + 2
	Case lnTemp > 38
		lnNEWS = lnNEWS + 1
	Case lnTemp > 36
		lnNEWS = lnNEWS + 0
	Case lnTemp >  35
		lnNEWS = lnNEWS + 1
	Otherwise
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"Temp."
	Endcase

	Do Case
	Case lnTAS >= 220
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"TAS"
	Case lnTAS > 110
		lnNEWS = lnNEWS + 0
	Case lnTAS >  100
		lnNEWS = lnNEWS + 1
	Case lnTAS >  90
		lnNEWS = lnNEWS + 2
	Otherwise
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"TAS"
	Endcase

	Do Case
	Case lnFC >=  131
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"FR"
	Case lnFC >=  111
		lnNEWS = lnNEWS + 2
	Case lnFC >= 91
		lnNEWS = lnNEWS + 1
	Case lnFC >= 51
		lnNEWS = lnNEWS + 0
	Case lnFC >= 41
		lnNEWS = lnNEWS + 1
	Otherwise
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"FR"
	Endcase
	If lnConc>1
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"NC"
	Endif

Endif
If lnreturn =1
	Return lnNEWS
Else
	Return mlobs
Endif
*!*	=PuntosFR + PuntosSaO2 + PuntosO2 + PuntosPAS + PuntosFC + PuntosConsc + PuntosTemp
*!*	(Nota: Ajusta esta fórmula según los rangos estándar de NEWS2:
*!*	\(\le 8\) (3 ptos),
*!*	9-11 (1 pto),
*!*	12-20 (0 ptos),
*!*	 21-24 (2 ptos),
*!*	 \(\ge 25\) (3 ptos))
