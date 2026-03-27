Lparameters mce,miform,miafi
If Vartype(miafi)#"C"
	If Used('mwkafient1')
		miafi = Alltrim(mwkafient1.afi_nroafiliado)
	Else
		miafi= ''
	Endif
Endif
If miform.BaseClass = "Container"
	mprop = ".txtafiliado.parent.parent"
Else
	mprop = ".txtafiliado.parent"
Endif
With miform
	.txtafiliado.InputMask = ''

	Do Case
		Case Inlist( mce, 175, 75)
*		.txtafiliado.InputMask = '99-99999999-9/99'
			.txtafiliado.Value	= Chrtran(miafi ," -/","")
			With &mprop
				.lcontrolnro=.T.
			Endwith
		Case Inlist( mce, 704, 876) &&PAMI
*		.txtafiliado.InputMask = '999999999999-99'
			.txtafiliado.Value	= Chrtran(miafi ," -/","")
			With &mprop
				.lcontrolnro=.T.
			Endwith
		Case Inlist( mce, 149)
*		.txtafiliado.InputMask = '99 999999 9 99'
			.txtafiliado.Value	= Chrtran(miafi ," -/","")
			If Len(.txtafiliado.Value)=10
				.txtafiliado.Value	= "0"+Chrtran(miafi ," -/","")
			Endif
			With &mprop
				.lcontrolnro=.T.
			Endwith
		Case Inlist( mce, 193)  &&Femedica
*		.txtafiliado.InputMask = '99-99999999/99-9'
			.txtafiliado.Value	= Chrtran(miafi ," -/","")
			If Len(.txtafiliado.Value)=12
				.txtafiliado.Value	= "0"+Chrtran(miafi ," -/","")
			Endif
			With &mprop
				.lcontrolnro=.T.
			Endwith
		Case Inlist( mce, 100,101,711)

*	.txtafiliado.InputMask = '999999999'
			.txtafiliado.Value	= Chrtran(miafi ," -/","")
			With &mprop
				.lcontrolnro=.F.
			Endwith
		Case Inlist( mce,992 ) && sancorsalud
*		.txtafiliado.InputMask = '9999999/99'
			.txtafiliado.Value	= Chrtran(miafi ," -/","")
			With &mprop
				.lcontrolnro=.T.
			Endwith
		Otherwise
			.txtafiliado.InputMask = ''
			.txtafiliado.Value	= miafi
			With &mprop
				.lcontrolnro=.T.
			Endwith
	Endcase
Endwith
