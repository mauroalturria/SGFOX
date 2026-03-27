Parameters mTexto

*!*	If !Used("letras")
*!*	Create Cursor letras (caracter c(1), codigo n(3))
*!*	Endif

mCadena = ""
mRetorno = ""
mGrabo = 1

If Len(mTexto)>0

	For a = 1 To Len(mTexto)

		mCar = Substr(mTexto,a,1)

		Do Case
		Case mCar = "<"
			mGrabo = 0
		Case mCar = ">"
			mGrabo = 1
		Endcase

		If mGrabo = 1
			If !mCar = Chr(10)
				mCadena = mCadena + mCar
*!*					Insert Into letras (caracter,codigo) Values (mCar,Asc(mCar))
			Else
				mCadena = mCadena + " "
			Endif
		Endif

	Endfor

	mRetorno = (Strtran(Alltrim(mCadena),">",""))

Endif

Return mRetorno