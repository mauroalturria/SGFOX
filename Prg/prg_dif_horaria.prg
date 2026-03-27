* Diferencia Horaria
* mttIni = Desde
* mttFin = Hasta
* mtipo  = 'D' contempla Dias , caso contrario hs.
* mctrl  = señal si excede las hs. especificadas
* mtipo2 = 0 devuelve formato normal, 1 devuelve dias transcurridos solo variable mlndia

Lparameters mttIni,mttFin,mtipo,mctrl,mtipo2

If vartype(mctrl) # "N" && Controla diferencia horaria excedente a x hs.
	mctrl = 0
Endif
If Empty(mttFin)
	mttFin = sp_busco_fecha_serv('DT')
Endif
If vartype(mtipo2) # "N"
	mtipo2 = 0
Endif
mretorno =''
If mttFin >= mttIni
	mln    = mttFin - mttIni
	mlnSeg = MOD(mln,60)
	mln    = INT(mln/60)
	mlnMin = MOD(mln,60)
	mln    = INT(mln/60)
	mlnHor = MOD(mln,24)
	mlnDia = INT(mln/24)
	If mtipo2 = 0
		If mlnDia = 0 and mtipo = 'D'
			mtipo = 'H'
		Endif
		If mtipo = 'D'
			If mlnDia > 99
				mretorno = "**d"+TRAN(mlnHor,"@L 99")+":"+TRAN(mlnMin,"@L 99") && +":"+TRAN(mlnSeg,"@L 99")
			Else
				mretorno = TRAN(mlnDia,"@L 99")+"d"+TRAN(mlnHor,"@L 99")+":"+TRAN(mlnMin,"@L 99") && +":"+TRAN(mlnSeg,"@L 99")
			Endif
		Else
			mretorno = TRAN(mlnHor,"@L 99")+":"+TRAN(mlnMin,"@L 99")+":"+TRAN(mlnSeg,"@L 99")
		Endif
		If mctrl > 0
			If mlnDia > 0
				mlnHor = mlnHor + (mlnDia*24)
			Endif
			If mlnHor >= mctrl
				mretorno = mretorno + '+'
			Else
				mretorno = mretorno + ' '
			Endif
		Else
			mretorno = mretorno + ' '
		Endif
	Else
		mretorno = mlnDia
	Endif
Else
	If mtipo2 = 1
		mretorno = 0
	Endif
Endif
Return mretorno
