*
* Hs y Minutos
*
Lparameters mval1, mval2, mtipo

mres = Space(20)

If !Isnull(mval1) And !Isnull(mval2)

	If mval1 <> {//} And mval2 <> {//}

		If Year(mval1) <> 1900 And Year(mval2) <> 1900

			If mtipo = "TXT"
				mseg = mval2 - mval1
				mmin = mseg / 60
				mhor = Int(Round(mmin,0) / 60)
				mres = mmin - (mhor * 60)
				mres = Transform(mhor,"@L 99")+" hs "+Transform(mres,"@L 99")+" min"
			Else
				mres = Transform(Round(((mval2 - mval1)/60)/60,2),'@L 99.99')
			Endif

		Endif

	Endif
Endif

Return mres
