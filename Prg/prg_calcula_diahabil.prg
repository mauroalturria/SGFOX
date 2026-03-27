*
* mfecha_Ini : Desde donde quiero calcular la primer fecha habil
* mnDiasH    : Si es valor positivo la primer fecha a partir de .._ini caso contrario la anterior fecha hábil
* mDiasNo    : "1,7"  No contemepla Domingo Ni sábado
*

Lparameters mfecha_Ini, mnDiasH, mDiasNo

Local K, I, mFecha_a
mFecha_a = iif(mnDiasH>0,ctod("01/01/2100"),ctod("01/01/1900"))
If vartyp(mDiasNo) # "C"
	mDiasNo = "1" && Domingo
Endif
K = mnDiasH
I = 1

If K > 0 && Dias Habiles para adelante
	msuma = .t.
Else
	msuma = .f.
	K = mnDiasH * -1
Endif

Do while I <> K+1
	mFecha_a = iif(msuma, mfecha_Ini+I, mfecha_Ini-I)
	mdmasx = mFecha_a
	If alltrim(str(dow(mFecha_a))) $ mDiasNo
		K = K + 1
	Else
		Do sp_busco_feriado
		Select MWKFeriados
		Count to mCant
		If mCant > 0 && Feriado
			K = K + 1
		Endif
	Endif
	I = I + 1
Enddo

Return mFecha_a
