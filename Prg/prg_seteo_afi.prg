Lparameters mxafi,mxcodent

Do Case
	Case Inlist( mxcodent , 100,101,711)
		mxAfiliado =ALLTRIM(Transform(mxafi))
		Do Case
			Case Len(mxAfiliado) < 9
				mxAfiliado = Padl(mxAfiliado,9,"0")
			Case Len(mxAfiliado) > 9
				mxAfiliado = Padl(Left(mxAfiliado, Len(mxAfiliado)-3),9,"0")
		Endcase
		cafiliado = mxAfiliado
	Case Inlist( mxcodent , 175, 75)
		cafiliado = Transform(mxafi,'99-99999999-9/99')

	Case Inlist( mxcodent , 149)
		cafiliado = Transform(mxafi,'99 999999 9 99')
	Otherwise
		cafiliado =ALLTRIM(Transform(mxafi))
Endcase
Return cafiliado
