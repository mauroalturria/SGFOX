*
* mfecha_Ini : Desde donde quiero calcular la primer fecha habil
* mfecha_fin : Si es valor positivo la primer fecha a partir de .._ini caso contrario la anterior fecha hábil
* mDiasNo    : "1,7"  No contemepla Domingo Ni sábado
*

lparameters mfecha_Ini, mfecha_fin, mDiasNo

local K, I, mFecha_a
if vartype(mfecha_Ini)="D"

	mFecha_a = mfecha_Ini
	if vartyp(mDiasNo) # "C"
		mDiasNo = "1" && Domingo
	endif
	if vartyp(mfecha_fin) # "D"
		mfecha_fin = sp_busco_fecha_serv("DD")
	endif
	if  mfecha_fin >= mfecha_Ini

		K = mfecha_fin - mfecha_Ini
		I = 1
		fer = 0
		for xind = 1 to K+1
			mdmasx = mFecha_a
			if alltrim(str(dow(mFecha_a))) $ mDiasNo
				fer = fer + 1
			else
				do sp_busco_feriado
				select MWKFeriados
				count to mCant
				if mCant > 0 && Feriado
					fer = fer + 1
				endif
			endif
			mFecha_a = mFecha_a + 1
		next
		return (k-fer)
	else
		return 0
	endif
else
	return 0
endif
