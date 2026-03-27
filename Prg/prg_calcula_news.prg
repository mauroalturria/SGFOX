*!*	 NEWS  National Early Warning Score
Parameters lnFR,lnSO2,lnTemp,lnTAS,lnFC,lnConc,lnreturn,LnO2Aux
lnreturn = Iif(Vartype(lnreturn)#"N" ,1,lnreturn)
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

	Do Case
	Case lnSO2 >= 96
		lnNEWS = lnNEWS + 0
	Case lnSO2 >= 94
		lnNEWS = lnNEWS + 1
	Case lnSO2 >= 92
		lnNEWS = lnNEWS + 2
	Otherwise
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"SO2"
	ENDCASE
	
	lnNEWS = lnNEWS + Iif(LnO2Aux= 1,2,0)
*	mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"O2"+Iif(LnO2Aux= 1,"+",+Iif(LnO2Aux= 2,"-","x"))
	
	Do Case
	Case lnTemp >= 39
		lnNEWS = lnNEWS + 2
	Case lnTemp >= 38
		lnNEWS = lnNEWS + 1
	Case lnTemp >= 36
		lnNEWS = lnNEWS + 0
	Case lnTemp >= 36
		lnNEWS = lnNEWS + 0
	Case lnTemp >= 35
		lnNEWS = lnNEWS + 1
	Otherwise
		lnNEWS = lnNEWS + 3
	Endcase

	Do Case
	Case lnTAS >= 220
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"TAS"
	Case lnTAS >= 110
		lnNEWS = lnNEWS + 0
	Case lnTAS >= 100
		lnNEWS = lnNEWS + 1
	Case lnTAS >= 90
		lnNEWS = lnNEWS + 2
	Otherwise
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"TAS"
	Endcase

	Do Case
	Case lnFC >= 130
		lnNEWS = lnNEWS + 3
		mlobs = mlobs + Iif(!Empty(mlobs),"-","")+"FR"
	Case lnFC >= 110
		lnNEWS = lnNEWS + 2
	Case lnFC >= 90
		lnNEWS = lnNEWS + 1
	Case lnFC >= 50
		lnNEWS = lnNEWS + 0
	Case lnFC >= 40
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
